import 'package:flutter/material.dart';

import '../core/tokens.dart';

/// Monogram: an engraved diamond with a hairline core, then the wordmark.
class Logo extends StatelessWidget {
  final bool compact;
  final double size;
  const Logo({super.key, this.compact = false, this.size = 22});

  @override
  Widget build(BuildContext context) {
    final mark = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MarkPainter()),
    );
    if (compact) return mark;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      mark,
      const SizedBox(width: 12),
      displayText('Obsid-finance', T.display(size * 1.05, letterSpacing: 1.2, height: 1)),
    ]);
  }
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final c = s.center(Offset.zero);
    final r = s.width / 2;
    final outer = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx + r, c.dy)
      ..lineTo(c.dx, c.dy + r)
      ..lineTo(c.dx - r, c.dy)
      ..close();
    canvas.drawPath(
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, C.platinum, C.gunmetal, C.champagne],
        ).createShader(Offset.zero & s),
    );
    final ir = r * 0.42;
    final inner = Path()
      ..moveTo(c.dx, c.dy - ir)
      ..lineTo(c.dx + ir, c.dy)
      ..lineTo(c.dx, c.dy + ir)
      ..lineTo(c.dx - ir, c.dy)
      ..close();
    canvas.drawPath(inner, Paint()..color = C.champagne);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
