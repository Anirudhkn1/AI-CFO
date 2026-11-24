// Product components shared by the website and the app.
import 'package:flutter/material.dart';

import '../core/engine.dart';
import '../core/format.dart';
import '../core/models.dart';
import '../core/tokens.dart';
import 'charts.dart';
import 'common.dart';
import 'logo.dart';

// ── Structured AI answer ────────────────────────────────────────────────────
class AnswerCard extends StatefulWidget {
  final CfoAnswer answer;
  final VoidCallback? onNextAction;
  const AnswerCard(this.answer, {super.key, this.onNextAction});
  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  bool _detail = false;

  Widget _section(String label, Widget child) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: T.mono(9.5, color: C.faint, letterSpacing: 1.6)),
          const SizedBox(height: 6),
          child,
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final a = widget.answer;
    return Panel(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
      color: C.bg2,
      borderColor: C.line,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Logo(compact: true, size: 14),
          const SizedBox(width: 10),
          Text('Obsid-finance', style: T.mono(11, color: C.text, letterSpacing: 1.4)),
          const Spacer(),
          ConfidenceMeter(a.confidence),
        ]),
        const SizedBox(height: 14),
        Text(a.observation, style: T.body(17, weight: FontWeight.w500, height: 1.45)),
        _section(
          'Evidence',
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final e in a.evidence)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                    color: C.surface, border: Border.all(color: C.lineSoft), borderRadius: BorderRadius.circular(kRadius)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.link, size: 12, color: C.champagne),
                  const SizedBox(width: 6),
                  Text(e, style: T.mono(10.5, color: C.text)),
                ]),
              ),
          ]),
        ),
        _section('Cause', Text(a.cause, style: T.body(14, color: C.muted))),
        _section('Financial impact', Text(a.impact, style: T.body(14, color: C.text))),
        _section(
          'Options',
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var i = 0; i < a.options.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 22, child: Text('0${i + 1}', style: T.mono(11, color: C.champagne))),
                  Expanded(child: Text(a.options[i], style: T.body(14, color: C.text))),
                ]),
              ),
          ]),
        ),
        _section(
          'Recommendation',
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(border: Border(left: BorderSide(color: C.champagne))),
            child: Text(a.recommendation, style: T.body(14.5, color: C.text, height: 1.5)),
          ),
        ),
        _section('Limitations', Text(a.limits, style: T.body(13, color: C.muted))),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: _detail
              ? _section(
                  'Calculation path',
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: C.bg,
                    child: Text(a.calculation, style: T.mono(11.5, color: C.platinum)),
                  ))
              : const SizedBox(width: double.infinity),
        ),
        const SizedBox(height: 18),
        Wrap(spacing: 14, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
          PButton(a.nextAction, small: true, onTap: widget.onNextAction, icon: Icons.arrow_forward),
          LinkText(_detail ? 'Hide calculation' : 'Show calculation',
              onTap: () => setState(() => _detail = !_detail), style: T.body(12.5, color: C.muted)),
        ]),
      ]),
    );
  }
}

// ── Approval card (PRD §6.16) ───────────────────────────────────────────────
class ApprovalCard extends StatelessWidget {
  final ApprovalItem item;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  const ApprovalCard(this.item, {super.key, this.onApprove, this.onReject});

  @override
  Widget build(BuildContext context) {
    final m = Bp.mobile(context);
    final pending = item.status == ApprovalStatus.pending;
    return Panel(
      padding: EdgeInsets.all(m ? 20 : 28),
      color: C.bg2,
      borderColor: pending ? C.line : C.lineSoft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(item.kind.toUpperCase(), style: T.label(color: C.champagne, size: 10)),
          const Spacer(),
          Text(item.id, style: T.mono(11)),
        ]),
        const SizedBox(height: 12),
        Text(item.title, style: T.display(m ? 26 : 30, height: 1.1)),
        const SizedBox(height: 8),
        Text('Requested by ${item.requestedBy} · ${item.created}', style: T.body(12.5, color: C.muted)),
        const SizedBox(height: 18),
        const Hairline(),
        const SizedBox(height: 6),
        Text('EXACT PARAMETERS', style: T.mono(9.5, color: C.faint, letterSpacing: 1.6)),
        for (final e in item.params.entries) KV(e.key, e.value),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.surface, border: Border.all(color: C.lineSoft)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('WHAT WILL HAPPEN', style: T.mono(9.5, color: C.faint, letterSpacing: 1.6)),
            const SizedBox(height: 6),
            Text(item.whatHappens, style: T.body(13.5, color: C.text)),
            const SizedBox(height: 10),
            Wrap(spacing: 16, runSpacing: 6, children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(item.reversible ? Icons.undo : Icons.block, size: 14,
                    color: item.reversible ? C.positive : C.negative),
                const SizedBox(width: 6),
                Text(item.reversible ? 'Reversible' : 'Not reversible once done',
                    style: T.body(12.5, color: item.reversible ? C.positive : C.negative)),
              ]),
              Text('Affects: ${item.affected}', style: T.body(12.5, color: C.muted)),
            ]),
          ]),
        ),
        const SizedBox(height: 20),
        if (pending)
          Wrap(spacing: 10, runSpacing: 10, children: [
            PButton('Approve exactly this', small: true, onTap: onApprove, icon: Icons.check),
            PButton('Reject', small: true, ghost: true, onTap: onReject),
          ])
        else
          Row(children: [
            Icon(item.status == ApprovalStatus.approved ? Icons.verified_outlined : Icons.cancel_outlined,
                size: 16, color: item.status == ApprovalStatus.approved ? C.positive : C.negative),
            const SizedBox(width: 8),
            Text(
                '${item.status == ApprovalStatus.approved ? 'Approved' : 'Rejected'} · ${item.decidedAt ?? ''} · logged',
                style: T.mono(11.5, color: C.text)),
          ]),
      ]),
    );
  }
}

