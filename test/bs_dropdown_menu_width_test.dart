import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // The overlay Stack that hosts a dropdown's menu (see BsDropdown's
  // _buildOverlay) only *loosens* the tight full-screen constraints Overlay
  // hands its entries — it doesn't bound them to the menu's actual content.
  // Without IntrinsicWidth, the menu's Column (`crossAxisAlignment:
  // stretch`) stretched out to that loose, screen-sized width instead of
  // its natural content width. For `alignEnd: true` menus specifically,
  // whose `topRight`/`bottomRight` follower anchor reads that bogus width
  // to compute its horizontal offset, this shifted the entire menu off to
  // the left of the toggle instead of hugging its right edge.
  testWidgets('BsDropdown menu hugs its toggle instead of stretching full-screen', (tester) async {
    await tester.pumpWidget(
      BsApp(
        debugShowCheckedModeBanner: false,
        home: Padding(
          padding: const EdgeInsets.all(40),
          child: Align(
            alignment: Alignment.topRight,
            child: BsDropdown(
              alignEnd: true,
              toggleBuilder: (context, toggle, isOpen) => GestureDetector(
                key: const Key('avatar-tap'),
                onTap: toggle,
                child: Container(width: 32, height: 32, key: const Key('avatar')),
              ),
              items: const [BsDropdownItem(child: Text('New project')), BsDropdownItem(child: Text('Settings'))],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    tester.widget<GestureDetector>(find.byKey(const Key('avatar-tap'))).onTap!();
    await tester.pumpAndSettle();

    final avatarRect = tester.getRect(find.byKey(const Key('avatar')));
    final menuRect = tester.getRect(find.byType(DecoratedBox).last);

    // The menu's right edge should align with the toggle's, and it should
    // be a normal, content-sized width — not stretched across the screen.
    expect(menuRect.right, closeTo(avatarRect.right, 1));
    expect(menuRect.width, lessThan(400));
  });

  testWidgets('BsPopover bubble hugs its content instead of stretching full-screen', (tester) async {
    await tester.pumpWidget(
      BsApp(
        debugShowCheckedModeBanner: false,
        home: Padding(
          padding: const EdgeInsets.all(40),
          child: Align(
            alignment: Alignment.topLeft,
            child: BsPopover(
              content: const Text('Short'),
              triggerBuilder: (context, toggle, isOpen) => GestureDetector(
                key: const Key('trigger-tap'),
                onTap: toggle,
                child: Container(width: 32, height: 32, key: const Key('trigger')),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    tester.widget<GestureDetector>(find.byKey(const Key('trigger-tap'))).onTap!();
    await tester.pumpAndSettle();

    final bubbleRect = tester.getRect(find.byType(DecoratedBox).last);
    expect(bubbleRect.width, lessThan(400));
  });
}
