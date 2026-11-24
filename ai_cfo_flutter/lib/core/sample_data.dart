// All names, figures and organisations below are SAMPLE DATA for design review.
import 'models.dart';

// ── Personal ────────────────────────────────────────────────────────────────
const personalNetWorth = 4862300;
const personalNetWorthDelta = 112400;

const personalBreakdown = <(String, num, Tag)>[
  ('Bank & cash', 684200, Tag.actual),
  ('Mutual funds & stocks', 2240100, Tag.actual),
  ('EPF & PPF', 918000, Tag.estimate),
  ('Flat — Powai', 4200000, Tag.manual),
  ('Home loan', -3180000, Tag.actual),
];

const personalKpis = [
  Kpi('Available cash', 142300, delta: 'Synced 2h ago', tag: Tag.actual),
  Kpi('Income', 135000, delta: 'Salary + freelance', tag: Tag.actual),
  Kpi('Spending to date', 71480, delta: '+14% vs Oct', deltaUp: false, tag: Tag.actual),
  Kpi('Savings rate', 29, delta: 'Month-end projection', tag: Tag.forecast, isPercent: true),
];

const personalInsights = [
  Insight(
    title: 'Dining & delivery is 38% above October',
    period: '1 – 24 Nov 2026',
    impact: '₹6,420 over budget',
    impactPositive: false,
    confidence: Confidence.high,
    evidence: '23 transactions · HDFC ••4521, ICICI ••8812',
    body: 'Weekend delivery orders doubled. At this pace the category closes at ₹15,400 against a ₹9,000 budget.',
  ),
  Insight(
    title: 'Three subscriptions show no recent use',
    period: 'Last 90 days',
    impact: 'Up to ₹1,847/mo (estimate)',
    impactPositive: true,
    confidence: Confidence.medium,
    evidence: '3 recurring charges · ICICI ••8812',
    body: 'A streaming plan, a fitness pass and a notes app. Savings are tracked as “estimated” until later statements confirm them.',
  ),
  Insight(
    title: 'Emergency fund is 64% complete',
    period: 'As of 24 Nov 2026',
    impact: '₹1,08,000 to go · on track for Mar 2027',
    impactPositive: true,
    confidence: Confidence.high,
    evidence: 'Goal: 6 months of essentials (₹3,00,000)',
    body: 'Keeping the ₹20,000 monthly transfer reaches the goal one month earlier than planned.',
  ),
];

final personalTxns = <Txn>[
  Txn('24 Nov', 'Swiggy order', 'Swiggy', 'Dining & delivery', -684, 'ICICI ••8812', 'UPI/SWIGGY/8812/2411', Tag.actual),
  Txn('23 Nov', 'Transfer to self', 'Aarav Mehta', 'Uncategorised', -20000, 'HDFC ••4521', 'IMPS/SELF/LIQUIDFUND', Tag.needsReview),
  Txn('22 Nov', 'BESCOM electricity', 'BESCOM', 'Bills & utilities', -2340, 'HDFC ••4521', 'BBPS/BESCOM/NOV', Tag.actual),
  Txn('21 Nov', 'Freelance — design retainer', 'Studio Arc', 'Income', 28000, 'HDFC ••4521', 'NEFT/STUDIOARC/INV17', Tag.actual),
  Txn('20 Nov', 'Amazon', 'Amazon', 'Shopping', -3499, 'ICICI ••8812', 'POS/AMAZON/IN', Tag.actual),
  Txn('19 Nov', 'Cult.fit membership', 'Cult.fit', 'Subscriptions', -1299, 'ICICI ••8812', 'SI/CULTFIT/MONTHLY', Tag.needsReview),
  Txn('15 Nov', 'Home loan EMI', 'HDFC Home Loans', 'Loan repayment', -38900, 'HDFC ••4521', 'ACH/HDFCHL/EMI', Tag.actual),
  Txn('12 Nov', 'SIP — Flexi cap fund', 'Mutual fund', 'Investments', -15000, 'HDFC ••4521', 'ACH/BSE STAR MF/SIP', Tag.actual),
  Txn('01 Nov', 'Salary', 'Lumen Labs Pvt Ltd', 'Income', 107000, 'HDFC ••4521', 'NEFT/LUMENLABS/SAL NOV', Tag.actual),
  Txn('01 Nov', 'Rent share', 'R. Iyer', 'Housing', -18000, 'HDFC ••4521', 'UPI/RIYER/RENT', Tag.actual),
];

