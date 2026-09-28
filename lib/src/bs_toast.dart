import 'dart:async';

import 'package:flutter/widgets.dart';

import 'bs_close_button.dart';
import 'bs_theme.dart';
import 'tokens/bs_close_button_style.dart';
import 'tokens/bs_toast_style.dart';

/// Which corner (or edge center) a toast stack anchors to. The six
/// top/bottom placements match Bootstrap's own toast docs; [centerStart]/
/// [centerEnd] (vertically centered against the left/right edge) have no
/// Bootstrap equivalent there, but round out the set the same way a
/// SnackBar/notification rail on the side of the screen would.
enum BsToastPosition { topStart, topCenter, topEnd, centerStart, centerEnd, bottomStart, bottomCenter, bottomEnd }

/// Programmatic control of a single toast shown via [showBsToast] —
/// mirrors Bootstrap's own `bootstrap.Toast` JS plugin: [hide] (its
/// `show()`/`hide()`, minus `show()` since a [BsToastController] always
/// starts already shown — there's no separate "create it hidden, then show
/// it later" step the way a fresh Bootstrap `Toast` instance has). No
/// `enable`/`disable` either, matching Bootstrap's own Toast plugin.
///
/// Unlike this package's other controllers, [showBsToast] always hands one
/// back as its return value (creating one internally if you don't pass
/// your own) rather than keeping it purely internal — so, deliberately,
/// nothing here ever calls [dispose] on it. It's yours from the moment
/// [showBsToast] returns.
class BsToastController extends ChangeNotifier {
  bool _shown = true;

  /// Whether the toast is currently on screen (or fading out after
  /// [hide]).
  bool get isShown => _shown;

  /// Dismisses the toast the same way its own close button (or the
  /// auto-dismiss timer) would. Does nothing if already hidden.
  void hide() {
    if (!_shown) return;
    _shown = false;
    notifyListeners();
  }
}

/// Shows a Bootstrap toast (`.toast`), stacking it with any other toasts
/// already showing at the same [position] — the same corner-stack
/// behavior Material's `ScaffoldMessenger`/`SnackBar` doesn't attempt
/// (Material queues one `SnackBar` at a time instead), so this manages its
/// own [OverlayEntry] and list of active toasts per position rather than
/// adapting that queueing model.
///
/// [builder] mirrors [BsDropdown.toggleBuilder]: it's handed a `dismiss`
/// callback to wire up to the toast's own close button, if any. Each toast
/// auto-dismisses after [duration] regardless, or can be dismissed early
/// through the returned [BsToastController] (or one passed via
/// [controller]).
///
/// [onShow] fires synchronously, right here. [onShown] fires once the
/// fade-in finishes, [onHide] as soon as a dismissal is triggered — by the
/// timer, the close button, or [BsToastController.hide] — and [onHidden]
/// once the fade-out finishes, mirroring Bootstrap's
/// `show.bs.toast`/`shown.bs.toast`/`hide.bs.toast`/`hidden.bs.toast`.
BsToastController showBsToast(
  BuildContext context, {
  required Widget Function(BuildContext context, VoidCallback dismiss) builder,
  BsToastPosition position = BsToastPosition.bottomEnd,
  Duration duration = const Duration(seconds: 5),
  BsToastController? controller,
  VoidCallback? onShow,
  VoidCallback? onShown,
  VoidCallback? onHide,
  VoidCallback? onHidden,
}) {
  final resolvedController = controller ?? BsToastController();
  onShow?.call();
  _managerFor(context).show(
    builder: builder,
    position: position,
    duration: duration,
    controller: resolvedController,
    onShown: onShown,
    onHide: onHide,
    onHidden: onHidden,
  );
  return resolvedController;
}

final _managers = Expando<_BsToastManager>();

_BsToastManager _managerFor(BuildContext context) {
  final overlay = Overlay.of(context);
  return _managers[overlay] ??= _BsToastManager(overlay);
}

class _BsToastRecord {
  _BsToastRecord({
    required this.builder,
    required this.duration,
    required this.controller,
    this.onShown,
    this.onHide,
    this.onHidden,
  });

