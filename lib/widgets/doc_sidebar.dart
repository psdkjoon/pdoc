import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/version_selector.dart';

class DocSidebar extends StatefulWidget {
  final DocPageArgs args;
  final String currentSection;
  final String currentPage;
  final Set<String> expandedSections;
  final void Function(String section) onToggleSection;
  final void Function(String section, String page) onSelectPage;
  final void Function(String version) onChangeVersion;

  const DocSidebar({
    super.key,
    required this.args,
    required this.currentSection,
    required this.currentPage,
    required this.expandedSections,
    required this.onToggleSection,
    required this.onSelectPage,
    required this.onChangeVersion,
  });

  @override
  State<DocSidebar> createState() => _DocSidebarState();
}

class _DocSidebarState extends State<DocSidebar> {
  bool entered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.args.version != '0.0.0') ...[
                    VersionSelector(
                      currentVersion: widget.args.version,
                      versions: docVersions(widget.args.doc),
                      onChanged: widget.onChangeVersion,
                    ),
                    const SizedBox(height: 24),
                  ],
                  for (final section in widget.args.sections.entries)
                    _SidebarSection(
                      title: section.key,
                      pages: section.value.keys.toList(),
                      isOpen: widget.expandedSections.contains(section.key),
                      currentSection: widget.currentSection,
                      currentPage: widget.currentPage,
                      onToggle: () => widget.onToggleSection(section.key),
                      onSelectPage: widget.onSelectPage,
                    ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: MouseRegion(
              onEnter: (_) => setState(() => entered = true),
              onExit: (_) => setState(() => entered = false),
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, entered ? -2 : 0, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  border: Border.all(
                    color: entered ? scheme.primary : scheme.outline,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: entered
                      ? [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),

                child: Center(child: Text('Back To Main Menu')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final List<String> pages;
  final bool isOpen;
  final String currentSection;
  final String currentPage;
  final VoidCallback onToggle;
  final void Function(String section, String page) onSelectPage;

  const _SidebarSection({
    required this.title,
    required this.pages,
    required this.isOpen,
    required this.currentSection,
    required this.currentPage,
    required this.onToggle,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isOpen && title == currentSection
                            ? scheme.surfaceContainerHigh
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(DocColors.sm),
                        border: Border(
                          left: BorderSide(
                            color: isOpen && title == currentSection
                                ? scheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.expand_more_rounded,
                      size: 24,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            crossFadeState: isOpen
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final page in pages)
                  _SidebarNavItem(
                    selected: title == currentSection && page == currentPage,
                    page: page,
                    onTap: () => onSelectPage(title, page),
                  ),
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final String page;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.page,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? scheme.surfaceContainerHigh : Colors.transparent,
            borderRadius: BorderRadius.circular(DocColors.sm),
            border: Border(
              left: BorderSide(
                color: selected ? scheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            page,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
