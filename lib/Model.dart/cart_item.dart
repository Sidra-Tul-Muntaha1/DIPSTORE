import 'package:DIPSTORE/Model.dart/Productmodel.dart';

class CartItem {
  final int? id;
  final String title;
  final String brand;
  final String imageUrl;
  final String priceString;
  final double unitPrice;
  final String size;
  final String? category;
  int quantity;
  bool selected;

  CartItem({
    this.id,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.priceString,
    required this.unitPrice,
    this.size = "M",
    this.category,
    this.quantity = 1,
    this.selected = true,
  });

  /// Safely parse currency string like "$149.00", "$1,450.00", "49.99" to double
  static double parsePrice(String priceStr) {
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  factory CartItem.fromProduct(
    Product product, {
    int quantity = 1,
    String size = "M",
    bool selected = true,
  }) {
    return CartItem(
      id: product.id,
      title: product.title,
      brand: product.brand ?? "DIPSTORE",
      imageUrl: product.image,
      priceString: product.price,
      unitPrice: parsePrice(product.price),
      size: size,
      category: product.category,
      quantity: quantity > 0 ? quantity : 1,
      selected: selected,
    );
  }

  double get lineTotal => unitPrice * quantity;

  bool matchesProduct(Product product) {
    if (id != null && product.id != null) {
      return id == product.id;
    }
    return title.trim().toLowerCase() == product.title.trim().toLowerCase() &&
        brand.trim().toLowerCase() ==
            (product.brand ?? 'dipstore').trim().toLowerCase();
  }
}
