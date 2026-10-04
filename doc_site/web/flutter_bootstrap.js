{{flutter_js}}
{{flutter_build_config}}

// Use the browser's own text layout (Flutter's experimental "WebParagraph")
// where it exists, so `system-ui` resolves to the real system font — San
// Francisco on macOS, as in Bootstrap's own pages — instead of the bundled
// Roboto canvas text falls back to. It needs Chrome's canvas Text Clusters API
// (Chrome behind --enable-experimental-web-platform-features); everywhere else
// the engine ignores the option and renders as before.
_flutter.loader.load({
  config: { preferWebParagraph: true },
});
