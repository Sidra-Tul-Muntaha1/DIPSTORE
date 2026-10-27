import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight persistent key-value store saved directly to the application documents directory.
/// Ensures user-specific preference storage (e.g. avatar paths) across app restarts without third-party dependencies.
class AvatarPreferences {
  static const String _fileName = 'dipstore_user_preferences.json';

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<String?> getString(String key) async {
    try {
      final file = await _getFile();
      if (!file.existsSync()) return null;
      final content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);
      return data[key]?.toString();
    } catch (_) {
      return null;
    }
  }

  static Future<void> setString(String key, String value) async {
    try {
      final file = await _getFile();
      Map<String, dynamic> data = {};
      if (file.existsSync()) {
        try {
          final content = await file.readAsString();
          data = Map<String, dynamic>.from(jsonDecode(content));
        } catch (_) {}
      }
      data[key] = value;
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Failed to save avatar preference: $e');
    }
  }

  static Future<void> remove(String key) async {
    try {
      final file = await _getFile();
      if (!file.existsSync()) return;
      final content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);
      data.remove(key);
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }
}

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final currentUser = Rx<User?>(null);
  final displayName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final localAvatarPath = ''.obs;
  final shippingAddress = ''.obs;
  final city = ''.obs;
  final orderCount = 0.obs;
  final ordersList = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final isSaving = false.obs;
  final isSavingAvatar = false.obs;
  final errorMessage = ''.obs;
  final Rx<Uint8List?> localAvatarBytes = Rx<Uint8List?>(null);

  bool get isSignedIn => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    _syncAuthData(_auth.currentUser);

    _auth.authStateChanges().listen((user) {
      currentUser.value = user;
      _syncAuthData(user);
      if (user != null) {
        loadUserProfile(user.uid);
        loadLocalProfilePicture();
       // _loadLocalAvatar(user.uid);
      } else {
        _clearProfile();
      }
    });

    if (_auth.currentUser != null) {
      loadUserProfile(_auth.currentUser!.uid);
      loadLocalProfilePicture();
     // _loadLocalAvatar(_auth.currentUser!.uid);
    }
  }

  void _syncAuthData(User? user) {
    if (user != null) {
      email.value = user.email ?? '';
      if (displayName.value.isEmpty) {
        displayName.value = user.displayName ?? '';
      }
    }
  }

  void _clearProfile() {
    displayName.value = '';
    email.value = '';
    phone.value = '';
    localAvatarPath.value = '';
    shippingAddress.value = '';
    city.value = '';
    orderCount.value = 0;
    ordersList.clear();
  }

  /// Loads the saved local profile picture path for the given user UID.
  Future<void> _loadLocalAvatar(String uid) async {
    try {
      final key = 'user_avatar_$uid';
      final savedPath = await AvatarPreferences.getString(key);
      if (savedPath != null && savedPath.trim().isNotEmpty) {
        final file = File(savedPath.trim());
        if (file.existsSync() && file.lengthSync() > 0) {
          localAvatarPath.value = savedPath.trim();
          return;
        }
      }

      // Fallback check in persistent user_avatars directory
      final appDir = await getApplicationDocumentsDirectory();
      final avatarsDir = Directory('${appDir.path}/user_avatars');
      if (avatarsDir.existsSync()) {
        final matches = avatarsDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.contains('avatar_$uid'))
            .toList();
        if (matches.isNotEmpty) {
          matches.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
          final latest = matches.first;
          if (latest.existsSync() && latest.lengthSync() > 0) {
            localAvatarPath.value = latest.path;
            await AvatarPreferences.setString(key, latest.path);
            return;
          }
        }
      }

      localAvatarPath.value = '';
    } catch (e) {
      debugPrint('Error loading local avatar: $e');
      localAvatarPath.value = '';
    }
  }

  /// Reloads profile data from Firestore document `users/{uid}` and order count from `users/{uid}/orders`.
  Future<void> loadUserProfile(String uid) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Fetch user profile doc
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final firestoreName = data['displayName']?.toString() ??
            data['name']?.toString() ??
            data['customerName']?.toString();
        if (firestoreName != null && firestoreName.trim().isNotEmpty) {
          displayName.value = firestoreName.trim();
        }

        final firestorePhone = data['phone']?.toString() ??
            data['phoneNumber']?.toString();
        if (firestorePhone != null) {
          phone.value = firestorePhone.trim();
        }

        final firestoreAddress = data['deliveryAddress']?.toString() ??
            data['address']?.toString();
        if (firestoreAddress != null) {
          shippingAddress.value = firestoreAddress.trim();
        }

        final firestoreCity = data['city']?.toString();
        if (firestoreCity != null) {
          city.value = firestoreCity.trim();
        }
      }

      // 2. Fetch user orders count
      final ordersSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('orders')
          .orderBy('placedAt', descending: true)
          .limit(20)
          .get();

      orderCount.value = ordersSnapshot.docs.length;
      ordersList.value = ordersSnapshot.docs.map((d) {
        final m = d.data();
        m['id'] = d.id;
        return m;
      }).toList();

      // 3. Ensure local avatar is loaded
      await _loadLocalAvatar(uid);
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Saves the picked image locally in the app's persistent application documents directory.
  /// Stores a user-specific key in preferences based on Firebase Authentication UID.
  /// No cloud upload or Firestore write is performed.
  String _avatarKey(String uid) => 'user_avatar_$uid';

