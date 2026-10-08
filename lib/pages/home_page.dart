import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/app_footer.dart';
import 'package:pdoc/widgets/background.dart';
import 'package:pdoc/widgets/cards.dart';
import 'package:pdoc/widgets/docs_appbar.dart';
import 'package:pdoc/widgets/page_transition.dart';
import 'package:pdoc/widgets/reveal.dart';
import 'package:pdoc/widgets/titleandsearchbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openDoc(BuildContext context, Doc doc) {
    final versions = docVersions(doc);
    final version = versions.last;
    final sections = docSections(doc, version);
    final firstSection = sections.keys.first;
    final firstPage = sections[firstSection]!.keys.first;

    Navigator.of(context).push(
      docRoute<void>(
        (context) => DocPage(
          args: DocPageArgs(
            doc: doc,
            projectTitle: doc['title'] as String,
            version: version,
            sections: sections,
            currentSection: firstSection,
            currentPage: firstPage,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= DocValues.wideBreakpoint;
    final isMedium = width >= DocValues.mediumBreakpoint;

    final horizontalPadding = isWide
        ? DocValues.pagePadWide
        : (isMedium ? DocValues.pagePadMedium : DocValues.pagePadCompact);
    final particleCount = isWide
        ? DocValues.particlesHomeWide
        : (isMedium
              ? DocValues.particlesHomeMedium
              : DocValues.particlesHomeCompact);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const DocsAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Background(
              accent: scheme.primary,
              backgroundColor: scheme.surface,
              particleCount: particleCount,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: DocValues.s4),
                        const Reveal(dy: -10, child: TitleAndSearchBar()),
                        const SizedBox(height: DocValues.s2),
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: docsLoadingNotifier,
                            builder: (context, loading, _) {
                              if (loading) return const _LoadingDocs();
                              return ValueListenableBuilder<Docs>(
                                valueListenable: docsNotifier,
                                builder: (context, docs, _) => DocsCards(
                                  docs: docs,
                                  onOpen: (doc) => _openDoc(context, doc),
                                  isWide: isWide,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDocs extends StatelessWidget {
  const _LoadingDocs();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Semantics(
        label: 'Loading documentation',
        child: CircularProgressIndicator(
          strokeWidth: DocValues.borderThick,
          color: scheme.primary,
        ),
      ),
    );
  }
}
