import 'package:flutter/material.dart';

class WaveBars extends StatefulWidget {
  const WaveBars({super.key});

  @override
  State<WaveBars> createState() => _WaveBarsState();
}

class _WaveBarsState extends State<WaveBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _wave(double t, double offset) {
    final v = (t + offset) % 1.0;
    return v < 0.5 ? v * 2 : (1.0 - v) * 2;
  }

  Widget _bar(double heightFraction) {
    return Container(
      width: 3,
      height: 20 * heightFraction,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 20,
        height: 20,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final t = _ctrl.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _bar(0.4 + 0.6 * _wave(t, 0.0)),
                _bar(0.4 + 0.6 * _wave(t, 0.33)),
                _bar(0.4 + 0.6 * _wave(t, 0.66)),
              ],
            );
          },
        ),
      ),
    );
  }
}
