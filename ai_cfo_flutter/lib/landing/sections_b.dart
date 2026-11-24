import 'dart:async';

import 'package:flutter/material.dart';

import '../core/models.dart';
import '../core/sample_data.dart';
import '../core/tokens.dart';
import '../widgets/cfo.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';
import '../widgets/logo.dart';
import 'sections_a.dart';

// ── Anatomy of an answer ────────────────────────────────────────────────────
class AnatomySection extends StatefulWidget {
  const AnatomySection({super.key});
  @override
  State<AnatomySection> createState() => _AnatomySectionState();
}

class _AnatomySectionState extends State<AnatomySection> {
  static const _steps = [
    ('Observation', 'Cash fell ₹18.6 L in October while revenue rose 12%.'),
    ('Evidence', 'Bank balances 30 Sep → 31 Oct · 214 transactions · invoices register (41).'),
    ('Cause', 'Receivables over 30 days grew from ₹9.2 L to ₹21.4 L; two annual renewals (₹4.1 L) landed in October.'),
    ('Financial impact', 'At today’s collection speed, the ₹50 L reserve floor is reached two months earlier.'),
    ('Options', 'Chase three overdue invoices · offer 2% early-payment discount · move renewals to quarterly billing.'),
    ('Recommendation', 'Prioritise INV-2041, INV-2047 and INV-2052 — ₹14.8 L in total.'),
    ('Confidence & limits', 'Medium. Bank data is complete; four invoices have no due date, so their timing is estimated.'),
    ('Next action', 'Three reminder drafts are ready in Approvals. Nothing is sent without you.'),
  ];
  int _i = 0;
  Timer? _t;
  bool _manual = false;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      if (!_manual && mounted) setState(() => _i = (_i + 1) % _steps.length);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Bp.tablet(context);
    final left = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHead(
        eyebrow: 'Evidence-first AI',
        title: 'Every answer shows its working.',
        sub: 'Accuracy before fluency. Figures and arithmetic come from validated data and versioned calculation services — '
            'never from a language model’s guess.',
      ),
      const SizedBox(height: 36),
      Panel(
        color: C.bg2,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('BUSINESS · ASKED TODAY 09:02', style: T.mono(10, color: C.faint, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          Text('“Why is our cash falling even though revenue is increasing?”', style: T.display(28, height: 1.2)),
        ]),
      ),
    ]);

    final right = Column(children: [
      for (var k = 0; k < _steps.length; k++)
        Hover(
          builder: (context, h) => GestureDetector(
            onTap: () => setState(() {
              _i = k;
              _manual = true;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              decoration: BoxDecoration(
                color: k == _i ? C.surface2 : (h ? C.surface : Colors.transparent),
                border: Border(
                  left: BorderSide(color: k == _i ? C.champagne : C.lineSoft, width: k == _i ? 2 : 1),
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('0${k + 1}', style: T.mono(11, color: k == _i ? C.champagne : C.faint)),
                  const SizedBox(width: 16),
                  Text(_steps[k].$1, style: T.body(16, color: k == _i ? C.text : C.muted, weight: FontWeight.w500)),
                ]),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: k == _i
                      ? Padding(
                          padding: const EdgeInsets.only(left: 36, top: 10),
                          child: Text(_steps[k].$2, style: T.body(14.5, color: C.text, height: 1.55)),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ]),
            ),
          ),
        ),
    ]);

    return Padding(
      padding: sectionPad(context),
      child: Contained(
        child: t
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Reveal(child: left), const SizedBox(height: 40), right])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Reveal(child: left)),
                const SizedBox(width: 80),
                Expanded(child: Reveal(delayMs: 150, child: right)),
              ]),
      ),
    );
  }
}

