import 'package:flutter/material.dart';
import 'package:izmir_go/domain/models/transit.dart';

/// İzmir Go design tokens. Colours are checked for WCAG AA contrast with their text colour
/// (see test/ui/tokens_test.dart).
abstract final class IzColors {
  /// "Körfez" (the Gulf of İzmir) deep blue: primary brand colour.
  static const korfez = Color(0xFF0B4F8A);
  static const korfezDark = Color(0xFF8CC4F5);

  /// Teal accent, used sparingly for selection and focus.
  static const ege = Color(0xFF00796B);

  /// Status colours. Always paired with an icon and text, never colour alone.
  static const live = Color(0xFF1B5E20);
  static const scheduled = Color(0xFF37474F);
  static const cached = Color(0xFF8D6E00);
  static const warning = Color(0xFF9A4D00);

  /// Fallback mode colours when an operator publishes none (ESHOT does not).
  static const modeColors = <TransitMode, Color>{
    TransitMode.bus: Color(0xFF00796B),
    TransitMode.metro: Color(0xFF0038EF),
    TransitMode.tram: Color(0xFFAD1457),
    TransitMode.rail: Color(0xFFB34700),
    TransitMode.ferry: Color(0xFF01579B),
    TransitMode.walk: Color(0xFF546E7A),
    TransitMode.other: Color(0xFF455A64),
  };
}

abstract final class IzSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Side gutter for screens.
  static const gutter = 16.0;

  /// Minimum touch target (Material and Apple HIG both ask for ~44-48 dp).
  static const minTouch = 48.0;
}

abstract final class IzRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 20.0;
}

abstract final class IzMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);

  /// Honour the OS "reduce motion" setting.
  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;
}

/// Parses an API colour ("0038EF") with a mode fallback.
Color routeColor(String? hex, TransitMode mode) {
  final value = int.tryParse(hex ?? '', radix: 16);
  if (hex != null && hex.length == 6 && value != null) {
    return Color(0xFF000000 | value);
  }
  return IzColors.modeColors[mode] ?? IzColors.modeColors[TransitMode.other]!;
}

/// Text colour with sufficient contrast on [background] (WCAG relative luminance).
Color onColor(Color background, {String? hex}) {
  final value = int.tryParse(hex ?? '', radix: 16);
  if (hex != null && hex.length == 6 && value != null) {
    return Color(0xFF000000 | value);
  }
  return contrastRatio(background, Colors.white) >= 4.5 ? Colors.white : Colors.black;
}

double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}
