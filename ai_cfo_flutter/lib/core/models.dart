import 'package:flutter/foundation.dart';

enum Workspace { personal, business }

extension WorkspaceX on Workspace {
  String get title => this == Workspace.personal ? 'Personal CFO' : 'Business CFO';
  String get short => this == Workspace.personal ? 'Personal' : 'Business';
  String get owner => this == Workspace.personal ? 'Aarav Mehta' : 'Lumen Labs Pvt Ltd';
}

/// The single source of truth for which workspace is open.
/// Personal and business data are never mixed: every screen reads from this.
final workspace = ValueNotifier<Workspace>(Workspace.personal);

/// PRD §14 labels — every figure says what kind of number it is.
enum Tag { actual, forecast, estimate, manual, needsReview, confirmed, edited, insufficient }

extension TagX on Tag {
  String get label => switch (this) {
        Tag.actual => 'Actual',
        Tag.forecast => 'Forecast',
        Tag.estimate => 'Estimate',
        Tag.manual => 'Manually entered',
        Tag.needsReview => 'Needs review',
        Tag.confirmed => 'Confirmed',
        Tag.edited => 'Edited by you',
        Tag.insufficient => 'Insufficient data',
      };
}

/// PRD Appendix B — confidence is qualitative unless a number can be justified.
enum Confidence { high, medium, low, insufficient }

extension ConfidenceX on Confidence {
  String get label => switch (this) {
        Confidence.high => 'High',
        Confidence.medium => 'Medium',
        Confidence.low => 'Low',
        Confidence.insufficient => 'Insufficient data',
      };
  int get bars => switch (this) {
        Confidence.high => 4,
        Confidence.medium => 3,
        Confidence.low => 2,
        Confidence.insufficient => 0,
      };
}

class Kpi {
  final String label;
  final num value;
  final String? delta;
  final bool? deltaUp;
  final Tag tag;
  final String period;
  final bool isPercent;
  final bool isMonths;
  const Kpi(this.label, this.value,
      {this.delta,
      this.deltaUp,
      this.tag = Tag.actual,
      this.period = 'Nov 2026',
      this.isPercent = false,
      this.isMonths = false});
}

class Insight {
  final String title;
  final String period;
  final String impact;
  final bool impactPositive;
  final Confidence confidence;
  final String evidence;
  final String body;
  const Insight(
      {required this.title,
      required this.period,
      required this.impact,
      required this.impactPositive,
      required this.confidence,
      required this.evidence,
      required this.body});
}

class Txn {
  final String date;
  final String description;
  final String counterparty;
  String category;
  final num amount;
  final String source;
  final String raw;
  Tag tag;
  Txn(this.date, this.description, this.counterparty, this.category, this.amount, this.source,
      this.raw, this.tag);
}

class DataSource {
  final String name;
  final String kind;
  final String masked;
  final String status; // synced | imported | manual | missing | error
  final String freshness;
  const DataSource(this.name, this.kind, this.masked, this.status, this.freshness);
}

enum ApprovalStatus { pending, approved, rejected }

class ApprovalItem {
  final String id;
  final String title;
  final String kind;
  final String requestedBy;
  final String created;
  final Map<String, String> params;
  final String whatHappens;
  final bool reversible;
  final String affected;
  ApprovalStatus status;
  String? decidedAt;
  ApprovalItem({
    required this.id,
    required this.title,
    required this.kind,
    required this.requestedBy,
    required this.created,
    required this.params,
    required this.whatHappens,
    required this.reversible,
    required this.affected,
    this.status = ApprovalStatus.pending,
    this.decidedAt,
  });
}

class ActivityEvent {
  final String time;
  final String title;
  final String detail;
  final String kind; // import | edit | recommendation | approval
  const ActivityEvent(this.time, this.title, this.detail, this.kind);
}

/// Structured AI answer — PRD §6.10:
/// Observation → Evidence → Cause → Impact → Options → Recommendation → Confidence & limits → Next action.
class CfoAnswer {
  final String observation;
  final List<String> evidence;
  final String cause;
  final String impact;
  final List<String> options;
  final String recommendation;
  final Confidence confidence;
  final String limits;
  final String nextAction;
  final String calculation;
  const CfoAnswer({
    required this.observation,
    required this.evidence,
    required this.cause,
    required this.impact,
    required this.options,
    required this.recommendation,
    required this.confidence,
    required this.limits,
    required this.nextAction,
    required this.calculation,
  });
}
