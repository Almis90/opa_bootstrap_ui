# doc_site

Documentation and examples for `opa_bootstrap_ui`, structured after
getbootstrap.com's docs.

## Running it

```sh
flutter run -d chrome --web-browser-flag=--enable-experimental-web-platform-features
```

Hot reload (`r`) and hot restart (`R`) work as usual in that terminal.

### Why the flag?

Bootstrap's pages ask the browser for `system-ui`, which is San Francisco on
macOS. Flutter web normally paints text onto a canvas it can only fill with
fonts it ships, so it falls back to Roboto and text comes out narrower and
lighter than Bootstrap's. `web/flutter_bootstrap.js` turns on Flutter's
experimental *WebParagraph* text engine (`preferWebParagraph`), which lays text
out with the browser itself and so can use the system font. It relies on
Chrome's canvas Text Clusters API, still behind that flag; in any browser
without it the option is ignored and the site renders with Roboto as before.

To try it in a Chrome you launch yourself, enable
`chrome://flags/#enable-experimental-web-platform-features` instead.

## Bootstrap's original examples, locally

To open Bootstrap's own example pages next to the Flutter port, in the same
browser and with the same system font:

```sh
node tool/vendor_examples.mjs        # http://localhost:8800/
```

It turns the Astro templates in `vendor/bootstrap/site/src/assets/examples`
into static pages under `build/vendor_examples` (see the header comment in
`tool/vendor_examples.mjs` for what it expands). `--port` changes the port and
`--no-serve` only builds. Pages that load Chart.js, Masonry or web fonts still
fetch them from their CDNs, as the originals do.
