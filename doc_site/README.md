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

Known limitation: WebParagraph is still being fixed. On Flutter stable 3.47.5
a few words render a pixel high with their top row clipped (the "F" of
"Features" in the Headers example). That is
[flutter/flutter#191736](https://github.com/flutter/flutter/pull/191736), merged
to master on 2026-09-12 and already in the beta channel, but not in 3.47.5.

To try it in a Chrome you launch yourself, enable
`chrome://flags/#enable-experimental-web-platform-features` instead.

## Bundled assets

- `assets/fonts/Roboto-{Light,Regular,Medium,SemiBold,Bold}.ttf`: static instances (Apache
  2.0) of the latin subset of Google Fonts' variable Roboto — the file Bootstrap's
  own pages get when they run with `node tool/vendor_examples.mjs --font roboto`.
  Without them the web engine's fallback Roboto has no real light/medium/bold
  weights (`fw-bold`, headings, `.lead`), so they are synthesised and come out
  too light and a few percent narrower.
- `assets/examples/heroes/*.png`: Bootstrap's own screenshots for the Heroes
  example (from `vendor/bootstrap/site/src/assets/examples/heroes`).

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
