import 'package:flutter/material.dart';
import 'package:pdoc/src/constants.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/link_confirm_dialog.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  bool _hovered = false;

  static const _nameStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  double get _nameWidth {
    final painter = TextPainter(
      text: const TextSpan(text: 'Hossein', style: _nameStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gradient = LinearGradient(colors: [scheme.primary, scheme.secondary]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: GestureDetector(
          onTap: () => showExternalLinkDialog(context, githubPageUrl),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                'Made by ',
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => gradient.createShader(bounds),
                      child: const Text('Hossein', style: _nameStyle),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      height: 2,
                      width: _nameWidth,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _hovered ? 1.0 : 0.0),
                        duration: DocColors.fast,
                        curve: DocColors.curve,
                        builder: (context, value, child) => Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: _nameWidth * value,
                            height: 2,
                            child: child,
                          ),
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
