import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/background.dart';
import 'package:pdoc/widgets/doc_appbar.dart';
import 'package:pdoc/widgets/doc_search_dialog.dart';
import 'package:pdoc/widgets/doc_sidebar.dart';
import 'package:pdoc/widgets/markdown_scroll_view.dart';
import 'package:pdoc/widgets/wide_sidebar.dart';

class DocPageArgs {
  final Doc doc;
  final String projectTitle;
  final String version;
  final Map<String, Map<String, String>> sections;
  final String currentSection;
  final String currentPage;

  const DocPageArgs({
    required this.doc,
    required this.projectTitle,
    required this.version,
    required this.sections,
    required this.currentSection,
    required this.currentPage,
  });
}

class DocPage extends StatefulWidget {
  final DocPageArgs args;

  const DocPage({super.key, required this.args});

  @override
  State<DocPage> createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> {
  final _scrollController = ScrollController();
  late String currentVersion;
  late Map<String, Map<String, String>> sections;
  late String currentSection;
  late String currentPage;
  late Set<String> expandedSections;
  late bool _sidebarOpen = true;

  @override
  void initState() {
    super.initState();
    currentVersion = widget.args.version;
    sections = widget.args.sections;
    currentSection = widget.args.currentSection;
    currentPage = widget.args.currentPage;
    expandedSections = {currentSection};
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DocPageArgs get _currentArgs => DocPageArgs(
    doc: widget.args.doc,
    projectTitle: widget.args.projectTitle,
    version: currentVersion,
    sections: sections,
    currentSection: currentSection,
    currentPage: currentPage,
  );

  List<(String, String)> get flatPages {
    final pages = <(String, String)>[];
    for (final entry in sections.entries) {
      for (final pageTitle in entry.value.keys) {
        pages.add((entry.key, pageTitle));
      }
    }
    return pages;
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: DocColors.med,
          curve: DocColors.curve,
        );
      }
    });
  }

  void _toggleSidebar() {
    setState(() => _sidebarOpen = !_sidebarOpen);
  }

  void goTo(String section, String page) {
    setState(() {
      currentSection = section;
      currentPage = page;
      expandedSections.add(section);
    });
    _scrollToTop();
  }

  void toggleSection(String section) {
    setState(() {
      if (expandedSections.contains(section)) {
        expandedSections.remove(section);
      } else {
        expandedSections.add(section);
      }
    });
  }

  void changeVersion(String version) {
    if (version == currentVersion) return;
    final newSections = docSections(widget.args.doc, version);
    final keepsPage =
        newSections[currentSection]?.containsKey(currentPage) ?? false;
    final nextSection = keepsPage ? currentSection : newSections.keys.first;
    final nextPage = keepsPage
        ? currentPage
        : newSections[nextSection]!.keys.first;
    setState(() {
      currentVersion = version;
      sections = newSections;
      currentSection = nextSection;
      currentPage = nextPage;
      expandedSections = {nextSection};
    });
    _scrollToTop();
  }

  void _openSearch() {
    showDocSearchDialog(context, sections: sections, onSelect: goTo);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isWide =
        MediaQuery.of(context).size.width >= DocColors.wideBreakpoint;
    final args = _currentArgs;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DocAppBar(
        args: args,
        openSearch: _openSearch,
        toggleSidebar: _toggleSidebar,
        sidebarOpen: _sidebarOpen,
      ),
      drawer: isWide
          ? null
          : Drawer(
              backgroundColor: scheme.surfaceContainer,
              child: SafeArea(
                child: DocSidebar(
                  args: args,
                  currentSection: currentSection,
                  currentPage: currentPage,
                  expandedSections: expandedSections,
                  onToggleSection: toggleSection,
                  onSelectPage: (section, page) {
                    goTo(section, page);
                    Navigator.of(context).maybePop();
                  },
                  onChangeVersion: changeVersion,
                ),
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWide && _sidebarOpen)
            WideSidebar(
              args: args,
              currentSection: currentSection,
              currentPage: currentPage,
              expandedSections: expandedSections,
              toggleSection: toggleSection,
              goTo: goTo,
              onChangeVersion: changeVersion,
            ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Background(
                    accent: scheme.primary,
                    backgroundColor: scheme.surface,
                    particleCount: isWide ? 120 : 50,
                  ),
                ),
                MarkdownScrollView(
                  controller: _scrollController,
                  isWide: isWide,
                  args: args,
                  currentSection: currentSection,
                  currentPage: currentPage,
                  goTo: goTo,
                  flatPages: flatPages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