Future<bool> confirmApproval(BuildContext context, ApprovalItem item, bool approve) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(approve ? 'Approve exactly this action?' : 'Reject this request?', style: T.display(28)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Text(
          approve
              ? '“${item.title}” will run with the parameters shown. '
                  '${item.reversible ? 'You can undo it afterwards.' : 'This cannot be undone.'} '
                  'Your approval, the time and the result are logged.'
              : 'Nothing will happen. The request and your decision are logged.',
          style: T.body(14, color: C.muted),
        ),
      ),
      actions: [
        PButton('Cancel', small: true, ghost: true, onTap: () => Navigator.pop(ctx, false)),
        PButton(approve ? 'Approve' : 'Reject', small: true, onTap: () => Navigator.pop(ctx, true)),
      ],
    ),
  );
  return r ?? false;
}

// ── Scenario lab (PRD §6.9) ─────────────────────────────────────────────────
class ScenarioLab extends StatefulWidget {
  final Workspace mode;
  final bool showModeSwitch;
  const ScenarioLab({super.key, required this.mode, this.showModeSwitch = false});
  @override
  State<ScenarioLab> createState() => _ScenarioLabState();
}

class _ScenarioLabState extends State<ScenarioLab> {
  late Workspace _mode = widget.mode;
  var _b = const BusinessInputs();
  var _p = const PersonalInputs();

  @override
  void didUpdateWidget(covariant ScenarioLab old) {
    super.didUpdateWidget(old);
    if (old.mode != widget.mode) _mode = widget.mode;
  }

