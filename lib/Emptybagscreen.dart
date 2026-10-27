import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyBagScreen extends StatefulWidget {
  final VoidCallback? onStartShopping;
  const EmptyBagScreen({super.key, this.onStartShopping});

  @override
  State<EmptyBagScreen> createState() => _EmptyBagScreenState();
}

class _EmptyBagScreenState extends State<EmptyBagScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 236, 236),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://img.pikbest.com/wp/202413/outline-sketch-cartoon-car-coloring-page-shopping-bag-drawing-vector_10468769.jpg!sw800",
              height: 200,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.shopping_bag_outlined,
                size: 140,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Your bag is empty",
              style: GoogleFonts.aboreto(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              "Looking for ideas?",
              style: GoogleFonts.aboreto(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (widget.onStartShopping != null) {
                  widget.onStartShopping!();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Start Shopping",
                style: GoogleFonts.aboreto(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
