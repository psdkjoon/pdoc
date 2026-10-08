import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/logic/font_size_controller.dart';
import 'package:pdoc/logic/link_resolver.dart';
import 'package:pdoc/markdown/markdown_view.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/app_footer.dart';
import 'package:pdoc/widgets/bread_crumbs.dart';
import 'package:pdoc/widgets/doc_prev_next_nav.dart';
import 'package:pdoc/widgets/fit_text.dart';
import 'package:pdoc/widgets/link_confirm_dialog.dart';
import 'package:pdoc/widgets/page_transition.dart';
import 'package:pdoc/widgets/reveal.dart';

class MarkdownScrollView extends StatelessWidget {
  final ScrollController controller;
  final bool isWide;
  final DocPageArgs args;
  final String currentSection;
  final String currentPage;
  final void Function(String, String) goTo;
  final List<(String, String)> flatPages;

  const MarkdownScrollView({
    super.key,
    required this.controller,
    required this.isWide,
    required this.args,
    required this.currentSection,
    required this.currentPage,
    required this.goTo,
    required this.flatPages,
  });

  void _openInNewDoc(BuildContext context, ResolvedDocLink resolved) {
    final sections = docSections(resolved.doc, resolved.version);
    Navigator.of(context).push(
      docRoute<void>(
        (context) => DocPage(
          args: DocPageArgs(
            doc: resolved.doc,
            projectTitle: resolved.doc['title'] as String,
            version: resolved.version,
            sections: sections,
            currentSection: resolved.section,
            currentPage: resolved.page,
          ),
        ),
      ),
    );
  }

  void _handleLinkTap(BuildContext context, String href) {
    if (isExternalLink(href)) {
      showExternalLinkDialog(context, href);
      return;
    }

    final resolved = resolveInternalLink(href, docsNotifier.value);
    if (resolved == null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text("Couldn't find that page"),
          duration: DocValues.toast,
        ),
      );
      return;
    }

    final sameDoc =
        resolved.doc['title'] == args.projectTitle &&
        resolved.version == args.version;
    if (sameDoc && args.sections.containsKey(resolved.section)) {
      goTo(resolved.section, resolved.page);
    } else {
      _openInNewDoc(context, resolved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context)
                .copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.symmetric(
                horizontal: isWide
                    ? DocValues.docPadWide
                    : DocValues.docPadCompact,
                vertical: DocValues.s5,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: DocValues.maxDocWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DocBreadcrumb(args: args, section: currentSection),
                      const SizedBox(height: DocValues.s28),
                      ValueListenableBuilder<DocFontSize>(
                        valueListenable: fontSizeNotifier,
                        builder: (context, fontSize, _) {
                          final scale =
                              fontSize.bodyFontSize / DocValues.readerBase;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Reveal(
                                key: ValueKey<String>(
                                  'title-$currentSection-$currentPage',
                                ),
                                dy: 10,
                                child: SizedBox(
                                width: double.infinity,
                                child: WrapText(
                                  currentPage,
                                  style: TextStyle(
                                    fontSize: DocValues.fsPageTitle * scale,
                                    fontWeight: DocValues.fwBold,
                                    height: DocValues.lhTight,
                                    color: scheme.onSurface,
                                  ),
                                ),
                              ),
                              ),
                              const SizedBox(height: DocValues.s4),
                              MarkdownView(
                                source:
                                    args.sections[currentSection]?[currentPage] ??
                                    '_Page not found in this version._',
                                bodyFontSize: fontSize.bodyFontSize,
                                onLinkTap: (href) =>
                                    _handleLinkTap(context, href),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: DocValues.s4),
                      DocPrevNextNav(
                        pages: flatPages,
                        current: (currentSection, currentPage),
                        onSelect: goTo,
                      ),
                      const SizedBox(height: DocValues.s4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const AppFooter(),
      ],
    );
  }
}
