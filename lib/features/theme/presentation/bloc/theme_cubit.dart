import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application theme mode (light, dark, system).
///
/// Persists the selected theme to SharedPreferences so it survives app restarts.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'THEME_MODE';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_loadTheme(_prefs));

  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final value = prefs.getString(_themeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Set the theme mode and persist it.
  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    await _prefs.setString(_themeKey, _themeToString(mode));
  }

  /// Toggle between light and dark (convenience method).
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newMode);
  }

  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
