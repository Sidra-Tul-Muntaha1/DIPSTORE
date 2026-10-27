
import 'package:DIPSTORE/Controller.dart/product_controller.dart';
import 'package:DIPSTORE/brand_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandsListScreen extends StatelessWidget {
  const BrandsListScreen({super.key});

  static const List<Map<String, dynamic>> brandInfo = [
    {
      'name': 'Zara',
      'tag': 'ZARA',
      'subtitle': 'Contemporary European chic, blazers & tailoring',
      'fontStyle': TextStyle(
        fontFamily: 'serif',
        fontWeight: FontWeight.w900,
        fontSize: 16,
        letterSpacing: 2.0,
        color: Colors.black,
      ),
    },
    {
      'name': 'Nike',
      'tag': 'NIKE',
      'subtitle': 'Performance sportswear, fleece hoodies & tech jackets',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 16,
        fontStyle: FontStyle.italic,
        letterSpacing: 2.0,
        color: Colors.black,
      ),
    },
    {
      'name': 'H&M',
      'tag': 'H&M',
      'subtitle': 'Modern everyday essentials, denim & knitwear',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 17,
        color: Color(0xFFCC0000),
      ),
    },
    {
      'name': 'Gucci',
      'tag': 'GUCCI',
      'subtitle': 'Italian luxury, high-fashion statement pieces & silk',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 2.5,
        color: Colors.black,
      ),
    },
    {
      'name': 'Dior',
      'tag': 'DIOR',
      'subtitle': 'French haute couture, virgin wool tailoring & dresses',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        letterSpacing: 3.0,
        color: Colors.black,
      ),
    },
    {
      'name': 'Adidas',
      'tag': 'ADIDAS',
      'subtitle': 'Iconic 3-Stripes track tops, windbreakers & street hoodies',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 14,
        letterSpacing: 1.6,
        color: Colors.black,
      ),
    },
    {
      'name': "Levi's",
      'tag': "LEVI'S",
      'subtitle': 'Heritage denim, original 501 jeans & trucker jackets',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 15,
        letterSpacing: 1.0,
        color: Color(0xFFC41230),
      ),
    },
    {
      'name': 'Uniqlo',
      'tag': 'UNIQLO',
      'subtitle': 'Minimalist Japanese LifeWear, ultra light down & fleece',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 14,
        letterSpacing: 1.2,
        color: Color(0xFFED1D24),
      ),
    },
    {
      'name': 'Puma',
      'tag': 'PUMA',
      'subtitle': 'Dynamic athletic apparel, T7 track jackets & joggers',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 15,
        letterSpacing: 1.8,
        color: Colors.black,
      ),
    },
    {
      'name': 'Mango',
      'tag': 'MANGO',
      'subtitle': 'Mediterranean elegance, wool wrap coats & satin dresses',
      'fontStyle': TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 2.0,
        color: Colors.black,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ProductController productController =
        Get.isRegistered<ProductController>()
            ? Get.find<ProductController>()
            : Get.put(ProductController());

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
          'Featured Brands (${brandInfo.length})',
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: brandInfo.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final brand = brandInfo[index];
          final String name = brand['name'] as String;
          final String tag = brand['tag'] as String;
          final String subtitle = brand['subtitle'] as String;
          final TextStyle fontStyle = brand['fontStyle'] as TextStyle;

          final count = productController.getProductsByBrand(name).length;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BrandPage(brandName: name),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Circular logo mark
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFBF8F5),
                      border: Border.all(
                        color: const Color.fromARGB(255, 215, 183, 171),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tag,
                      textAlign: TextAlign.center,
                      style: fontStyle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 36, 14, 5),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2ECEC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$count items',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
