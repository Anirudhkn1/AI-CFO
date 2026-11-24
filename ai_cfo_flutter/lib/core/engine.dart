import 'dart:math';

/// Deterministic scenario engine (PRD §6.9, §10).
/// Projected closing cash = Opening cash + expected inflows − expected outflows.
/// No language model touches these numbers.
const calcVersion = 'calc v2.4.0';

class ScenarioResult {
  final List<double> baseline;
  final List<double> scenario;
  final List<double> low;
  final List<double> high;
  final double floor;
  final int horizon;
  const ScenarioResult(
      this.baseline, this.scenario, this.low, this.high, this.floor, this.horizon);

  /// Months until cash goes below zero, or null if it never does within the horizon.
  static int? runway(List<double> s) {
    for (var i = 0; i < s.length; i++) {
      if (s[i] < 0) return i;
    }
    return null;
  }

  int? get runwayBaseline => runway(baseline);
  int? get runwayScenario => runway(scenario);
  double get lowestScenario => scenario.reduce(min);
  int get monthsBelowFloor => scenario.where((v) => v < floor).length;
  int? get firstBreachMonth {
    for (var i = 0; i < scenario.length; i++) {
      if (scenario[i] < floor) return i;
    }
    return null;
  }
}

// ── Business: "Can we hire two engineers next month?" ─────────────────────────
class BusinessInputs {
  final int hires;
  final double annualCtc; // per engineer, ₹
  final int startMonth; // 1 = next month
  final double growthPct; // monthly revenue growth, %
  const BusinessInputs(
      {this.hires = 2, this.annualCtc = 3000000, this.startMonth = 1, this.growthPct = 3});
  BusinessInputs copyWith({int? hires, double? annualCtc, int? startMonth, double? growthPct}) =>
      BusinessInputs(
          hires: hires ?? this.hires,
          annualCtc: annualCtc ?? this.annualCtc,
          startMonth: startMonth ?? this.startMonth,
          growthPct: growthPct ?? this.growthPct);
}

class BusinessAssumptions {
  static const openingCash = 18400000.0; // ₹1.84 Cr
  static const revenue = 2600000.0; // ₹26 L / month
  static const costs = 3700000.0; // ₹37 L / month
  static const costGrowth = 0.01; // 1% / month
  static const employerCost = 0.12; // employer contributions & benefits (assumption)
  static const recruiting = 150000.0; // one-time, per hire
  static const floor = 5000000.0; // ₹50 L reserve policy
}

ScenarioResult runBusiness(BusinessInputs i, {int horizon = 18}) {
  List<double> sim(double growth, bool hire) {
    var cash = BusinessAssumptions.openingCash;
    final out = <double>[cash];
    for (var m = 1; m <= horizon; m++) {
      final rev = BusinessAssumptions.revenue * pow(1 + growth, m - 1);
      var cost = BusinessAssumptions.costs * pow(1 + BusinessAssumptions.costGrowth, m - 1);
      if (hire && m >= i.startMonth) {
        cost += i.hires * i.annualCtc / 12 * (1 + BusinessAssumptions.employerCost);
        if (m == i.startMonth) cost += i.hires * BusinessAssumptions.recruiting;
      }
      cash += rev - cost;
      out.add(cash);
    }
    return out;
  }

  final g = i.growthPct / 100;
  return ScenarioResult(
    sim(g, false),
    sim(g, true),
    sim(max(0, g - 0.015), true),
    sim(g + 0.015, true),
    BusinessAssumptions.floor,
    horizon,
  );
}

double monthlyHiringCost(BusinessInputs i) =>
    i.hires * i.annualCtc / 12 * (1 + BusinessAssumptions.employerCost);

// ── Personal: "Can I afford a big purchase?" ─────────────────────────────────
enum PayMode { now, emi6, emi12 }

class PersonalInputs {
  final double price;
  final int buyMonth; // 1 = December
  final PayMode mode;
  const PersonalInputs({this.price = 240000, this.buyMonth = 1, this.mode = PayMode.now});
  PersonalInputs copyWith({double? price, int? buyMonth, PayMode? mode}) => PersonalInputs(
      price: price ?? this.price, buyMonth: buyMonth ?? this.buyMonth, mode: mode ?? this.mode);
}

class PersonalAssumptions {
  static const openingCash = 142300.0;
  static const income = 135000.0;
  static const spend = 96000.0;
  static const floor = 30000.0; // user-defined cash floor
}

ScenarioResult runPersonal(PersonalInputs i, {int horizon = 12}) {
  List<double> sim(double spendFactor, bool buy) {
    var cash = PersonalAssumptions.openingCash;
    final out = <double>[cash];
    final n = switch (i.mode) { PayMode.now => 1, PayMode.emi6 => 6, PayMode.emi12 => 12 };
    for (var m = 1; m <= horizon; m++) {
      cash += PersonalAssumptions.income - PersonalAssumptions.spend * spendFactor;
      if (buy && m >= i.buyMonth && m < i.buyMonth + n) cash -= i.price / n;
      out.add(cash);
    }
    return out;
  }

  return ScenarioResult(
    sim(1, false),
    sim(1, true),
    sim(1.06, true),
    sim(0.94, true),
    PersonalAssumptions.floor,
    horizon,
  );
}
