import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdata/pdata.dart';

typedef Doc = Map<String, dynamic>;
typedef Docs = List<Doc>;

final docsNotifier = ValueNotifier<Docs>([]);

const docMetaKeys = {'title', 'description', 'tags'};

Future<void> loadDocsIntoCache() async {
  docsNotifier.value = await docsLoader();
}

Future<Docs> docsLoader() async {
  final docs = <Doc>[];
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final paths = manifest.listAssets().where(
    (file) => file.startsWith('assets/data') && file.endsWith('.json'),
  );
  for (final path in paths) {
    final raw = await rootBundle.loadString(path);
    docs.add(pdataDecode(raw, PdataFormat.json) as Doc);
  }
  return docs;
}

List<String> docVersions(Doc doc) {
  final versions = doc.keys.where((key) => !docMetaKeys.contains(key)).toList();
  versions.sort(compareVersions);
  return versions;
}

int compareVersions(String a, String b) {
  final partsA = a.split('.').map((part) => int.tryParse(part) ?? 0).toList();
  final partsB = b.split('.').map((part) => int.tryParse(part) ?? 0).toList();
  final length = partsA.length > partsB.length ? partsA.length : partsB.length;
  for (var i = 0; i < length; i++) {
    final valueA = i < partsA.length ? partsA[i] : 0;
    final valueB = i < partsB.length ? partsB[i] : 0;
    if (valueA != valueB) return valueA.compareTo(valueB);
  }
  return 0;
}

Map<String, Map<String, String>> docSections(Doc doc, String version) {
  final raw = doc[version] as Map<String, dynamic>;
  return raw.map(
    (section, pages) => MapEntry(
      section,
      (pages as Map<String, dynamic>).map(
        (page, content) => MapEntry(page, content as String),
      ),
    ),
  );
}
