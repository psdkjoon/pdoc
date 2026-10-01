import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

const _themeModeKey = 'theme_mode';

Future<void> loadThemeMode() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModeKey);
    themeModeNotifier.value = ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.dark,
    );
  } catch (_) {
    themeModeNotifier.value = ThemeMode.dark;
  }
}

Future<void> setThemeMode(ThemeMode mode) async {
  themeModeNotifier.value = mode;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  } catch (_) {}
}
