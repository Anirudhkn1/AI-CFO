import 'package:flutter/material.dart';

import '../core/models.dart';
import '../core/sample_data.dart';
import '../core/tokens.dart';
import '../widgets/common.dart';
import '../widgets/logo.dart';
import 'app_data.dart';
import 'screens/approvals_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/connections_screen.dart';
import 'screens/empty_module.dart';
import 'screens/forecast_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/scenarios_screen.dart';
import 'screens/transactions_screen.dart';

/// State that must survive screen changes, kept per workspace (never shared).
class WorkspaceState {
  final List<ApprovalItem> approvals;
  final List<ActivityEvent> activity;
  final ChatController chat;
  WorkspaceState(this.approvals, this.activity, this.chat);
  int get pending => approvals.where((a) => a.status == ApprovalStatus.pending).length;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String _screen = 'overview';
  String _period = 'This month';
  final _scaffold = GlobalKey<ScaffoldState>();

  final _state = {
    Workspace.personal: WorkspaceState(personalApprovals(), [...personalActivity], ChatController(Workspace.personal)),
    Workspace.business: WorkspaceState(businessApprovals(), [...businessActivity], ChatController(Workspace.business)),
  };

  @override
  void initState() {
    super.initState();
    workspace.addListener(_onWs);
  }

  @override
  void dispose() {
    workspace.removeListener(_onWs);
    for (final s in _state.values) {
      s.chat.dispose();
    }
    super.dispose();
  }

  void _onWs() => setState(() {
        if (!navFor(workspace.value).any((n) => n.id == _screen)) _screen = 'overview';
      });

  void _go(String id) {
    setState(() => _screen = id);
    if (_scaffold.currentState?.isDrawerOpen ?? false) Navigator.pop(context);
  }

  Widget _body(Workspace ws) {
    final s = _state[ws]!;
    return switch (_screen) {
      'overview' => OverviewScreen(ws: ws, state: s, onNavigate: _go),
      'transactions' => TransactionsScreen(ws: ws),
      'forecast' => ForecastScreen(ws: ws),
      'chat' => ChatScreen(controller: s.chat, onNavigate: _go),
      'scenarios' => ScenariosScreen(ws: ws),
      'approvals' => ApprovalsScreen(ws: ws, state: s, onChanged: () => setState(() {})),
      'connections' => ConnectionsScreen(ws: ws),
      _ => EmptyModuleScreen(id: _screen, title: navFor(ws).firstWhere((n) => n.id == _screen).label, onNavigate: _go),
    };
  }

