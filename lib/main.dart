import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/logic/font_size_controller.dart';
import 'package:pdoc/logic/theme_controller.dart';
import 'package:pdoc/pages/home_page.dart';
import 'package:pdoc/src/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadThemeMode();
  await loadFontSize();
  unawaited(loadDocsIntoCache());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const DocsApp());
}

class DocsApp extends StatelessWidget {
  const DocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'psdkjoon docs',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: const HomePage(),
        );
      },
    );
  }
}
