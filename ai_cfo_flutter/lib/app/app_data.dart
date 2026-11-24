import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/models.dart';

class NavItem {
  final String id;
  final String label;
  final IconData icon;
  const NavItem(this.id, this.label, this.icon);
}

/// PRD §14 suggested navigation, per workspace.
List<NavItem> navFor(Workspace ws) => ws == Workspace.personal
    ? const [
        NavItem('overview', 'Overview', Icons.dashboard_outlined),
        NavItem('transactions', 'Transactions', Icons.receipt_long_outlined),
        NavItem('forecast', 'Cash Flow', Icons.show_chart),
        NavItem('budgets', 'Budgets & Goals', Icons.flag_outlined),
        NavItem('scenarios', 'Plan a Decision', Icons.tune),
        NavItem('networth', 'Net Worth & Investments', Icons.account_balance_wallet_outlined),
        NavItem('documents', 'Documents', Icons.description_outlined),
        NavItem('chat', 'Obsid-finance Chat', Icons.chat_bubble_outline),
        NavItem('learning', 'Learning', Icons.school_outlined),
        NavItem('approvals', 'Approvals & Activity', Icons.task_alt),
        NavItem('connections', 'Settings & Connections', Icons.settings_outlined),
      ]
    : const [
        NavItem('overview', 'Command Center', Icons.dashboard_outlined),
        NavItem('transactions', 'Transactions & Accounting', Icons.receipt_long_outlined),
        NavItem('forecast', 'Cash Flow & Forecasts', Icons.show_chart),
        NavItem('revenue', 'Revenue & Performance', Icons.trending_up),
        NavItem('arap', 'Receivables & Payables', Icons.swap_horiz),
        NavItem('spend', 'Spend Intelligence', Icons.manage_search),
        NavItem('scenarios', 'Budgets & Scenarios', Icons.tune),
        NavItem('documents', 'Documents & Payroll', Icons.description_outlined),
        NavItem('chat', 'Obsid-finance Chat', Icons.chat_bubble_outline),
        NavItem('approvals', 'Approvals', Icons.task_alt),
        NavItem('connections', 'Settings & Connections', Icons.settings_outlined),
      ];

const mobileTabs = ['overview', 'transactions', 'chat', 'scenarios', 'approvals'];

/// Empty-state copy (PRD §14: explain how to add data and what the user gains).
const emptyModules = <String, (String, List<String>, List<String>)>{
  'budgets': (
    'Budgets & goals turn intentions into a plan you can see.',
    ['Monthly budgets with forecast overspend', 'Emergency-fund, debt-payoff and purchase goals', 'Saved plan versions you can compare'],
    ['Import 3 months of statements', 'Pick a goal to start with'],
  ),
  'networth': (
    'See everything you own and owe — with sources and dates.',
    ['Allocation and concentration, explained', 'Fees and time-horizon in plain language', 'Missing holdings flagged, never assumed'],
    ['Upload your consolidated account statement (CAS)', 'Add property or vehicles manually'],
  ),
  'documents': (
    'Upload a document. Check what was read. Then it counts.',
    ['Totals, dates, parties and tax fields extracted', 'Each field shown with confidence and its page', 'Duplicates detected and linked to transactions'],
    ['Drop bank statements, invoices, bills or payslips', 'Review low-confidence fields'],
  ),
  'learning': (
    'Short lessons, using your own numbers.',
    ['Budgeting, cash flow, tax basics, debt and investing', 'Glossary, examples and calculators', 'Save explanations you found useful'],
    ['Ask a “what does this mean?” question in chat', 'Choose a learning path'],
  ),
  'revenue': (
    'Revenue, margins and unit economics — only when the data supports them.',
    ['Revenue and expense trends', 'Gross and operating margin', 'CAC, LTV and payback when inputs exist — never fabricated'],
    ['Import your accounting export', 'Connect your payment gateway'],
  ),
  'arap': (
    'Know what’s owed to you, what you owe, and what to pay first.',
    ['Overdue receivables and upcoming bills', 'Impact of late collections on cash', 'Reminder drafts, sent only after approval'],
    ['Import invoices and bills (CSV/XLSX)', 'Set your payment-priority policy'],
  ),
  'spend': (
    'Find the money that leaks quietly.',
    ['Recurring charges and supplier price rises', 'Possible duplicate payments, for review', 'Estimated vs verified savings, tracked separately'],
    ['Import 6 months of transactions', 'Tag your key suppliers'],
  ),
};

