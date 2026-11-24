import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/tokens.dart';

/// Forecast line chart: actual vs forecast split, uncertainty band, comparison line,
/// threshold and an exact-value crosshair (PRD: charts must expose exact values).
class ForecastChart extends StatefulWidget {
  final List<String> xLabels;
  final List<double> primary;
  final String primaryLabel;
  final List<double>? comparison;
  final String comparisonLabel;
  final List<double>? low;
  final List<double>? high;
  final double? threshold;
  final String thresholdLabel;
  final int? splitIndex;
  final double height;
  final String Function(num) format;

  const ForecastChart({
    super.key,
    required this.xLabels,
    required this.primary,
    this.primaryLabel = 'Scenario',
    this.comparison,
    this.comparisonLabel = 'Baseline',
    this.low,
    this.high,
    this.threshold,
    this.thresholdLabel = 'Floor',
    this.splitIndex,
    this.height = 300,
    this.format = inrCompact,
  });

  @override
  State<ForecastChart> createState() => _ForecastChartState();
}

class _ForecastChartState extends State<ForecastChart> {
  int? _hover;

  void _set(Offset p, double width) {
    const left = _ChartPainter.padLeft, right = _ChartPainter.padRight;
    final n = widget.primary.length;
    final x = ((p.dx - left) / (width - left - right)).clamp(0.0, 1.0);
    setState(() => _hover = (x * (n - 1)).round());
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Chart: ${widget.primaryLabel}. '
          '${List.generate(widget.primary.length, (i) => '${widget.xLabels[i]} ${widget.format(widget.primary[i])}').join(', ')}',
      child: SizedBox(
        height: widget.height,
        child: LayoutBuilder(builder: (context, c) {
          return MouseRegion(
            onHover: (e) => _set(e.localPosition, c.maxWidth),
            onExit: (_) => setState(() => _hover = null),
            child: GestureDetector(
              onPanDown: (d) => _set(d.localPosition, c.maxWidth),
              onPanUpdate: (d) => _set(d.localPosition, c.maxWidth),
              onPanEnd: (_) => setState(() => _hover = null),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1100),
                curve: Curves.easeOutCubic,
                builder: (context, t, _) => CustomPaint(
                  size: Size(c.maxWidth, widget.height),
                  painter: _ChartPainter(widget, _hover, t),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  static const padLeft = 58.0, padRight = 12.0, padTop = 14.0, padBottom = 30.0;
  final ForecastChart w;
  final int? hover;
  final double progress;
  _ChartPainter(this.w, this.hover, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final all = <double>[
      ...w.primary,
      ...?w.comparison,
      ...?w.low,
      ...?w.high,
      if (w.threshold != null) w.threshold!,
    ];
    var lo = all.reduce(min), hi = all.reduce(max);
    final pad = (hi - lo) * 0.1 + 1;
    lo -= pad;
    hi += pad;
    final plot = Rect.fromLTRB(padLeft, padTop, size.width - padRight, size.height - padBottom);
    final n = w.primary.length;
    double xAt(int i) => plot.left + plot.width * (i / (n - 1));
    double yAt(double v) => plot.bottom - plot.height * ((v - lo) / (hi - lo));

    // Grid + y labels
    final grid = Paint()
      ..color = C.lineSoft
      ..strokeWidth = 1;
    for (var g = 0; g <= 4; g++) {
      final v = lo + (hi - lo) * g / 4;
      final y = yAt(v);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      _text(canvas, _axis(v), Offset(0, y - 7), T.mono(9.5, color: C.faint), maxW: padLeft - 6);
    }
    // Zero line
    if (lo < 0 && hi > 0) {
      canvas.drawLine(Offset(plot.left, yAt(0)), Offset(plot.right, yAt(0)),
          Paint()..color = C.line..strokeWidth = 1);
    }
    // X labels
    final every = max(1, (n / (size.width < 500 ? 5 : 9)).ceil());
    for (var i = 0; i < n; i += every) {
      _text(canvas, w.xLabels[i], Offset(xAt(i) - 14, plot.bottom + 10), T.mono(9.5, color: C.faint));
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, plot.left + plot.width * progress + 1, size.height));

    // Band
    if (w.low != null && w.high != null) {
      final band = Path()..moveTo(xAt(0), yAt(w.high![0]));
      for (var i = 1; i < n; i++) {
        band.lineTo(xAt(i), yAt(w.high![i]));
      }
      for (var i = n - 1; i >= 0; i--) {
        band.lineTo(xAt(i), yAt(w.low![i]));
      }
      band.close();
      canvas.drawPath(band, Paint()..color = C.champagne.withValues(alpha: 0.08));
      final edge = Paint()
        ..color = C.champagne.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawPath(_line(w.low!, xAt, yAt), edge);
      canvas.drawPath(_line(w.high!, xAt, yAt), edge);
    }

    // Threshold
    if (w.threshold != null) {
      final y = yAt(w.threshold!);
      _dash(canvas, Offset(plot.left, y), Offset(plot.right, y),
          Paint()..color = C.negative.withValues(alpha: 0.7)..strokeWidth = 1);
    }

    // Comparison
    if (w.comparison != null) {
      _dashPath(canvas, w.comparison!, xAt, yAt,
          Paint()..color = C.gunmetal..strokeWidth = 1.2..style = PaintingStyle.stroke);
    }

    // Primary fill
    final fill = _line(w.primary, xAt, yAt)
      ..lineTo(xAt(n - 1), plot.bottom)
      ..lineTo(xAt(0), plot.bottom)
      ..close();
    canvas.drawPath(
        fill,
        Paint()
          ..shader = ui.Gradient.linear(Offset(0, plot.top), Offset(0, plot.bottom),
              [C.platinum.withValues(alpha: 0.12), C.platinum.withValues(alpha: 0)]));

    // Primary — solid for actuals, lighter for forecast.
    final split = w.splitIndex ?? 0;
    final strong = Paint()
      ..color = C.platinum
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    if (split > 0) {
      canvas.drawPath(_line(w.primary.sublist(0, split + 1), xAt, yAt), strong);
      final fc = Path()..moveTo(xAt(split), yAt(w.primary[split]));
      for (var i = split + 1; i < n; i++) {
        fc.lineTo(xAt(i), yAt(w.primary[i]));
      }
      canvas.drawPath(fc, strong..color = C.champagne);
      // Today marker
      final x = xAt(split);
      _dash(canvas, Offset(x, plot.top), Offset(x, plot.bottom), Paint()..color = C.line);
      _text(canvas, 'TODAY', Offset(x + 6, plot.top), T.mono(9, color: C.muted, letterSpacing: 1.2));
    } else {
      canvas.drawPath(_line(w.primary, xAt, yAt), strong);
    }
    canvas.restore();

    if (w.threshold != null) {
      _text(canvas, '${w.thresholdLabel} ${w.format(w.threshold!)}',
          Offset(plot.right - 164, yAt(w.threshold!) - 16), T.mono(9.5, color: C.negative), maxW: 160, right: true);
    }

    // Hover crosshair + exact values
    if (hover != null) {
      final i = hover!.clamp(0, n - 1);
      final x = xAt(i);
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), Paint()..color = C.line);
      canvas.drawCircle(Offset(x, yAt(w.primary[i])), 4, Paint()..color = C.bg);
      canvas.drawCircle(Offset(x, yAt(w.primary[i])), 4,
          Paint()..color = C.platinum..style = PaintingStyle.stroke..strokeWidth = 1.5);
      final lines = <(String, String)>[
        (w.xLabels[i], ''),
        (w.primaryLabel, w.format(w.primary[i])),
        if (w.comparison != null) (w.comparisonLabel, w.format(w.comparison![i])),
        if (w.low != null) ('Range', '${w.format(w.low![i])} – ${w.format(w.high![i])}'),
      ];
      const bw = 200.0;
      final bh = 14.0 + lines.length * 18;
      var bx = x + 12;
      if (bx + bw > size.width) bx = x - bw - 12;
      final box = RRect.fromRectAndRadius(Rect.fromLTWH(bx, plot.top + 4, bw, bh), const Radius.circular(2));
      canvas.drawRRect(box, Paint()..color = C.bg3);
      canvas.drawRRect(box, Paint()..color = C.line..style = PaintingStyle.stroke);
      for (var k = 0; k < lines.length; k++) {
        final (a, b) = lines[k];
        final y = plot.top + 11 + k * 18;
        _text(canvas, a, Offset(bx + 10, y), k == 0 ? T.mono(10, color: C.champagne) : T.body(11.5, color: C.muted));
        if (b.isNotEmpty) {
          _text(canvas, b, Offset(bx + 10, y), T.mono(11, color: C.text), maxW: bw - 20, right: true);
        }
      }
    }
  }

  String _axis(double v) {
    final a = v.abs();
    final s = a >= 1e7 ? '${(a / 1e7).toStringAsFixed(1)} Cr' : a >= 1e5 ? '${(a / 1e5).toStringAsFixed(0)} L' : a >= 1e3 ? '${(a / 1e3).toStringAsFixed(0)}K' : a.toStringAsFixed(0);
    return '${v < 0 ? '−' : ''}₹$s';
  }

  Path _line(List<double> s, double Function(int) x, double Function(double) y) {
    final p = Path()..moveTo(x(0), y(s[0]));
    for (var i = 1; i < s.length; i++) {
      p.lineTo(x(i), y(s[i]));
    }
    return p;
  }

  void _dashPath(Canvas c, List<double> s, double Function(int) x, double Function(double) y, Paint p) {
    for (var i = 1; i < s.length; i++) {
      _dash(c, Offset(x(i - 1), y(s[i - 1])), Offset(x(i), y(s[i])), p);
    }
  }

  void _dash(Canvas c, Offset a, Offset b, Paint p) {
    const dash = 5.0, gap = 4.0;
    final d = (b - a).distance;
    if (d == 0) return;
    final dir = (b - a) / d;
    for (double s = 0; s < d; s += dash + gap) {
      c.drawLine(a + dir * s, a + dir * min(s + dash, d), p);
    }
  }

  void _text(Canvas c, String s, Offset o, TextStyle st, {double? maxW, bool right = false}) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: st),
      textDirection: TextDirection.ltr,
      textAlign: right ? TextAlign.right : TextAlign.left,
      maxLines: 1,
      ellipsis: '…',
    )..layout(minWidth: right && maxW != null ? maxW : 0, maxWidth: maxW ?? 400);
    tp.paint(c, o);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.hover != hover || old.progress != progress || old.w != w;
}

/// Minimal sparkline.
class Sparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double height;
  const Sparkline(this.data, {super.key, this.color = C.platinum, this.height = 40});
  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _SparkPainter(data, color)),
      );
}

