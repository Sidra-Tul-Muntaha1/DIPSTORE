import 'dart:convert';
import 'package:DIPSTORE/Model.dart/Productmodel.dart';
import 'package:DIPSTORE/Model.dart/fashion_catalog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  final products = <Product>[...FashionCatalog.curatedClothing].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  bool _hasFetchedApi = false;

  static const List<String> featuredBrandNames = [
    'Zara',
    'Nike',
    'H&M',
    'Gucci',
    'Dior',
    'Adidas',
    "Levi's",
    'Uniqlo',
    'Puma',
    'Mango',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    // Avoid duplicate fetching if already fetched and not refreshing
    if (_hasFetchedApi && !isRefresh) {
      return;
    }
    _hasFetchedApi = true;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Initialize with our fashion-exclusive curated collection
      final List<Product> catalog = List.from(FashionCatalog.curatedClothing);

      // Fetch authentic clothing-only categories from DummyJSON
      final clothingCategories = [
        'mens-shirts',
        'tops',
        'womens-dresses',
      ];

      for (final category in clothingCategories) {
        try {
          final res = await http
              .get(Uri.parse('https://dummyjson.com/products/category/$category'))
              .timeout(const Duration(seconds: 4));

          if (res.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(res.body);
            final rawList = data['products'] as List?;
            if (rawList != null) {
              for (final item in rawList) {
                final product = Product.fromJson(item as Map<String, dynamic>);
                // Ensure no non-clothing or duplicate products enter the catalog
                if (!catalog.any((p) => p.id == product.id)) {
                  catalog.add(product);
                }
              }
            }
          }
        } catch (_) {
          // If an individual category fetch times out, continue with curated items
        }
      }

      products.value = catalog;
    } catch (e) {
      // In case of complete network failure, fall back to the curated fashion catalog
      if (products.isEmpty) {
        products.value = List.from(FashionCatalog.curatedClothing);
      }
      errorMessage.value =
          'Network connection limited. Showing offline fashion catalog.';
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> get fastSellingProducts {
    if (products.length <= 8) return products;
    return products.sublist(0, 8);
  }

  List<Product> get popularProducts {
    if (products.length <= 8) return products;
    return products.sublist(8);
  }

  List<Product> getProductsByBrand(String brandName) {
    final query = brandName.trim().toLowerCase().replaceAll("'", '');
    return products.where((p) {
      final brand = p.brand?.trim().toLowerCase().replaceAll("'", '');
      if (brand == null) return false;
      return brand == query || brand.contains(query) || query.contains(brand);
    }).toList();
  }

  List<Product> searchProducts(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return products;
    }

    final tokens = trimmed
        .replaceAll("'", '')
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    return products.where((p) {
      final title = p.title.toLowerCase().replaceAll("'", '');
      final brand = p.brand?.toLowerCase().replaceAll("'", '') ?? '';
      final category = p.category?.toLowerCase().replaceAll("'", '') ?? '';
      final combined = '$title $brand $category';
      final combinedStripped = combined.replaceAll('-', '');

      // Check if full phrase matches
      if (combined.contains(trimmed) || combinedStripped.contains(trimmed.replaceAll('-', ''))) {
        return true;
      }

      // Or check if all individual query tokens match somewhere in (title, brand, category)
      return tokens.every((token) {
        final tokenStripped = token.replaceAll('-', '');
        return combined.contains(token) || combinedStripped.contains(tokenStripped);
      });
    }).toList();
  }

  String? findMatchingBrand(String query) {
    final trimmed = query.trim().toLowerCase().replaceAll("'", '');
    if (trimmed.isEmpty) return null;
    final tokens = trimmed.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

    for (final brand in featuredBrandNames) {
      final brandClean = brand.toLowerCase().replaceAll("'", '');
      if (brandClean == trimmed ||
          trimmed.contains(brandClean) ||
          tokens.contains(brandClean)) {
        return brand;
      }
    }
    return null;
  }
}