// ── Scenario lab ────────────────────────────────────────────────────────────
class LabSection extends StatelessWidget {
  const LabSection({super.key});
  @override
  Widget build(BuildContext context) => Container(
        color: C.bg2,
        padding: sectionPad(context),
        child: Contained(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Reveal(
              child: SectionHead(
                eyebrow: 'Scenario lab · try it',
                title: 'Decide with the consequences in view.',
                sub: 'Move the sliders. Cash, runway and your floor recompute instantly against the baseline — '
                    'with the downside drawn, not hidden.',
              ),
            ),
            const SizedBox(height: 52),
            Reveal(
              child: Container(
                padding: EdgeInsets.all(Bp.mobile(context) ? 20 : 40),
                decoration: BoxDecoration(color: C.bg, border: Border.all(color: C.line)),
                child: const ScenarioLab(mode: Workspace.business, showModeSwitch: true),
              ),
            ),
          ]),
        ),
      );
}

// ── Approvals ───────────────────────────────────────────────────────────────
class ApprovalsSection extends StatefulWidget {
  const ApprovalsSection({super.key});
  @override
  State<ApprovalsSection> createState() => _ApprovalsSectionState();
}

class _ApprovalsSectionState extends State<ApprovalsSection> {
  late ApprovalItem _item = businessApprovals().first;
  final _log = <(String, String)>[('09:14', 'Request prepared by Obsid-finance · Receivables')];

  void _decide(bool approve) async {
    if (!await confirmApproval(context, _item, approve)) return;
    setState(() {
      _item.status = approve ? ApprovalStatus.approved : ApprovalStatus.rejected;
      _item.decidedAt = 'Today, 09:21';
      _log.add(('09:21', approve ? 'Approved by you — exact parameters, scoped to APR-1042' : 'Rejected by you'));
      if (approve) _log.add(('09:21', '3 emails queued from your mailbox (sample) · ref MSG-88412'));
    });
  }

  void _reset() => setState(() {
        _item = businessApprovals().first;
        _log
          ..clear()
          ..add(('09:14', 'Request prepared by Obsid-finance · Receivables'));
      });

  static const _policy = [
    ('Categorise, summarise, forecast', 'Prepared automatically'),
    ('Change records or budgets', 'Your confirmation'),
    ('Message customers or suppliers', 'Explicit send approval'),
    ('Payments & transfers', 'Transaction-specific approval; files, not money'),
    ('Trades & tax filing', 'Out of scope'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Bp.tablet(context);
    final left = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHead(
        eyebrow: 'Human control',
        title: 'Nothing moves without you.',
        sub: 'Obsid-finance prepares, calculates and drafts. Anything consequential becomes an approval request showing exactly what will happen, '
            'what it touches and whether it can be undone.',
      ),
      const SizedBox(height: 36),
      for (final (a, b) in _policy)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.lineSoft))),
          child: Row(children: [
            Expanded(child: Text(a, style: T.body(14.5, color: C.text))),
            const SizedBox(width: 12),
            Flexible(child: Text(b, textAlign: TextAlign.right, style: T.mono(11.5, color: C.champagne))),
          ]),
        ),
    ]);

    final right = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ApprovalCard(_item, onApprove: () => _decide(true), onReject: () => _decide(false)),
      const SizedBox(height: 18),
      Text('ACTIVITY', style: T.mono(10, color: C.faint, letterSpacing: 1.6)),
      const SizedBox(height: 8),
      for (final (time, e) in _log)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 52, child: Text(time, style: T.mono(11))),
            Expanded(child: Text(e, style: T.body(13, color: C.text))),
          ]),
        ),
      if (_item.status != ApprovalStatus.pending) ...[
        const SizedBox(height: 10),
        LinkText('Reset demo', onTap: _reset, style: T.body(12.5, color: C.muted)),
      ],
    ]);

    return Padding(
      padding: sectionPad(context),
      child: Contained(
        child: t
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Reveal(child: left), const SizedBox(height: 48), Reveal(child: right)])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Reveal(child: left)),
                const SizedBox(width: 80),
                Expanded(child: Reveal(delayMs: 150, child: right)),
              ]),
      ),
    );
  }
}

