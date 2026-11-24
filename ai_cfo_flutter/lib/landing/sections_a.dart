import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/models.dart';
import '../core/sample_data.dart';
import '../core/tokens.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

EdgeInsets sectionPad(BuildContext c) =>
    EdgeInsets.symmetric(vertical: Bp.mobile(c) ? 88 : 120);

// ── Ask anything — two marquees of real questions ───────────────────────────
class AskSection extends StatelessWidget {
  const AskSection({super.key});

  static const _personal = [
    'What’s my net worth today?',
    'Can I afford a ₹80,000 laptop?',
    'Why did spending rise in October?',
    'Which subscriptions am I not using?',
    'When will my emergency fund be full?',
    'How much tax have I already paid this year?',
    'What happens if my income stops for 3 months?',
  ];
  static const _business = [
    'How long is our runway?',
    'Can we hire two engineers next month?',
    'Why is cash falling while revenue grows?',
    'Which invoices are overdue?',
    'What if our biggest customer pays 30 days late?',
    'Where did the cloud bill jump?',
    'Are we on budget this quarter?',
  ];

  Widget _q(String s, String tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: C.line),
          borderRadius: BorderRadius.circular(40),
          color: C.surface,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(tag, style: T.mono(9, color: C.champagne, letterSpacing: 1.4)),
          const SizedBox(width: 10),
          Text(s, style: T.body(15, color: C.text, height: 1.2)),
        ]),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: Bp.mobile(context) ? 64 : 96, bottom: 24),
        child: Column(children: [
          const Contained(
            child: Reveal(
              child: SectionHead(
                eyebrow: 'Ask anything',
                title: 'Ask the questions you’d ask your CFO.',
                sub: 'Plain-language questions, answered from your own authorised data — and an honest “I don’t know yet” when the data isn’t there.',
                center: true,
              ),
            ),
          ),
          const SizedBox(height: 56),
          Marquee(height: 52, speed: 34, children: [for (final s in _personal) _q(s, 'PERSONAL')]),
          const SizedBox(height: 14),
          Marquee(height: 52, speed: 28, reverse: true, children: [for (final s in _business) _q(s, 'BUSINESS')]),
        ]),
      );
}

// ── One picture — consolidated, source-aware view ───────────────────────────
class OnePictureSection extends StatelessWidget {
  const OnePictureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Bp.tablet(context);
    final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHead(
        eyebrow: 'One financial picture',
        title: 'Every account. One calm view.',
        sub: 'Bank accounts, cards, funds, EPF, property and loans — brought together from statements, exports and authorised connections. '
            'Each figure carries its source, its date and what kind of number it is.',
      ),
      const SizedBox(height: 32),
      for (final (t1, d) in const [
        ('Source-aware', 'See freshness, coverage and anything missing — never a silent gap.'),
        ('Clickable to the record', 'Every material number opens the transactions or document behind it.'),
        ('Honest labels', 'Actual, Forecast, Estimate, Manually entered, Needs review.'),
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: const EdgeInsets.only(top: 8), width: 14, height: 1, color: C.champagne),
            const SizedBox(width: 14),
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(text: '$t1  ', style: T.body(15, weight: FontWeight.w600)),
                  TextSpan(text: d, style: T.body(15, color: C.muted)),
                ]),
              ),
            ),
          ]),
        ),
    ]);

    final card = GlareCard(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('NET WORTH', style: T.label(size: 10)),
          const Spacer(),
          Text('As of 24 Nov 2026', style: T.mono(10.5)),
        ]),
        const SizedBox(height: 14),
        Text(inr(personalNetWorth), style: T.figure(Bp.mobile(context) ? 44 : 60)),
        const SizedBox(height: 6),
        Text('${inr(personalNetWorthDelta, sign: true)} this month', style: T.mono(12, color: C.positive)),
        const SizedBox(height: 18),
        const Sparkline([41.2, 42.0, 41.6, 43.1, 44.0, 43.4, 45.2, 46.1, 45.8, 47.5, 48.62], height: 54),
        const SizedBox(height: 18),
        const Hairline(),
        const SizedBox(height: 8),
        for (final (label, v, tag) in personalBreakdown)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              Expanded(child: Text(label, style: T.body(14, color: C.text))),
              if (!Bp.mobile(context)) ...[StatusTag(tag), const SizedBox(width: 14)],
              SizedBox(
                width: 110,
                child: Text(inr(v), textAlign: TextAlign.right, style: T.mono(12.5, color: v < 0 ? C.negative : C.text)),
              ),
            ]),
          ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          color: C.surface,
          child: Row(children: [
            const Icon(Icons.info_outline, size: 14, color: C.champagne),
            const SizedBox(width: 10),
            Expanded(child: Text('EPF not connected — figure estimated from your last payslip.', style: T.body(12.5, color: C.muted))),
          ]),
        ),
      ]),
    );

    return Padding(
      padding: sectionPad(context),
      child: Contained(
        child: t
            ? Column(children: [Reveal(child: copy), const SizedBox(height: 48), Reveal(child: card)])
            : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(child: Reveal(child: copy)),
                const SizedBox(width: 80),
                Expanded(child: Reveal(delayMs: 150, child: card)),
              ]),
      ),
    );
  }
}

