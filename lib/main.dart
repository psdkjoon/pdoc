import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/logic/font_size_controller.dart';
import 'package:pdoc/logic/theme_controller.dart';
import 'package:pdoc/pages/home_page.dart';
import 'package:pdoc/src/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DocsApp());
  unawaited(
    Future.wait<void>([loadThemeMode(), loadFontSize(), loadDocsIntoCache()]),
  );
  if (!kIsWeb) {
    unawaited(
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    );
  }
}

class DocsApp extends StatelessWidget {
  const DocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: DocValues.appTitle,
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