const personalSources = [
  DataSource('HDFC Bank — Savings', 'Bank account', '••4521', 'synced', 'Synced 2h ago'),
  DataSource('ICICI — Credit card', 'Card', '••8812', 'imported', 'CSV imported 21 Nov'),
  DataSource('Mutual funds & stocks', 'Holdings', 'CAS statement', 'imported', 'PDF imported 18 Nov'),
  DataSource('Flat — Powai', 'Property', 'Self-declared value', 'manual', 'Manually entered 1 Oct'),
  DataSource('EPF', 'Retirement', 'UAN ••7731', 'missing', 'Not connected'),
];

// ── Business ────────────────────────────────────────────────────────────────
const businessKpis = [
  Kpi('Cash balance', 18400000, delta: 'HDFC Current + Razorpay', tag: Tag.actual),
  Kpi('Revenue', 2640000, delta: '+12% vs Oct', deltaUp: true, tag: Tag.forecast),
  Kpi('Net burn', 1120000, delta: '−6% vs Oct', deltaUp: true, tag: Tag.actual),
  Kpi('Receivables', 2140000, delta: '₹14.8 L overdue', deltaUp: false, tag: Tag.actual),
];

const businessInsights = [
  Insight(
    title: 'Collections slowed while revenue grew',
    period: 'Oct 2026',
    impact: '₹12.2 L less cash than plan',
    impactPositive: false,
    confidence: Confidence.medium,
    evidence: '41 invoices · Invoices register (Tally export)',
    body: 'Receivables older than 30 days rose from ₹9.2 L to ₹21.4 L. Four invoices have no due date, which lowers confidence.',
  ),
  Insight(
    title: 'Cloud bill up 22% month-on-month',
    period: 'Nov 2026',
    impact: '₹1.38 L/mo more spend',
    impactPositive: false,
    confidence: Confidence.high,
    evidence: '6 bills · Cloud infrastructure',
    body: 'Most of the increase is a staging cluster left running since 3 Nov. Review with engineering before cutting.',
  ),
  Insight(
    title: 'Collecting three invoices extends runway',
    period: 'Next 30 days',
    impact: '+0.9 months of runway',
    impactPositive: true,
    confidence: Confidence.medium,
    evidence: 'INV-2041 · INV-2047 · INV-2052',
    body: 'Reminder drafts are prepared and waiting in Approvals. Nothing is sent without you.',
  ),
];

final businessTxns = <Txn>[
  Txn('24 Nov', 'Razorpay settlement', 'Razorpay', 'Revenue — subscriptions', 412300, 'HDFC ••0193', 'NEFT/RAZORPAY/SETL2411', Tag.actual),
  Txn('23 Nov', 'AWS India', 'Amazon Web Services', 'Software subscriptions', -184200, 'HDFC ••0193', 'ACH/AWSINDIA/NOV', Tag.needsReview),
  Txn('22 Nov', 'Prism Design Studio', 'Prism Design Studio', 'Professional fees', -236000, 'Bills register', 'BILL-0388', Tag.estimate),
  Txn('21 Nov', 'Kestrel Foods — INV-2033', 'Kestrel Foods Pvt Ltd', 'Revenue — services', 590000, 'HDFC ••0193', 'NEFT/KESTREL/INV2033', Tag.actual),
  Txn('20 Nov', 'GST payment — Oct', 'GSTN', 'Taxes', -318400, 'HDFC ••0193', 'GST/PMT-06/OCT', Tag.actual),
  Txn('18 Nov', 'WeWork — Koramangala', 'WeWork India', 'Rent', -265000, 'HDFC ••0193', 'NEFT/WEWORK/NOV', Tag.actual),
  Txn('15 Nov', 'Google Ads', 'Google India', 'Marketing', -122000, 'HDFC ••0193', 'CARD/GOOGLEADS', Tag.actual),
  Txn('12 Nov', 'Transfer to Razorpay X', 'Lumen Labs', 'Transfer', -500000, 'HDFC ••0193', 'IMPS/RZPX/TOPUP', Tag.needsReview),
  Txn('01 Nov', 'Payroll — October', '24 employees', 'Payroll', -2480000, 'Payroll register', 'PAYROLL/OCT/24', Tag.actual),
  Txn('01 Nov', 'Orbit Retail — INV-2029', 'Orbit Retail LLP', 'Revenue — services', 340000, 'HDFC ••0193', 'NEFT/ORBIT/INV2029', Tag.actual),
];