  final Widget Function(BuildContext context, VoidCallback dismiss) builder;
  final Duration duration;
  final BsToastController controller;
  final VoidCallback? onShown;
  final VoidCallback? onHide;
  final VoidCallback? onHidden;
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
    required BsToastController controller,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
  }) {
    final record = _BsToastRecord(
      builder: builder,
      duration: duration,
      controller: controller,
      onShown: onShown,
      onHide: onHide,
      onHidden: onHidden,
    );
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
        // Without IntrinsicWidth, the Column below's `crossAxisAlignment:
        // stretch` would stretch it out to the overlay Stack's full
        // (screen-sized) loose width instead of shrinking to the toasts'
        // own content width — see the identical fix and explanation on
        // BsDropdown's `_BsDropdownMenu`. With the Column already spanning
        // edge to edge, this Align's start/center/end all looked the same;
        // only top/bottom (the Column's own shrink-wrapped main axis) ever
        // visibly differed.
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, record) in records.indexed)
                Padding(
                  padding: EdgeInsets.only(bottom: index == records.length - 1 ? 0 : BsToastStyle.defaultSpacing),
                  child: _BsToastItem(
                    key: record.key,
                    duration: record.duration,
                    builder: record.builder,
                    controller: record.controller,
                    onShown: record.onShown,
                    onHide: record.onHide,
                    onHidden: record.onHidden,
                    onDismissed: () => _remove(position, record),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Alignment _alignmentFor(BsToastPosition position) => switch (position) {
    BsToastPosition.topStart => Alignment.topLeft,
    BsToastPosition.topCenter => Alignment.topCenter,
    BsToastPosition.topEnd => Alignment.topRight,
    BsToastPosition.centerStart => Alignment.centerLeft,
    BsToastPosition.centerEnd => Alignment.centerRight,
    BsToastPosition.bottomStart => Alignment.bottomLeft,
    BsToastPosition.bottomCenter => Alignment.bottomCenter,
    BsToastPosition.bottomEnd => Alignment.bottomRight,
  };
}

class _BsToastItem extends StatefulWidget {
  const _BsToastItem({
    super.key,
    required this.duration,
    required this.builder,
    required this.controller,
    this.onShown,
    this.onHide,
    this.onHidden,
    required this.onDismissed,
  });

  final Duration duration;
  final Widget Function(BuildContext context, VoidCallback dismiss) builder;
  final BsToastController controller;
  final VoidCallback? onShown;
  final VoidCallback? onHide;
  final VoidCallback? onHidden;
  final VoidCallback onDismissed;

  @override
  State<_BsToastItem> createState() => _BsToastItemState();
}

class _BsToastItemState extends State<_BsToastItem> with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  Timer? _autoDismissTimer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    // controller.hide() called between showBsToast() returning and this
    // widget actually mounting (e.g. synchronously, right after the call)
    // would otherwise be lost — nothing was listening yet to notice it.
    if (!widget.controller.isShown) {
      dismiss();
      return;
    }
    _fadeController.forward().then((_) {
      if (mounted) widget.onShown?.call();
    });
    _autoDismissTimer = Timer(widget.duration, dismiss);
  }

  void _handleControllerChanged() {
    if (!widget.controller.isShown) dismiss();
  }

  Future<void> dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    _autoDismissTimer?.cancel();
    widget.controller.hide(); // no-op if already hidden via this same path
    widget.onHide?.call();
    await _fadeController.reverse();
    if (mounted) widget.onHidden?.call();
    // Unconditional even if unmounted by then (e.g. the whole overlay
    // tore down mid-animation) — this is what tells the manager to drop
    // the record; skipping it would leak it there forever.
    widget.onDismissed();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _autoDismissTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: SizeTransition(
        sizeFactor: _fadeController,
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
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsToastStyle.darkDefaults : BsToastStyle.defaults).merge(this.style);
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
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsToastStyle.darkDefaults : BsToastStyle.defaults).merge(this.style);

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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: style.headerColor ?? BsToastStyle.defaultHeaderColor,
                ),
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