  Widget _slider(String label, String value, double v, double lo, double hi, int div,
          ValueChanged<double> on) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(label, style: T.body(13, color: C.muted))),
            Text(value, style: T.mono(13, color: C.text)),
          ]),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14)),
            child: Slider(value: v, min: lo, max: hi, divisions: div, onChanged: on),
          ),
        ]),
      );

  String _months(int? r, int horizon) => r == null ? '$horizon+ mo' : '$r mo';

  @override
  Widget build(BuildContext context) {
    final m = Bp.tablet(context);
    final business = _mode == Workspace.business;
    final res = business ? runBusiness(_b) : runPersonal(_p);
    final labels = ['Now', ...monthLabels(res.horizon)];

    final controls = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.showModeSwitch) ...[
        Segmented<Workspace>(
          options: const [(Workspace.business, 'Business'), (Workspace.personal, 'Personal')],
          value: _mode,
          onChanged: (v) => setState(() => _mode = v),
          dense: true,
        ),
        const SizedBox(height: 22),
      ],
      Text(business ? '“Can we hire two engineers next month?”' : '“Can I afford a big purchase?”',
          style: T.display(26, height: 1.15)),
      const SizedBox(height: 6),
      Text(business ? 'Lumen Labs · opening cash ₹1.84 Cr' : 'Aarav · opening cash ₹1,42,300',
          style: T.mono(11)),
      const SizedBox(height: 22),
      if (business) ...[
        _slider('Engineers to hire', '${_b.hires}', _b.hires.toDouble(), 0, 6, 6,
            (v) => setState(() => _b = _b.copyWith(hires: v.round()))),
        _slider('Annual CTC each', inrCompact(_b.annualCtc), _b.annualCtc, 1200000, 6000000, 16,
            (v) => setState(() => _b = _b.copyWith(annualCtc: v))),
        _slider('Start month', monthLabels(6)[_b.startMonth - 1], _b.startMonth.toDouble(), 1, 6, 5,
            (v) => setState(() => _b = _b.copyWith(startMonth: v.round()))),
        _slider('Revenue growth / month', pct(_b.growthPct), _b.growthPct, 0, 8, 16,
            (v) => setState(() => _b = _b.copyWith(growthPct: v))),
      ] else ...[
        _slider('Purchase amount', inr(_p.price), _p.price, 20000, 500000, 48,
            (v) => setState(() => _p = _p.copyWith(price: v))),
        _slider('Buy in', monthLabels(6)[_p.buyMonth - 1], _p.buyMonth.toDouble(), 1, 6, 5,
            (v) => setState(() => _p = _p.copyWith(buyMonth: v.round()))),
        Text('Pay', style: T.body(13, color: C.muted)),
        const SizedBox(height: 8),
        Segmented<PayMode>(
          options: const [(PayMode.now, 'Upfront'), (PayMode.emi6, 'EMI ×6'), (PayMode.emi12, 'EMI ×12')],
          value: _p.mode,
          onChanged: (v) => setState(() => _p = _p.copyWith(mode: v)),
          dense: true,
        ),
        const SizedBox(height: 18),
      ],
      Text('ASSUMPTIONS', style: T.mono(9.5, color: C.faint, letterSpacing: 1.6)),
      const SizedBox(height: 6),
      Text(
        business
            ? 'Revenue ₹26 L/mo · costs ₹37 L/mo (+1%/mo) · employer cost 12% · recruiting ₹1.5 L per hire · reserve floor ₹50 L. Band = growth ±1.5 pts.'
            : 'Income ₹1,35,000/mo · spending ₹96,000/mo · cash floor ₹30,000 (your setting) · no-cost EMI. Band = spending ±6%.',
        style: T.body(12.5, color: C.muted, height: 1.5),
      ),
    ]);

    final breach = res.firstBreachMonth;
    final stats = <(String, String, String, bool)>[
      if (business) ...[
        ('Runway', '${_months(res.runwayBaseline, res.horizon)} → ${_months(res.runwayScenario, res.horizon)}', 'baseline → scenario',
            (res.runwayScenario ?? 99) >= (res.runwayBaseline ?? 99)),
        ('Reserve floor', breach == null ? 'Holds' : 'Breached ${labels[breach]}', 'first month below ₹50 L', breach == null),
        ('Added cost', '${inrCompact(monthlyHiringCost(_b))}/mo', 'from ${monthLabels(6)[_b.startMonth - 1]}', true),
      ] else ...[
        ('Lowest balance', inrCompact(res.lowestScenario), 'next 12 months', res.lowestScenario >= res.floor),
        ('Below floor', res.monthsBelowFloor == 0 ? 'Never' : '${res.monthsBelowFloor} mo', 'floor ₹30,000', res.monthsBelowFloor == 0),
        ('Cash in 12 mo', inrCompact(res.scenario.last), 'vs ${inrCompact(res.baseline.last)} baseline', true),
      ],
    ];

    final output = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 18, runSpacing: 8, children: [
        _legend(C.platinum, 'Scenario', solid: true),
        _legend(C.gunmetal, 'Baseline'),
        _legend(C.champagne.withValues(alpha: 0.3), business ? 'Downside – optimistic' : 'Spending ±6%', band: true),
        _legend(C.negative, 'Floor'),
      ]),
      const SizedBox(height: 14),
      ForecastChart(
        xLabels: labels,
        primary: res.scenario,
        comparison: res.baseline,
        low: res.low,
        high: res.high,
        threshold: res.floor,
        splitIndex: 0,
        height: m ? 240 : 300,
      ),
      const SizedBox(height: 18),
      LayoutBuilder(builder: (context, c) {
        final narrow = c.maxWidth < 520;
        final tiles = [
          for (final (k, v, s, ok) in stats)
            Container(
              width: narrow ? c.maxWidth : (c.maxWidth - 24) / 3,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: C.lineSoft), color: C.surface),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(k.toUpperCase(), style: T.mono(9.5, color: C.faint, letterSpacing: 1.4)),
                const SizedBox(height: 10),
                Text(v, style: T.body(21, weight: FontWeight.w300, height: 1.2, color: ok ? C.text : C.negative)),
                const SizedBox(height: 6),
                Text(s, style: T.body(12, color: C.muted)),
              ]),
            ),
        ];
        return Wrap(spacing: 12, runSpacing: 12, children: tiles);
      }),
      const SizedBox(height: 16),
      Wrap(spacing: 16, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Text('Closing cash = opening + inflows − outflows · $calcVersion · deterministic',
            style: T.mono(10.5, color: C.faint)),
        LinkText('Save scenario', onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Scenario saved with inputs, assumptions and $calcVersion (sample).')));
        }, style: T.body(12.5, color: C.champagne)),
      ]),
    ]);

    return m
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [controls, const SizedBox(height: 28), output])
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 340, child: controls),
            const SizedBox(width: 48),
            Expanded(child: output),
          ]);
  }

  Widget _legend(Color c, String l, {bool solid = false, bool band = false}) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 18, height: band ? 8 : 2, color: band ? c : (solid ? c : null),
            decoration: band || solid ? null : BoxDecoration(border: Border(top: BorderSide(color: c, width: 2)))),
        const SizedBox(width: 8),
        Text(l, style: T.body(12, color: C.muted)),
      ]);
}
