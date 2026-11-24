import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/tokens.dart';

/// Slow, silk-like threads of platinum light drifting over obsidian.
class SilkBackground extends StatefulWidget {
  final double intensity;
  const SilkBackground({super.key, this.intensity = 1});
  @override
  State<SilkBackground> createState() => _SilkBackgroundState();
}

class _SilkBackgroundState extends State<SilkBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 28))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: CustomPaint(
          painter: _SilkPainter(_c, widget.intensity),
          size: Size.infinite,
        ),
      );
}

class _SilkPainter extends CustomPainter {
  final Animation<double> a;
  final double intensity;
  _SilkPainter(this.a, this.intensity) : super(repaint: a);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final t = a.value * 2 * pi;
    canvas.drawRect(rect, Paint()..color = C.bg);

    // Soft sheen bands
    for (var b = 0; b < 3; b++) {
      final path = Path();
      final base = size.height * (0.35 + b * 0.18);
      path.moveTo(0, size.height);
      for (double x = 0; x <= size.width + 10; x += 12) {
        final nx = x / size.width;
        final y = base +
            sin(nx * 2.2 * pi + t + b * 1.7) * size.height * 0.09 +
            sin(nx * 4.4 * pi - t * 0.7 + b) * size.height * 0.03;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4A4A52).withValues(alpha: 0.20 * intensity),
              C.bg.withValues(alpha: 0),
            ],
          ).createShader(rect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
      );
    }

    // Fine threads
    const threads = 26;
    for (var i = 0; i < threads; i++) {
      final p = i / threads;
      final path = Path();
      final base = size.height * (0.22 + p * 0.62);
      final amp = size.height * (0.07 + 0.03 * sin(i * 0.9 + t));
      for (double x = -10; x <= size.width + 10; x += 8) {
        final nx = x / size.width;
        final y = base +
            sin(nx * 2.0 * pi + t + p * 3.2) * amp +
            sin(nx * 5.3 * pi - t * 1.3 + i * 0.4) * amp * 0.22;
        if (x == -10) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      final shine = (sin(t + i * 0.45) + 1) / 2;
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6 + shine * 0.7
          ..shader = LinearGradient(
            colors: [
              C.platinum.withValues(alpha: 0),
              C.platinum.withValues(alpha: (0.05 + 0.16 * shine) * intensity),
              C.champagne.withValues(alpha: (0.04 + 0.14 * shine) * intensity),
              C.platinum.withValues(alpha: 0),
            ],
            stops: [0, 0.35 + 0.2 * sin(t + i), 0.7, 1],
          ).createShader(rect),
      );
    }

    // Vignette
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 1.1,
          colors: [C.bg.withValues(alpha: 0), C.bg.withValues(alpha: 0.85)],
          stops: const [0.45, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _SilkPainter old) => old.intensity != intensity;
}

/// Platinum text with a slow specular highlight passing through it.
class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final Color base;
  const ShimmerText(this.text,
      {super.key, required this.style, this.textAlign, this.base = C.platinum});
  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 4200))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, child) => ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (r) => LinearGradient(
            colors: [widget.base, widget.base, Colors.white, C.champagne, widget.base, widget.base],
            stops: const [0, 0.38, 0.48, 0.54, 0.64, 1],
            transform: _Slide(_c.value * 2.4 - 1.2),
          ).createShader(r),
          child: child,
        ),
        child: Text(widget.text, style: widget.style, textAlign: widget.textAlign),
      );
}

class _Slide extends GradientTransform {
  final double p;
  const _Slide(this.p);
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * p, 0, 0);
}

