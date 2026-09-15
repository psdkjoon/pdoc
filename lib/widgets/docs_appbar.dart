import 'package:flutter/material.dart';
import 'package:pdoc/widgets/theme_toggle.dart';

class DocsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DocsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/icon-4096.png',
          fit: BoxFit.contain,
          height: 32,
          width: 32,
          filterQuality: FilterQuality.high,
        ),
      ),
      title: const Text('psdkjoon Docs', style: TextStyle(fontSize: 24)),
      centerTitle: true,
      actionsPadding: const EdgeInsets.all(4.0),
      actions: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: ThemeToggle(),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: scheme.outlineVariant, height: 2.0),
      ),
    );
  }
}
