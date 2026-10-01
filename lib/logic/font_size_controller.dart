import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DocFontSize { small, medium, large }

extension DocFontSizeValues on DocFontSize {
  double get bodyFontSize {
    switch (this) {
      case DocFontSize.small:
        return DocValues.readerSmall;
      case DocFontSize.medium:
        return DocValues.readerMedium;
      case DocFontSize.large:
        return DocValues.readerLarge;
    }
  }

  double get labelFontSize {
    switch (this) {
      case DocFontSize.small:
        return DocValues.readerLabelSmall;
      case DocFontSize.medium:
        return DocValues.readerLabelMedium;
      case DocFontSize.large:
        return DocValues.readerLabelLarge;
    }
  }
}

final fontSizeNotifier = ValueNotifier<DocFontSize>(DocFontSize.medium);

const _fontSizeKey = 'font_size';

Future<void> loadFontSize() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_fontSizeKey);
    fontSizeNotifier.value = DocFontSize.values.firstWhere(
      (size) => size.name == stored,
      orElse: () => DocFontSize.medium,
    );
  } catch (_) {
    fontSizeNotifier.value = DocFontSize.medium;
  }
}

Future<void> setFontSize(DocFontSize size) async {
  fontSizeNotifier.value = size;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontSizeKey, size.name);
  } catch (_) {}
}
