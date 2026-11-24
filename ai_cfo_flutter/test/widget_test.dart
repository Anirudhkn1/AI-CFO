import 'package:obsid_finance/core/engine.dart';
import 'package:obsid_finance/core/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Indian grouping', () {
    expect(inr(4862300), '₹48,62,300');
    expect(inr(-80000), '−₹80,000');
    expect(inrCompact(18400000), '₹1.84 Cr');
    expect(inrCompact(1480000), '₹14.8 L');
  });

  test('Scenario engine is deterministic and hiring costs cash', () {
    final a = runBusiness(const BusinessInputs());
    final b = runBusiness(const BusinessInputs());
    expect(a.scenario, b.scenario);
    expect(a.scenario.last, lessThan(a.baseline.last));
    expect(monthlyHiringCost(const BusinessInputs()), closeTo(560000, 1));
  });

  test('Personal: buying ₹2.4 L upfront in Dec breaches the floor', () {
    final r = runPersonal(const PersonalInputs());
    expect(r.firstBreachMonth, 1);
  });
}