Future<void> loadLocalProfilePicture() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    localAvatarBytes.value = null;
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final savedImage = prefs.getString(_avatarKey(user.uid));

  if (savedImage == null) {
    localAvatarBytes.value = null;
    return;
  }

  try {
    localAvatarBytes.value = base64Decode(savedImage);
  } catch (_) {
    localAvatarBytes.value = null;
  }
}

Future<void> saveLocalProfilePicture(Uint8List bytes) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('Please sign in before changing your picture.');
  }

  final prefs = await SharedPreferences.getInstance();
  final encodedImage = base64Encode(bytes);

  final saved = await prefs.setString(
    _avatarKey(user.uid),
    encodedImage,
  );

  if (!saved) {
    throw Exception('Could not save the picture on this device.');
  }

  localAvatarBytes.value = bytes;
}

  void _cleanupOldAvatars(Directory avatarsDir, String uid, String currentPath) {
    try {
      final files = avatarsDir.listSync();
      for (final f in files) {
        if (f is File && f.path != currentPath && f.path.contains('avatar_$uid')) {
          try {
            f.deleteSync();
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  /// Updates profile details (name and phone) in Firestore and Firebase Auth.
  Future<bool> updateProfileDetails({
    required String name,
    required String phoneNumber,
  }) async {
    final user = currentUser.value;
    if (user == null) {
      Get.snackbar(
        'Sign in required',
        'Please sign in to update your profile.',
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
      );
      return false;
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Display name cannot be empty.',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    }

    try {
      isSaving.value = true;
      final updates = {
        'displayName': trimmedName,
        'phone': phoneNumber.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore without overwriting unrelated fields
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(updates, SetOptions(merge: true));

      // Update Firebase Auth profile
      await user.updateDisplayName(trimmedName);

      displayName.value = trimmedName;
      phone.value = phoneNumber.trim();

      Get.snackbar(
        'Profile Updated',
        'Your profile changes have been saved.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
        margin: const EdgeInsets.all(12),
      );
      return true;
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Update Failed',
        e.message ?? 'Failed to update profile.',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Updates shipping address in Firestore `users/{uid}`.
  Future<bool> updateShippingAddress({
    required String address,
    required String cityName,
  }) async {
    final user = currentUser.value;
    if (user == null) return false;

    try {
      isSaving.value = true;
      final updates = {
        'deliveryAddress': address.trim(),
        'city': cityName.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(updates, SetOptions(merge: true));

      shippingAddress.value = address.trim();
      city.value = cityName.trim();

      Get.snackbar(
        'Address Saved',
        'Your shipping address has been updated.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save shipping address: $e',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Sends a password reset email to the signed-in user's email address.
  Future<bool> sendPasswordResetEmail() async {
    final userEmail = email.value.trim();
    if (userEmail.isEmpty) {
      Get.snackbar(
        'Error',
        'No email address associated with this account.',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    }

    try {
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        'Email Sent',
        'A password reset link has been sent to $userEmail. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Password Reset Failed',
        e.message ?? 'Failed to send password reset email.',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    }
  }

  /// Changes the user's password using reauthentication with their current password.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser.value;
    if (user == null || user.email == null) {
      Get.snackbar(
        'Error',
        'You must be signed in with an email account to change password.',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Weak Password',
        'New password must be at least 6 characters long.',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    }

    try {
      isSaving.value = true;

      // 1. Reauthenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // 2. Update password
      await user.updatePassword(newPassword);

      Get.snackbar(
        'Password Changed',
        'Your password has been changed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
        margin: const EdgeInsets.all(12),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'Failed to update password.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'The current password entered is incorrect.';
      }
      Get.snackbar(
        'Password Update Failed',
        message,
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Signs the user out safely.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _clearProfile();
      Get.snackbar(
        'Logged Out',
        'You have been logged out of DIPSTORE.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade900,
      );
    }
  }
}