// ── Principles / privacy ────────────────────────────────────────────────────
class PrinciplesSection extends StatelessWidget {
  const PrinciplesSection({super.key});
  static const _p = [
    (Icons.calculate_outlined, 'Accuracy before fluency', 'Deterministic, versioned calculations. Reproducible from stored inputs.'),
    (Icons.visibility_outlined, 'Explainable by default', 'Period, source, assumptions and calculation path on every material number.'),
    (Icons.back_hand_outlined, 'Human control', 'The AI recommends. Consequential actions need your explicit approval.'),
    (Icons.lock_outline, 'Private by design', 'Minimum data collected, encrypted, masked identifiers, MFA options.'),
    (Icons.call_split, 'Workspaces isolated', 'Personal and business data separated — including in AI retrieval.'),
    (Icons.block_outlined, 'Not training data', 'Your financial data is not used to train general models.'),
  ];
  @override
  Widget build(BuildContext context) => Container(
        color: C.bg2,
        padding: sectionPad(context),
        child: Contained(
          child: Column(children: [
            const Reveal(
              child: SectionHead(
                eyebrow: 'Principles',
                title: 'Trust is the product.',
                sub: 'Six commitments that shape every screen, every answer and every line of the engine.',
                center: true,
              ),
            ),
            const SizedBox(height: 56),
            LayoutBuilder(builder: (context, c) {
              final n = c.maxWidth < 640 ? 1 : (c.maxWidth < 1000 ? 2 : 3);
              final w = ((c.maxWidth - 1) / n).floorToDouble();
              return Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line), left: BorderSide(color: C.line))),
                child: Wrap(children: [
                  for (var i = 0; i < _p.length; i++)
                    Container(
                      width: w,
                      padding: const EdgeInsets.all(32),
                      decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: C.line), bottom: BorderSide(color: C.line))),
                      child: Reveal(
                        delayMs: (i % n) * 90,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Icon(_p[i].$1, size: 22, color: C.champagne),
                          const SizedBox(height: 26),
                          Text(_p[i].$2, style: T.display(26)),
                          const SizedBox(height: 10),
                          Text(_p[i].$3, style: T.body(14, color: C.muted)),
                        ]),
                      ),
                    ),
                ]),
              );
            }),
          ]),
        ),
      );
}

