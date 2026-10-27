import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget get leftPadding => Padding(
        padding: EdgeInsets.all(12),
        child: this,
      );
}

extension ColorExtension on Color {
  Color get semiTransparent => withOpacity(0.5);
}

extension DecorationExtension on Decoration {
  Decoration get toCircleBox => BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.amber,
        border: Border.all(),
      );
}