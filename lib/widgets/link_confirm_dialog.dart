import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdoc/src/theme.dart';

Future<void> showExternalLinkDialog(BuildContext context, String href) async {
  final scheme = Theme.of(context).colorScheme;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DocColors.sm),
        ),
        title: const Text('Leave the app?'),
        content: Text(
          href,
          style: TextStyle(
            fontFamily: DocColors.mono,
            fontSize: 13,
            color: scheme.onSurfaceVariant,
          ),
        ),
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
              await launchUrl(
                Uri.parse(href),
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('Open'),
          ),
        ],
      );
    },
  );
}
