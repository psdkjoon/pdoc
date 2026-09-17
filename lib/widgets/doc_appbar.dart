import 'package:flutter/material.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/widgets/font_size_toggle.dart';
import 'package:pdoc/widgets/github_button.dart';
import 'package:pdoc/widgets/search_button.dart';
import 'package:pdoc/widgets/theme_toggle.dart';

class DocAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DocPageArgs args;
  final VoidCallback openSearch;
  final VoidCallback toggleSidebar;
  final bool sidebarOpen;

  const DocAppBar({
    super.key,
    required this.args,
    required this.openSearch,
    required this.toggleSidebar,
    required this.sidebarOpen,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: sidebarOpen
          ? IconButton(
              onPressed: toggleSidebar,
              icon: const Icon(Icons.arrow_back),
            )
          : IconButton(onPressed: toggleSidebar, icon: const Icon(Icons.menu)),
      title: Text('${args.projectTitle} Docs'),
      actions: [
        const GithubButton(),
        SearchButton(openSearch: openSearch),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: FontSizeToggle(),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8, top: 10, bottom: 10),
          child: ThemeToggle(),
        ),
      ],
    );
  }
}