class _SparkPainter extends CustomPainter {
  final List<double> d;
  final Color color;
  _SparkPainter(this.d, this.color);
  @override
  void paint(Canvas canvas, Size s) {
    if (d.length < 2) return;
    final lo = d.reduce(min), hi = d.reduce(max);
    double x(int i) => s.width * i / (d.length - 1);
    double y(double v) => s.height - (hi == lo ? 0.5 : (v - lo) / (hi - lo)) * s.height;
    final p = Path()..moveTo(x(0), y(d[0]));
    for (var i = 1; i < d.length; i++) {
      p.lineTo(x(i), y(d[i]));
    }
    final f = Path.from(p)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    canvas.drawPath(
        f,
        Paint()
          ..shader = ui.Gradient.linear(Offset.zero, Offset(0, s.height),
              [color.withValues(alpha: 0.18), color.withValues(alpha: 0)]));
    canvas.drawPath(p, Paint()..color = color..strokeWidth = 1.4..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(x(d.length - 1), y(d.last)), 2.5, Paint()..color = C.champagne);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter old) => old.d != d;
}

/// Horizontal proportion bars with exact values (for breakdowns).
class BreakdownBars extends StatelessWidget {
  final List<(String, num)> items;
  const BreakdownBars(this.items, {super.key});
  @override
  Widget build(BuildContext context) {
    final maxV = items.map((e) => e.$2.abs()).reduce(max);
    return Column(children: [
      for (final (label, v) in items)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            SizedBox(width: 150, child: Text(label, style: T.body(13, color: C.muted), overflow: TextOverflow.ellipsis)),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) => Align(
                  alignment: Alignment.centerLeft,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: v.abs() / maxV),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, f, _) => Container(
                      height: 6,
                      width: c.maxWidth * f,
                      color: v < 0 ? C.negative.withValues(alpha: 0.7) : C.platinum.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
                width: 96,
                child: Text(inrCompact(v), textAlign: TextAlign.right, style: T.mono(12, color: C.text))),
          ]),
        ),
    ]);
  }
}
