import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// A small "Copy"/"Copied!" pill meant to sit in the corner of a code
/// panel, mirroring the copy button on Bootstrap's own docs site.
class CopyCodeButton extends StatefulWidget {
  const CopyCodeButton({super.key, required this.code});

  final String code;

  @override
  State<CopyCodeButton> createState() => _CopyCodeButtonState();
}

class _CopyCodeButtonState extends State<CopyCodeButton> {
  bool _hovered = false;
  bool _copied = false;
  Timer? _resetTimer;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    _resetTimer?.cancel();
    setState(() => _copied = true);
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _copy,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? BsColors.gray600 : BsColors.gray700,
            borderRadius: BorderRadius.circular(BsBorders.radius),
          ),
          child: Text(
            _copied ? 'Copied!' : 'Copy',
            style: const TextStyle(fontSize: 12, color: BsColors.gray100, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
