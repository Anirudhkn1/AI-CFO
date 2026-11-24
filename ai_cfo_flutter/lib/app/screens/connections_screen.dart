import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../core/sample_data.dart';
import '../../core/tokens.dart';
import '../../widgets/common.dart';
import 'overview_screen.dart';

class ConnectionsScreen extends StatefulWidget {
  final Workspace ws;
  const ConnectionsScreen({super.key, required this.ws});
  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  static const _steps = [
    ('Uploading', 'statement_nov.csv · 48 KB'),
    ('Validating', '214 rows · dates, amounts and currency checked'),
    ('Detecting duplicates', '3 rows already imported — skipped'),
    ('Categorising', '209 categorised · 2 need review'),
    ('Reconciling', 'Closing balance matches statement'),
  ];
  int _step = -1;
  Timer? _t;

  void _start() {
    _t?.cancel();
    setState(() => _step = 0);
    _t = Timer.periodic(const Duration(milliseconds: 850), (t) {
      if (!mounted) return t.cancel();
      setState(() => _step++);
      if (_step >= _steps.length) t.cancel();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _snack(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  @override
  Widget build(BuildContext context) {
    final sources = widget.ws == Workspace.personal ? personalSources : businessSources;
    final t = Bp.tablet(context);
    final done = _step >= _steps.length;

    final importer = Panel(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Import data', style: T.body(16, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('CSV, XLSX and supported PDF statements. Imports are safe to re-run — duplicates are detected.',
            style: T.body(13, color: C.muted)),
        const SizedBox(height: 20),
        Hover(
          builder: (context, h) => GestureDetector(
            onTap: _step == -1 || done ? _start : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: h ? C.surface2 : C.surface,
                border: Border.all(color: h ? C.champagne.withValues(alpha: 0.5) : C.line),
              ),
              child: Column(children: [
                const Icon(Icons.upload_file_outlined, size: 28, color: C.champagne),
                const SizedBox(height: 12),
                Text('Drop a statement here, or click to simulate an import', textAlign: TextAlign.center, style: T.body(14.5)),
                const SizedBox(height: 4),
                Text('Files are type-checked and scanned before processing.', textAlign: TextAlign.center, style: T.mono(10.5)),
              ]),
            ),
          ),
        ),
        if (_step >= 0) ...[
          const SizedBox(height: 20),
          for (var i = 0; i < _steps.length; i++)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: i <= _step ? 1 : 0.3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: i < _step
                        ? const Icon(Icons.check, size: 16, color: C.positive)
                        : (i == _step
                            ? const CircularProgressIndicator(strokeWidth: 1.5, color: C.champagne)
                            : const Icon(Icons.circle_outlined, size: 12, color: C.faint)),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(width: 170, child: Text(_steps[i].$1, style: T.body(13.5))),
                  Expanded(child: Text(_steps[i].$2, style: T.mono(10.5))),
                ]),
              ),
            ),
          if (done) ...[
            const SizedBox(height: 12),
            Row(children: [
              const StatusTag(Tag.needsReview),
              const SizedBox(width: 12),
              Expanded(child: Text('2 rows need your review before they count.', style: T.body(13, color: C.muted))),
            ]),
          ],
        ],
      ]),
    );

    final list = Panel(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Connected sources', style: T.body(16, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Authorised integrations are added progressively. Manual entries are always labelled.',
            style: T.body(13, color: C.muted)),
        const SizedBox(height: 8),
        for (final s in sources) SourceRow(s, onFix: () => _snack('Connection flow opens here (sample).')),
      ]),
    );

    final privacy = Panel(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Privacy & control', style: T.body(16, weight: FontWeight.w600)),
        const SizedBox(height: 14),
        for (final (a, b) in const [
          ('Two-factor authentication', 'On'),
          ('Account numbers', 'Masked everywhere'),
          ('Used to train general AI models', 'Never'),
          ('Delegated access', 'None'),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              Expanded(child: Text(a, style: T.body(13.5, color: C.muted))),
              Text(b, style: T.mono(11.5, color: C.text)),
            ]),
          ),
        const SizedBox(height: 18),
        Wrap(spacing: 10, runSpacing: 10, children: [
          PButton('Export my data', small: true, ghost: true, onTap: () => _snack('Export prepared: CSV + PDF report (sample).')),
          PButton('Delete workspace data', small: true, ghost: true, onTap: () => _snack('Deletion requires confirmation by email (sample).')),
        ]),
      ]),
    );

    return ListView(padding: screenPad(context), children: [
      if (t) ...[importer, const SizedBox(height: 14), list, const SizedBox(height: 14), privacy]
      else
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(children: [importer, const SizedBox(height: 14), privacy])),
          const SizedBox(width: 14),
          Expanded(child: list),
        ]),
    ]);
  }
}
