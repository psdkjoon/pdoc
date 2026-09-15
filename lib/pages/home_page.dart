import 'package:flutter/material.dart';
import 'package:pdoc/logic/docs_controller.dart';
import 'package:pdoc/pages/doc_page.dart';
import 'package:pdoc/widgets/app_footer.dart';
import 'package:pdoc/widgets/background.dart';
import 'package:pdoc/widgets/cards.dart';
import 'package:pdoc/widgets/docs_appbar.dart';
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
      MaterialPageRoute<void>(
        builder: (context) => DocPage(
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
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width >= 900
        ? 100.0
        : (width >= 600 ? 48.0 : 16.0);
    final particleCount = width >= 900 ? 200 : (width >= 600 ? 150 : 90);

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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const TitleAndSearchBar(),
                        ValueListenableBuilder<Docs>(
                          valueListenable: docsNotifier,
                          builder: (context, docs, _) {
                            return DocsCards(
                              docs: docs,
                              onOpen: (doc) => _openDoc(context, doc),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
