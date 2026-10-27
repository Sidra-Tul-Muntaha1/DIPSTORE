import 'package:DIPSTORE/Model.dart/Productmodel.dart';
import 'package:DIPSTORE/Model.dart/fashion_catalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  final favourites = <Product>[].obs;
  final favouriteIds = <int>{}.obs;
  final isLoading = false.obs;

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loadUserFavourites(user.uid);
      } else {
        // Keep in-memory favourites or clear on logout
      }
    });
  }

  bool isFavourite(Product product) {
    if (product.id == null) return false;
    return favouriteIds.contains(product.id);
  }

  int get count => favourites.length;

  void toggleFavourite(Product product) {
    if (product.id == null) return;

    if (isFavourite(product)) {
      favouriteIds.remove(product.id);
      favourites.removeWhere((p) => p.id == product.id);
      _removeCloudFavourite(product.id!);
      Get.snackbar(
        'Removed from Wishlist',
        '${product.title} removed from your favourites.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
        margin: const EdgeInsets.all(12),
      );
    } else {
      favouriteIds.add(product.id!);
      favourites.add(product);
      _saveCloudFavourite(product);
      Get.snackbar(
        'Added to Wishlist',
        '${product.title} added to your favourites.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        colorText: const Color.fromARGB(255, 36, 14, 5),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  Future<void> _loadUserFavourites(String uid) async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .get();

      final List<Product> loaded = [];
      final Set<int> ids = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final id = int.tryParse(doc.id) ?? data['id'] as int?;
        if (id != null) {
          ids.add(id);
          // Look up full product from catalog or reconstruct from stored doc
          final match = FashionCatalog.curatedClothing.firstWhereOrNull(
            (p) => p.id == id,
          );
          if (match != null) {
            loaded.add(match);
          } else {
            loaded.add(
              Product(
                id: id,
                title: data['title']?.toString() ?? 'Fashion Item',
                price: data['price']?.toString() ?? '\$0.00',
                image: data['image']?.toString() ?? '',
                brand: data['brand']?.toString(),
                category: data['category']?.toString(),
              ),
            );
          }
        }
      }

      favouriteIds.value = ids;
      favourites.value = loaded;
    } catch (_) {
      // Offline fallback: keep existing in-memory favourites
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveCloudFavourite(Product product) async {
    final user = currentUser;
    if (user == null || product.id == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(product.id.toString())
          .set({
        'id': product.id,
        'title': product.title,
        'brand': product.brand,
        'price': product.price,
        'image': product.image,
        'category': product.category,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Ignored if offline; in-memory state remains intact
    }
  }

  Future<void> _removeCloudFavourite(int productId) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(productId.toString())
          .delete();
    } catch (_) {
      // Ignored if offline
    }
  }
}
