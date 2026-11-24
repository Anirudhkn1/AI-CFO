import 'package:flutter/material.dart';

import '../../core/tokens.dart';
import '../../widgets/common.dart';
import '../../widgets/effects.dart';
import '../../widgets/logo.dart';
import '../app_data.dart';
import 'overview_screen.dart';

/// PRD §14 empty state: explain how to add data and what the user will gain.
class EmptyModuleScreen extends StatelessWidget {
  final String id;
  final String title;
  final ValueChanged<String> onNavigate;
  const EmptyModuleScreen({super.key, required this.id, required this.title, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final (lead, gains, steps) = emptyModules[id] ??
        ('This module is on its way.', <String>['Built on the same evidence-first engine'], <String>['Import data to get started']);
    final m = Bp.mobile(context);
    return ListView(padding: screenPad(context), children: [
      Panel(
        padding: EdgeInsets.all(m ? 24 : 56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Seal(text: '${title.toUpperCase()} · AWAITING DATA · ', size: 120, center: const Logo(compact: true, size: 20)),
          const SizedBox(height: 32),
          Text(lead, style: T.display(m ? 32 : 46, height: 1.1)),
          const SizedBox(height: 36),
          Wrap(spacing: 48, runSpacing: 32, children: [
            SizedBox(
              width: 360,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('WHAT YOU’LL GET', style: T.label(size: 10, color: C.champagne)),
                const SizedBox(height: 12),
                for (final g in gains)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Padding(padding: EdgeInsets.only(top: 3), child: Icon(Icons.check, size: 14, color: C.champagne)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(g, style: T.body(14.5))),
                    ]),
                  ),
              ]),
            ),
            SizedBox(
              width: 360,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('HOW TO START', style: T.label(size: 10)),
                const SizedBox(height: 12),
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 26, child: Text('0${i + 1}', style: T.mono(11, color: C.faint))),
                      Expanded(child: Text(steps[i], style: T.body(14.5, color: C.muted))),
                    ]),
                  ),
              ]),
            ),
          ]),
          const SizedBox(height: 36),
          Wrap(spacing: 12, runSpacing: 12, children: [
            PButton('Import data', small: true, onTap: () => onNavigate('connections'), icon: Icons.arrow_forward),
            PButton('Ask Obsid-finance', small: true, ghost: true, onTap: () => onNavigate('chat')),
          ]),
        ]),
      ),
    ]);
  }
}
