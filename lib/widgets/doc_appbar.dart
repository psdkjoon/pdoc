import 'package:flutter/material.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';
import 'package:pdoc/widgets/font_size_toggle.dart';
import 'package:pdoc/widgets/github_button.dart';
import 'package:pdoc/widgets/search_button.dart';
import 'package:pdoc/widgets/theme_toggle.dart';

class DocAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DocPageArgs args;
  final VoidCallback openSearch;
  final VoidCallback toggleSidebar;
  final bool sidebarOpen;
  final bool isWide;

  const DocAppBar({
    super.key,
    required this.args,
    required this.openSearch,
    required this.toggleSidebar,
    required this.sidebarOpen,
    required this.isWide,
  });

  @override
  Size get preferredSize => const Size.fromHeight(DocValues.headerHeight);

  Widget _leading(BuildContext context) {
    if (!isWide) {
      return Builder(
        builder: (innerContext) => IconButton(
          onPressed: () => Scaffold.of(innerContext).openDrawer(),
          tooltip: MaterialLocalizations.of(innerContext).openAppDrawerTooltip,
          icon: const Icon(Icons.menu),
        ),
      );
    }
    return IconButton(
      onPressed: toggleSidebar,
      tooltip: sidebarOpen ? 'Hide sidebar' : 'Show sidebar',
      icon: Icon(sidebarOpen ? Icons.arrow_back : Icons.menu),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showFontToggle = width >= DocValues.mediumBreakpoint;
    final showGithub = width >= DocValues.mediumBreakpoint;

    return AppBar(
      leading: _leading(context),
      titleSpacing: DocValues.s0,
      title: FitText(
        '${args.projectTitle} Docs',
        minFontSize: DocValues.fsBody,
      ),
      actions: [
        if (showGithub) const GithubButton(),
        SearchButton(openSearch: openSearch),
        if (showFontToggle)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DocValues.s2,
              vertical: DocValues.s25,
            ),
            child: FontSizeToggle(),
          ),
        const Padding(
          padding: EdgeInsets.only(
            left: DocValues.s2,
            right: DocValues.s2,
            top: DocValues.s25,
            bottom: DocValues.s25,
          ),
          child: ThemeToggle(),
        ),
      ],
    );
  }
}
