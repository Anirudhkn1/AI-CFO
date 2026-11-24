import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/models.dart';
import '../../core/sample_data.dart';
import '../../core/tokens.dart';
import '../../widgets/common.dart';
import 'overview_screen.dart';

class TransactionsScreen extends StatefulWidget {
  final Workspace ws;
  const TransactionsScreen({super.key, required this.ws});
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late final List<Txn> _all = widget.ws == Workspace.personal ? personalTxns : businessTxns;
  String _filter = 'All';
  String _q = '';
  int? _open;

  List<String> get _categories => widget.ws == Workspace.personal
      ? const ['Income', 'Housing', 'Bills & utilities', 'Dining & delivery', 'Shopping', 'Subscriptions', 'Investments', 'Loan repayment', 'Transfer', 'Uncategorised']
      : const ['Revenue — subscriptions', 'Revenue — services', 'Payroll', 'Rent', 'Marketing', 'Cloud infrastructure', 'Software subscriptions', 'Professional fees', 'Taxes', 'Transfer'];

  List<Txn> get _rows => _all.where((t) {
        final f = switch (_filter) {
          'Needs review' => t.tag == Tag.needsReview,
          'Money in' => t.amount > 0,
          'Money out' => t.amount < 0,
          _ => true,
        };
        final q = _q.isEmpty ||
            '${t.description} ${t.counterparty} ${t.category}'.toLowerCase().contains(_q.toLowerCase());
        return f && q;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final m = Bp.mobile(context);
    final rows = _rows;
    final review = _all.where((t) => t.tag == Tag.needsReview).length;
    final inflow = rows.where((t) => t.amount > 0).fold<num>(0, (a, t) => a + t.amount);
    final outflow = rows.where((t) => t.amount < 0).fold<num>(0, (a, t) => a + t.amount);

    return ListView(padding: screenPad(context), children: [
      if (review > 0)
        Panel(
          padding: const EdgeInsets.all(16),
          borderColor: C.negative.withValues(alpha: 0.35),
          child: Row(children: [
            const Icon(Icons.flag_outlined, size: 16, color: C.negative),
            const SizedBox(width: 12),
            Expanded(
                child: Text('$review transactions need review before they count in your totals.',
                    style: T.body(13.5))),
            LinkText('Show', onTap: () => setState(() => _filter = 'Needs review'), style: T.body(12.5, color: C.champagne)),
          ]),
        ),
      const SizedBox(height: 18),
      Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
        for (final f in const ['All', 'Needs review', 'Money in', 'Money out'])
          Chip2(f, selected: _filter == f, onTap: () => setState(() => _filter = f)),
        SizedBox(
          width: m ? double.infinity : 260,
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            style: T.body(14),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search description, party or category',
              hintStyle: T.body(13, color: C.faint),
              prefixIcon: const Icon(Icons.search, size: 16),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: C.line), borderRadius: BorderRadius.zero),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: C.platinum), borderRadius: BorderRadius.zero),
            ),
          ),
        ),
      ]),
      const SizedBox(height: 14),
      Row(children: [
        Text('${rows.length} records', style: T.mono(11)),
        const Spacer(),
        Text('In ${inrCompact(inflow)}  ·  Out ${inrCompact(outflow)}', style: T.mono(11, color: C.text)),
      ]),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
        child: Column(children: [
          if (!m)
            Container(
              color: C.surface,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(children: [
                SizedBox(width: 70, child: Text('DATE', style: T.mono(9.5, color: C.faint, letterSpacing: 1.4))),
                Expanded(child: Text('DESCRIPTION', style: T.mono(9.5, color: C.faint, letterSpacing: 1.4))),
                SizedBox(width: 210, child: Text('CATEGORY', style: T.mono(9.5, color: C.faint, letterSpacing: 1.4))),
                SizedBox(width: 140, child: Text('STATUS', style: T.mono(9.5, color: C.faint, letterSpacing: 1.4))),
                SizedBox(width: 120, child: Text('AMOUNT', textAlign: TextAlign.right, style: T.mono(9.5, color: C.faint, letterSpacing: 1.4))),
              ]),
            ),
          for (var i = 0; i < rows.length; i++) _row(rows[i], i, m),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Text('No records match. Try another filter.', style: T.body(14, color: C.muted)),
            ),
        ]),
      ),
      const SizedBox(height: 12),
      Text('Original source records are preserved. Edits are logged in the audit history.', style: T.mono(10.5, color: C.faint)),
    ]);
  }

  Widget _category(Txn t) => PopupMenuButton<String>(
        tooltip: 'Change category',
        onSelected: (c) => setState(() {
          t.category = c;
          t.tag = Tag.edited;
        }),
        itemBuilder: (_) => [for (final c in _categories) PopupMenuItem(value: c, child: Text(c))],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(border: Border.all(color: C.lineSoft), borderRadius: BorderRadius.circular(40)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Flexible(child: Text(t.category, overflow: TextOverflow.ellipsis, style: T.body(12.5, color: C.text, height: 1.2))),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 14),
          ]),
        ),
      );

  Widget _row(Txn t, int i, bool m) {
    final amount = Text(inr(t.amount, sign: true),
        textAlign: TextAlign.right, style: T.mono(13, color: t.amount > 0 ? C.positive : C.text));
    return Column(children: [
      Hover(
        builder: (context, h) => GestureDetector(
          onTap: () => setState(() => _open = _open == i ? null : i),
          child: Container(
            color: _open == i ? C.surface2 : (h ? C.surface : Colors.transparent),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: m
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(t.description, style: T.body(14.5, weight: FontWeight.w500))),
                      amount,
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Text(t.date, style: T.mono(10.5)),
                      const SizedBox(width: 10),
                      Flexible(child: _category(t)),
                      const SizedBox(width: 8),
                      StatusTag(t.tag),
                    ]),
                  ])
                : Row(children: [
                    SizedBox(width: 70, child: Text(t.date, style: T.mono(11.5))),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t.description, style: T.body(14, weight: FontWeight.w500, height: 1.3)),
                        Text('${t.counterparty} · ${t.source}', style: T.mono(10.5)),
                      ]),
                    ),
                    SizedBox(width: 210, child: Align(alignment: Alignment.centerLeft, child: _category(t))),
                    SizedBox(width: 140, child: Align(alignment: Alignment.centerLeft, child: StatusTag(t.tag))),
                    SizedBox(width: 120, child: amount),
                  ]),
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 220),
        child: _open == i
            ? Container(
                width: double.infinity,
                color: C.bg2,
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  KV('Source', t.source),
                  KV('Original description', t.raw, mono: true),
                  KV('Import', widget.ws == Workspace.personal ? 'Batch #1182 · 21 Nov 2026, 14:02' : 'Batch #2207 · 20 Nov 2026, 16:30'),
                  const KV('Reconciliation', 'Matched to statement balance'),
                  const SizedBox(height: 8),
                  Wrap(spacing: 14, children: [
                    LinkText('Split', style: T.body(12.5, color: C.champagne), onTap: () => _snack('Split saved (sample).')),
                    LinkText('Mark as transfer', style: T.body(12.5, color: C.champagne), onTap: () => setState(() {
                          t.category = 'Transfer';
                          t.tag = Tag.edited;
                        })),
                    LinkText('Add note', style: T.body(12.5, color: C.champagne), onTap: () => _snack('Note added (sample).')),
                    LinkText('Exclude from analysis', style: T.body(12.5, color: C.champagne), onTap: () => _snack('Excluded from spending totals (sample).')),
                  ]),
                ]),
              )
            : const SizedBox(width: double.infinity),
      ),
      const Hairline(),
    ]);
  }

  void _snack(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
}