const businessSources = [
  DataSource('HDFC Bank — Current', 'Bank account', '••0193', 'synced', 'Synced 1h ago'),
  DataSource('Payment gateway settlements', 'Payments', 'Razorpay', 'synced', 'Synced 3h ago'),
  DataSource('Accounting export', 'Ledger', 'Tally XLSX', 'imported', 'XLSX imported 20 Nov'),
  DataSource('Payroll register — Oct', 'Payroll', '24 employees', 'imported', 'CSV imported 2 Nov'),
  DataSource('Invoices & bills', 'Receivables', '4 invoices missing due dates', 'error', 'Needs review'),
];

// ── Approvals (PRD §6.16) ───────────────────────────────────────────────────
List<ApprovalItem> businessApprovals() => [
      ApprovalItem(
        id: 'APR-1042',
        title: 'Send first reminders for 3 overdue invoices',
        kind: 'Message to customers',
        requestedBy: 'Obsid-finance · Receivables',
        created: 'Today, 09:14',
        params: {
          'Recipients': 'Kestrel Foods Pvt Ltd, Orbit Retail LLP, Nimbus Health',
          'Invoices': 'INV-2041 · INV-2047 · INV-2052',
          'Total outstanding': '₹14,80,000',
          'Days overdue': '32 · 21 · 18',
          'Channel': 'Email from finance@ (draft attached)',
          'Tone': 'Polite first reminder, no penalty language',
        },
        whatHappens:
            'Three emails are sent from your connected mailbox. The invoices are marked “Reminder sent”. No money moves.',
        reversible: false,
        affected: '3 invoices · 3 customer contacts',
      ),
      ApprovalItem(
        id: 'APR-1043',
        title: 'Recategorise 18 cloud transactions',
        kind: 'Change accounting records',
        requestedBy: 'Obsid-finance · Accounting',
        created: 'Today, 08:02',
        params: {
          'Rule': 'Counterparty contains “AWS”',
          'Period': '1 Apr – 24 Nov 2026',
          'From': 'Software subscriptions',
          'To': 'Cloud infrastructure',
          'Transactions': '18 (₹11,42,600)',
        },
        whatHappens:
            'Category changes on 18 records. Originals stay in the audit history and the change can be undone.',
        reversible: true,
        affected: '18 transactions · FY 2026-27 P&L view',
      ),
      ApprovalItem(
        id: 'APR-1044',
        title: 'Prepare payment file: Prism Design Studio',
        kind: 'Payment preparation',
        requestedBy: 'Obsid-finance · Payables',
        created: 'Yesterday, 17:40',
        params: {
          'Amount': '₹2,36,000 (incl. GST ₹36,000)',
          'Bill': 'BILL-0388 · due 30 Nov 2026',
          'Pay from': 'HDFC Current ••0193',
          'Execution': 'Bank upload file only — no direct payment',
        },
        whatHappens:
            'A bank-format payment file is generated for you to upload. Obsid-finance cannot send money.',
        reversible: true,
        affected: '1 bill · cash forecast for 30 Nov',
      ),
      ApprovalItem(
        id: 'APR-1039',
        title: 'Update marketing budget for Q4',
        kind: 'Change budget',
        requestedBy: 'Priya S. (Finance)',
        created: '21 Nov, 11:20',
        params: {'Budget': 'Marketing — Q4', 'From': '₹9,00,000', 'To': '₹11,50,000'},
        whatHappens: 'Budget version 3 is saved. Version 2 stays available.',
        reversible: true,
        affected: '1 budget',
        status: ApprovalStatus.approved,
        decidedAt: '21 Nov, 15:02',
      ),
      ApprovalItem(
        id: 'APR-1036',
        title: 'Email supplier about price increase',
        kind: 'Message to supplier',
        requestedBy: 'Obsid-finance · Spend',
        created: '19 Nov, 10:05',
        params: {'Supplier': 'CloudKitchen Supplies', 'Change': '+9% unit price'},
        whatHappens: 'One email draft sent.',
        reversible: false,
        affected: '1 supplier',
        status: ApprovalStatus.rejected,
        decidedAt: '19 Nov, 12:44',
      ),
    ];

