import 'package:flutter/material.dart';

import '../../core/engine.dart';
import '../../core/format.dart';
import '../../core/models.dart';
import '../../core/sample_data.dart';
import '../../core/tokens.dart';
import '../../widgets/charts.dart';
import '../../widgets/common.dart';
import '../app_data.dart';
import '../app_shell.dart';

EdgeInsets screenPad(BuildContext c) =>
    Bp.tablet(c) ? const EdgeInsets.fromLTRB(16, 20, 16, 40) : const EdgeInsets.fromLTRB(40, 32, 40, 56);

/// Lays out children in a responsive grid of equal columns.
class Grid extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final double gap;
  final double minItemWidth;
  const Grid({super.key, required this.children, this.columns = 4, this.gap = 14, this.minItemWidth = 220});
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        var n = columns;
        while (n > 1 && (c.maxWidth - (n - 1) * gap) / n < minItemWidth) {
          n--;
        }
        final w = (c.maxWidth - (n - 1) * gap) / n;
        return Wrap(spacing: gap, runSpacing: gap, children: [for (final ch in children) SizedBox(width: w, child: ch)]);
      });
}

class OverviewScreen extends StatelessWidget {
  final Workspace ws;
  final WorkspaceState state;
  final ValueChanged<String> onNavigate;
  const OverviewScreen({super.key, required this.ws, required this.state, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final personal = ws == Workspace.personal;
    final t = Bp.tablet(context);
    final kpis = personal ? personalKpis : businessKpis;
    final insights = personal ? personalInsights : businessInsights;
    final sources = personal ? personalSources : businessSources;
    final series = weeklySeries(ws);
    final runway = runBusiness(const BusinessInputs(hires: 0)).runwayScenario;

    final status = Panel(
      padding: const EdgeInsets.all(28),
      color: C.bg2,
      borderColor: C.line,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(personal ? 'NET WORTH' : 'CASH POSITION', style: T.label(size: 10)),
          const Spacer(),
          const StatusTag(Tag.actual),
        ]),
        const SizedBox(height: 16),
        Text(personal ? inr(personalNetWorth) : inrCompact(18400000),
            style: T.figure(Bp.mobile(context) ? 46 : 64)),
        const SizedBox(height: 8),
        Wrap(spacing: 18, runSpacing: 6, children: [
          Text(personal ? '${inr(personalNetWorthDelta, sign: true)} since 1 Nov' : '−₹18.6 L in October',
              style: T.mono(12, color: personal ? C.positive : C.negative)),
          Text(
              personal
                  ? 'Liquid after loans: ₹6,62,300'
                  : 'Runway ${runway ?? '18+'} months at current burn',
              style: T.mono(12, color: C.muted)),
        ]),
        const SizedBox(height: 22),
        Sparkline(
            personal
                ? const [41.2, 42.0, 41.6, 43.1, 44.0, 43.4, 45.2, 46.1, 45.8, 47.5, 48.62]
                : const [2.61, 2.52, 2.47, 2.38, 2.30, 2.21, 2.16, 2.02, 1.97, 1.84],
            height: 58),
        const SizedBox(height: 10),
        Text(personal ? 'Last 11 months' : 'Last 10 months', style: T.mono(10, color: C.faint)),
      ]),
    );

    final next = GestureDetector(
      onTap: () => onNavigate('approvals'),
      child: Panel(
        padding: const EdgeInsets.all(28),
        borderColor: C.champagne.withValues(alpha: 0.4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.bolt_outlined, size: 16, color: C.champagne),
            const SizedBox(width: 8),
            Text('MOST IMPORTANT NEXT ACTION', style: T.label(size: 10, color: C.champagne)),
          ]),
          const SizedBox(height: 18),
          Text(
              personal
                  ? 'Move ₹20,000 to your emergency fund on 1 Dec.'
                  : 'Three overdue invoices hold ₹14.8 L of your cash.',
              style: T.display(28, height: 1.15)),
          const SizedBox(height: 12),
          Text(
              personal
                  ? 'Keeps you on track to finish the fund in March. You complete the transfer in your bank app.'
                  : 'Reminder drafts are prepared. Collecting them adds about 0.9 months of runway.',
              style: T.body(14, color: C.muted)),
          const SizedBox(height: 22),
          Row(children: [
            PButton('Review & approve', small: true, onTap: () => onNavigate('approvals'), icon: Icons.arrow_forward),
            const SizedBox(width: 14),
            Text('${state.pending} pending', style: T.mono(11)),
          ]),
        ]),
      ),
    );

    final kpiTiles = [
      for (final k in kpis)
        Panel(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(k.label, style: T.body(13, color: C.muted))),
              StatusTag(k.tag),
            ]),
            const SizedBox(height: 16),
            Text(k.isPercent ? pct(k.value, digits: 0) : inrCompact(k.value), style: T.figure(34)),
            const SizedBox(height: 8),
            Text(k.delta ?? '',
                style: T.mono(11,
                    color: k.deltaUp == null ? C.muted : (k.deltaUp! ? C.positive : C.negative))),
          ]),
        ),
    ];

    final chart = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Cash forecast · next 90 days', style: T.body(16, weight: FontWeight.w600))),
          LinkText('Open forecast', onTap: () => onNavigate('forecast'), style: T.body(12.5, color: C.champagne)),
        ]),
        const SizedBox(height: 4),
        Text(personal ? 'Weekly closing balance · HDFC ••4521' : 'Weekly closing cash · all business accounts',
            style: T.mono(10.5)),
        const SizedBox(height: 18),
        ForecastChart(
          xLabels: series.labels,
          primary: series.values,
          primaryLabel: 'Base case',
          low: series.low,
          high: series.high,
          splitIndex: series.split,
          threshold: personal ? 30000 : null,
          thresholdLabel: 'Your floor',
          height: 260,
        ),
        const SizedBox(height: 10),
        Text('Solid = actual · champagne = forecast · band = downside to optimistic', style: T.mono(10, color: C.faint)),
      ]),
    );

    final insightCol = Column(children: [
      for (final i in insights)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Panel(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(i.period.toUpperCase(), style: T.mono(9.5, color: C.faint, letterSpacing: 1.2))),
                ConfidenceMeter(i.confidence, compact: true),
              ]),
              const SizedBox(height: 10),
              Text(i.title, style: T.body(15.5, weight: FontWeight.w600, height: 1.35)),
              const SizedBox(height: 6),
              Text(i.impact, style: T.mono(12, color: i.impactPositive ? C.positive : C.negative)),
              const SizedBox(height: 8),
              Text(i.body, style: T.body(13, color: C.muted)),
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.link, size: 12, color: C.champagne),
                const SizedBox(width: 6),
                Expanded(child: Text(i.evidence, style: T.mono(10.5, color: C.text), overflow: TextOverflow.ellipsis)),
                LinkText('Evidence', onTap: () => onNavigate('transactions'), style: T.body(12, color: C.champagne)),
              ]),
            ]),
          ),
        ),
    ]);

    final sourcesPanel = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Data coverage', style: T.body(16, weight: FontWeight.w600))),
          LinkText('Manage', onTap: () => onNavigate('connections'), style: T.body(12.5, color: C.champagne)),
        ]),
        const SizedBox(height: 10),
        for (final s in sources) SourceRow(s, onFix: () => onNavigate('connections')),
      ]),
    );

    final activityPanel = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Activity', style: T.body(16, weight: FontWeight.w600)),
        const SizedBox(height: 14),
        ActivityTimeline(state.activity.take(5).toList()),
      ]),
    );

    return ListView(padding: screenPad(context), children: [
      if (t) ...[status, const SizedBox(height: 14), next]
      else
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(flex: 7, child: status),
            const SizedBox(width: 14),
            Expanded(flex: 5, child: next),
          ]),
        ),
      const SizedBox(height: 14),
      Grid(children: kpiTiles, minItemWidth: 200),
      const SizedBox(height: 14),
      if (t) ...[chart, const SizedBox(height: 14), insightCol]
      else
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 7, child: chart),
          const SizedBox(width: 14),
          Expanded(flex: 5, child: insightCol),
        ]),
      const SizedBox(height: 2),
      if (t) ...[sourcesPanel, const SizedBox(height: 14), activityPanel]
      else
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: sourcesPanel),
          const SizedBox(width: 14),
          Expanded(child: activityPanel),
        ]),
    ]);
  }
}