// ── Two workspaces ──────────────────────────────────────────────────────────
class WorkspacesSection extends StatefulWidget {
  const WorkspacesSection({super.key});
  @override
  State<WorkspacesSection> createState() => _WorkspacesSectionState();
}

class _WorkspacesSectionState extends State<WorkspacesSection> {
  Workspace _ws = Workspace.personal;

  static const _data = {
    Workspace.personal: (
      'For individuals, families and the self-employed.',
      ['Young professionals', 'Households', 'Investors', 'Self-employed'],
      ['Net worth', 'Monthly cash flow', 'Savings rate', 'Goal progress', 'Upcoming obligations'],
      ['Household budget', 'Emergency fund', 'Debt payoff', 'Big purchases', 'Retirement'],
      ['Overview', 'Transactions', 'Budgets & Goals', 'Net Worth & Investments', 'Documents', 'Obsid-finance Chat', 'Learning', 'Approvals & Activity'],
    ),
    Workspace.business: (
      'For founders, SMEs, finance teams and fractional CFOs.',
      ['Startup founders', 'SME owners', 'Finance managers', 'Fractional CFOs'],
      ['Cash position', 'Runway', 'Revenue & margins', 'Receivables', 'Payables', 'Budget variance'],
      ['Hiring', 'Pricing', 'Marketing spend', 'Expansion', 'Funding', 'Downside cases'],
      ['Command Center', 'Transactions & Accounting', 'Cash Flow & Forecasts', 'Revenue & Performance', 'Receivables & Payables', 'Spend Intelligence', 'Budgets & Scenarios', 'Approvals'],
    ),
  };