List<ApprovalItem> personalApprovals() => [
      ApprovalItem(
        id: 'APR-0217',
        title: 'Move ₹20,000 to your emergency fund',
        kind: 'Transfer instruction',
        requestedBy: 'Obsid-finance · Goals',
        created: 'Today, 07:30',
        params: {
          'From': 'HDFC Savings ••4521',
          'To': 'Liquid fund — Emergency goal',
          'Amount': '₹20,000',
          'Date': '1 Dec 2026',
          'Execution': 'Reminder + prepared instruction; you complete it in your bank app',
        },
        whatHappens:
            'You get a reminder on 1 Dec with the instruction ready. Obsid-finance does not move money.',
        reversible: true,
        affected: 'Emergency fund goal · Dec cash forecast',
      ),
      ApprovalItem(
        id: 'APR-0216',
        title: 'Raise December dining budget to ₹11,000',
        kind: 'Change budget',
        requestedBy: 'Obsid-finance · Budgets',
        created: 'Yesterday, 21:10',
        params: {
          'Budget': 'Dining & delivery — Dec 2026',
          'From': '₹9,000',
          'To': '₹11,000',
          'Offset': 'Shopping budget reduced by ₹2,000',
        },
        whatHappens: 'A new budget version is saved. Savings rate projection stays at 29%.',
        reversible: true,
        affected: '2 budget categories',
      ),
      ApprovalItem(
        id: 'APR-0215',
        title: 'Mark 4 self-transfers as internal',
        kind: 'Change records',
        requestedBy: 'Obsid-finance · Transactions',
        created: '22 Nov, 18:02',
        params: {
          'Transactions': '4 (₹62,000)',
          'Rule': 'Same owner, matching amounts within 1 day',
          'Effect': 'Excluded from income and spending totals',
        },
        whatHappens: 'Spending and income totals for Nov drop by ₹62,000 each.',
        reversible: true,
        affected: '4 transactions',
      ),
      ApprovalItem(
        id: 'APR-0209',
        title: 'Remind me to review health insurance renewal',
        kind: 'Reminder',
        requestedBy: 'You',
        created: '14 Nov, 09:00',
        params: {'Date': '5 Dec 2026'},
        whatHappens: 'One reminder.',
        reversible: true,
        affected: '—',
        status: ApprovalStatus.approved,
        decidedAt: '14 Nov, 09:01',
      ),
    ];

const personalActivity = [
  ActivityEvent('Today 07:30', 'Approval requested', 'Move ₹20,000 to emergency fund', 'approval'),
  ActivityEvent('Yesterday 21:10', 'Recommendation', 'Raise December dining budget', 'recommendation'),
  ActivityEvent('21 Nov 14:02', 'Import completed', 'ICICI card CSV · 86 rows · 2 duplicates skipped', 'import'),
  ActivityEvent('18 Nov 10:12', 'Import completed', 'Holdings statement (PDF) · 14 holdings', 'import'),
  ActivityEvent('16 Nov 19:40', 'Edit', 'Split “Amazon” ₹6,998 into Shopping / Gifts', 'edit'),
];