  @override
  Widget build(BuildContext context) {
    final ws = workspace.value;
    final mobile = Bp.tablet(context);
    final items = navFor(ws);
    final current = items.firstWhere((n) => n.id == _screen, orElse: () => items.first);
    final body = KeyedSubtree(key: ValueKey('$ws-$_screen'), child: _body(ws));

    final sidebar = _Sidebar(
      ws: ws,
      items: items,
      current: _screen,
      pending: _state[ws]!.pending,
      onSelect: _go,
    );

    if (mobile) {
      return Scaffold(
        key: _scaffold,
        drawer: Drawer(width: 300, child: sidebar),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SafeArea(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.lineSoft))),
              child: Row(children: [
                IconButton(
                    icon: const Icon(Icons.menu, color: C.text),
                    onPressed: () => _scaffold.currentState?.openDrawer()),
                Expanded(child: displayText(current.label, T.display(22), overflow: TextOverflow.ellipsis, maxLines: 1)),
                Segmented<Workspace>(
                  dense: true,
                  options: const [(Workspace.personal, 'Personal'), (Workspace.business, 'Business')],
                  value: ws,
                  onChanged: (v) => workspace.value = v,
                ),
                const SizedBox(width: 8),
              ]),
            ),
          ),
        ),
        body: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: body),
        bottomNavigationBar: _BottomBar(
          current: _screen,
          ws: ws,
          pending: _state[ws]!.pending,
          onSelect: _go,
        ),
      );
    }

    return Scaffold(
      key: _scaffold,
      body: Row(children: [
        SizedBox(width: 272, child: sidebar),
        const Hairline(vertical: true),
        Expanded(
          child: Column(children: [
            _TopBar(
              title: current.label,
              ws: ws,
              period: _period,
              onPeriod: (p) => setState(() => _period = p),
              onAsk: () => _go('chat'),
              showPeriod: _screen == 'overview' || _screen == 'transactions',
            ),
            Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: body)),
          ]),
        ),
      ]),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final Workspace ws;
  final List<NavItem> items;
  final String current;
  final int pending;
  final ValueChanged<String> onSelect;
  const _Sidebar(
      {required this.ws, required this.items, required this.current, required this.pending, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.bg,
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 16, 22),
            child: Row(children: [
              const Logo(size: 18),
              const Spacer(),
              IconButton(
                tooltip: 'Back to website',
                icon: const Icon(Icons.north_west, size: 16),
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false),
              ),
            ]),
          ),
          // Workspace switcher
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: C.line)),
              child: Column(children: [
                for (final w in Workspace.values)
                  Hover(
                    builder: (context, h) => GestureDetector(
                      onTap: () => workspace.value = w,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        color: w == ws ? C.surface2 : (h ? C.surface : Colors.transparent),
                        child: Row(children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: w == ws ? C.champagne : C.line),
                              shape: BoxShape.circle,
                            ),
                            child: Text(w == Workspace.personal ? 'AM' : 'LL',
                                style: T.mono(9.5, color: w == ws ? C.champagne : C.muted)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(w.title, style: T.body(13, weight: FontWeight.w600, height: 1.2)),
                              Text(w.owner, style: T.body(11.5, color: C.muted, height: 1.3)),
                            ]),
                          ),
                          if (w == ws) const Icon(Icons.check, size: 14, color: C.champagne),
                        ]),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
            child: Text('Workspaces are isolated — data never mixes.', style: T.mono(9.5, color: C.faint)),
          ),
          Expanded(
            child: ListView(padding: const EdgeInsets.symmetric(horizontal: 10), children: [
              for (final n in items)
                Hover(
                  builder: (context, h) => GestureDetector(
                    onTap: () => onSelect(n.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: n.id == current ? C.surface2 : (h ? C.surface : Colors.transparent),
                        border: Border(
                            left: BorderSide(color: n.id == current ? C.champagne : Colors.transparent, width: 2)),
                      ),
                      child: Row(children: [
                        Icon(n.icon, size: 17, color: n.id == current ? C.text : C.muted),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(n.label,
                              overflow: TextOverflow.ellipsis,
                              style: T.body(13.5, color: n.id == current ? C.text : C.muted, height: 1.2)),
                        ),
                        if (n.id == 'approvals' && pending > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            color: C.champagne,
                            child: Text('$pending', style: T.mono(10, color: C.bg, weight: FontWeight.w700)),
                          ),
                      ]),
                    ),
                  ),
                ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(border: Border.all(color: C.lineSoft), color: C.surface),
            child: Row(children: [
              const Icon(Icons.science_outlined, size: 14, color: C.champagne),
              const SizedBox(width: 10),
              Expanded(child: Text('Sample data for design review', style: T.body(11.5, color: C.muted))),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final Workspace ws;
  final String period;
  final ValueChanged<String> onPeriod;
  final VoidCallback onAsk;
  final bool showPeriod;
  const _TopBar(
      {required this.title,
      required this.ws,
      required this.period,
      required this.onPeriod,
      required this.onAsk,
      required this.showPeriod});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 24, 32, 20),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.lineSoft))),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${ws.title.toUpperCase()} · ${ws.owner.toUpperCase()}', style: T.label(size: 10)),
            const SizedBox(height: 6),
            displayText(title, T.display(36, height: 1.1)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
          child: Row(children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: C.positive, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(ws == Workspace.personal ? 'Synced 2h ago · 4 of 5 sources' : 'Synced 1h ago · 4 of 5 sources',
                style: T.mono(10.5)),
          ]),
        ),
        if (showPeriod) ...[
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            tooltip: 'Period',
            onSelected: onPeriod,
            itemBuilder: (_) => [
              for (final p in const ['This month', 'Last month', 'This quarter', 'FY 2026-27'])
                PopupMenuItem(value: p, child: Text(p)),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: C.line)),
              child: Row(children: [
                Text(period, style: T.body(12.5)),
                const SizedBox(width: 6),
                const Icon(Icons.expand_more, size: 16),
              ]),
            ),
          ),
        ],
        const SizedBox(width: 12),
        PButton('Ask Obsid-finance', small: true, onTap: onAsk, icon: Icons.auto_awesome_outlined),
      ]),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String current;
  final Workspace ws;
  final int pending;
  final ValueChanged<String> onSelect;
  const _BottomBar({required this.current, required this.ws, required this.pending, required this.onSelect});

  static const _icons = {
    'overview': (Icons.dashboard_outlined, 'Home'),
    'transactions': (Icons.receipt_long_outlined, 'Activity'),
    'chat': (Icons.auto_awesome_outlined, 'Ask'),
    'scenarios': (Icons.tune, 'Plan'),
    'approvals': (Icons.task_alt, 'Approve'),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: C.bg, border: Border(top: BorderSide(color: C.lineSoft))),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(children: [
            for (final id in mobileTabs)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelect(id),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Badge(
                      isLabelVisible: id == 'approvals' && pending > 0,
                      backgroundColor: C.champagne,
                      textColor: C.bg,
                      label: Text('$pending'),
                      child: Icon(_icons[id]!.$1, size: 20, color: current == id ? C.champagne : C.muted),
                    ),
                    const SizedBox(height: 5),
                    Text(_icons[id]!.$2.toUpperCase(),
                        style: T.body(9.5, color: current == id ? C.text : C.muted, letterSpacing: 1.2)),
                  ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
