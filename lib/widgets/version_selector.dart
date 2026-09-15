import 'package:flutter/material.dart';
import 'package:pdoc/src/theme.dart';

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
    final button =
        _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final topLeft = button.localToGlobal(
      Offset(0, button.size.height + 6),
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
        0,
      ),
      color: context.docSurfaces.cardBg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DocColors.sm),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      items: [
        for (final version in widget.versions)
          PopupMenuItem<String>(
            value: version,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'v$version',
                    style: TextStyle(
                      fontWeight: version == widget.currentVersion
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: version == widget.currentVersion
                          ? scheme.primary
                          : scheme.onSurface,
                    ),
                  ),
                ),
                if (version == widget.currentVersion)
                  Icon(Icons.check_rounded, size: 16, color: scheme.primary),
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
          duration: DocColors.fast,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(DocColors.sm),
            border: Border.all(
              color: _hovered ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.sell_outlined, size: 15, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'v${widget.currentVersion}',
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: _hovered ? 0.5 : 0,
                duration: DocColors.fast,
                child: Icon(
                  Icons.unfold_more_rounded,
                  size: 15,
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
