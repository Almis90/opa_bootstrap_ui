import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// A single live example within a [DocPage]: a rendered [preview] inside a
/// bordered box (Bootstrap's `.bd-example`), with the Dart [code] that
/// produced it available behind a "Show code" toggle (Bootstrap's
/// `.highlight` snippet, collapsed by default on narrow examples).
class DocExample extends StatefulWidget {
  const DocExample({
    super.key,
    this.title,
    this.description,
    required this.code,
    required this.preview,
  });

  /// Optional heading shown above the example, e.g. "Basic" or "Disabled".
  final String? title;

  /// Optional one- or two-sentence explanation shown under the title.
  final String? description;

  /// The Dart snippet that builds [preview], shown verbatim in a code panel.
  final String code;

  /// The live widget being documented.
  final Widget preview;

  @override
  State<DocExample> createState() => _DocExampleState();
}

class _DocExampleState extends State<DocExample> {
  bool _showCode = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < BsBreakpoint.md.minWidth;
    final previewPadding = isMobile ? 12.0 : 24.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: BsBody.colorOf(context)),
            ),
            const SizedBox(height: 4),
          ],
          if (widget.description != null) ...[
            Text(widget.description!, style: TextStyle(fontSize: 14, color: BsBody.secondaryColorOf(context), height: 1.5)),
            const SizedBox(height: 12),
          ],
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(previewPadding),
            decoration: BoxDecoration(
              border: Border.all(color: BsBorders.colorOf(context)),
              borderRadius: BorderRadius.circular(BsBorders.radius),
            ),
            child: widget.preview,
          ),
          GestureDetector(
            onTap: () => setState(() => _showCode = !_showCode),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: BsBody.tertiaryBackgroundOf(context),
                border: Border(
                  left: BorderSide(color: BsBorders.colorOf(context)),
                  right: BorderSide(color: BsBorders.colorOf(context)),
                  bottom: BorderSide(color: BsBorders.colorOf(context)),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(BsBorders.radius),
                  bottomRight: Radius.circular(BsBorders.radius),
                ),
              ),
              child: Text(
                _showCode ? '– Hide code' : '</> Show code',
                style: const TextStyle(fontSize: 13, color: BsColors.blue, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          if (_showCode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: BsColors.gray900),
              child: BsPre(
                style: const BsCodeStyle(preColor: BsColors.gray100),
                child: Text(widget.code),
              ),
            ),
        ],
      ),
    );
  }
}
