import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Opens [url] in a new browser tab.
void openUrl(String url) {
  globalContext.callMethod<JSAny?>(
    'open'.toJS,
    url.toJS,
    '_blank'.toJS,
    'noopener'.toJS,
  );
}
