import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class ModalPage extends StatelessWidget {
  const ModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Modal',
      children: [
        DemoSection(
          title: 'Basic',
          child: BsButton(onPressed: () => _showBasic(context), child: const Text('Launch modal')),
        ),
        DemoSection(
          title: 'Static backdrop',
          child: BsButton(
            onPressed: () => _showBasic(context, barrierDismissible: false),
            child: const Text('Launch static-backdrop modal'),
          ),
        ),
        DemoSection(
          title: 'Centered',
          child: BsButton(onPressed: () => _showCentered(context), child: const Text('Launch centered modal')),
        ),
        DemoSection(
          title: 'Scrollable long content',
          child: BsButton(onPressed: () => _showScrollable(context), child: const Text('Launch scrollable modal')),
        ),
        DemoSection(
          title: 'Sizes',
          child: Wrap(
            spacing: 8,
            children: [
              BsButton(onPressed: () => _showSized(context, BsModalSize.small, 'Small modal'), child: const Text('Small')),
              BsButton(onPressed: () => _showSized(context, BsModalSize.large, 'Large modal'), child: const Text('Large')),
              BsButton(
                onPressed: () => _showSized(context, BsModalSize.extraLarge, 'Extra large modal'),
                child: const Text('Extra large'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBasic(BuildContext context, {bool barrierDismissible = true}) {
    showBsModal<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => BsModalDialog(
        child: BsModal(
          header: BsModalHeader(
            onClose: () => Navigator.of(context).pop(),
            child: const Text('Modal title'),
          ),
          body: BsModalBody(
            child: Text(
              barrierDismissible
                  ? 'Woohoo, you are reading this text in a modal!'
                  : "I will not close if you click outside of me. Don't even try to press escape key.",
            ),
          ),
          footer: BsModalFooter(
            children: [
              BsButton(outline: true, onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
              BsButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Save changes')),
            ],
          ),
        ),
      ),
    );
  }

  void _showCentered(BuildContext context) {
    showBsModal<void>(
      context: context,
      builder: (context) => BsModalDialog(
        centered: true,
        child: BsModal(
          header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Centered modal')),
          body: const BsModalBody(child: Text('This modal is vertically centered in the viewport.')),
        ),
      ),
    );
  }

  void _showScrollable(BuildContext context) {
    showBsModal<void>(
      context: context,
      builder: (context) => BsModalDialog(
        child: BsModal(
          scrollableBody: true,
          header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Scrollable modal')),
          body: BsModalBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (var i = 1; i <= 30; i++) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('Line $i of long content.'))],
            ),
          ),
          footer: BsModalFooter(
            children: [BsButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
          ),
        ),
      ),
    );
  }

  void _showSized(BuildContext context, BsModalSize size, String title) {
    showBsModal<void>(
      context: context,
      builder: (context) => BsModalDialog(
        size: size,
        child: BsModal(
          header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: Text(title)),
          body: const BsModalBody(child: Text('This modal demonstrates a non-default size.')),
        ),
      ),
    );
  }
}
