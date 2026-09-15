import 'package:pdoc/logic/docs_controller.dart';

class ResolvedDocLink {
  final Doc doc;
  final String version;
  final String section;
  final String page;

  ResolvedDocLink({
    required this.doc,
    required this.version,
    required this.section,
    required this.page,
  });
}

class _PageRef {
  final String section;
  final String page;
  const _PageRef(this.section, this.page);
}

bool isExternalLink(String href) =>
    href.startsWith('http://') || href.startsWith('https://');

String slugify(String input) {
  var value = input.toLowerCase().replaceAll('&', ' and ');
  value = value.replaceAll(RegExp(r'[^\w\s-]'), '');
  value = value.trim();
  value = value.replaceAll(RegExp(r'[\s_]+'), '-');
  return value;
}

Set<String> _pageSlugs(String title) {
  final slugs = {slugify(title)};
  if (title.contains('(')) {
    slugs.add(slugify(title.split('(').first.trim()));
  }
  return slugs;
}

Set<String> _sectionSlugs(String title) {
  final full = slugify(title);
  final first = full.split('-').first;
  return {full, first, '${first}s'};
}

String _singularize(String word) => word.length > 3 && word.endsWith('s')
    ? word.substring(0, word.length - 1)
    : word;

double _wordOverlap(String a, String b) {
  final wordsA = a.split('-').map(_singularize).toSet();
  final wordsB = b.split('-').map(_singularize).toSet();
  if (wordsA.isEmpty || wordsB.isEmpty) return 0;
  final intersection = wordsA.intersection(wordsB).length;
  final union = wordsA.union(wordsB).length;
  return union == 0 ? 0 : intersection / union;
}

ResolvedDocLink? resolveInternalLink(String href, List<Doc> allDocs) {
  var path = href;
  final hashIndex = path.indexOf('#');
  if (hashIndex != -1) path = path.substring(0, hashIndex);
  final segments = path
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .toList();
  if (segments.isEmpty) return null;

  Doc? doc;
  for (final candidate in allDocs) {
    if (slugify(candidate['title'] as String) == segments.first) {
      doc = candidate;
      break;
    }
  }
  if (doc == null) return null;

  final versions = docVersions(doc);
  if (versions.isEmpty) return null;

  var remaining = segments.sublist(1);
  var version = versions.last;
  if (remaining.isNotEmpty && versions.contains(remaining.first)) {
    version = remaining.first;
    remaining = remaining.sublist(1);
  }

  final sections = docSections(doc, version);
  if (sections.isEmpty) return null;

  if (remaining.isEmpty) {
    final firstSection = sections.keys.first;
    final firstPage = sections[firstSection]!.keys.first;
    return ResolvedDocLink(
      doc: doc,
      version: version,
      section: firstSection,
      page: firstPage,
    );
  }

  final last = remaining.last;
  final stripped = last.replaceFirst(RegExp(r'^\d+-'), '');
  final targetCandidates = {last, stripped};
  final middle = remaining.sublist(0, remaining.length - 1).toSet();

  final matches = <_PageRef>[];
  final allPages = <(_PageRef, Set<String>)>[];
  for (final sectionEntry in sections.entries) {
    final pageNames = sectionEntry.value.keys.toList();
    for (var i = 0; i < pageNames.length; i++) {
      final pageName = pageNames[i];
      var candidates = _pageSlugs(pageName);
      final isSelf =
          pageName.trim().toLowerCase() == 'overview' ||
          pageName.trim().toLowerCase() ==
              sectionEntry.key.trim().toLowerCase() ||
          i == 0;
      if (isSelf) {
        candidates = {...candidates, ..._sectionSlugs(sectionEntry.key)};
      }
      final ref = _PageRef(sectionEntry.key, pageName);
      allPages.add((ref, candidates));
      if (candidates.intersection(targetCandidates).isNotEmpty) {
        matches.add(ref);
      }
    }
  }

  if (matches.isEmpty) {
    _PageRef? best;
    var bestScore = 0.0;
    for (final entry in allPages) {
      for (final candidate in entry.$2) {
        final score = _wordOverlap(stripped, candidate);
        if (score > bestScore) {
          bestScore = score;
          best = entry.$1;
        }
      }
    }
    if (best != null && bestScore >= 0.5) {
      return ResolvedDocLink(
        doc: doc,
        version: version,
        section: best.section,
        page: best.page,
      );
    }
    return null;
  }

  if (matches.length > 1) {
    final tie = matches
        .where((m) => _sectionSlugs(m.section).intersection(middle).isNotEmpty)
        .toList();
    if (tie.length == 1) {
      return ResolvedDocLink(
        doc: doc,
        version: version,
        section: tie.first.section,
        page: tie.first.page,
      );
    }
  }

  return ResolvedDocLink(
    doc: doc,
    version: version,
    section: matches.first.section,
    page: matches.first.page,
  );
}
