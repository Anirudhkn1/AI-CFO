import 'package:flutter/material.dart';

import '../core/models.dart';
import '../core/tokens.dart';

/// Gives a builder the current hover state (pointer devices only).
class Hover extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovered) builder;
  final MouseCursor cursor;
  const Hover({super.key, required this.builder, this.cursor = SystemMouseCursors.click});
  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: widget.cursor,
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: widget.builder(context, _h),
      );
}

/// Centered max-width column with responsive gutters.
class Contained extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const Contained({super.key, required this.child, this.maxWidth = kMaxWidth});
  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth + Bp.gutter(context) * 2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Bp.gutter(context)),
            child: child,
          ),
        ),
      );
}

class Eyebrow extends StatelessWidget {
  final String text;
  final bool center;
  final Color color;
  const Eyebrow(this.text, {super.key, this.center = false, this.color = C.muted});
  @override
  Widget build(BuildContext context) {
    final rule = Container(width: 28, height: 1, color: C.line);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        rule,
        const SizedBox(width: 12),
        Flexible(child: Text(text.toUpperCase(), style: T.label(color: color))),
        if (center) ...[const SizedBox(width: 12), rule],
      ],
    );
  }
}

class SectionHead extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? sub;
  final bool center;
  const SectionHead(
      {super.key, required this.eyebrow, required this.title, this.sub, this.center = false});
  @override
  Widget build(BuildContext context) {
    final m = Bp.mobile(context);
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final ta = center ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Eyebrow(eyebrow, center: center),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Text(title, textAlign: ta, style: T.display(m ? 40 : 64)),
        ),
        if (sub != null) ...[
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(sub!, textAlign: ta, style: T.body(m ? 16 : 18, color: C.muted)),
          ),
        ],
      ],
    );
  }
}

/// Primary (platinum) and ghost buttons — square, uppercase, tracked.
class PButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool ghost;
  final bool small;
  final IconData? icon;
  const PButton(this.label,
      {super.key, this.onTap, this.ghost = false, this.small = false, this.icon});
  @override
  Widget build(BuildContext context) {
    return Hover(builder: (context, h) {
      final bg = ghost ? (h ? C.surface2 : Colors.transparent) : (h ? C.champagne : C.platinum);
      final fg = ghost ? C.text : C.bg;
      final border = ghost ? (h ? C.platinum : C.line) : Colors.transparent;
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: small ? 16 : 26, vertical: small ? 11 : 17),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(kRadius),
            boxShadow: !ghost && h
                ? [BoxShadow(color: C.champagne.withValues(alpha: 0.25), blurRadius: 30)]
                : null,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label.toUpperCase(),
                style: T.body(small ? 11 : 12,
                    color: fg, weight: FontWeight.w600, letterSpacing: 1.8, height: 1)),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, size: small ? 14 : 16, color: fg),
            ],
          ]),
        ),
      );
    });
  }
}

/// Text link with an underline that draws in on hover.
class LinkText extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final TextStyle? style;
  const LinkText(this.label, {super.key, this.onTap, this.style});
  @override
  Widget build(BuildContext context) => Hover(
        builder: (context, h) => GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: (style ?? T.body(14, color: C.muted)).copyWith(color: h ? C.text : null),
                child: Text(label),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                height: 1,
                width: h ? 24 : 0,
                color: C.champagne,
              ),
            ],
          ),
        ),
      );
}

/// Hairline panel.
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  const Panel(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(24),
      this.color,
      this.borderColor});
  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? C.surface,
          border: Border.all(color: borderColor ?? C.lineSoft),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: child,
      );
}

/// PRD §14 status label: Actual · Forecast · Estimate · Manually entered · Needs review…
class StatusTag extends StatelessWidget {
  final Tag tag;
  const StatusTag(this.tag, {super.key});
  Color get _c => switch (tag) {
        Tag.actual || Tag.confirmed => C.platinum,
        Tag.forecast => C.champagne,
        Tag.estimate || Tag.manual => C.gunmetal,
        Tag.needsReview => C.negative,
        Tag.edited => C.positive,
        Tag.insufficient => C.faint,
      };
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: _c.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                  color: tag == Tag.estimate || tag == Tag.manual ? Colors.transparent : _c,
                  border: Border.all(color: _c),
                  shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(tag.label.toUpperCase(),
              style: T.mono(9.5, color: _c, letterSpacing: 1.1, weight: FontWeight.w500)),
        ]),
      );
}

