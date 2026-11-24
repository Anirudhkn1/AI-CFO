import 'package:flutter/material.dart';

import '../../core/engine.dart';
import '../../core/models.dart';
import '../../core/tokens.dart';
import '../../widgets/cfo.dart';
import '../../widgets/common.dart';
import 'overview_screen.dart';

class ScenariosScreen extends StatelessWidget {
  final Workspace ws;
  const ScenariosScreen({super.key, required this.ws});

  @override
  Widget build(BuildContext context) {
    final saved = ws == Workspace.personal
        ? const [
            ('Laptop on 1 Dec vs today', '22 Nov 2026, 21:14', 'Price ₹80,000 · upfront · buy Dec'),
            ('Car down-payment in 2027', '02 Nov 2026, 10:40', 'Price ₹3,00,000 · EMI ×12 · buy Mar'),
          ]
        : const [
            ('Hire 2 engineers — Dec', '23 Nov 2026, 18:02', '2 × ₹30 L CTC · growth 3%/mo'),
            ('Stagger hires — Dec & Mar', '23 Nov 2026, 18:09', '1 + 1 × ₹30 L CTC · growth 3%/mo'),
            ('Downside: biggest customer churns', '15 Nov 2026, 12:30', 'Revenue −₹5.9 L/mo from Jan'),
          ];
    return ListView(padding: screenPad(context), children: [
      Panel(
        padding: EdgeInsets.all(Bp.mobile(context) ? 18 : 32),
        child: ScenarioLab(key: ValueKey(ws), mode: ws),
      ),
      const SizedBox(height: 16),
      Panel(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Saved scenarios', style: T.body(16, weight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Each is reproducible from its stored inputs and calculation version.', style: T.body(12.5, color: C.muted)),
          const SizedBox(height: 10),
          for (final (name, savedAt, inputs) in saved)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.lineSoft))),
              child: Row(children: [
                const Icon(Icons.bookmark_border, size: 16, color: C.champagne),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: T.body(14.5, weight: FontWeight.w500)),
                    Text(inputs, style: T.mono(10.5)),
                  ]),
                ),
                if (!Bp.mobile(context)) Text("$savedAt · $calcVersion", style: T.mono(10.5)),
              ]),
            ),
        ]),
      ),
    ]);
  }
}
