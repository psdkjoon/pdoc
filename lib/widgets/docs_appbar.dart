import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';
import 'package:pdoc/widgets/theme_toggle.dart';

class DocsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DocsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(DocValues.headerHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(DocValues.s2),
        child: Image.asset(
          DocValues.iconAsset,
          fit: BoxFit.contain,
          height: DocValues.appIcon,
          width: DocValues.appIcon,
          cacheWidth: DocValues.appIconCache,
          cacheHeight: DocValues.appIconCache,
          filterQuality: FilterQuality.medium,
          semanticLabel: DocValues.brandName,
          errorBuilder: (context, error, stack) => const SizedBox.shrink(),
        ),
      ),
      title: const FitText(
        DocValues.brandName,
        style: TextStyle(fontSize: DocValues.fsBrand),
        minFontSize: DocValues.fsBodyLg,
      ),
      centerTitle: true,
      actionsPadding: const EdgeInsets.all(DocValues.s1),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: DocValues.s15),
          child: ThemeToggle(),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(DocValues.rulerHeight),
        child: Container(
          color: scheme.outlineVariant,
          height: DocValues.borderMed,
        ),
      ),
    );
  }
}
