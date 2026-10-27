
import 'package:DIPSTORE/brand_page.dart';
import 'package:DIPSTORE/brands_list_screen.dart';
import 'package:flutter/material.dart';

class BrandRow extends StatefulWidget {
  const BrandRow({super.key});

  @override
  State<BrandRow> createState() => _BrandRowState();
}

class _BrandRowState extends State<BrandRow> {
  final List<Map<String, dynamic>> brands = [
    {
      "name": "Zara",
      "tag": "ZARA",
      "fontStyle": const TextStyle(
        fontFamily: 'serif',
        fontWeight: FontWeight.w900,
        fontSize: 13,
        letterSpacing: 1.5,
        color: Colors.black,
      ),
    },
    {
      "name": "Nike",
      "tag": "NIKE",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 13,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.8,
        color: Colors.black,
      ),
    },
    {
      "name": "H&M",
      "tag": "H&M",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 14,
        color: Color(0xFFCC0000),
      ),
    },
    {
      "name": "Gucci",
      "tag": "GUCCI",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 2.0,
        color: Colors.black,
      ),
    },
    {
      "name": "Dior",
      "tag": "DIOR",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        letterSpacing: 2.5,
        color: Colors.black,
      ),
    },
    {
      "name": "Adidas",
      "tag": "ADIDAS",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 1.4,
        color: Colors.black,
      ),
    },
    {
      "name": "Levi's",
      "tag": "LEVI'S",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 12,
        letterSpacing: 0.8,
        color: Color(0xFFC41230),
      ),
    },
    {
      "name": "Uniqlo",
      "tag": "UNIQLO",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 1.0,
        color: Color(0xFFED1D24),
      ),
    },
    {
      "name": "Puma",
      "tag": "PUMA",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 12,
        letterSpacing: 1.5,
        color: Colors.black,
      ),
    },
    {
      "name": "Mango",
      "tag": "MANGO",
      "fontStyle": const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 1.8,
        color: Colors.black,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Featured brands",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BrandsListScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "Tap to view",
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final brand = brands[index];
              final String name = brand["name"] as String;
              final String tag = brand["tag"] as String;
              final TextStyle style = brand["fontStyle"] as TextStyle;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BrandPage(brandName: name),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(255, 215, 183, 171),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tag,
                        textAlign: TextAlign.center,
                        style: style,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
