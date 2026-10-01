import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';
import 'package:pdoc/widgets/fit_text.dart';

class VersionSelector extends StatefulWidget {
  final String currentVersion;
  final List<String> versions;
  final ValueChanged<String> onChanged;

  const VersionSelector({
    super.key,
    required this.currentVersion,
    required this.versions,
    required this.onChanged,
  });

  @override
  State<VersionSelector> createState() => _VersionSelectorState();
}

class _VersionSelectorState extends State<VersionSelector> {
  final _buttonKey = GlobalKey();
  bool _hovered = false;

  Future<void> _openMenu() async {
    final scheme = Theme.of(context).colorScheme;
    final button = _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final topLeft = button.localToGlobal(
      Offset(DocValues.s0, button.size.height + DocValues.s15),
      ancestor: overlay,
    );
    final bottomRight = button.localToGlobal(
      button.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        topLeft.dx,
        topLeft.dy,
        overlay.size.width - bottomRight.dx,
        DocValues.s0,
      ),
      color: scheme.surfaceContainer,
      surfaceTintColor: DocValues.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DocValues.sm),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      items: [
        for (final version in widget.versions)
          PopupMenuItem<String>(
            value: version,
            child: Row(
              children: [
                Expanded(
                  child: FitText(
                    'v$version',
                    style: TextStyle(
                      fontWeight: version == widget.currentVersion
                          ? DocValues.fwBold
                          : DocValues.fwMedium,
                      color: version == widget.currentVersion
                          ? scheme.primary
                          : scheme.onSurface,
                    ),
                  ),
                ),
                if (version == widget.currentVersion)
                  Icon(
                    Icons.check_rounded,
                    size: DocValues.iconMedium,
                    color: scheme.primary,
                  ),
              ],
            ),
          ),
      ],
    );

    if (selected != null && selected != widget.currentVersion) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _openMenu,
        child: AnimatedContainer(
          key: _buttonKey,
          duration: DocValues.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: DocValues.s3,
            vertical: DocValues.s25,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(DocValues.sm),
            border: Border.all(
              color: _hovered ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.sell_outlined,
                size: DocValues.iconSmall,
                color: scheme.primary,
              ),
              const SizedBox(width: DocValues.s2),
              Expanded(
                child: FitText(
                  'v${widget.currentVersion}',
                  style: TextStyle(
                    fontSize: DocValues.fsSmall,
                    color: scheme.onSurface,
                    fontWeight: DocValues.fwSemi,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: _hovered ? DocValues.halfTurn : DocValues.s0,
                duration: DocValues.fast,
                child: Icon(
                  Icons.unfold_more_rounded,
                  size: DocValues.iconSmall,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
