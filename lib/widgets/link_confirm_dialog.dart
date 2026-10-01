import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdoc/src/theme.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showExternalLinkDialog(BuildContext context, String href) async {
  final scheme = Theme.of(context).colorScheme;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DocValues.sm),
        ),
        title: const Text('Leave the app?'),
        content: SingleChildScrollView(
          child: SelectableText(
            href,
            style: TextStyle(
              fontFamily: DocValues.mono,
              fontSize: DocValues.fsSmall,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        actionsOverflowAlignment: OverflowBarAlignment.end,
        actionsOverflowButtonSpacing: DocValues.s1,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: href));
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Copy'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final uri = Uri.tryParse(href);
              if (uri == null) return;
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: const Text('Open'),
          ),
        ],
      );
    },
  );
}
