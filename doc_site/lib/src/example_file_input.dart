import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'file_input_labels.dart';
import 'file_picker.dart';

/// `<input type="file" class="form-control">` as the examples have it: a
/// [BsFormFile] whose "Choose File" opens the browser's file dialog and which
/// then shows the name of the file picked.
class ExampleFileInput extends StatefulWidget {
  const ExampleFileInput({
    super.key,
    this.enabled = true,
    this.size = BsFormControlSize.normal,
    this.initialFileName,
  });

  final bool enabled;
  final BsFormControlSize size;

  /// A file already "chosen".
  final String? initialFileName;

  @override
  State<ExampleFileInput> createState() => _ExampleFileInputState();
}

class _ExampleFileInputState extends State<ExampleFileInput> {
  late String? _fileName = widget.initialFileName;

  Future<void> _pick() async {
    final name = await pickFileName();
    // (cancelling a dialog keeps what was chosen before, as a browser does)
    if (name != null && mounted) setState(() => _fileName = name);
  }

  @override
  Widget build(BuildContext context) {
    // (the words are the browser's own: Chrome's "No file chosen", Safari's
    // "no file selected", Firefox's "Browse…" and "No file selected.")
    final labels = fileInputLabelsFor(browserUserAgent());
    return BsFormFile(
      buttonLabel: labels.button,
      noFileLabel: labels.noFile,
      fileName: _fileName,
      enabled: widget.enabled,
      size: widget.size,
      onPressed: widget.enabled ? _pick : null,
    );
  }
}