// ── Overview forecast series ────────────────────────────────────────────────
class WeeklySeries {
  final List<String> labels;
  final List<double> values;
  final List<double> low;
  final List<double> high;
  final int split;
  const WeeklySeries(this.labels, this.values, this.low, this.high, this.split);
}

/// 7 past weeks + [forecastWeeks] future weeks, anchored so "today" (24 Nov 2026)
/// equals the current balance.
WeeklySeries weeklySeries(Workspace ws, {int forecastWeeks = 13}) {
  const past = 7;
  final start = DateTime(2026, 11, 24).subtract(const Duration(days: 7 * past));
  final n = past + forecastWeeks + 1;
  final raw = <double>[];
  final labels = <String>[];
  double cash = 0;
  for (var i = 0; i < n; i++) {
    final d = start.add(Duration(days: 7 * i));
    labels.add('${d.day} ${months[d.month - 1]}');
    if (ws == Workspace.personal) {
      if (d.day <= 7) cash += 135000;
      if (d.day > 7 && d.day <= 14) cash -= 38900;
      cash -= 22000 + (i % 3) * 1500;
    } else {
      if (d.day <= 7) cash -= 2480000; // payroll
      cash += 640000 - 290000 + (i % 4 == 2 ? -180000 : 0);
    }
    raw.add(cash);
  }
  final anchor = ws == Workspace.personal ? 142300.0 : 18400000.0;
  final shift = anchor - raw[past];
  final values = [for (final v in raw) v + shift];
  final unit = ws == Workspace.personal ? 2600.0 : 140000.0;
  final low = [for (var i = 0; i < n; i++) values[i] - (i > past ? (i - past) * unit * 1.2 : 0)];
  final high = [for (var i = 0; i < n; i++) values[i] + (i > past ? (i - past) * unit : 0)];
  return WeeklySeries(labels, values, low, high, past);
}

class Driver {
  final String date;
  final String item;
  final num amount;
  final Tag tag;
  const Driver(this.date, this.item, this.amount, this.tag);
}

List<Driver> driversFor(Workspace ws) => ws == Workspace.personal
    ? const [
        Driver('28 Nov', 'Credit card bill — ICICI ••8812', -21400, Tag.confirmed),
        Driver('30 Nov', 'Electricity & broadband', -3900, Tag.estimate),
        Driver('01 Dec', 'Salary — Lumen Labs', 107000, Tag.confirmed),
        Driver('01 Dec', 'Emergency-fund transfer (pending approval)', -20000, Tag.estimate),
        Driver('05 Dec', 'Freelance retainer — Studio Arc', 28000, Tag.estimate),
        Driver('15 Dec', 'Home loan EMI', -38900, Tag.confirmed),
      ]
    : const [
        Driver('28 Nov', 'Kestrel Foods — INV-2041 (32 days overdue)', 590000, Tag.estimate),
        Driver('30 Nov', 'Prism Design Studio — BILL-0388', -236000, Tag.confirmed),
        Driver('01 Dec', 'Payroll — November (24 employees)', -2480000, Tag.confirmed),
        Driver('05 Dec', 'Gateway settlements (weekly avg.)', 412000, Tag.estimate),
        Driver('07 Dec', 'TDS deposit — November', -186000, Tag.confirmed),
        Driver('20 Dec', 'GST payment — November', -324000, Tag.estimate),
      ];
