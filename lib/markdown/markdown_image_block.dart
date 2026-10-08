import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';

class MarkdownImageBlock extends StatelessWidget {
  final String alt;
  final String src;

  const MarkdownImageBlock({super.key, required this.alt, required this.src});

  @override
  Widget build(BuildContext context) {
    final isNetwork = src.startsWith('http://') || src.startsWith('https://');
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(DocValues.rCode);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: DocValues.shadowColor.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(DocValues.s0, DocValues.s1),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: radius,
      ),
      child: isNetwork
          ? Image.network(
              src,
              semanticLabel: alt.isNotEmpty ? alt : null,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => _fallback(context),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : _fallback(context, loading: true),
            )
          : _fallback(context),
    );
  }

  Widget _fallback(BuildContext context, {bool loading = false}) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DocValues.s4),
      color: scheme.surfaceContainer,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            loading ? Icons.image_outlined : Icons.broken_image_outlined,
            color: scheme.outline,
            size: DocValues.iconLarge,
          ),
          if (alt.isNotEmpty) ...[
            const SizedBox(height: DocValues.s1),
            WrapText(
              alt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: DocValues.mono,
                fontSize: DocValues.fsCaption,
                color: scheme.outline,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
