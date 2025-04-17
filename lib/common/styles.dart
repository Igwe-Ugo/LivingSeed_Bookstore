import 'package:flutter/material.dart';

abstract class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    MaterialColor myPrimarySwatch = MaterialColor(
        const Color.fromARGB(255, 34, 246, 220).value, const <int, Color>{
      50: Color.fromARGB(255, 161, 102, 47),
      100: Color.fromARGB(255, 161, 102, 47),
      200: Color.fromARGB(255, 161, 102, 47),
      300: Color.fromARGB(255, 161, 102, 47),
      400: Color.fromARGB(255, 161, 102, 47),
      500: Color.fromARGB(255, 161, 102, 47),
      600: Color.fromARGB(255, 161, 102, 47),
      700: Color.fromARGB(255, 161, 102, 47),
      800: Color.fromARGB(255, 161, 102, 47),
      900: Color.fromARGB(255, 161, 102, 47),
    });
    return ThemeData(
      fontFamily: 'Satoshi',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: myPrimarySwatch,
      primaryColor: const Color.fromARGB(255, 69, 242, 72),
      primaryColorDark: const Color.fromARGB(255, 45, 184, 61),
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xFF161618) : const Color(0xFFFFFFFF),
      indicatorColor:
          isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      hintColor:
          isDarkTheme ? const Color(0xff280C0B) : const Color(0xFFFFFFFF),
      highlightColor:
          isDarkTheme ? const Color(0xff372901) : const Color(0xFFC5C6CC),
      hoverColor: isDarkTheme
          ? const Color(0xff3A3A3B)
          : const Color.fromARGB(255, 198, 199, 200),
      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
      cardColor:
          isDarkTheme ? const Color(0xFF272829) : const Color(0xFFEEEEEE),
      dividerColor:
          isDarkTheme ? const Color(0xFF272829) : const Color(0xFFE0E0E0),
      canvasColor:
          isDarkTheme ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
