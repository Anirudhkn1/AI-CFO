import 'dart:async';

import 'package:flutter/material.dart';

import '../core/tokens.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';
import '../widgets/logo.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onOpenApp;
  final VoidCallback onSeeHow;
  const HeroSection({super.key, required this.onOpenApp, required this.onSeeHow});

  @override
  Widget build(BuildContext context) {
    final m = Bp.mobile(context);
    final t = Bp.tablet(context);
    final h = MediaQuery.sizeOf(context).height;

    final copy = Column(
      crossAxisAlignment: t ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Eyebrow('Obsid-finance · Personal & Business · India-first', center: t),
        SizedBox(height: m ? 26 : 34),
        Text('Your money,',
            textAlign: t ? TextAlign.center : TextAlign.start,
            style: T.display(m ? 56 : 104, height: 0.98, letterSpacing: -1)),
        ShimmerText('finally explained.',
            textAlign: t ? TextAlign.center : TextAlign.start,
            style: T.display(m ? 56 : 104, height: 1.02, letterSpacing: -1)),
        SizedBox(height: m ? 22 : 30),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Obsid-finance brings your accounts, statements and invoices into one calm view, forecasts what comes next, '
            'and answers in plain language — with the evidence behind every number. Nothing moves without your approval.',
            textAlign: t ? TextAlign.center : TextAlign.start,
            style: T.body(m ? 16 : 18, color: C.muted, height: 1.6),
          ),
        ),
        SizedBox(height: m ? 28 : 40),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: t ? WrapAlignment.center : WrapAlignment.start,
          children: [
            PButton('Open the app', onTap: onOpenApp, icon: Icons.arrow_forward),
            PButton('See how it answers', ghost: true, onTap: onSeeHow),
          ],
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 22,
          runSpacing: 8,
          alignment: t ? WrapAlignment.center : WrapAlignment.start,
          children: [
            for (final s in ['Evidence on every number', 'Approval before every action', 'Personal & business never mixed'])
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 4, height: 4, color: C.champagne),
                const SizedBox(width: 8),
                Text(s, style: T.mono(11, color: C.muted)),
              ]),
          ],
        ),
      ],
    );

    return Stack(children: [
      const Positioned.fill(child: SilkBackground()),
      if (!m) ...[
        Positioned(top: 104, left: 32, child: Text('19.0760° N · 72.8777° E', style: T.mono(10, color: C.faint))),
        Positioned(top: 104, right: 32, child: Text('MMXXVI', style: T.mono(10, color: C.faint))),
        Positioned(bottom: 28, left: 32, child: Text('OBSID-FINANCE', style: T.mono(10, color: C.faint, letterSpacing: 2))),
        Positioned(bottom: 28, right: 32, child: Text('SCROLL ↓', style: T.mono(10, color: C.faint, letterSpacing: 2))),
      ],
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: m ? 0 : (h < 820 ? 820 : h)),
        child: Contained(
          child: Padding(
            padding: EdgeInsets.only(top: m ? 120 : 150, bottom: m ? 72 : 110),
            child: t
                ? Column(children: [
                    copy,
                    const SizedBox(height: 64),
                    const Reveal(delayMs: 250, child: PhoneChatDemo()),
                  ])
                : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(flex: 7, child: copy),
                    const SizedBox(width: 40),
                    const Expanded(flex: 5, child: Reveal(delayMs: 250, child: Center(child: PhoneChatDemo()))),
                  ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Phone mock with a scripted conversation ─────────────────────────────────
enum _Kind { user, ai, typing }

class _Step {
  final _Kind kind;
  final String? text;
  final Widget Function()? card;
  final int holdMs;
  const _Step(this.kind, {this.text, this.card, this.holdMs = 1600});
}

class PhoneChatDemo extends StatefulWidget {
  const PhoneChatDemo({super.key});
  @override
  State<PhoneChatDemo> createState() => _PhoneChatDemoState();
}

class _PhoneChatDemoState extends State<PhoneChatDemo> {
  late final List<_Step> _script = [
    const _Step(_Kind.user, text: 'What’s my net worth today?', holdMs: 900),
    const _Step(_Kind.typing, holdMs: 1100),
    _Step(_Kind.ai, card: _netWorthCard, holdMs: 3600),
    const _Step(_Kind.user, text: 'Can I afford a ₹80,000 laptop this month?', holdMs: 900),
    const _Step(_Kind.typing, holdMs: 1300),
    _Step(_Kind.ai, card: _affordCard, holdMs: 6500),
  ];
  final List<_Step> _shown = [];
  int _i = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 900), _next);
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      if (_i >= _script.length) {
        _shown.clear();
        _i = 0;
      }
      final s = _script[_i];
      _shown.removeWhere((e) => e.kind == _Kind.typing);
      _shown.add(s);
      _i++;
    });
    _timer = Timer(Duration(milliseconds: _shown.last.holdMs), _next);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = Bp.mobile(context) ? 0.92 : 1.0;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 340,
        height: 690,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(46),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3A3A3E), Color(0xFF151517), Color(0xFF2B2B2F)],
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 80, offset: const Offset(0, 40)),
            BoxShadow(color: C.champagne.withValues(alpha: 0.06), blurRadius: 120),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(37),
          child: Container(
            color: const Color(0xFF0D0D0F),
            child: Column(children: [
              // Status bar + island
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 12, 22, 0),
                child: Row(children: [
                  Text('9:41', style: T.body(13, weight: FontWeight.w600)),
                  const Spacer(),
                  Container(width: 92, height: 26, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20))),
                  const Spacer(),
                  const Icon(Icons.signal_cellular_alt, size: 14, color: C.text),
                  const SizedBox(width: 4),
                  const Icon(Icons.battery_full, size: 14, color: C.text),
                ]),
              ),
              // App header
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                child: Row(children: [
                  const Logo(compact: true, size: 16),
                  const SizedBox(width: 10),
                  displayText('Obsid-finance', T.display(18, letterSpacing: 1.5)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: C.line), borderRadius: BorderRadius.circular(20)),
                    child: Text('PERSONAL', style: T.mono(8.5, color: C.champagne, letterSpacing: 1.2)),
                  ),
                ]),
              ),
              const Hairline(),
              // Conversation
              Expanded(
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.bottomCenter,
                    maxHeight: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [for (var k = 0; k < _shown.length; k++) _bubble(_shown[k], k)],
                      ),
                    ),
                  ),
                ),
              ),
              // Composer
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 22),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: C.surface,
                  border: Border.all(color: C.line),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(children: [
                  Expanded(child: Text('Ask about your money…', style: T.body(13, color: C.faint))),
                  const Icon(Icons.mic_none, size: 18, color: C.muted),
                  const SizedBox(width: 10),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(color: C.platinum, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_upward, size: 15, color: C.bg),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _bubble(_Step s, int k) {
    Widget child;
    switch (s.kind) {
      case _Kind.user:
        child = Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 240),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: C.platinum,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(s.text!, style: T.body(13.5, color: C.bg, height: 1.35)),
          ),
        );
      case _Kind.typing:
        child = Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: C.surface2, borderRadius: BorderRadius.circular(16)),
            child: const TypingDots(),
          ),
        );
      case _Kind.ai:
        child = s.card!();
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey('$k-${s.kind}-${s.text}'),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, v, c) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * 14), child: c),
      ),
      child: Padding(padding: const EdgeInsets.only(top: 12), child: child),
    );
  }

  static Widget _aiShell(List<Widget> children) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bg2,
          border: Border.all(color: C.line),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  static Widget _row(String a, String b, {Color? color, bool faint = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Expanded(child: Text(a, style: T.body(11.5, color: faint ? C.faint : C.muted, height: 1.2))),
          Text(b, style: T.mono(11, color: color ?? C.text)),
        ]),
      );

  static Widget _foot(String s) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(s, style: T.mono(9, color: C.faint)),
      );

  static Widget _netWorthCard() => _aiShell([
        Text('NET WORTH · 24 NOV', style: T.mono(9, color: C.faint, letterSpacing: 1.4)),
        const SizedBox(height: 6),
        Text('₹48,62,300', style: T.figure(30)),
        const SizedBox(height: 2),
        Text('+₹1,12,400 since 1 Nov', style: T.mono(10.5, color: C.positive)),
        const SizedBox(height: 8),
        const Hairline(),
        const SizedBox(height: 6),
        _row('Bank & cash', '₹6,84,200'),
        _row('Funds & stocks', '₹22,40,100'),
        _row('EPF & PPF · estimate', '₹9,18,000'),
        _row('Flat · manually entered', '₹42,00,000'),
        _row('Home loan', '−₹31,80,000', color: C.negative),
        _foot('4 of 5 sources current · Confidence: Medium'),
      ]);

  static Widget _affordCard() => _aiShell([
        Text('Yes — but not this week.', style: T.body(14, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Buying today takes you below your ₹30,000 cash floor until salary on 1 Dec.',
            style: T.body(11.5, color: C.muted, height: 1.4)),
        const SizedBox(height: 8),
        _row('Available cash', '₹1,42,300'),
        _row('Bills due by 30 Nov', '−₹38,900'),
        _row('Laptop', '−₹80,000'),
        const Hairline(),
        _row('Left until 1 Dec', '₹23,400', color: C.negative),
        const SizedBox(height: 8),
        Text('OPTIONS', style: T.mono(9, color: C.faint, letterSpacing: 1.4)),
        _row('01  Buy on 1 Dec', 'floor holds', color: C.positive),
        _row('02  No-cost EMI × 6', '₹13,334/mo'),
        _row('03  Save for 3 months', 'goals intact'),
        _foot('Sources: HDFC ••4521 · 3 bills · The decision is yours'),
      ]);
}
