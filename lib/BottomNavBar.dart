import 'package:DIPSTORE/Controller.dart/cart_controller.dart';
import 'package:DIPSTORE/Emptybagscreen.dart';
import 'package:DIPSTORE/Fullbagscreen.dart';
import 'package:DIPSTORE/Profilescreen.dart';
import 'package:DIPSTORE/favourites_screen.dart';
import 'package:DIPSTORE/home.dart';
import 'package:DIPSTORE/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottomnavbar extends StatefulWidget {
  final int initialIndex;
  const Bottomnavbar({super.key, this.initialIndex = 0});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  late int _selectedIndex;
  final CartController cartController = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 3);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const Home();
      case 1:
        return const SearchScreen();
      case 2:
        return FavouritesScreen(onStartShopping: () => _onItemTapped(0));
      case 3:
        return const Profilescreen();
      default:
        return const Home();
    }
  }

  Widget _buildNavItem(
    int index,
    IconData outlineIcon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;
    const primaryColor = Color.fromARGB(255, 36, 14, 5);
    const activeBg = Color(0xFFFEEFE3);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : outlineIcon,
              color: isSelected ? primaryColor : Colors.grey.shade600,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    const primaryColor = Color.fromARGB(255, 36, 14, 5);

    return Obx(() {
      final count = cartController.totalItemCount;

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => cartController.isEmpty
                  ? EmptyBagScreen(onStartShopping: () => _onItemTapped(0))
                  : FullBagScreen(onStartShopping: () => _onItemTapped(0)),
            ),
          );
        },
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Badge(
              isLabelVisible: count > 0,
              label: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xFFC41230),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFFFEEFE3),
                size: 24,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _buildBody(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // 4-tab Floating Pill
              Expanded(
                child: Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        0,
                        Icons.home_outlined,
                        Icons.home_rounded,
                        'Home',
                      ),
                      _buildNavItem(
                        1,
                        Icons.search,
                        Icons.search_rounded,
                        'Search',
                      ),
                      _buildNavItem(
                        2,
                        Icons.favorite_border_rounded,
                        Icons.favorite_rounded,
                        'Wishlist',
                      ),
                      _buildNavItem(
                        3,
                        Icons.person_outline_rounded,
                        Icons.person_rounded,
                        'Profile',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Circular Floating Cart Button
              _buildCartButton(),
            ],
          ),
        ),
      ),
    );
  }
}