class SourceRow extends StatelessWidget {
  final DataSource s;
  final VoidCallback? onFix;
  const SourceRow(this.s, {super.key, this.onFix});
  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (s.status) {
      'synced' => (Icons.check_circle_outline, C.positive),
      'imported' => (Icons.upload_file_outlined, C.platinum),
      'manual' => (Icons.edit_outlined, C.gunmetal),
      'missing' => (Icons.add_circle_outline, C.caution),
      _ => (Icons.error_outline, C.negative),
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.lineSoft))),
      child: Row(children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: T.body(14, height: 1.3)),
            Text('${s.kind} · ${s.masked}', style: T.mono(10.5)),
          ]),
        ),
        if (s.status == 'missing' || s.status == 'error')
          LinkText(s.status == 'missing' ? 'Connect' : 'Review', onTap: onFix, style: T.body(12.5, color: color))
        else
          Text(s.freshness, style: T.mono(10.5)),
      ]),
    );
  }
}

class ActivityTimeline extends StatelessWidget {
  final List<ActivityEvent> events;
  const ActivityTimeline(this.events, {super.key});
  @override
  Widget build(BuildContext context) => Column(children: [
        for (var i = 0; i < events.length; i++)
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(
                width: 18,
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: events[i].kind == 'approval' ? C.champagne : Colors.transparent,
                      border: Border.all(color: events[i].kind == 'approval' ? C.champagne : C.gunmetal),
                    ),
                  ),
                  if (i < events.length - 1) Expanded(child: Container(width: 1, color: C.lineSoft)),
                ]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(events[i].title, style: T.body(13.5, weight: FontWeight.w500, height: 1.3))),
                      Text(events[i].time, style: T.mono(10)),
                    ]),
                    const SizedBox(height: 2),
                    Text(events[i].detail, style: T.body(12.5, color: C.muted, height: 1.4)),
                  ]),
                ),
              ),
            ]),
          ),
      ]);
}
