import 'package:flutter/material.dart';
import 'package:pdoc/src/constants.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/link_confirm_dialog.dart';

class GithubButton extends StatelessWidget {
  const GithubButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: DocValues.s2),
      child: Container(
        width: DocValues.iconButton,
        height: DocValues.iconButton,
        decoration: BoxDecoration(
          border: Border.all(
            color: scheme.outline,
            width: DocValues.borderThick,
          ),
          borderRadius: BorderRadius.circular(DocValues.sm),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          tooltip: 'Source code on GitHub',
          icon: const Icon(Icons.code_rounded),
          onPressed: () => showExternalLinkDialog(context, githubUrl),
        ),
      ),
    );
  }
}
