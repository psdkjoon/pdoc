import 'package:flutter/material.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/widgets/font_size_toggle.dart';
import 'package:pdoc/widgets/github_button.dart';
import 'package:pdoc/widgets/search_button.dart';
import 'package:pdoc/widgets/theme_toggle.dart';

class DocAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DocPageArgs args;
  final VoidCallback openSearch;

  const DocAppBar({super.key, required this.args, required this.openSearch});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return AppBar(
      leading: canPop
          ? const BackButton()
          : Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      title: Text('${args.projectTitle} Docs'),
      actions: [
        if (canPop)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
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