/// Four bars + label. Never a decorative percentage (PRD Appendix B).
class ConfidenceMeter extends StatelessWidget {
  final Confidence confidence;
  final bool compact;
  const ConfidenceMeter(this.confidence, {super.key, this.compact = false});
  @override
  Widget build(BuildContext context) {
    final on = confidence == Confidence.insufficient ? C.faint : C.champagne;
    return Tooltip(
      message: 'Based on data completeness, freshness, reconciliation and model performance — not a guess.',
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: 3,
            height: 6.0 + i * 2.5,
            margin: const EdgeInsets.only(right: 2),
            color: i < confidence.bars ? on : C.line,
          ),
        const SizedBox(width: 7),
        Text(compact ? confidence.label : 'Confidence · ${confidence.label}',
            style: T.mono(10.5, color: C.muted)),
      ]),
    );
  }
}

class Hairline extends StatelessWidget {
  final bool vertical;
  final Color color;
  const Hairline({super.key, this.vertical = false, this.color = C.lineSoft});
  @override
  Widget build(BuildContext context) => vertical
      ? Container(width: 1, color: color)
      : Container(height: 1, color: color);
}

/// Fades and lifts its child the first time it scrolls into view.
class Reveal extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final double offset;
  const Reveal({super.key, required this.child, this.delayMs = 0, this.offset = 28});
  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _shown = false;
  ScrollPosition? _pos;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pos?.removeListener(_check);
    _pos = Scrollable.maybeOf(context)?.position;
    _pos?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return;
    final y = box.localToGlobal(Offset.zero).dy;
    if (y < MediaQuery.sizeOf(context).height * 0.92) {
      _pos?.removeListener(_check);
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) setState(() => _shown = true);
      });
    }
  }

  @override
  void dispose() {
    _pos?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: _shown ? 1 : 0,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _shown ? Offset.zero : Offset(0, widget.offset / 400),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      );
}

/// Square segmented control.
class Segmented<V> extends StatelessWidget {
  final List<(V, String)> options;
  final V value;
  final ValueChanged<V> onChanged;
  final bool dense;
  const Segmented(
      {super.key,
      required this.options,
      required this.value,
      required this.onChanged,
      this.dense = false});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            border: Border.all(color: C.line), borderRadius: BorderRadius.circular(kRadius)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          for (final (v, label) in options)
            Hover(
              builder: (context, h) => GestureDetector(
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.symmetric(horizontal: dense ? 12 : 18, vertical: dense ? 7 : 10),
                  decoration: BoxDecoration(
                    color: v == value ? C.platinum : (h ? C.surface2 : Colors.transparent),
                    borderRadius: BorderRadius.circular(kRadius),
                  ),
                  child: Text(label.toUpperCase(),
                      style: T.body(dense ? 10.5 : 11.5,
                          color: v == value ? C.bg : C.muted,
                          weight: FontWeight.w600,
                          letterSpacing: 1.4,
                          height: 1)),
                ),
              ),
            ),
        ]),
      );
}

class Chip2 extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  const Chip2(this.label, {super.key, this.selected = false, this.onTap, this.icon});
  @override
  Widget build(BuildContext context) => Hover(
        builder: (context, h) => GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? C.surface2 : (h ? C.surface : Colors.transparent),
              border: Border.all(color: selected ? C.platinum.withValues(alpha: 0.6) : C.line),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (icon != null) ...[Icon(icon, size: 14, color: C.champagne), const SizedBox(width: 8)],
              Text(label, style: T.body(13, color: selected || h ? C.text : C.muted, height: 1.2)),
            ]),
          ),
        ),
      );
}

/// Key / value row used for evidence and exact approval parameters.
class KV extends StatelessWidget {
  final String k;
  final String v;
  final bool mono;
  const KV(this.k, this.v, {super.key, this.mono = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 140, child: Text(k, style: T.body(13, color: C.muted))),
          Expanded(
              child: Text(v,
                  style: mono ? T.mono(12.5, color: C.text) : T.body(13.5, color: C.text))),
        ]),
      );
}