const businessActivity = [
  ActivityEvent('Today 09:14', 'Approval requested', 'Reminders for 3 overdue invoices', 'approval'),
  ActivityEvent('Today 08:02', 'Recommendation', 'Recategorise 18 cloud transactions', 'recommendation'),
  ActivityEvent('21 Nov 15:02', 'Approved by Priya S.', 'Marketing budget Q4 → ₹11,50,000', 'approval'),
  ActivityEvent('20 Nov 16:30', 'Import completed', 'Tally export · 1,204 rows · 0 duplicates', 'import'),
  ActivityEvent('19 Nov 12:44', 'Rejected by you', 'Supplier price-increase email', 'approval'),
];

// ── Chat (PRD Appendix A) ───────────────────────────────────────────────────
const answerAfford = CfoAnswer(
  observation: 'You can, but buying this month takes you below your ₹30,000 cash floor.',
  evidence: ['HDFC ••4521 · ₹1,42,300 available', '3 bills due by 30 Nov · ₹38,900', 'Floor set by you · ₹30,000'],
  cause: 'Your home-loan EMI and two bills land before the next salary credit on 1 Dec.',
  impact: 'Buying today leaves ₹23,400 until 1 Dec — ₹6,600 under your floor for 6 days.',
  options: [
    'Buy on 1 Dec, after salary — stays above floor all month',
    'No-cost EMI × 6 — ₹13,334/mo, savings rate drops to 19% for 6 months',
    'Wait 3 months — fund it fully from savings without touching the emergency goal',
  ],
  recommendation: 'Waiting one week to 1 Dec keeps every goal intact. The decision is yours.',
  confidence: Confidence.high,
  limits: 'Card dues for December are estimated from the last 3 statements.',
  nextAction: 'Save as scenario',
  calculation: '142,300 − 38,900 − 80,000 = 23,400 · floor 30,000 · calc v2.4.0',
);

const answerNetWorth = CfoAnswer(
  observation: 'Your net worth is ₹48,62,300 — up ₹1,12,400 since 1 Nov.',
  evidence: ['4 of 5 sources current', 'Flat value is manually entered (1 Oct)', 'EPF not connected'],
  cause: 'Markets added ₹71,600 to your funds; savings added ₹40,800.',
  impact: 'Liquid net worth (excluding the flat and EPF) is ₹6,62,300 after the home loan.',
  options: ['Connect EPF for a complete picture', 'Update the flat’s value', 'See the 12-month trend'],
  recommendation: 'Connect EPF — it is likely your third-largest asset.',
  confidence: Confidence.medium,
  limits: 'EPF is an estimate from your last payslip; property is self-declared.',
  nextAction: 'Connect EPF',
  calculation: '6,84,200 + 22,40,100 + 9,18,000 + 42,00,000 − 31,80,000 = 48,62,300',
);

const answerSpending = CfoAnswer(
  observation: 'Spending is 14% higher than October so far, mostly dining & delivery.',
  evidence: ['71 transactions · 1–24 Nov', 'Dining & delivery · 23 transactions', 'October baseline · ₹62,700 by day 24'],
  cause: 'Weekend delivery orders doubled; one-off ₹3,499 shopping order.',
  impact: 'Month-end spend projected at ₹96,000 — savings rate 29% instead of 33%.',
  options: ['Cap delivery at ₹9,000 for December', 'Keep as is and lower the SIP top-up', 'Ignore — it is seasonal'],
  recommendation: 'A December cap keeps your emergency-fund date in March.',
  confidence: Confidence.high,
  limits: 'Two UPI transfers still need a category.',
  nextAction: 'Review 2 uncategorised',
  calculation: '71,480 vs 62,700 → +14.0% · calc v2.4.0',
);

const answerHire = CfoAnswer(
  observation: 'Hiring two engineers from December shortens runway from 18+ months to about 14.',
  evidence: ['Cash ₹1.84 Cr · HDFC Current + gateway', 'Payroll register Oct · 24 employees', 'CTC assumption · ₹30 L each + 12% employer cost'],
  cause: 'Adds ₹5.6 L per month in cost plus ₹3 L one-time recruiting.',
  impact: 'Cash falls below your ₹50 L reserve in August (month 9) in the base case; July in the downside.',
  options: [
    'Hire both in December',
    'Stagger: one now, one in March — the reserve holds longer',
    'Hire one and collect the ₹14.8 L overdue first',
  ],
  recommendation: 'Stagger the second hire unless overdue invoices are collected by January.',
  confidence: Confidence.medium,
  limits: 'Revenue growth of 3%/month is your assumption, not a forecast; 4 invoices lack due dates.',
  nextAction: 'Open in Scenarios',
  calculation: '2 × 30,00,000 ÷ 12 × 1.12 = 5,60,000 / month · calc v2.4.0',
);

