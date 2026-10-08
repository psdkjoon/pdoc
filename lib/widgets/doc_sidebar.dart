import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';
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
    final versions = docVersions(widget.args.doc);
    return Padding(
      padding: const EdgeInsets.all(DocValues.s3),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DocValues.s2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (versions.length > 1) ...[
                    VersionSelector(
                      currentVersion: widget.args.version,
                      versions: versions,
                      onChanged: widget.onChangeVersion,
                    ),
                    const SizedBox(height: DocValues.s4),
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
          const SizedBox(height: DocValues.s2),
          Semantics(
            button: true,
            label: 'Back to main menu',
            child: MouseRegion(
              onEnter: (_) => setState(() => entered = true),
              onExit: (_) => setState(() => entered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: AnimatedContainer(
                  duration: DocValues.hover,
                  curve: DocValues.curveHover,
                  transform: Matrix4.translationValues(
                    DocValues.s0,
                    entered ? DocValues.hoverLift : DocValues.s0,
                    DocValues.s0,
                  ),
                  padding: const EdgeInsets.all(DocValues.s3),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    border: Border.all(
                      color: entered ? scheme.primary : scheme.outline,
                      width: DocValues.borderMed,
                    ),
                    borderRadius: BorderRadius.circular(DocValues.rCode),
                    boxShadow: entered
                        ? [
                            BoxShadow(
                              color: scheme.primary.withValues(
                                alpha: DocValues.alphaShadowStrong,
                              ),
                              blurRadius: DocValues.glowBlur,
                              spreadRadius: DocValues.glowSpread,
                            ),
                          ]
                        : const [],
                  ),
                  child: const Center(
                    child: FitText(
                      'Back To Main Menu',
                      minFontSize: DocValues.fsFloor,
                    ),
                  ),
                ),
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
    final active = isOpen && title == currentSection;
    return Padding(
      padding: const EdgeInsets.only(bottom: DocValues.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            expanded: isOpen,
            label: title,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(DocValues.s2),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: active
                              ? scheme.surfaceContainerHigh
                              : DocValues.transparent,
                          borderRadius: BorderRadius.circular(DocValues.rMd),
                          border: Border(
                            left: BorderSide(
                              color: active
                                  ? scheme.primary
                                  : DocValues.transparent,
                              width: DocValues.accentBar,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: DocValues.s3,
                          vertical: DocValues.s2,
                        ),
                        child: WrapText(
                          title,
                          style: TextStyle(
                            fontSize: DocValues.fsBodyLg,
                            fontWeight: DocValues.fwBold,
                            color: scheme.onSurfaceVariant,
                            letterSpacing: DocValues.lsLabel,
                          ),
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isOpen ? DocValues.halfTurn : DocValues.s0,
                      duration: DocValues.fast,
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: DocValues.iconGlyph,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: DocValues.fast,
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
      padding: const EdgeInsets.only(left: DocValues.sidebarIndent),
      child: Semantics(
        button: true,
        selected: selected,
        label: page,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: DocValues.fast,
            margin: const EdgeInsets.only(bottom: DocValues.sPx2),
            padding: const EdgeInsets.symmetric(
              vertical: DocValues.s2,
              horizontal: DocValues.s3,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.surfaceContainerHigh
                  : DocValues.transparent,
              borderRadius: BorderRadius.circular(DocValues.rMd),
              border: Border(
                left: BorderSide(
                  color: selected ? scheme.primary : DocValues.transparent,
                  width: DocValues.accentBar,
                ),
              ),
            ),
            child: WrapText(
              page,
              style: TextStyle(
                fontSize: DocValues.fsBody2,
                fontWeight: selected ? DocValues.fwBold : DocValues.fwMedium,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
