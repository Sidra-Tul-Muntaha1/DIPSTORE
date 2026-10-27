
import 'package:DIPSTORE/Controller.dart/product_controller.dart';
import 'package:DIPSTORE/Model.dart/Productmodel.dart';
import 'package:DIPSTORE/brand_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreScreen extends StatefulWidget {
  final String? initialCategory;

  const ExploreScreen({super.key, this.initialCategory});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ProductController productController =
      Get.isRegistered<ProductController>()
          ? Get.find<ProductController>()
          : Get.put(ProductController());

  late String _selectedCategory;

  final List<String> _categories = [
    'All',
    'Jackets',
    'Hoodies',
    'Shirts',
    'Dresses',
    'Trousers',
    'Knitwear',
    'Sportswear',
    'Jeans',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
  }

  List<Product> _getFilteredProducts() {
    final all = productController.products;
    if (_selectedCategory == 'All') {
      return all;
    }
    final target = _selectedCategory.toLowerCase();
    return all.where((p) {
      final cat = p.category?.toLowerCase() ?? '';
      return cat == target || cat.contains(target) || target.contains(cat);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEEFE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Explore Fashion',
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal Category Filter Pills
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat.toLowerCase() == _selectedCategory.toLowerCase();

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 36, 14, 5)
                            : const Color(0xFFF2ECEC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color.fromARGB(255, 36, 14, 5)
                              : const Color.fromARGB(255, 215, 183, 171),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Product count header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Obx(() {
              final list = _getFilteredProducts();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == 'All'
                        ? 'All Fashion Items'
                        : '$_selectedCategory Collection',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${list.length} products',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),

          // Main 2-column Grid of products
          Expanded(
            child: Obx(() {
              final list = _getFilteredProducts();

              if (productController.isLoading.value && list.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.brown),
                );
              }

              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.checkroom_outlined,
                          size: 64,
                          color: Colors.brown,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found in $_selectedCategory',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try selecting another category or check back soon for new arrivals.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'All';
                            });
                          },
                          child: const Text('View All Categories'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return BrandProductCard(product: list[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
