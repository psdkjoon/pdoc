import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

class SearchButton extends StatelessWidget {
  final VoidCallback openSearch;

  const SearchButton({super.key, required this.openSearch});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: DocValues.iconButton,
      height: DocValues.iconButton,
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline, width: DocValues.borderThick),
        borderRadius: BorderRadius.circular(DocValues.sm),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: 'Search this project',
        icon: const Icon(Icons.search_rounded),
        onPressed: openSearch,
      ),
    );
  }
}
