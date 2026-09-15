import 'package:flutter/material.dart';
import 'package:pdoc/src/constants.dart';
import 'package:pdoc/widgets/link_confirm_dialog.dart';

class GithubButton extends StatelessWidget {
  const GithubButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outline, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.code_rounded),
          onPressed: () => showExternalLinkDialog(context, githubUrl),
        ),
      ),
    );
  }
}
