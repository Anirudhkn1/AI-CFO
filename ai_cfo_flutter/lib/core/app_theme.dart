import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

ThemeData buildTheme() {
  final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: C.bg,
    canvasColor: C.bg,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: C.surface,
    colorScheme: const ColorScheme.dark(
      surface: C.bg2,
      primary: C.platinum,
      onPrimary: C.bg,
      secondary: C.champagne,
      onSecondary: C.bg,
      onSurface: C.text,
      outline: C.line,
    ),
    textTheme: GoogleFonts.hankenGroteskTextTheme(base.textTheme)
        .apply(bodyColor: C.text, displayColor: C.text),
    dividerColor: C.line,
    dividerTheme: const DividerThemeData(color: C.lineSoft, thickness: 1, space: 1),
    iconTheme: const IconThemeData(color: C.muted, size: 18),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
          color: C.bg3, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(kRadius)),
      textStyle: T.body(12, color: C.text),
    ),
    sliderTheme: const SliderThemeData(
      trackHeight: 1.5,
      activeTrackColor: C.platinum,
      inactiveTrackColor: C.line,
      thumbColor: C.platinum,
      overlayColor: Color(0x22E5E4E2),
      valueIndicatorColor: C.bg3,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7, elevation: 0),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(C.line),
      thickness: WidgetStateProperty.all(4),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: C.bg3,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: C.line), borderRadius: BorderRadius.circular(kRadius)),
      textStyle: T.body(14),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: C.bg2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: C.line), borderRadius: BorderRadius.circular(kRadius)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: C.bg2,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: C.line,
    ),
    drawerTheme: const DrawerThemeData(
        backgroundColor: C.bg, surfaceTintColor: Colors.transparent, shape: RoundedRectangleBorder()),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: C.bg3,
      contentTextStyle: T.body(14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: C.line), borderRadius: BorderRadius.circular(kRadius)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: C.champagne, selectionColor: Color(0x55E8D8B0)),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    }),
  );
}
