import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

class MarkdownImageBlock extends StatelessWidget {
  final String alt;
  final String src;

  const MarkdownImageBlock({super.key, required this.alt, required this.src});

  @override
  Widget build(BuildContext context) {
    final isNetwork = src.startsWith('http://') || src.startsWith('https://');
    final scheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(DocColors.lg),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(DocColors.lg),
      ),
      child: isNetwork
          ? Image.network(
              src,
              semanticLabel: alt.isNotEmpty ? alt : null,
              errorBuilder: (context, error, stackTrace) => _fallback(context),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : _fallback(context, loading: true),
            )
          : _fallback(context),
    );
  }

  Widget _fallback(BuildContext context, {bool loading = false}) {
    final scheme = Theme.of(context).colorScheme;
    final docSurfaces = context.docSurfaces;
    return Container(
      padding: const EdgeInsets.all(DocColors.s4),
      color: scheme.surfaceContainer,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            loading ? Icons.image_outlined : Icons.broken_image_outlined,
            color: docSurfaces.textFaint,
            size: 22,
          ),
          if (alt.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              alt,
              style: TextStyle(
                fontFamily: DocColors.mono,
                fontSize: 12,
                color: docSurfaces.textFaint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
