import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/version_selector.dart';

class DocSidebar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (args.version != '0.0.0') ...[
            VersionSelector(
              currentVersion: args.version,
              versions: docVersions(args.doc),
              onChanged: onChangeVersion,
            ),
            const SizedBox(height: 24),
          ],
          for (final section in args.sections.entries)
            _SidebarSection(
              title: section.key,
              pages: section.value.keys.toList(),
              isOpen: expandedSections.contains(section.key),
              currentSection: currentSection,
              currentPage: currentPage,
              onToggle: () => onToggleSection(section.key),
              onSelectPage: onSelectPage,
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
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurfaceVariant,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.expand_more_rounded,
                      size: 16,
                      color: scheme.outlineVariant,
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
    return GestureDetector(
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
    );
  }
}
