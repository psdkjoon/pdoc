import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final VoidCallback openSearch;

  const SearchButton({super.key, required this.openSearch});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.search_rounded),
        onPressed: openSearch,
      ),
    );
  }
}
