import 'package:DIPSTORE/Controller.dart/product_controller.dart';
import 'package:DIPSTORE/Widgets.dart/Brandrow.dart';
import 'package:DIPSTORE/Widgets.dart/Recommendationcard.dart';
import 'package:DIPSTORE/brand_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductController productController = Get.isRegistered<ProductController>()
      ? Get.find<ProductController>()
      : Get.put(ProductController());

  String searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEEFE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
  onPressed: () {
     Get.back();
  },
),
        title: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              searchQuery = val;
            });
          },
          decoration: InputDecoration(
            hintText: "Search fashion, brands, categories...",
            border: InputBorder.none,
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        searchQuery = "";
                      });
                    },
                  )
                : null,
          ),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (searchQuery.isEmpty) ...[
              // Featured brands row
              const BrandRow(),
              const SizedBox(height: 16),

              // Recommendation Card with functional Explore button
              const RecommendationCard(),
              const SizedBox(height: 20),

              // Trending fashion header with count
              Obx(() {
                final trending = productController.products;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Trending fashion",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${trending.length} items",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 12),

              // Vertically scrollable 2-column product grid
              Obx(() {
                if (productController.isLoading.value &&
                    productController.products.isEmpty) {
                  return const SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.brown),
                    ),
                  );
                }

                final trending = productController.products;
                if (trending.isEmpty) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        "No fashion products loaded",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    return BrandProductCard(product: trending[index]);
                  },
                );
              }),
            ] else ...[
              // Search results view
              Obx(() {
                final matchedBrand =
                    productController.findMatchingBrand(searchQuery);
                final filteredProducts =
                    productController.searchProducts(searchQuery);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (matchedBrand != null) ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BrandPage(brandName: matchedBrand),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 215, 183, 171),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                color: Colors.brown,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Explore the official $matchedBrand collection',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.brown,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Results for '$searchQuery'",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "${filteredProducts.length} items",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (filteredProducts.isEmpty) ...[
                      Container(
                        height: 220,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No clothing found for '$searchQuery'",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Try searching for Zara, Nike, Adidas, Levi's, jackets, dresses, or hoodies",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return BrandProductCard(
                            product: filteredProducts[index],
                          );
                        },
                      ),
                    ],
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
