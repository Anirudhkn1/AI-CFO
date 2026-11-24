# Obsid-finance · Flutter (Platinum Obsidian)

The Obsid-finance marketing website and the Personal/Business app, built in Flutter from
`../AI_CFO_Comprehensive_PRD.pdf`. It uses the **Platinum Obsidian** direction: obsidian, platinum and
champagne, Italiana display type, Hanken Grotesk body and JetBrains Mono for figures. The chat-first
"ask your CFO anything" idea and the single financial picture take inspiration from CFO Silvia. The
branding, copy and UX here are original.

## Run

Flutter SDK is installed at `D:\flutter` (3.50.1 stable). Add `D:\flutter\bin` to PATH, or call it directly:

```bash
D:\flutter\bin\flutter pub get
D:\flutter\bin\flutter run -d chrome          # website at  /   · app at  /#/app
D:\flutter\bin\flutter build web --release    # output in build/web
D:\flutter\bin\flutter test
```

Android and iOS folders are generated. To build for Windows desktop, turn on Windows **Developer Mode**
first, because plugins need symlinks.

## What's inside

**Website** (`lib/landing/`): hero with silk light and a phone running a scripted chat, an "ask anything"
marquee, one financial picture, two workspaces, nine modules, how an answer is built, an interactive
Scenario Lab, an approvals demo, principles, pricing, FAQ, and the closing seal.

**App** (`lib/app/`): Personal and Business workspaces that never share data. The navigation follows PRD §14.
- Overview / Command Center: status, the most important next action, KPIs with Actual/Forecast/Estimate labels,
  a 90-day forecast with a range band and exact hover values, insight cards (period, impact, confidence,
  evidence), data coverage and an activity timeline.
- Transactions: filters, search, category correction, and evidence for each source record.
- Cash Flow: 30/90/180-day horizons, confirmed vs estimated drivers, and what changed.
- Obsid-finance Chat: structured answers (Observation → Evidence → Cause → Impact → Options → Recommendation →
  Confidence & limits → Next action), with a calculation path and an honest "insufficient data" reply.
- Scenarios: the deterministic engine (`lib/core/engine.dart`) for hiring or a big purchase.
- Approvals: exact parameters, what will happen, whether it can be undone, a confirm dialog, and a logged decision.
- Settings & Connections: a simulated import (validation, duplicates, categorising, reconciling) and privacy controls.
- Empty states for modules that aren't built yet. Each explains what to add and what you get.

All figures, people and organisations are **sample data**. Answers are scripted in `lib/core/sample_data.dart`,
and no AI backend is connected yet.
