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

  static const _lead = 'Made by ';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gradient = LinearGradient(colors: [scheme.primary, scheme.secondary]);
    final leadStyle = TextStyle(
      fontSize: DocValues.fsSmall,
      color: scheme.onSurfaceVariant,
    );
    final nameStyle = TextStyle(
      fontSize: DocValues.fsSmall,
      fontWeight: DocValues.fwBold,
      color: scheme.onSurface,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scheme.outline, width: DocValues.borderThick),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: DocValues.s25,
        horizontal: DocValues.s3,
      ),
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showExternalLinkDialog(context, githubPageUrl),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(_lead, style: leadStyle),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: DocValues.sPx3 + DocValues.accentBar,
                      ),
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: gradient.createShader,
                        child: Text(
                          DocValues.authorName,
                          textAlign: TextAlign.center,
                          style: nameStyle.copyWith(color: scheme.onSurface),
                        ),
                      ),
                    ),
                    Positioned(
                      left: DocValues.s0,
                      right: DocValues.s0,
                      bottom: DocValues.s0,
                      height: DocValues.accentBar,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: DocValues.alphaZero,
                          end: _hovered
                              ? DocValues.scaleUnit
                              : DocValues.alphaZero,
                        ),
                        duration: DocValues.slow,
                        curve: DocValues.curve,
                        builder: (context, value, child) =>
                            FractionallySizedBox(
                              widthFactor: value,
                              child: child,
                            ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(
                              DocValues.sHair,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