  Widget _col(String title, List<String> items) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title.toUpperCase(), style: T.mono(10, color: C.faint, letterSpacing: 1.6)),
        const SizedBox(height: 14),
        for (final i in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(i, style: T.body(15, color: C.text)),
          ),
      ]);

  @override
  Widget build(BuildContext context) {
    final m = Bp.mobile(context);
    final d = _data[_ws]!;
    final cols = [
      _col('Built for', d.$2),
      _col('Dashboard', d.$3),
      _col('Plans', d.$4),
      _col('Navigation', d.$5),
    ];
    return Container(
      color: C.bg2,
      padding: sectionPad(context),
      child: Contained(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Reveal(
            child: SectionHead(
              eyebrow: 'Two workspaces',
              title: 'Personal and business. Never mixed.',
              sub: 'One account, shared intelligence — but separate workspaces, permissions, dashboards and rules. '
                  'Nothing is combined into one number unless you choose it and it’s clearly labelled.',
            ),
          ),
          const SizedBox(height: 40),
          Segmented<Workspace>(
            options: const [(Workspace.personal, 'Personal CFO'), (Workspace.business, 'Business CFO')],
            value: _ws,
            onChanged: (v) => setState(() => _ws = v),
          ),
          const SizedBox(height: 36),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 380),
            child: Container(
              key: ValueKey(_ws),
              padding: EdgeInsets.all(m ? 22 : 40),
              decoration: BoxDecoration(border: Border.all(color: C.line), color: C.bg),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_ws.title, style: T.display(m ? 34 : 48)),
                const SizedBox(height: 6),
                Text(d.$1, style: T.body(16, color: C.muted)),
                const SizedBox(height: 32),
                const Hairline(),
                const SizedBox(height: 28),
                LayoutBuilder(builder: (context, c) {
                  final n = c.maxWidth < 520 ? 1 : (c.maxWidth < 900 ? 2 : 4);
                  final w = (c.maxWidth - (n - 1) * 32) / n;
                  return Wrap(spacing: 32, runSpacing: 32, children: [for (final col in cols) SizedBox(width: w, child: col)]);
                }),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Modules ─────────────────────────────────────────────────────────────────
class ModulesSection extends StatelessWidget {
  const ModulesSection({super.key});

  static const _mods = [
    (Icons.dashboard_outlined, 'Command Center', 'Net worth, cash, runway and obligations in one view — every figure opens its source.'),
    (Icons.show_chart, 'Cash-flow forecasting', 'Base, optimistic and downside ranges, with confirmed items kept apart from estimates.'),
    (Icons.receipt_long_outlined, 'Spend intelligence', 'Recurring charges, price rises and possible duplicates surfaced for review. Savings verified later, not just promised.'),
    (Icons.swap_horiz, 'Receivables & payables', 'What’s overdue, how late collections hit cash, and what to pay first under your policies.'),
    (Icons.tune, 'Scenario simulator', 'Hire, borrow, buy or pause — compared against your baseline with deterministic maths.'),
    (Icons.description_outlined, 'Document intelligence', 'Statements, invoices and payslips read with field-level confidence, the original page beside it.'),
    (Icons.flag_outlined, 'Budgets & goals', 'Emergency funds, debt payoff and department budgets — with overspend flagged before it happens.'),
    (Icons.account_balance_outlined, 'Tax preparation', 'India-first checklists, organised documents and draft workpapers for you or your CA to review.'),
    (Icons.school_outlined, 'Learn in context', 'Short lessons on cash flow, tax basics and unit economics — explained with your own numbers.'),
  ];

  @override
  Widget build(BuildContext context) => Padding(
        padding: sectionPad(context),
        child: Contained(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Reveal(
              child: SectionHead(
                eyebrow: 'The platform',
                title: 'Everything a finance function does. Quietly.',
                sub: 'Nine capabilities on one shared, permissioned engine. The AI prepares and explains; you decide.',
              ),
            ),
            const SizedBox(height: 56),
            LayoutBuilder(builder: (context, c) {
              final n = c.maxWidth < 640 ? 1 : (c.maxWidth < 1000 ? 2 : 3);
              final w = (c.maxWidth - (n - 1) * 16) / n;
              return Wrap(spacing: 16, runSpacing: 16, children: [
                for (var i = 0; i < _mods.length; i++)
                  SizedBox(
                    width: w,
                    height: n == 1 ? 210 : 268,
                    child: Reveal(
                      delayMs: (i % n) * 90,
                      child: GlareCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text((i + 1).toString().padLeft(2, '0'), style: T.mono(11, color: C.faint)),
                            const Spacer(),
                            Icon(_mods[i].$1, size: 20, color: C.champagne),
                          ]),
                          const Spacer(),
                          Text(_mods[i].$2, style: T.display(30, height: 1.1)),
                          const SizedBox(height: 12),
                          Text(_mods[i].$3, style: T.body(14, color: C.muted, height: 1.55)),
                        ]),
                      ),
                    ),
                  ),
              ]);
            }),
          ]),
        ),
      );
}
