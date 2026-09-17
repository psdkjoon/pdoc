import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

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
    _runSearch('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSearch(String query) {
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
        final lowerContent = content.toLowerCase();
        final contentIndex = lowerContent.indexOf(normalized);
        if (titleMatch || contentIndex != -1) {
          var snippet = '';
          if (contentIndex != -1) {
            final start = (contentIndex - 30).clamp(0, content.length);
            final end = (contentIndex + normalized.length + 30).clamp(
              0,
              content.length,
            );
            snippet = content
                .substring(start, end)
                .replaceAll('\n', ' ')
                .trim();
          }
          hits.add(
            _SearchHit(section: sectionEntry.key, page: page, snippet: snippet),
          );
        }
      }
    }
    setState(() => _hits = hits);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DocColors.lg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 480),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DocColors.sm),
                  border: Border.all(color: scheme.outline, width: 3),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: _runSearch,
                  decoration: InputDecoration(
                    hoverColor: Colors.transparent,
                    hintText: 'Search this project…',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: scheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DocColors.sm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: _hits.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No matching pages',
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(DocColors.sm),
                          border: Border.all(color: scheme.outline, width: 3),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(6),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: DocColors.fast,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? scheme.surfaceContainerHigh : Colors.transparent,
            borderRadius: BorderRadius.circular(DocColors.sm),
          ),
          child: Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 16,
                color: _hovered ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.hit.page,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.hit.snippet.isEmpty
                          ? widget.hit.section
                          : '${widget.hit.section} · ${widget.hit.snippet}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 12,
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
