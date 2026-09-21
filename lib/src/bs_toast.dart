import 'dart:async';

import 'package:flutter/widgets.dart';

import 'bs_close_button.dart';
import 'tokens/bs_close_button_style.dart';
import 'tokens/bs_toast_style.dart';

/// Which corner (or top/bottom edge center) a toast stack anchors to,
/// matching the placements shown in Bootstrap's own toast docs.
enum BsToastPosition { topStart, topCenter, topEnd, bottomStart, bottomCenter, bottomEnd }

/// Shows a Bootstrap toast (`.toast`), stacking it with any other toasts
/// already showing at the same [position] — the same corner-stack
/// behavior Material's `ScaffoldMessenger`/`SnackBar` doesn't attempt
/// (Material queues one `SnackBar` at a time instead), so this manages its
/// own [OverlayEntry] and list of active toasts per position rather than
/// adapting that queueing model.
///
/// [builder] mirrors [BsDropdown.toggleBuilder]: it's handed a `dismiss`
/// callback to wire up to the toast's own close button, if any. Each toast
/// auto-dismisses after [duration] regardless.
void showBsToast(
  BuildContext context, {
  required Widget Function(BuildContext context, VoidCallback dismiss) builder,
  BsToastPosition position = BsToastPosition.bottomEnd,
  Duration duration = const Duration(seconds: 5),
}) {
  _managerFor(context).show(builder: builder, position: position, duration: duration);
}

final _managers = Expando<_BsToastManager>();

_BsToastManager _managerFor(BuildContext context) {
  final overlay = Overlay.of(context);
  return _managers[overlay] ??= _BsToastManager(overlay);
}

class _BsToastRecord {
  _BsToastRecord({required this.builder, required this.duration});

  final Widget Function(BuildContext context, VoidCallback dismiss) builder;
  final Duration duration;
  final GlobalKey<_BsToastItemState> key = GlobalKey<_BsToastItemState>();
}

class _BsToastManager {
  _BsToastManager(this._overlayState);

  final OverlayState _overlayState;
  final Map<BsToastPosition, List<_BsToastRecord>> _records = {};
  OverlayEntry? _overlayEntry;

  void show({
    required Widget Function(BuildContext context, VoidCallback dismiss) builder,
    required BsToastPosition position,
    required Duration duration,
  }) {
    final record = _BsToastRecord(builder: builder, duration: duration);
    (_records[position] ??= []).add(record);

    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: _buildOverlay);
      _overlayState.insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _remove(BsToastPosition position, _BsToastRecord record) {
    _records[position]?.remove(record);
    _overlayEntry?.markNeedsBuild();
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: [
        for (final entry in _records.entries)
          if (entry.value.isNotEmpty) _buildPosition(entry.key, entry.value),
      ],
    );
  }

  Widget _buildPosition(BsToastPosition position, List<_BsToastRecord> records) {
    return Align(
      alignment: _alignmentFor(position),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final record in records)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BsToastItem(
                  key: record.key,
                  duration: record.duration,
                  builder: record.builder,
                  onDismissed: () => _remove(position, record),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Alignment _alignmentFor(BsToastPosition position) => switch (position) {
    BsToastPosition.topStart => Alignment.topLeft,
    BsToastPosition.topCenter => Alignment.topCenter,
    BsToastPosition.topEnd => Alignment.topRight,
    BsToastPosition.bottomStart => Alignment.bottomLeft,
    BsToastPosition.bottomCenter => Alignment.bottomCenter,
    BsToastPosition.bottomEnd => Alignment.bottomRight,
  };
}

class _BsToastItem extends StatefulWidget {
  const _BsToastItem({super.key, required this.duration, required this.builder, required this.onDismissed});

  final Duration duration;
  final Widget Function(BuildContext context, VoidCallback dismiss) builder;
  final VoidCallback onDismissed;

  @override
  State<_BsToastItem> createState() => _BsToastItemState();
}

class _BsToastItemState extends State<_BsToastItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  Timer? _autoDismissTimer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _autoDismissTimer = Timer(widget.duration, dismiss);
  }

  Future<void> dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    _autoDismissTimer?.cancel();
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SizeTransition(
        sizeFactor: _controller,
        alignment: Alignment.topCenter,
        child: widget.builder(context, dismiss),
      ),
    );
  }
}

/// `.toast`: the bordered notification card [showBsToast] displays.
class BsToast extends StatelessWidget {
  const BsToast({super.key, this.header, required this.body, this.style});

  /// Typically a [BsToastHeader].
  final Widget? header;

  /// `.toast-body`.
  final Widget body;

  /// Style overrides layered on top of [BsToastStyle.defaults].
  final BsToastStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsToastStyle.defaults.merge(this.style);
    final borderRadius = BorderRadius.circular(style.borderRadius ?? BsToastStyle.defaultBorderRadius);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: style.maxWidth ?? BsToastStyle.defaultMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.background ?? BsToastStyle.defaultBackground,
          border: Border.all(
            color: style.borderColor ?? BsToastStyle.defaultBorderColor,
            width: style.borderWidth ?? BsToastStyle.defaultBorderWidth,
          ),
          borderRadius: borderRadius,
          boxShadow: style.boxShadow ?? BsToastStyle.defaultBoxShadow,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ?header,
              Padding(
                padding: style.padding ?? BsToastStyle.defaultPadding,
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: style.color, fontSize: style.fontSize ?? BsToastStyle.defaultFontSize),
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `.toast-header`: [title] plus optional [meta] (e.g. a timestamp) and a
/// close button, above a divider.
class BsToastHeader extends StatelessWidget {
  const BsToastHeader({super.key, required this.title, this.meta, this.onClose, this.style});

  final Widget title;
  final Widget? meta;

  /// Shows a [BsCloseButton] calling this when tapped. Omit to hide it.
  final VoidCallback? onClose;

  final BsToastStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsToastStyle.defaults.merge(this.style);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.headerBackground ?? BsToastStyle.defaultHeaderBackground,
        border: Border(
          bottom: BorderSide(
            color: style.headerBorderColor ?? BsToastStyle.defaultBorderColor,
            width: style.borderWidth ?? BsToastStyle.defaultBorderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: style.padding ?? BsToastStyle.defaultPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DefaultTextStyle.merge(
                style: TextStyle(fontWeight: FontWeight.bold, color: style.headerColor ?? BsToastStyle.defaultHeaderColor),
                child: title,
              ),
            ),
            if (meta != null) ...[
              const SizedBox(width: 8),
              DefaultTextStyle.merge(
                style: TextStyle(fontSize: 12, color: style.headerColor ?? BsToastStyle.defaultHeaderColor),
                child: meta!,
              ),
            ],
            if (onClose != null) ...[
              const SizedBox(width: 8),
              BsCloseButton(onPressed: onClose, style: const BsCloseButtonStyle(size: 12)),
            ],
          ],
        ),
      ),
    );
  }
}
