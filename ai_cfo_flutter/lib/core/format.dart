/// India-first number formatting (lakh / crore grouping).
library;

String _group(int n) {
  final s = n.abs().toString();
  if (s.length <= 3) return s;
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${parts.join(',')},$last3';
}

String _trim(double x, int digits) {
  var s = x.toStringAsFixed(digits);
  if (s.contains('.')) {
    s = s.replaceAll(RegExp(r'0+$'), '');
    s = s.replaceAll(RegExp(r'\.$'), '');
  }
  return s;
}

String _prefix(num v, bool sign) {
  if (v < 0) return '−';
  if (sign && v > 0) return '+';
  return '';
}

/// ₹12,40,000
String inr(num v, {bool sign = false}) {
  final n = v.round();
  return '${_prefix(n, sign)}₹${_group(n)}';
}

/// ₹1.84 Cr · ₹12.4 L · ₹42,300
String inrCompact(num v, {bool sign = false, int digits = 2}) {
  final a = v.abs().toDouble();
  String body;
  if (a >= 1e7) {
    body = '${_trim(a / 1e7, digits)} Cr';
  } else if (a >= 1e5) {
    body = '${_trim(a / 1e5, digits)} L';
  } else {
    body = _group(a.round());
  }
  return '${_prefix(v, sign)}₹$body';
}

String pct(num v, {int digits = 1, bool sign = false}) =>
    '${_prefix(v, sign)}${_trim(v.abs().toDouble(), digits)}%';

const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// Month labels starting from December 2026 (the month after "today" in the sample data).
List<String> monthLabels(int count, {int startMonthIndex = 11}) =>
    List.generate(count, (i) => months[(startMonthIndex + i) % 12]);
