/// Opens the browser's file dialog and returns the chosen file's name — null if
/// none was chosen (or off the web, where there is no dialog to open).
library;

export 'file_picker_stub.dart'
    if (dart.library.js_interop) 'file_picker_web.dart';
