import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Platinum Obsidian — obsidian, platinum and champagne.
/// A monochrome metal-card palette with almost no colour at all.
class C {
  C._();
  static const bg = Color(0xFF0B0B0C); // Obsidian
  static const bg2 = Color(0xFF141416);
  static const bg3 = Color(0xFF1C1C1E);
  static const bg4 = Color(0xFF242427);
  static const text = Color(0xFFF2F2F0);
  static const muted = Color(0xFF9A9A98);
  static const faint = Color(0xFF66666A);
  static const platinum = Color(0xFFE5E4E2);
  static const champagne = Color(0xFFE8D8B0);
  static const gunmetal = Color(0xFF8E8E93);
  static const line = Color(0x29E5E4E2); // 16%
  static const lineSoft = Color(0x17E5E4E2); // 9%
  static const surface = Color(0x0AE5E4E2); // 4%
  static const surface2 = Color(0x17E5E4E2); // 9%

  // Signals stay desaturated so the palette stays calm.
  static const positive = Color(0xFFA9C5A6);
  static const negative = Color(0xFFD9A093);
  static const caution = Color(0xFFE0C38A);
}

class T {
  T._();
  static TextStyle display(double size,
          {Color color = C.text, double height = 1.04, double letterSpacing = -0.4}) =>
      GoogleFonts.italiana(
          fontSize: size, color: color, height: height, letterSpacing: letterSpacing);

  static TextStyle body(double size,
          {Color color = C.text,
          FontWeight weight = FontWeight.w400,
          double height = 1.55,
          double letterSpacing = 0}) =>
      GoogleFonts.hankenGrotesk(
          fontSize: size,
          color: color,
          fontWeight: weight,
          height: height,
          letterSpacing: letterSpacing);

  static TextStyle mono(double size,
          {Color color = C.muted,
          FontWeight weight = FontWeight.w400,
          double letterSpacing = 0.3,
          double height = 1.4}) =>
      GoogleFonts.jetBrainsMono(
          fontSize: size,
          color: color,
          fontWeight: weight,
          letterSpacing: letterSpacing,
          height: height);

  /// Small uppercase tracking label (the "eyebrow").
  static TextStyle label({Color color = C.muted, double size = 11}) =>
      GoogleFonts.hankenGrotesk(
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.4,
          height: 1.2);

  /// Large numeric figures — Italiana reads as engraved metal.
  static TextStyle figure(double size, {Color color = C.text}) =>
      GoogleFonts.italiana(fontSize: size, color: color, height: 1.0, letterSpacing: 0);
}

class Bp {
  Bp._();
  static double w(BuildContext c) => MediaQuery.sizeOf(c).width;
  static bool mobile(BuildContext c) => w(c) < 760;
  static bool tablet(BuildContext c) => w(c) < 1100;
  static double gutter(BuildContext c) => mobile(c) ? 20 : (tablet(c) ? 36 : 56);
}

const kRadius = 2.0;
const kMaxWidth = 1240.0;

/// Display text whose hyphens are drawn in the body face — Italiana's own hyphen is invisible,
/// which would turn "Obsid-finance" into "Obsid finance".
Widget displayText(String s, TextStyle style,
    {TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) {
  final hyphen = GoogleFonts.hankenGrotesk(
    fontSize: style.fontSize,
    color: style.color,
    height: style.height,
    fontWeight: FontWeight.w200,
  );
  final parts = s.split('-');
  return Text.rich(
    TextSpan(children: [
      for (var i = 0; i < parts.length; i++) ...[
        if (i > 0) TextSpan(text: '-', style: hyphen),
        TextSpan(text: parts[i], style: style),
      ],
    ]),
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
  );
}
