import 'package:flutter/material.dart';

class SheetHandle extends StatelessWidget {
  final bool isDark;

  const SheetHandle({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? Colors.white24 : Colors.black12,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
