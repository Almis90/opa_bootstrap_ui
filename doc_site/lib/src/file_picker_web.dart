import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Clicks a fresh `<input type="file">`, as the page of the original does with
/// its own, and resolves to the name of the file the user picks (null when the
/// dialog is cancelled).
Future<String?> pickFileName() {
  final completer = Completer<String?>();
  final document = globalContext['document']! as JSObject;
  final input = document.callMethod<JSObject>(
    'createElement'.toJS,
    'input'.toJS,
  );
  input['type'] = 'file'.toJS;

  input.callMethod<JSAny?>(
    'addEventListener'.toJS,
    'change'.toJS,
    ((JSAny? _) {
      final files = input['files'] as JSObject?;
      final count = files == null
          ? 0
          : (files['length']! as JSNumber).toDartInt;
      if (count == 0) {
        completer.complete(null);
        return;
      }
      final file = files!.callMethod<JSObject>('item'.toJS, 0.toJS);
      completer.complete((file['name']! as JSString).toDart);
    }).toJS,
  );
  // (the dialog's Cancel: `change` doesn't fire for it)
  input.callMethod<JSAny?>(
    'addEventListener'.toJS,
    'cancel'.toJS,
    ((JSAny? _) {
      if (!completer.isCompleted) completer.complete(null);
    }).toJS,
  );

  input.callMethod<JSAny?>('click'.toJS);
  return completer.future;
}