const answerCash = CfoAnswer(
  observation: 'Cash fell ₹18.6 L in October while revenue rose 12%.',
  evidence: ['Bank balances 30 Sep → 31 Oct', '214 transactions', 'Invoices register · 41 invoices'],
  cause: 'Receivables over 30 days grew from ₹9.2 L to ₹21.4 L, and two annual software renewals (₹4.1 L) landed in October.',
  impact: 'At current collection speed, the reserve floor is reached 2 months earlier.',
  options: ['Chase 3 overdue invoices', 'Offer 2% early-payment discount', 'Move renewals to quarterly billing'],
  recommendation: 'Prioritise INV-2041, INV-2047, INV-2052 (₹14.8 L). Drafts are waiting for approval.',
  confidence: Confidence.medium,
  limits: '4 invoices have no due date; collection timing for them is estimated.',
  nextAction: 'Review 3 reminder drafts',
  calculation: 'Δcash = inflows 2,31,40,000 − outflows 2,50,00,000 = −18,60,000',
);

const answerOverdue = CfoAnswer(
  observation: '7 invoices are overdue, worth ₹21.4 L. Three account for ₹14.8 L.',
  evidence: ['Invoices register · synced 20 Nov', 'Bank receipts matched to 34 invoices'],
  cause: 'Two customers moved to 60-day payment cycles in September.',
  impact: 'Every 30 days of delay on the top three costs ~0.9 months of runway.',
  options: ['Send first reminders', 'Call Kestrel Foods (largest, 32 days)', 'Add late-fee terms to new invoices'],
  recommendation: 'Send reminders now; schedule a call if unpaid by 5 Dec.',
  confidence: Confidence.high,
  limits: 'Customer payment promises from email aren’t imported.',
  nextAction: 'Open approvals',
  calculation: 'Σ overdue = 21,40,000 · top 3 = 14,80,000',
);

const answerUnknown = CfoAnswer(
  observation: 'I can’t answer that reliably with the data you’ve shared.',
  evidence: ['No matching records in this workspace'],
  cause: 'The question needs data that isn’t connected or imported yet.',
  impact: 'Guessing would risk a wrong number, so I won’t.',
  options: ['Import a statement or export', 'Rephrase around cash, spending, goals or forecasts', 'Ask a learning question instead'],
  recommendation: 'Add the source and I’ll answer with evidence.',
  confidence: Confidence.insufficient,
  limits: 'Answers only use authorised data in the current workspace.',
  nextAction: 'Add data',
  calculation: '—',
);

CfoAnswer answerFor(String q, Workspace ws) {
  final s = q.toLowerCase();
  bool has(List<String> k) => k.any(s.contains);
  if (ws == Workspace.personal) {
    if (has(['afford', 'laptop', 'buy'])) return answerAfford;
    if (has(['net worth', 'networth', 'worth'])) return answerNetWorth;
    if (has(['spend', 'spent', 'spending', 'october', 'budget'])) return answerSpending;
  } else {
    if (has(['hire', 'hiring', 'engineer'])) return answerHire;
    if (has(['cash', 'falling', 'runway', 'burn'])) return answerCash;
    if (has(['overdue', 'invoice', 'receivable', 'collect'])) return answerOverdue;
  }
  return answerUnknown;
}

List<String> suggestedPrompts(Workspace ws) => ws == Workspace.personal
    ? const ['Can I afford a ₹80,000 laptop?', 'What’s my net worth today?', 'Why is my spending up?']
    : const ['Can we hire two engineers next month?', 'Why is cash falling while revenue grows?', 'Which invoices are overdue?'];
