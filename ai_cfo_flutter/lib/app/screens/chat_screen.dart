import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../core/sample_data.dart';
import '../../core/tokens.dart';
import '../../widgets/cfo.dart';
import '../../widgets/common.dart';
import '../../widgets/effects.dart';
import '../../widgets/logo.dart';

class ChatMessage {
  final bool fromUser;
  final String? text;
  final CfoAnswer? answer;
  const ChatMessage.user(this.text)
      : fromUser = true,
        answer = null;
  const ChatMessage.ai(this.answer)
      : fromUser = false,
        text = null;
}

/// Keeps a workspace's conversation alive across screen changes.
/// Retrieval is scoped to the workspace the controller was created for.
class ChatController extends ChangeNotifier {
  final Workspace ws;
  ChatController(this.ws);
  final messages = <ChatMessage>[];
  bool thinking = false;
  Timer? _t;

  void ask(String q) {
    if (q.trim().isEmpty || thinking) return;
    messages.add(ChatMessage.user(q.trim()));
    thinking = true;
    notifyListeners();
    _t = Timer(const Duration(milliseconds: 1100), () {
      messages.add(ChatMessage.ai(answerFor(q, ws)));
      thinking = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }
}

class ChatScreen extends StatefulWidget {
  final ChatController controller;
  final ValueChanged<String> onNavigate;
  const ChatScreen({super.key, required this.controller, required this.onNavigate});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changed);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_changed);
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _changed() {
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
      }
    });
  }

  void _send([String? q]) {
    widget.controller.ask(q ?? _input.text);
    _input.clear();
  }

  String _routeFor(String action) {
    final a = action.toLowerCase();
    if (a.contains('approv') || a.contains('draft')) return 'approvals';
    if (a.contains('scenario')) return 'scenarios';
    if (a.contains('connect') || a.contains('add data')) return 'connections';
    if (a.contains('uncategorised') || a.contains('review')) return 'transactions';
    return 'overview';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final personal = c.ws == Workspace.personal;
    final m = Bp.mobile(context);

    final intro = Panel(
      padding: const EdgeInsets.all(24),
      color: C.bg2,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Logo(compact: true, size: 14),
          const SizedBox(width: 10),
          Text('Obsid-finance · ${c.ws.title}', style: T.mono(11, color: C.text, letterSpacing: 1.2)),
        ]),
        const SizedBox(height: 16),
        Text(personal ? 'Good evening, Aarav.' : 'Good evening, Lumen Labs.', style: T.display(m ? 30 : 38)),
        const SizedBox(height: 10),
        Text('Since yesterday:', style: T.body(14, color: C.muted)),
        const SizedBox(height: 8),
        for (final s in personal
            ? const ['Dining & delivery passed 70% of its monthly budget.', 'Your freelance retainer (₹28,000) was credited.', 'One approval is waiting: emergency-fund transfer.']
            : const ['Kestrel Foods is now 32 days overdue (₹5.9 L).', 'Gateway settlements of ₹4.1 L arrived.', 'Three approvals are waiting, including invoice reminders.'])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(margin: const EdgeInsets.only(top: 9), width: 10, height: 1, color: C.champagne),
              const SizedBox(width: 12),
              Expanded(child: Text(s, style: T.body(14.5))),
            ]),
          ),
        const SizedBox(height: 14),
        Text('I answer only from this workspace’s data, show my evidence, and say so when I can’t.',
            style: T.mono(10.5, color: C.faint)),
      ]),
    );

    return Column(children: [
      Expanded(
        child: ListView(
          controller: _scroll,
          padding: EdgeInsets.symmetric(horizontal: m ? 16 : 40, vertical: 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  intro,
                  for (final msg in c.messages)
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: msg.fromUser
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 520),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                decoration: const BoxDecoration(
                                  color: C.platinum,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                                child: Text(msg.text!, style: T.body(15, color: C.bg, height: 1.4)),
                              ),
                            )
                          : TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              builder: (context, v, ch) => Opacity(
                                  opacity: v, child: Transform.translate(offset: Offset(0, (1 - v) * 12), child: ch)),
                              child: AnswerCard(msg.answer!,
                                  onNextAction: () => widget.onNavigate(_routeFor(msg.answer!.nextAction))),
                            ),
                    ),
                  if (c.thinking)
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: C.surface2, borderRadius: BorderRadius.circular(16)),
                          child: const TypingDots(),
                        ),
                        const SizedBox(width: 12),
                        Text('Checking sources and running calculations…', style: T.mono(10.5)),
                      ]),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
      Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.lineSoft))),
        padding: EdgeInsets.fromLTRB(m ? 16 : 40, 14, m ? 16 : 40, 18),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Column(children: [
              SizedBox(
                height: 40,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  for (final p in suggestedPrompts(c.ws))
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip2(p, icon: Icons.auto_awesome_outlined, onTap: () => _send(p)),
                    ),
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 18, right: 6),
                decoration: BoxDecoration(
                  color: C.surface,
                  border: Border.all(color: C.line),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      onSubmitted: (_) => _send(),
                      style: T.body(15),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: personal ? 'Ask about your money…' : 'Ask about the business…',
                        hintStyle: T.body(15, color: C.faint),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Send',
                    onPressed: _send,
                    icon: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(color: C.platinum, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_upward, size: 18, color: C.bg),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 8),
              Text('Education and decision support — not regulated financial advice.', style: T.mono(9.5, color: C.faint)),
            ]),
          ),
        ),
      ),
    ]);
  }
}
