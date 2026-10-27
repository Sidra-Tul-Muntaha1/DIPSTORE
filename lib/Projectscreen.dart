
import 'dart:async';

import 'package:DIPSTORE/BottomNavBar.dart';
import 'package:DIPSTORE/next.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Projectscreen extends StatefulWidget {
  const Projectscreen({super.key});

  @override
  State<Projectscreen> createState() => _ProjectscreenState();
}

class _ProjectscreenState extends State<Projectscreen> {
  Timer? _projectTimer;

  @override
  void initState() {
    super.initState();

    // Automatically leave the project screen after 3 seconds.
    _projectTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Bottomnavbar()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Next()),
        );
      }
    }
    );
  }

  @override
  void dispose() {
    _projectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF30180F),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            return SizedBox.expand(
              child: Stack(
                children: [
                  // Warm brown background.
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF6C391E),
                            Color(0xFF572C17),
                            Color(0xFF3C2012),
                            Color(0xFF29150D),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Soft lighting behind the branding.
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.57,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.2),
                          radius: 1.0,
                          colors: [
                            const Color(0xFF9A6038)
                                .withValues(alpha: 0.20),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Clothing rack and garments, drawn without images.
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: screenHeight * 0.49,
                    child: CustomPaint(
                      painter: ClothingRackPainter(),
                      size: Size(
                        screenWidth,
                        screenHeight * 0.49,
                      ),
                    ),
                  ),

                  // Centered branding.
                  Positioned(
                    top: screenHeight * 0.195,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomPaint(
                          size: Size(
                            screenWidth * 0.31,
                            screenHeight * 0.105,
                          ),
                          painter: HangerLogoPainter(),
                        ),

                        SizedBox(height: screenHeight * 0.012),

                        Text(
                          'DIPSTORE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Aboreto',
                            color: Colors.white,
                            fontSize: screenWidth * 0.103,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                            height: 1.0,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.009),

                        Text(
                          'Wear Better. Live Smarter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Aboreto',
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: screenWidth * 0.037,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// White hanger logo.
class HangerLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Hook.
    path.moveTo(size.width * 0.49, size.height * 0.20);
    path.cubicTo(
      size.width * 0.49,
      size.height * 0.02,
      size.width * 0.65,
      size.height * 0.02,
      size.width * 0.65,
      size.height * 0.17,
    );
    path.cubicTo(
      size.width * 0.65,
      size.height * 0.29,
      size.width * 0.52,
      size.height * 0.31,
      size.width * 0.50,
      size.height * 0.43,
    );

    // Hanger frame.
    path.moveTo(size.width * 0.50, size.height * 0.43);
    path.lineTo(size.width * 0.10, size.height * 0.88);
    path.lineTo(size.width * 0.90, size.height * 0.88);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HangerLogoPainter oldDelegate) => false;
}

// Clothing rack and stylized garments, all drawn in Flutter.
class ClothingRackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final railPaint = Paint()
      ..color = const Color(0xFF17100C)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final highlightPaint = Paint()
      ..color = const Color(0xFFAD7950).withValues(alpha: 0.7)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final railY = h * 0.20;

    // Main clothing rail.
    canvas.drawLine(
      Offset(w * 0.17, railY),
      Offset(w * 0.96, railY - 3),
      railPaint,
    );

    canvas.drawLine(
      Offset(w * 0.17, railY - 2),
      Offset(w * 0.96, railY - 5),
      highlightPaint,
    );

    // Rack supports.
    canvas.drawLine(
      Offset(w * 0.20, railY),
      Offset(w * 0.20, h * 0.91),
      railPaint,
    );

    canvas.drawLine(
      Offset(w * 0.94, railY - 3),
      Offset(w * 0.94, h * 0.96),
      railPaint,
    );

    canvas.drawLine(
      Offset(w * 0.14, h * 0.96),
      Offset(w * 0.99, h * 0.96),
      railPaint,
    );

    // Rail brackets.
    for (int i = 0; i < 6; i++) {
      final x = w * (0.23 + i * 0.135);

      canvas.drawLine(
        Offset(x, railY - 1),
        Offset(x, railY + 8),
        Paint()
          ..color = const Color(0xFF17100C)
          ..strokeWidth = 2,
      );
    }

    // Alternating garment colors.
    final garmentColors = <Color>[
      const Color(0xFF211812),
      const Color(0xFF39261B),
      const Color(0xFF181411),
      const Color(0xFF6A4631),
      const Color(0xFFB69A7C),
      const Color(0xFFD0B79A),
      const Color(0xFFE0CDB4),
      const Color(0xFF3A281C),
      const Color(0xFF211914),
      const Color(0xFFAF9274),
      const Color(0xFFE3CFB7),
    ];

    final garmentCount = 11;
    final garmentWidth = w * 0.115;
    final garmentHeight = h * 0.60;
    final startX = w * 0.12;
    final gap = w * 0.073;

    for (int i = 0; i < garmentCount; i++) {
      final x = startX + i * gap;
      final top = railY + h * 0.045 + (i.isOdd ? 5.0 : 0.0);

      final garmentColor = garmentColors[i];

      // Hanger hook.
      final hangerPaint = Paint()
        ..color = const Color(0xFF17110D)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final hangerPath = Path()
        ..moveTo(x + garmentWidth * 0.50, railY + 7)
        ..cubicTo(
          x + garmentWidth * 0.43,
          railY - 1,
          x + garmentWidth * 0.59,
          railY - 1,
          x + garmentWidth * 0.50,
          railY + 7,
        );

      canvas.drawPath(hangerPath, hangerPaint);

      // Garment silhouette.
      final garmentPath = Path()
        ..moveTo(x + garmentWidth * 0.50, top)
        ..lineTo(x + garmentWidth * 0.28, top + h * 0.045)
        ..lineTo(x + garmentWidth * 0.08, top + h * 0.12)
        ..lineTo(x + garmentWidth * 0.17, top + h * 0.18)
        ..lineTo(x + garmentWidth * 0.23, top + h * 0.15)
        ..lineTo(x + garmentWidth * 0.22, top + garmentHeight)
        ..quadraticBezierTo(
          x + garmentWidth * 0.50,
          top + garmentHeight + 3,
          x + garmentWidth * 0.78,
          top + garmentHeight,
        )
        ..lineTo(x + garmentWidth * 0.77, top + h * 0.15)
        ..lineTo(x + garmentWidth * 0.83, top + h * 0.18)
        ..lineTo(x + garmentWidth * 0.92, top + h * 0.12)
        ..lineTo(x + garmentWidth * 0.72, top + h * 0.045)
        ..close();

      // Subtle shadow for depth.
      canvas.drawPath(
        garmentPath.shift(const Offset(2, 2)),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.22)
          ..style = PaintingStyle.fill,
      );

      canvas.drawPath(
        garmentPath,
        Paint()
          ..color = garmentColor
          ..style = PaintingStyle.fill,
      );

      // Garment outline and folds.
      canvas.drawPath(
        garmentPath,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.45)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke,
      );

      canvas.drawLine(
        Offset(x + garmentWidth * 0.50, top + h * 0.10),
        Offset(x + garmentWidth * 0.49, top + garmentHeight * 0.95),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.12)
          ..strokeWidth = 1,
      );

      // Inner hanger shoulders.
      canvas.drawLine(
        Offset(x + garmentWidth * 0.50, top),
        Offset(x + garmentWidth * 0.27, top + h * 0.045),
        Paint()
          ..color = const Color(0xFF23160E)
          ..strokeWidth = 1,
      );

      canvas.drawLine(
        Offset(x + garmentWidth * 0.50, top),
        Offset(x + garmentWidth * 0.73, top + h * 0.045),
        Paint()
          ..color = const Color(0xFF23160E)
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ClothingRackPainter oldDelegate) => false;
}


/* import 'dart:async';
import 'package:dipstore/BottomNavBar.dart';
import 'package:dipstore/next.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Projectscreen extends StatefulWidget {
  const Projectscreen({super.key});

  @override
  State<Projectscreen> createState() => _ProjectscreenState();
}

class _ProjectscreenState extends State<Projectscreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Navigate after 3 seconds: verify existing Firebase authentication session
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Bottomnavbar()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Next()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 94, 76, 70),
      body: Center(
        child: Text(
          'Dipstore.',
          style: GoogleFonts.aboreto(
            fontSize: 40,
            color: const Color.fromARGB(255, 237, 222, 176),
          ),
        ),
      ),
    );
  }
}
 */