/// Endless horizontal marquee.
class Marquee extends StatefulWidget {
  final List<Widget> children;
  final double speed; // px / s
  final bool reverse;
  final double height;
  final double gap;
  const Marquee(
      {super.key,
      required this.children,
      this.speed = 40,
      this.reverse = false,
      this.height = 48,
      this.gap = 14});
  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  final _sc = ScrollController();
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      final dt = (elapsed - _last).inMicroseconds / 1e6;
      _last = elapsed;
      if (!_paused && _sc.hasClients && _sc.position.hasContentDimensions) {
        _sc.jumpTo(_sc.offset + widget.speed * dt);
      }
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => _paused = true,
        onExit: (_) => _paused = false,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (r) => const LinearGradient(
            colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
            stops: [0, 0.08, 0.92, 1],
          ).createShader(r),
          child: SizedBox(
            height: widget.height,
            child: ListView.builder(
              controller: _sc,
              reverse: widget.reverse,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.gap / 2),
                child: Center(child: widget.children[i % widget.children.length]),
              ),
            ),
          ),
        ),
      );
}

/// Rotating engraved seal with circular text.
class Seal extends StatefulWidget {
  final String text;
  final double size;
  final Widget center;
  const Seal({super.key, required this.text, required this.center, this.size = 168});
  @override
  State<Seal> createState() => _SealState();
}

class _SealState extends State<Seal> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(alignment: Alignment.center, children: [
          RotationTransition(
            turns: _c,
            child: CustomPaint(
                size: Size.square(widget.size), painter: _CircularTextPainter(widget.text)),
          ),
          Container(
            width: widget.size * 0.52,
            height: widget.size * 0.52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: C.line),
              gradient: const RadialGradient(colors: [C.bg3, C.bg]),
            ),
            child: Center(child: widget.center),
          ),
        ]),
      );
}

class _CircularTextPainter extends CustomPainter {
  final String text;
  _CircularTextPainter(this.text);
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - 10;
    final c = size.center(Offset.zero);
    final chars = text.split('');
    final step = 2 * pi / chars.length;
    for (var i = 0; i < chars.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: chars[i], style: T.mono(10.5, color: C.platinum, letterSpacing: 0)),
        textDirection: TextDirection.ltr,
      )..layout();
      final ang = i * step - pi / 2;
      canvas.save();
      canvas.translate(c.dx + r * cos(ang), c.dy + r * sin(ang));
      canvas.rotate(ang + pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CircularTextPainter old) => old.text != text;
}

/// Card whose border and surface catch light where the pointer is.
class GlareCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool featured;
  const GlareCard(
      {super.key, required this.child, this.padding = const EdgeInsets.all(28), this.featured = false});
  @override
  State<GlareCard> createState() => _GlareCardState();
}

class _GlareCardState extends State<GlareCard> {
  Offset? _p;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onHover: (e) => setState(() => _p = e.localPosition),
        onExit: (_) => setState(() => _p = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: widget.featured ? C.surface2 : C.surface,
            border: Border.all(
                color: _p != null || widget.featured
                    ? C.champagne.withValues(alpha: widget.featured ? 0.55 : 0.35)
                    : C.lineSoft),
            borderRadius: BorderRadius.circular(kRadius),
          ),
          child: CustomPaint(
            painter: _GlarePainter(_p),
            child: Padding(padding: widget.padding, child: widget.child),
          ),
        ),
      );
}

class _GlarePainter extends CustomPainter {
  final Offset? p;
  _GlarePainter(this.p);
  @override
  void paint(Canvas canvas, Size size) {
    if (p == null) return;
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment((p!.dx / size.width) * 2 - 1, (p!.dy / size.height) * 2 - 1),
          radius: 0.9,
          colors: [C.champagne.withValues(alpha: 0.09), C.champagne.withValues(alpha: 0)],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _GlarePainter old) => old.p != p;
}

/// Three dots that breathe while the AI "thinks".
class TypingDots extends StatefulWidget {
  const TypingDots({super.key});
  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Row(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 0; i < 3; i++)
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.platinum.withValues(
                    alpha: 0.25 + 0.75 * ((sin((_c.value * 2 * pi) - i * 0.9) + 1) / 2)),
              ),
            ),
        ]),
      );
}
