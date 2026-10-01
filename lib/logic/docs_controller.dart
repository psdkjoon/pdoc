import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdata/pdata.dart';

typedef Doc = Map<String, dynamic>;
typedef Docs = List<Doc>;

final docsNotifier = ValueNotifier<Docs>([]);

final docsLoadingNotifier = ValueNotifier<bool>(true);

const docMetaKeys = {'title', 'description', 'tags'};

const _docsAssetPrefix = 'assets/data';
const _docsAssetSuffix = '.json';

Future<void> loadDocsIntoCache() async {
  try {
    docsNotifier.value = await docsLoader();
  } catch (error, stack) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'docs_controller',
        context: ErrorDescription('while loading docs'),
      ),
    );
  } finally {
    docsLoadingNotifier.value = false;
  }
}

Future<Docs> docsLoader() async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final paths =
      manifest
          .listAssets()
          .where(
            (file) =>
                file.startsWith(_docsAssetPrefix) &&
                file.endsWith(_docsAssetSuffix),
          )
          .toList()
        ..sort();

  final loaded = await Future.wait(paths.map(_loadOne));
  return loaded.whereType<Doc>().toList();
}

Future<Doc?> _loadOne(String path) async {
  try {
    final raw = await rootBundle.loadString(path);
    final decoded = pdataDecode(raw, PdataFormat.json) as Map<dynamic, dynamic>;
    return Doc.from(decoded);
  } catch (error, stack) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'docs_controller',
        context: ErrorDescription('while loading $path'),
      ),
    );
    return null;
  }
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
