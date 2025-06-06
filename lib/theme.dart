import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff834c74),
      surfaceTint: Color(0xff834c74),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffd7ef),
      onPrimaryContainer: Color(0xff36072d),
      secondary: Color(0xff6f5767),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfffadaec),
      onSecondaryContainer: Color(0xff281622),
      tertiary: Color(0xff815340),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdbcd),
      onTertiaryContainer: Color(0xff321205),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffff8f9),
      onBackground: Color(0xff201a1e),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff201a1e),
      surfaceVariant: Color(0xffefdee6),
      onSurfaceVariant: Color(0xff4f444a),
      outline: Color(0xff81737a),
      outlineVariant: Color(0xffd2c2ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff362e33),
      inverseOnSurface: Color(0xfffbedf3),
      inversePrimary: Color(0xfff6b2e0),
      primaryFixed: Color(0xffffd7ef),
      onPrimaryFixed: Color(0xff36072d),
      primaryFixedDim: Color(0xfff6b2e0),
      onPrimaryFixedVariant: Color(0xff69355b),
      secondaryFixed: Color(0xfffadaec),
      onSecondaryFixed: Color(0xff281622),
      secondaryFixedDim: Color(0xffdcbed0),
      onSecondaryFixedVariant: Color(0xff56404f),
      tertiaryFixed: Color(0xffffdbcd),
      onTertiaryFixed: Color(0xff321205),
      tertiaryFixedDim: Color(0xfff5b9a1),
      onTertiaryFixedVariant: Color(0xff663c2b),
      surfaceDim: Color(0xffe4d7dc),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffef0f6),
      surfaceContainer: Color(0xfff8eaf0),
      surfaceContainerHigh: Color(0xfff2e5ea),
      surfaceContainerHighest: Color(0xffecdfe5),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff643157),
      surfaceTint: Color(0xff834c74),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9c628b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff523c4b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff876d7d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff613827),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9a6955),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f9),
      onBackground: Color(0xff201a1e),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff201a1e),
      surfaceVariant: Color(0xffefdee6),
      onSurfaceVariant: Color(0xff4b4046),
      outline: Color(0xff685c62),
      outlineVariant: Color(0xff84777e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff362e33),
      inverseOnSurface: Color(0xfffbedf3),
      inversePrimary: Color(0xfff6b2e0),
      primaryFixed: Color(0xff9c628b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff814971),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff876d7d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6d5564),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9a6955),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7e513e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe4d7dc),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffef0f6),
      surfaceContainer: Color(0xfff8eaf0),
      surfaceContainerHigh: Color(0xfff2e5ea),
      surfaceContainerHighest: Color(0xffecdfe5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff3e0f34),
      surfaceTint: Color(0xff834c74),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff643157),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2f1c29),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff523c4b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3a190a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff613827),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f9),
      onBackground: Color(0xff201a1e),
      surface: Color(0xfffff8f9),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffefdee6),
      onSurfaceVariant: Color(0xff2b2127),
      outline: Color(0xff4b4046),
      outlineVariant: Color(0xff4b4046),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff362e33),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffe5f3),
      primaryFixed: Color(0xff643157),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff4a1a40),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff523c4b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3a2734),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff613827),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff472313),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe4d7dc),
      surfaceBright: Color(0xfffff8f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffef0f6),
      surfaceContainer: Color(0xfff8eaf0),
      surfaceContainerHigh: Color(0xfff2e5ea),
      surfaceContainerHighest: Color(0xffecdfe5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff6b2e0),
      surfaceTint: Color(0xfff6b2e0),
      onPrimary: Color(0xff4f1e43),
      primaryContainer: Color(0xff69355b),
      onPrimaryContainer: Color(0xffffd7ef),
      secondary: Color(0xffdcbed0),
      onSecondary: Color(0xff3e2a38),
      secondaryContainer: Color(0xff56404f),
      onSecondaryContainer: Color(0xfffadaec),
      tertiary: Color(0xfff5b9a1),
      onTertiary: Color(0xff4b2717),
      tertiaryContainer: Color(0xff663c2b),
      onTertiaryContainer: Color(0xffffdbcd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff181215),
      onBackground: Color(0xffecdfe5),
      surface: Color(0xff181215),
      onSurface: Color(0xffecdfe5),
      surfaceVariant: Color(0xff4f444a),
      onSurfaceVariant: Color(0xffd2c2ca),
      outline: Color(0xff9b8d94),
      outlineVariant: Color(0xff4f444a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffecdfe5),
      inverseOnSurface: Color(0xff362e33),
      inversePrimary: Color(0xff834c74),
      primaryFixed: Color(0xffffd7ef),
      onPrimaryFixed: Color(0xff36072d),
      primaryFixedDim: Color(0xfff6b2e0),
      onPrimaryFixedVariant: Color(0xff69355b),
      secondaryFixed: Color(0xfffadaec),
      onSecondaryFixed: Color(0xff281622),
      secondaryFixedDim: Color(0xffdcbed0),
      onSecondaryFixedVariant: Color(0xff56404f),
      tertiaryFixed: Color(0xffffdbcd),
      onTertiaryFixed: Color(0xff321205),
      tertiaryFixedDim: Color(0xfff5b9a1),
      onTertiaryFixedVariant: Color(0xff663c2b),
      surfaceDim: Color(0xff181215),
      surfaceBright: Color(0xff3f373b),
      surfaceContainerLowest: Color(0xff120c10),
      surfaceContainerLow: Color(0xff201a1e),
      surfaceContainer: Color(0xff251e22),
      surfaceContainerHigh: Color(0xff2f282c),
      surfaceContainerHighest: Color(0xff3a3337),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffbb6e4),
      surfaceTint: Color(0xfff6b2e0),
      onPrimary: Color(0xff2f0328),
      primaryContainer: Color(0xffbb7da8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe1c2d4),
      onSecondary: Color(0xff22101d),
      secondaryContainer: Color(0xffa48999),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff9bda5),
      onTertiary: Color(0xff2b0d02),
      tertiaryContainer: Color(0xffb9846f),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff181215),
      onBackground: Color(0xffecdfe5),
      surface: Color(0xff181215),
      onSurface: Color(0xfffff9f9),
      surfaceVariant: Color(0xff4f444a),
      onSurfaceVariant: Color(0xffd7c6ce),
      outline: Color(0xffae9fa6),
      outlineVariant: Color(0xff8d7f87),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffecdfe5),
      inverseOnSurface: Color(0xff2f282c),
      inversePrimary: Color(0xff6a365c),
      primaryFixed: Color(0xffffd7ef),
      onPrimaryFixed: Color(0xff280021),
      primaryFixedDim: Color(0xfff6b2e0),
      onPrimaryFixedVariant: Color(0xff55244a),
      secondaryFixed: Color(0xfffadaec),
      onSecondaryFixed: Color(0xff1c0b18),
      secondaryFixedDim: Color(0xffdcbed0),
      onSecondaryFixedVariant: Color(0xff45303e),
      tertiaryFixed: Color(0xffffdbcd),
      onTertiaryFixed: Color(0xff240801),
      tertiaryFixedDim: Color(0xfff5b9a1),
      onTertiaryFixedVariant: Color(0xff522c1c),
      surfaceDim: Color(0xff181215),
      surfaceBright: Color(0xff3f373b),
      surfaceContainerLowest: Color(0xff120c10),
      surfaceContainerLow: Color(0xff201a1e),
      surfaceContainer: Color(0xff251e22),
      surfaceContainerHigh: Color(0xff2f282c),
      surfaceContainerHighest: Color(0xff3a3337),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f9),
      surfaceTint: Color(0xfff6b2e0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xfffbb6e4),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe1c2d4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f8),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff9bda5),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff181215),
      onBackground: Color(0xffecdfe5),
      surface: Color(0xff181215),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff4f444a),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffd7c6ce),
      outlineVariant: Color(0xffd7c6ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffecdfe5),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff47173d),
      primaryFixed: Color(0xffffdef1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xfffbb6e4),
      onPrimaryFixedVariant: Color(0xff2f0328),
      secondaryFixed: Color(0xfffedef0),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe1c2d4),
      onSecondaryFixedVariant: Color(0xff22101d),
      tertiaryFixed: Color(0xffffe0d5),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfff9bda5),
      onTertiaryFixedVariant: Color(0xff2b0d02),
      surfaceDim: Color(0xff181215),
      surfaceBright: Color(0xff3f373b),
      surfaceContainerLowest: Color(0xff120c10),
      surfaceContainerLow: Color(0xff201a1e),
      surfaceContainer: Color(0xff251e22),
      surfaceContainerHigh: Color(0xff2f282c),
      surfaceContainerHighest: Color(0xff3a3337),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xff530b47),
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFFecd7b4),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFFecd7b4),
            size: 30,
          ),
          centerTitle: false,
          titleSpacing: 5,
        ),
        canvasColor: colorScheme.surface,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
