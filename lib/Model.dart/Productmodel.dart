class Product {
  final int? id;
  final String image;
  final String title;
  final String price;
  final String? oldPrice;
  final String? description;
  final double? rating;
  final String? category;
  final String? brand;
  final List<String> images;

  Product({
    this.id,
    required this.image,
    required this.title,
    required this.price,
    this.oldPrice,
    this.description,
    this.rating,
    this.category,
    this.brand,
    this.images = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    final numPrice = rawPrice is num ? rawPrice.toDouble() : 0.0;
    final priceStr = '\$${numPrice.toStringAsFixed(2)}';

    String? calculatedOldPrice;
    final discount = json['discountPercentage'];
    if (discount is num && discount > 0) {
      final originalPrice = numPrice / (1 - (discount / 100));
      calculatedOldPrice = '\$${originalPrice.toStringAsFixed(2)}';
    }

    final rawImages = json['images'];
    List<String> imageList = [];
    if (rawImages is List) {
      imageList = rawImages.map((e) => e.toString()).toList();
    }

    final primaryImage = (json['thumbnail'] as String?)?.isNotEmpty == true
        ? json['thumbnail'] as String
        : (imageList.isNotEmpty ? imageList.first : '');

    final rawRating = json['rating'];
    final double? ratingVal = rawRating is num ? rawRating.toDouble() : null;

    return Product(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      image: primaryImage,
      title: json['title']?.toString() ?? 'Product',
      price: priceStr,
      oldPrice: calculatedOldPrice,
      description: json['description']?.toString(),
      rating: ratingVal,
      category: json['category']?.toString(),
      brand: json['brand']?.toString(),
      images: imageList,
    );
  }
}
