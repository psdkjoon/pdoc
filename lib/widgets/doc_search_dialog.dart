import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';

class _SearchHit {
  final String section;
  final String page;
  final String snippet;

  const _SearchHit({
    required this.section,
    required this.page,
    required this.snippet,
  });
}

Future<void> showDocSearchDialog(
  BuildContext context, {
  required Map<String, Map<String, String>> sections,
  required void Function(String section, String page) onSelect,
}) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) =>
        _DocSearchDialog(sections: sections, onSelect: onSelect),
  );
}

class _DocSearchDialog extends StatefulWidget {
  final Map<String, Map<String, String>> sections;
  final void Function(String section, String page) onSelect;

  const _DocSearchDialog({required this.sections, required this.onSelect});

  @override
  State<_DocSearchDialog> createState() => _DocSearchDialogState();
}

class _DocSearchDialogState extends State<_DocSearchDialog> {
  final _controller = TextEditingController();
  List<_SearchHit> _hits = const [];

  @override
  void initState() {
    super.initState();
    _hits = _search('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_SearchHit> _search(String query) {
    final normalized = query.trim().toLowerCase();
    final hits = <_SearchHit>[];
    for (final sectionEntry in widget.sections.entries) {
      for (final pageEntry in sectionEntry.value.entries) {
        final page = pageEntry.key;
        final content = pageEntry.value;
        if (normalized.isEmpty) {
          hits.add(
            _SearchHit(section: sectionEntry.key, page: page, snippet: ''),
          );
          continue;
        }
        final titleMatch = page.toLowerCase().contains(normalized);
        final contentIndex = content.toLowerCase().indexOf(normalized);
        if (!titleMatch && contentIndex == -1) continue;

        var snippet = '';
        if (contentIndex != -1) {
          final start = max(
            contentIndex - DocValues.snippetContext,
            DocValues.firstIndex,
          );
          final end = min(
            contentIndex + normalized.length + DocValues.snippetContext,
            content.length,
          );
          snippet = content.substring(start, end).replaceAll('\n', ' ').trim();
        }
        hits.add(
          _SearchHit(section: sectionEntry.key, page: page, snippet: snippet),
        );
      }
    }
    return hits;
  }

  void _onChanged(String query) => setState(() => _hits = _search(query));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final frame = BoxDecoration(
      borderRadius: BorderRadius.circular(DocValues.sm),
      border: Border.all(color: scheme.outline, width: DocValues.borderThick),
    );

    return Dialog(
      backgroundColor: scheme.surfaceContainer,
      insetPadding: const EdgeInsets.all(DocValues.s3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DocValues.lg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: DocValues.maxDialogWidth,
          maxHeight: DocValues.maxDialogHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(DocValues.s3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: frame,
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    hoverColor: DocValues.transparent,
                    hintText: 'Search this project…',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: scheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DocValues.sm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DocValues.s28),
              Flexible(
                child: _hits.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: DocValues.s4,
                        ),
                        child: Text(
                          'No matching pages',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      )
                    : DecoratedBox(
                        decoration: frame,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(DocValues.s15),
                          shrinkWrap: true,
                          itemCount: _hits.length,
                          itemBuilder: (context, index) {
                            final hit = _hits[index];
                            return _SearchResultTile(
                              hit: hit,
                              onTap: () {
                                Navigator.of(context).pop();
                                widget.onSelect(hit.section, hit.page);
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatefulWidget {
  final _SearchHit hit;
  final VoidCallback onTap;

  const _SearchResultTile({required this.hit, required this.onTap});

  @override
  State<_SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<_SearchResultTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final detail = widget.hit.snippet.isEmpty
        ? widget.hit.section
        : '${widget.hit.section} · ${widget.hit.snippet}';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: DocValues.fast,
          margin: const EdgeInsets.symmetric(
            horizontal: DocValues.s1,
            vertical: DocValues.sPx3,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DocValues.s28,
            vertical: DocValues.s25,
          ),
          decoration: BoxDecoration(
            color: _hovered
                ? scheme.surfaceContainerHigh
                : DocValues.transparent,
            borderRadius: BorderRadius.circular(DocValues.sm),
          ),
          child: Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: DocValues.iconMedium,
                color: _hovered ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: DocValues.s25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WrapText(
                      widget.hit.page,
                      maxLines: DocValues.maxLinesTwo,
                      style: TextStyle(
                        fontWeight: DocValues.fwSemi,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: DocValues.sPx2),
                    WrapText(
                      detail,
                      maxLines: DocValues.maxLinesTwo,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: DocValues.fsCaption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
