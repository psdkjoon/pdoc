import 'package:flutter/material.dart';
import 'package:pdoc/logic/searchbar_controller.dart';

class TitleAndSearchBar extends StatefulWidget {
  const TitleAndSearchBar({super.key});

  @override
  State<TitleAndSearchBar> createState() => _TitleAndSearchBarState();
}

class _TitleAndSearchBarState extends State<TitleAndSearchBar> {
  final TextEditingController searchBarController = TextEditingController();

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final titleFontSize = width >= 600 ? 56.0 : 36.0;

    return Column(
      children: [
        Text(
          'Documentation',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            border: Border.all(color: scheme.outline, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Icon(Icons.search, size: 18, color: scheme.onSurface),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      onChanged: setSearchBarText,
                      controller: searchBarController,
                      maxLines: 1,
                      cursorHeight: 20,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search Docs...',
                        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
                        border: InputBorder.none,
                        isDense: true,
                        counterText: '',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