// ── Pricing ─────────────────────────────────────────────────────────────────
class PricingSection extends StatefulWidget {
  final VoidCallback onOpenApp;
  const PricingSection({super.key, required this.onOpenApp});
  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection> {
  Workspace _ws = Workspace.personal;

  static final _plans = {
    Workspace.personal: [
      ('Starter', '₹0', 'forever', 'Get the full picture.', ['Manual imports (CSV, XLSX, PDF)', 'Core dashboard', '6 months of history', 'Introductory lessons'], false),
      ('Personal Pro', '₹349', 'per month', 'Plan ahead with confidence.', ['Unlimited accounts', 'Full history & forecasts', 'Budgets, goals & scenarios', 'Obsid-finance chat with evidence', 'Investment overview'], true),
    ],
    Workspace.business: [
      ('Business Starter', '₹1,999', 'per month', 'See your business clearly.', ['Core business dashboard', 'Imports & basic cash flow', 'Up to 2 users'], false),
      ('Business Pro', '₹4,999', 'per month', 'Forecast and decide.', ['Advanced forecasting', 'Scenario simulator', 'Obsid-finance for business', 'Receivables & payables', 'Accounting workflows'], true),
      ('Business Team', '₹9,999', 'per month', 'Run finance as a team.', ['Roles & permissions', 'Approval policies', 'Audit trail & reporting', 'Enhanced controls'], false),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final plans = _plans[_ws]!;
    return Padding(
      padding: sectionPad(context),
      child: Contained(
        child: Column(children: [
          const Reveal(
            child: SectionHead(
              eyebrow: 'Membership',
              title: 'Simple, transparent pricing.',
              sub: 'No paid placement. Recommendations are never ranked by partner revenue.',
              center: true,
            ),
          ),
          const SizedBox(height: 36),
          Segmented<Workspace>(
            options: const [(Workspace.personal, 'Personal'), (Workspace.business, 'Business')],
            value: _ws,
            onChanged: (v) => setState(() => _ws = v),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(builder: (context, c) {
            final n = c.maxWidth < 700 ? 1 : plans.length;
            final w = n == 1 ? c.maxWidth : ((c.maxWidth - (n - 1) * 16) / n).clamp(0.0, 400.0);
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Wrap(
                key: ValueKey(_ws),
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  for (final (name, price, per, tag, feats, featured) in plans)
                    SizedBox(
                      width: w,
                      child: GlareCard(
                        featured: featured,
                        padding: const EdgeInsets.all(32),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text(name.toUpperCase(), style: T.label(color: featured ? C.champagne : C.muted)),
                            const Spacer(),
                            if (featured) Text('MOST CHOSEN', style: T.mono(9, color: C.champagne, letterSpacing: 1.4)),
                          ]),
                          const SizedBox(height: 24),
                          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text(price, style: T.figure(54)),
                            const SizedBox(width: 8),
                            Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(per, style: T.body(13, color: C.muted))),
                          ]),
                          const SizedBox(height: 8),
                          Text(tag, style: T.body(15, color: C.text)),
                          const SizedBox(height: 22),
                          const Hairline(),
                          const SizedBox(height: 14),
                          for (final f in feats)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(children: [
                                const Icon(Icons.check, size: 14, color: C.champagne),
                                const SizedBox(width: 12),
                                Expanded(child: Text(f, style: T.body(14, color: C.muted))),
                              ]),
                            ),
                          const SizedBox(height: 26),
                          PButton(featured ? 'Start 14-day trial' : 'Get started', ghost: !featured, onTap: widget.onOpenApp),
                        ]),
                      ),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 28),
          Text('Enterprise & advisory firms — multi-entity reporting, custom integrations and governance. Talk to us.',
              textAlign: TextAlign.center, style: T.body(14, color: C.muted)),
          const SizedBox(height: 8),
          Text('Indicative pilot pricing, inclusive of GST. Referral or partner revenue, if any, is always disclosed.',
              textAlign: TextAlign.center, style: T.mono(10.5, color: C.faint)),
        ]),
      ),
    );
  }
}

// ── FAQ ─────────────────────────────────────────────────────────────────────
class FaqSection extends StatefulWidget {
  const FaqSection({super.key});
  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _open = 0;
  static const _q = [
    ('Is Obsid-finance a financial adviser?',
        'No. It provides financial education, organisation, calculations and decision support. It does not replace a chartered accountant, tax practitioner or registered investment adviser, and it never promises returns or tax outcomes.'),
    ('Can it move my money?',
        'No. Obsid-finance can prepare a transfer instruction, a payment file or a reminder draft. Anything consequential needs your explicit, transaction-specific approval — and payments, trades and tax filing are outside the product at launch.'),
    ('Where does my data come from?',
        'You start with CSV, XLSX and supported PDF statements, plus manual entries that are clearly labelled. Authorised bank, accounting, payment and payroll connections are added progressively.'),
    ('Do you train AI on my financial data?',
        'No. Your data is not used to train general models. You can export or delete it, and you can see what is collected, why, and which providers process it.'),
    ('Can I use personal and business together?',
        'Yes, from one account — as two separate workspaces with their own permissions. Data is never combined into one net-worth or performance number unless you explicitly choose to, and it is labelled when you do.'),
    ('How is “confidence” decided?',
        'From measurable factors: data completeness, freshness, source reliability, reconciliation status and uncertainty in assumptions. When a number can’t be justified, you see High, Medium, Low or Insufficient data — with the reason.'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Bp.tablet(context);
    final head = const SectionHead(eyebrow: 'FAQ', title: 'Questions, answered plainly.');
    final list = Column(children: [
      for (var i = 0; i < _q.length; i++)
        Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.line))),
          child: Column(children: [
            Hover(
              builder: (context, h) => GestureDetector(
                onTap: () => setState(() => _open = _open == i ? null : i),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(children: [
                    Expanded(child: Text(_q[i].$1, style: T.body(18, color: h || _open == i ? C.text : C.muted, weight: FontWeight.w500))),
                    AnimatedRotation(
                      turns: _open == i ? 0.125 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(Icons.add, size: 20, color: C.champagne),
                    ),
                  ]),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: _open == i
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 26, right: 40),
                      child: Text(_q[i].$2, style: T.body(15, color: C.muted, height: 1.65)),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ]),
        ),
    ]);
    return Padding(
      padding: sectionPad(context),
      child: Contained(
        child: t
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [head, const SizedBox(height: 36), list])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 4, child: Reveal(child: head)),
                const SizedBox(width: 60),
                Expanded(flex: 6, child: Reveal(child: list)),
              ]),
      ),
    );
  }
}

