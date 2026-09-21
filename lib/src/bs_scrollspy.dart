import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Drives a nav's active item from a scroll position, the way Bootstrap's
/// Scrollspy JS plugin highlights the `.nav-link` for whichever section is
/// currently in view — and, like Material's [TabController], is a plain
/// [ChangeNotifier] rather than a widget: it doesn't render anything
/// itself, it just drives whatever nav widget (a [BsNav], [BsListGroup],
/// or anything else) you build around it with a [ListenableBuilder].
///
/// Attach it to the same [ScrollController] driving the scrollable holding
/// your sections, and give each section a [GlobalKey] (in [sectionKeys],
/// in the same order the sections appear) so their positions can be
/// measured via [RenderAbstractViewport.getOffsetToReveal] — the same
/// mechanism [Scrollable.ensureVisible] uses internally.
class BsScrollspyController extends ChangeNotifier {
  BsScrollspyController({required this.scrollController, required this.sectionKeys, this.offset = 0}) {
    scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  /// The scrollable content's controller.
  final ScrollController scrollController;

  /// One key per tracked section, attached to a widget inside the
  /// scrollable content, in the order the sections appear.
  final List<GlobalKey> sectionKeys;

  /// How far (in pixels) a section's top can be below the viewport's top
  /// edge and still count as "reached" — mirrors Bootstrap's
  /// `data-bs-offset`/`rootMargin`.
  final double offset;

  int _activeIndex = 0;

  /// The index into [sectionKeys] of the section currently considered
  /// active.
  int get activeIndex => _activeIndex;

  void _handleScroll() {
    if (sectionKeys.isEmpty || !scrollController.hasClients) return;

    final currentOffset = scrollController.offset;
    var newIndex = 0;
    for (var i = 0; i < sectionKeys.length; i++) {
      final renderObject = _readyRenderBox(sectionKeys[i]);
      if (renderObject == null) continue;
      final viewport = RenderAbstractViewport.maybeOf(renderObject);
      if (viewport == null) continue;

      final revealOffset = viewport.getOffsetToReveal(renderObject, 0).offset;
      if (currentOffset >= revealOffset - offset) {
        newIndex = i;
      } else {
        break;
      }
    }

    if (newIndex != _activeIndex) {
      _activeIndex = newIndex;
      notifyListeners();
    }
  }

  /// Scrolls so [sectionKeys][index] reaches the top of the viewport.
  Future<void> scrollToSection(int index, {Duration duration = const Duration(milliseconds: 300)}) {
    if (!scrollController.hasClients) return Future.value();
    final renderObject = _readyRenderBox(sectionKeys[index]);
    if (renderObject == null) return Future.value();
    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) return Future.value();

    final revealOffset = viewport.getOffsetToReveal(renderObject, 0).offset;
    final target = revealOffset.clamp(
      scrollController.position.minScrollExtent,
      scrollController.position.maxScrollExtent,
    );
    return scrollController.animateTo(target, duration: duration, curve: Curves.easeInOut);
  }

  /// The section's [RenderBox], or null if it isn't mounted or hasn't been
  /// laid out yet (e.g. the very first frame, before [scrollController]'s
  /// viewport has sized it).
  RenderBox? _readyRenderBox(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;
    return renderObject;
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    super.dispose();
  }
}
