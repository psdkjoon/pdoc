import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DocFontSize { small, medium, large }

extension DocFontSizeValues on DocFontSize {
  double get bodyFontSize {
    switch (this) {
      case DocFontSize.small:
        return 15;
      case DocFontSize.medium:
        return 25;
      case DocFontSize.large:
        return 35;
    }
  }

  double get labelFontSize {
    switch (this) {
      case DocFontSize.small:
        return 12;
      case DocFontSize.medium:
        return 15;
      case DocFontSize.large:
        return 18;
    }
  }
}

final fontSizeNotifier = ValueNotifier<DocFontSize>(DocFontSize.medium);

const _fontSizeKey = 'font_size';

Future<void> loadFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(_fontSizeKey) ?? 'medium';
  fontSizeNotifier.value = DocFontSize.values.firstWhere(
    (size) => size.name == stored,
  );
}

Future<void> setFontSize(DocFontSize size) async {
  fontSizeNotifier.value = size;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_fontSizeKey, size.name);
}
