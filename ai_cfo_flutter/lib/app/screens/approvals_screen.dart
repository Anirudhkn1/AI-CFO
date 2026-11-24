import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../core/tokens.dart';
import '../../widgets/cfo.dart';
import '../../widgets/common.dart';
import '../app_shell.dart';
import 'overview_screen.dart';

class ApprovalsScreen extends StatefulWidget {
  final Workspace ws;
  final WorkspaceState state;
  final VoidCallback onChanged;
  const ApprovalsScreen({super.key, required this.ws, required this.state, required this.onChanged});
  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  late String _selected = widget.state.approvals.first.id;

  String _now() {
    final n = DateTime.now();
    return 'Today, ${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _decide(ApprovalItem a, bool approve) async {
    if (!await confirmApproval(context, a, approve)) return;
    final when = _now();
    setState(() {
      a.status = approve ? ApprovalStatus.approved : ApprovalStatus.rejected;
      a.decidedAt = when;
      widget.state.activity.insert(
        0,
        ActivityEvent(when.replaceFirst('Today, ', 'Today '), approve ? 'Approved by you' : 'Rejected by you',
            '${a.title} · ${a.id}', 'approval'),
      );
    });
    widget.onChanged();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(approve
              ? '${a.id} approved and logged. ${a.reversible ? 'You can undo it from Activity.' : ''}'
              : '${a.id} rejected and logged.')));
    }
  }

  Widget _listTile(ApprovalItem a, bool mobile) {
    final sel = a.id == _selected && !mobile;
    return Hover(
      builder: (context, h) => GestureDetector(
        onTap: () {
          setState(() => _selected = a.id);
          if (mobile) _openDetail(a);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: sel ? C.surface2 : (h ? C.surface : Colors.transparent),
            border: Border(
              left: BorderSide(color: sel ? C.champagne : Colors.transparent, width: 2),
              bottom: const BorderSide(color: C.lineSoft),
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(a.kind.toUpperCase(), style: T.mono(9.5, color: C.champagne, letterSpacing: 1.2)),
              const Spacer(),
              Text(a.created, style: T.mono(10)),
            ]),
            const SizedBox(height: 8),
            Text(a.title, style: T.body(14.5, weight: FontWeight.w500, height: 1.35)),
            const SizedBox(height: 6),
            Text('${a.id} · ${a.requestedBy}', style: T.mono(10.5)),
          ]),
        ),
      ),
    );
  }

  void _openDetail(ApprovalItem a) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => Scaffold(
          appBar: AppBar(
            backgroundColor: C.bg,
            surfaceTintColor: Colors.transparent,
            title: Text(a.id, style: T.mono(13, color: C.text)),
          ),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            ApprovalCard(
              a,
              onApprove: () async {
                await _decide(a, true);
                setLocal(() {});
              },
              onReject: () async {
                await _decide(a, false);
                setLocal(() {});
              },
            ),
          ]),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = Bp.tablet(context);
    final items = widget.state.approvals;
    final pending = items.where((a) => a.status == ApprovalStatus.pending).toList();
    final history = items.where((a) => a.status != ApprovalStatus.pending).toList();
    final selected = items.firstWhere((a) => a.id == _selected, orElse: () => items.first);

    final list = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('PENDING · ${pending.length}', style: T.label(size: 10)),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
        child: Column(children: [
          for (final a in pending) _listTile(a, t),
          if (pending.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text('All clear. New requests appear here before anything happens.', style: T.body(13.5, color: C.muted)),
            ),
        ]),
      ),
      const SizedBox(height: 26),
      Text('DECIDED', style: T.label(size: 10)),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
        child: Column(children: [for (final a in history) _listTile(a, t)]),
      ),
    ]);

    final activity = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Activity timeline', style: T.body(16, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Imports, edits, recommendations and approvals — tamper-evident.', style: T.body(12.5, color: C.muted)),
        const SizedBox(height: 16),
        ActivityTimeline(widget.state.activity),
      ]),
    );

    if (t) {
      return ListView(padding: screenPad(context), children: [list, const SizedBox(height: 20), activity]);
    }
    return ListView(padding: screenPad(context), children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 360, child: list),
        const SizedBox(width: 24),
        Expanded(
          child: Column(children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: ApprovalCard(
                selected,
                key: ValueKey('${selected.id}-${selected.status}'),
                onApprove: () => _decide(selected, true),
                onReject: () => _decide(selected, false),
              ),
            ),
            const SizedBox(height: 16),
            activity,
          ]),
        ),
      ]),
    ]);
  }
}
