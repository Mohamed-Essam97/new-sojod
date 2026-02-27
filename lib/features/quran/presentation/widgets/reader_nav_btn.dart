import 'package:flutter/material.dart';

class ReaderNavBtn extends StatelessWidget {
  const ReaderNavBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.textColor,
    required this.onTap,
    this.isRight = false,
  });

  final IconData icon;
  final String label;
  final Color textColor;
  final VoidCallback onTap;
  final bool isRight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: isRight
              ? [
                  Text(label,
                      style: TextStyle(
                          color: textColor.withValues(alpha: 0.6),
                          fontSize: 12)),
                  const SizedBox(width: 2),
                  Icon(icon, color: textColor.withValues(alpha: 0.7), size: 26),
                ]
              : [
                  Icon(icon, color: textColor.withValues(alpha: 0.7), size: 26),
                  const SizedBox(width: 2),
                  Text(label,
                      style: TextStyle(
                          color: textColor.withValues(alpha: 0.6),
                          fontSize: 12)),
                ],
        ),
      ),
    );
  }
}
