import 'package:flutter/material.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/doc_sidebar.dart';

class WideSidebar extends StatelessWidget {
  final DocPageArgs args;
  final String currentSection;
  final String currentPage;
  final Set<String> expandedSections;
  final void Function(String) toggleSection;
  final void Function(String, String) goTo;
  final void Function(String version) onChangeVersion;

  const WideSidebar({
    super.key,
    required this.args,
    required this.currentSection,
    required this.currentPage,
    required this.expandedSections,
    required this.toggleSection,
    required this.goTo,
    required this.onChangeVersion,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: DocColors.sidebarWidth,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: DocSidebar(
        args: args,
        currentSection: currentSection,
        currentPage: currentPage,
        expandedSections: expandedSections,
        onToggleSection: toggleSection,
        onSelectPage: goTo,
        onChangeVersion: onChangeVersion,
      ),
    );
  }
}
