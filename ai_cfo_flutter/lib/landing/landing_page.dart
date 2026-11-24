import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/tokens.dart';
import '../widgets/common.dart';
import '../widgets/logo.dart';
import 'hero.dart';
import 'sections_a.dart';
import 'sections_b.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scroll = ScrollController();
  final _keys = {
    'Product': GlobalKey(),
    'Intelligence': GlobalKey(),
    'Scenarios': GlobalKey(),
    'Approvals': GlobalKey(),
    'Pricing': GlobalKey(),
    'FAQ': GlobalKey(),
  };
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final s = _scroll.offset > 24;
      if (s != _scrolled) setState(() => _scrolled = s);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _go(String k) {
    final ctx = _keys[k]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 900), curve: Curves.easeInOutCubic);
    }
  }

  void _openApp() => Navigator.of(context).pushNamed('/app');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Scrollbar(
          controller: _scroll,
          child: SingleChildScrollView(
            controller: _scroll,
            child: Column(children: [
              HeroSection(onOpenApp: _openApp, onSeeHow: () => _go('Intelligence')),
              const AskSection(),
              KeyedSubtree(key: _keys['Product'], child: const OnePictureSection()),
              const WorkspacesSection(),
              const ModulesSection(),
              KeyedSubtree(key: _keys['Intelligence'], child: const AnatomySection()),
              KeyedSubtree(key: _keys['Scenarios'], child: const LabSection()),
              KeyedSubtree(key: _keys['Approvals'], child: const ApprovalsSection()),
              const PrinciplesSection(),
              KeyedSubtree(key: _keys['Pricing'], child: PricingSection(onOpenApp: _openApp)),
              KeyedSubtree(key: _keys['FAQ'], child: const FaqSection()),
              CtaSection(onOpenApp: _openApp),
              const FooterSection(),
            ]),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _Nav(scrolled: _scrolled, links: _keys.keys.toList(), onLink: _go, onOpenApp: _openApp),
        ),
      ]),
    );
  }
}

class _Nav extends StatelessWidget {
  final bool scrolled;
  final List<String> links;
  final ValueChanged<String> onLink;
  final VoidCallback onOpenApp;
  const _Nav({required this.scrolled, required this.links, required this.onLink, required this.onOpenApp});

  @override
  Widget build(BuildContext context) {
    final t = Bp.tablet(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: scrolled ? 18 : 0, sigmaY: scrolled ? 18 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: scrolled ? C.bg.withValues(alpha: 0.78) : Colors.transparent,
            border: Border(bottom: BorderSide(color: scrolled ? C.lineSoft : Colors.transparent)),
          ),
          padding: EdgeInsets.symmetric(vertical: scrolled ? 14 : 24),
          child: Contained(
            child: Row(children: [
              Logo(size: Bp.mobile(context) ? 18 : 22),
              const Spacer(),
              if (!t) ...[
                for (final l in links)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LinkText(l.toUpperCase(),
                        onTap: () => onLink(l), style: T.body(11, color: C.muted, letterSpacing: 2.2)),
                  ),
                const Spacer(),
                LinkText('SIGN IN', onTap: onOpenApp, style: T.body(11, color: C.muted, letterSpacing: 2.2)),
                const SizedBox(width: 24),
                PButton('Open the app', small: true, onTap: onOpenApp),
              ] else ...[
                PButton('Open app', small: true, onTap: onOpenApp),
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Menu',
                  icon: const Icon(Icons.menu, color: C.text, size: 22),
                  onPressed: () => _menu(context),
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }

  void _menu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, _, __) => Material(
        color: C.bg,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Logo(),
                const Spacer(),
                IconButton(
                    icon: const Icon(Icons.close, color: C.text), onPressed: () => Navigator.pop(ctx)),
              ]),
              const SizedBox(height: 48),
              for (final l in links)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    Future.delayed(const Duration(milliseconds: 320), () => onLink(l));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l, style: T.display(40)),
                  ),
                ),
              const Spacer(),
              PButton('Open the app', onTap: () {
                Navigator.pop(ctx);
                onOpenApp();
              }),
            ]),
          ),
        ),
      ),
      transitionBuilder: (ctx, a, _, child) => FadeTransition(opacity: a, child: child),
    );
  }
}
