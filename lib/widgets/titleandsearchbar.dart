import 'package:flutter/material.dart';
import 'package:pdoc/logic/searchbar_controller.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';

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
    final width = MediaQuery.sizeOf(context).width;
    final titleFontSize = width >= DocValues.mediumBreakpoint
        ? DocValues.fsHeroWide
        : DocValues.fsHeroCompact;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FitText(
          'Documentation',
          textAlign: TextAlign.center,
          minFontSize: DocValues.fsHeadMd,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: DocValues.fwBold,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: DocValues.s2),
        Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            border: Border.all(
              color: scheme.outline,
              width: DocValues.borderMed,
            ),
            borderRadius: BorderRadius.circular(DocValues.rSm),
          ),
          padding: const EdgeInsets.all(DocValues.s15),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: DocValues.iconSearch,
                color: scheme.onSurface,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: DocValues.s2),
                  child: TextField(
                    onChanged: setSearchBarText,
                    controller: searchBarController,
                    maxLines: DocValues.maxLinesOne,
                    cursorHeight: DocValues.cursorHeight,
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
      ],
    );
  }
}