// ── Closing CTA + footer ────────────────────────────────────────────────────
class CtaSection extends StatelessWidget {
  final VoidCallback onOpenApp;
  const CtaSection({super.key, required this.onOpenApp});
  @override
  Widget build(BuildContext context) {
    final m = Bp.mobile(context);
    return Stack(children: [
      const Positioned.fill(child: Opacity(opacity: 0.7, child: SilkBackground(intensity: 0.8))),
      Padding(
        padding: EdgeInsets.symmetric(vertical: m ? 110 : 170),
        child: Contained(
          child: Reveal(
            child: Column(children: [
              const Seal(text: 'EVIDENCE · APPROVAL · PRIVACY · PRECISION · ', center: Logo(compact: true, size: 30)),
              const SizedBox(height: 44),
              Text('Precision is a luxury.', textAlign: TextAlign.center, style: T.display(m ? 46 : 92, height: 1)),
              ShimmerText('Now it’s a habit.',
                  textAlign: TextAlign.center, base: C.champagne, style: T.display(m ? 46 : 92, height: 1.1)),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text('Import one statement. Get your first evidence-backed insight in minutes.',
                    textAlign: TextAlign.center, style: T.body(17, color: C.muted)),
              ),
              const SizedBox(height: 36),
              PButton('Open the app', onTap: onOpenApp, icon: Icons.arrow_forward),
            ]),
          ),
        ),
      ),
    ]);
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});
  static const _cols = [
    ('Product', ['Personal CFO', 'Business CFO', 'Scenario lab', 'Pricing']),
    ('Trust', ['Security', 'Privacy', 'Data controls', 'Responsible AI']),
    ('Company', ['About us', 'Careers', 'Contact', 'Press']),
  ];
  @override
  Widget build(BuildContext context) {
    final m = Bp.mobile(context);
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line))),
      padding: const EdgeInsets.only(top: 72, bottom: 40),
      child: Contained(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 80, runSpacing: 40, children: [
            SizedBox(
              width: m ? double.infinity : 320,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Logo(),
                const SizedBox(height: 18),
                Text('A trusted financial co-pilot for Indian individuals and businesses.',
                    style: T.body(14, color: C.muted)),
              ]),
            ),
            for (final (h, items) in _cols)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(h.toUpperCase(), style: T.label(size: 10)),
                const SizedBox(height: 16),
                for (final i in items)
                  Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: LinkText(i)),
              ]),
          ]),
          const SizedBox(height: 56),
          const Hairline(),
          const SizedBox(height: 24),
          Text(
            'Obsid-finance provides financial education, organisation, calculations and decision support. It is not a registered investment adviser, '
            'tax practitioner or bank, does not guarantee outcomes, and does not move money, place trades or file returns. '
            'Figures and organisations shown on this site are sample data.',
            style: T.body(12, color: C.faint, height: 1.6),
          ),
          const SizedBox(height: 18),
          Text('© 2026 Obsid-finance · Made in India', style: T.mono(10.5, color: C.faint)),
        ]),
      ),
    );
  }
}
