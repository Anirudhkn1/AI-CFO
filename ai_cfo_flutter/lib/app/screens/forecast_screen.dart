import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/models.dart';
import '../../core/tokens.dart';
import '../../widgets/charts.dart';
import '../../widgets/common.dart';
import '../app_data.dart';
import 'overview_screen.dart';

class ForecastScreen extends StatefulWidget {
  final Workspace ws;
  const ForecastScreen({super.key, required this.ws});
  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  int _weeks = 13;
  bool _band = true;

  @override
  Widget build(BuildContext context) {
    final personal = widget.ws == Workspace.personal;
    final s = weeklySeries(widget.ws, forecastWeeks: _weeks);
    final end = s.values.last;
    final lowEnd = s.low.last;
    final drivers = driversFor(widget.ws);
    final t = Bp.tablet(context);

    final summary = Grid(minItemWidth: 180, columns: 3, children: [
      for (final (k, v, sub) in [
        ('Today', inrCompact(s.values[s.split]), 'Actual · reconciled'),
        ('In ${_weeks * 7} days', inrCompact(end), 'Base case'),
        ('Downside', inrCompact(lowEnd), personal ? 'Spending +6%, freelance late' : 'Collections 30 days slower'),
      ])
        Panel(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(k.toUpperCase(), style: T.mono(9.5, color: C.faint, letterSpacing: 1.4)),
            const SizedBox(height: 10),
            Text(v, style: T.figure(30)),
            const SizedBox(height: 6),
            Text(sub, style: T.body(12, color: C.muted)),
          ]),
        ),
    ]);

    final chart = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Segmented<int>(
            dense: true,
            options: const [(5, '30 days'), (13, '90 days'), (26, '180 days')],
            value: _weeks,
            onChanged: (v) => setState(() => _weeks = v),
          ),
          Chip2('Show range', selected: _band, icon: _band ? Icons.check : null, onTap: () => setState(() => _band = !_band)),
        ]),
        const SizedBox(height: 20),
        ForecastChart(
          key: ValueKey('$_weeks-$_band'),
          xLabels: s.labels,
          primary: s.values,
          primaryLabel: 'Base case',
          low: _band ? s.low : null,
          high: _band ? s.high : null,
          splitIndex: s.split,
          threshold: personal ? 30000 : 5000000,
          thresholdLabel: personal ? 'Your floor' : 'Reserve policy',
          height: t ? 260 : 340,
        ),
        const SizedBox(height: 12),
        Text('Hover or drag for exact values · forecast v2.4.0 · generated 24 Nov 2026, 06:00', style: T.mono(10, color: C.faint)),
      ]),
    );

    final driverPanel = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('What drives the next 30 days', style: T.body(16, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Confirmed items are kept apart from estimates.', style: T.body(13, color: C.muted)),
        const SizedBox(height: 12),
        for (final d in drivers)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.lineSoft))),
            child: Row(children: [
              SizedBox(width: 56, child: Text(d.date, style: T.mono(11))),
              Expanded(child: Text(d.item, style: T.body(13.5, height: 1.35))),
              const SizedBox(width: 10),
              StatusTag(d.tag),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: Text(inrCompact(d.amount, sign: true),
                    textAlign: TextAlign.right, style: T.mono(12.5, color: d.amount > 0 ? C.positive : C.text)),
              ),
            ]),
          ),
      ]),
    );

    final changed = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('What changed since last week', style: T.body(16, weight: FontWeight.w600)),
        const SizedBox(height: 14),
        for (final (a, b) in personal
            ? const [
                ('−₹6,420', 'Dining & delivery running above budget'),
                ('+₹28,000', 'Freelance retainer now expected 5 Dec'),
                ('−₹20,000', 'Emergency-fund transfer added (pending approval)'),
              ]
            : const [
                ('−₹12.2 L', 'Kestrel Foods payment moved 30 days later'),
                ('−₹1.38 L/mo', 'Cloud bill increase carried forward'),
                ('+₹4.1 L', 'Renewals moved to quarterly billing (assumption)'),
              ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  width: 96,
                  child: Text(a, style: T.mono(12, color: a.startsWith('+') ? C.positive : C.negative))),
              Expanded(child: Text(b, style: T.body(13.5, color: C.muted))),
            ]),
          ),
      ]),
    );

    return ListView(padding: screenPad(context), children: [
      summary,
      const SizedBox(height: 14),
      chart,
      const SizedBox(height: 14),
      if (t) ...[driverPanel, const SizedBox(height: 14), changed]
      else
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: driverPanel),
          const SizedBox(width: 14),
          Expanded(flex: 2, child: changed),
        ]),
    ]);
  }
}
