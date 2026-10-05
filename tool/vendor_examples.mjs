#!/usr/bin/env node
// Builds Bootstrap's own example pages (vendor/bootstrap/site/src/assets/examples)
// into plain static HTML and serves them locally, so they can be opened in the
// same browser, with the same system font, as the Flutter port.
//
// The originals are Astro templates. Rather than installing Astro and the
// whole docs site, this expands the handful of Astro features the examples
// actually use (frontmatter exports, getVersionedDocsPath, the year, the
// <Placeholder /> and <Example /> shortcodes, getData('theme-colors')) and
// wraps each page in a copy of ExamplesLayout.astro, theme toggler included.
// Examples that need more are listed as unsupported.
//
//   node tool/vendor_examples.mjs            build, then serve on :8800
//   node tool/vendor_examples.mjs --port 9000
//   node tool/vendor_examples.mjs --no-serve  just build
//   node tool/vendor_examples.mjs --font roboto
//                                    render every page in Roboto (loaded from
//                                    Google Fonts) instead of the system font,
//                                    to compare against Flutter web's fallback
//   node tool/vendor_examples.mjs --grayscale
//                                    turn off macOS subpixel/stem-darkening text
//                                    smoothing (-webkit-font-smoothing:
//                                    antialiased), which makes DOM text look
//                                    ~15-30% heavier than Flutter's canvas text
//
// Output goes to build/vendor_examples (git-ignored).

import fs from 'node:fs'
import http from 'node:http'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const VENDOR = path.join(ROOT, 'vendor/bootstrap')
const EXAMPLES = path.join(VENDOR, 'site/src/assets/examples')
const OUT = path.join(ROOT, 'build/vendor_examples')
const DOCS_VERSION = '5.3'

const args = process.argv.slice(2)
const serve = !args.includes('--no-serve')
const port = Number(args[args.indexOf('--port') + 1]) || 8800
const grayscale = args.includes('--grayscale')
const font = args.includes('--font') ? args[args.indexOf('--font') + 1] : undefined
if (font && font !== 'roboto') {
  console.error(`Unknown --font "${font}" (supported: roboto)`)
  process.exit(1)
}

// ---------------------------------------------------------------- helpers

const read = (p) => fs.readFileSync(p, 'utf8')

function copyDir(src, dest, skip = () => false) {
  fs.mkdirSync(dest, { recursive: true })
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    if (skip(entry.name)) continue
    const from = path.join(src, entry.name)
    const to = path.join(dest, entry.name)
    if (entry.isDirectory()) copyDir(from, to, skip)
    else fs.copyFileSync(from, to)
  }
}

const escapeAttr = (s) => String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;')

/** `getVersionedDocsPath('/assets/x')` → where that lands in this local build. */
function docsPath(p) {
  const clean = p.replace(/^\//, '')
  if (clean.startsWith('assets/')) return `/docs/${clean}`
  if (clean.startsWith('examples/')) return `/${clean}`
  if (clean === 'examples') return '/'
  return `https://getbootstrap.com/docs/${DOCS_VERSION}/${clean}`
}

// ---------------------------------------------------------- <Placeholder />

function parseAttrs(src) {
  const attrs = {}
  const re = /([\w:-]+)\s*=\s*(?:"([^"]*)"|'([^']*)'|\{([^}]*)\})/g
  for (const m of src.matchAll(re)) {
    const [, name, dq, sq, expr] = m
    if (expr !== undefined) {
      attrs[name] = expr.trim() === 'false' ? false : expr.trim() === 'true' ? true : expr.trim().replace(/^['"]|['"]$/g, '')
    } else attrs[name] = dq ?? sq
  }
  return attrs
}

// Mirrors site/src/libs/placeholder.ts (svg markup; the img variant is unused by the examples).
function renderPlaceholder(attrSrc) {
  const o = {
    background: '#868e96',
    color: '#dee2e6',
    height: '180',
    title: 'Placeholder',
    width: '100%',
    ...parseAttrs(attrSrc),
  }
  if (o.text === undefined) o.text = `${o.width}x${o.height}`
  const showText = o.text !== false
  const showTitle = o.title !== false
  const label = showText || showTitle ? `${showTitle ? o.title : ''}${showTitle && showText ? ': ' : ''}${showText ? o.text : ''}` : undefined
  const attrsOut = [
    ['aria-hidden', !showText && !showTitle ? 'true' : undefined],
    ['aria-label', label],
    ['class', ['bd-placeholder-img', o.class].filter(Boolean).join(' ')],
    ['height', o.height],
    ['preserveAspectRatio', 'xMidYMid slice'],
    ['role', showTitle || showText ? 'img' : undefined],
    ['width', o.width],
    ['xmlns', 'http://www.w3.org/2000/svg'],
  ]
    .filter(([, v]) => v !== undefined)
    .map(([k, v]) => `${k}="${escapeAttr(v)}"`)
    .join(' ')
  return (
    `<svg ${attrsOut}>` +
    (showTitle ? `<title>${o.title}</title>` : '') +
    `<rect width="100%" height="100%" fill="${o.background}" />` +
    (showText ? `<text x="50%" y="50%" fill="${o.color}" dy=".3em">${o.text}</text>` : '') +
    '</svg>'
  )
}

// ------------------------------------------------------------- <Example />
// Expands the docs' `<Example code={`...`} />` shortcode (the cheatsheet's
// building block): the `code` prop is a JS expression (template literals with
// `${}`, arrays, `getData(...)`), evaluated here and wrapped the way
// site/src/components/shortcodes/Example.astro does (preview only).

function skipString(s, i, q) {
  for (i++; i < s.length; i++) {
    if (s[i] === '\\') i++
    else if (s[i] === q) return i
  }
  return s.length
}
function skipTemplate(s, i) {
  for (i++; i < s.length; i++) {
    if (s[i] === '\\') i++
    else if (s[i] === '`') return i
    else if (s[i] === '$' && s[i + 1] === '{') i = scanBraces(s, i + 1) - 1
  }
  return s.length
}
/** The index just past the `}` matching the `{` at `i`. */
function scanBraces(s, i) {
  let depth = 0
  for (; i < s.length; i++) {
    const c = s[i]
    if (c === '{') depth++
    else if (c === '}') {
      if (--depth === 0) return i + 1
    } else if (c === "'" || c === '"') i = skipString(s, i, c)
    else if (c === '`') i = skipTemplate(s, i)
  }
  return s.length
}

function themeColors() {
  const yml = read(path.join(VENDOR, 'site/data/theme-colors.yml'))
  return [...yml.matchAll(/- name: (\w+)\n\s+hex: '([^']+)'(?:\n\s+contrast_color: (\w+))?/g)].map((m) => ({
    name: m[1],
    hex: m[2],
    contrast_color: m[3],
    title: m[1][0].toUpperCase() + m[1].slice(1),
  }))
}
const getData = (name) => {
  if (name === 'theme-colors') return themeColors()
  throw new Error(`getData('${name}') is not supported`)
}

function expandExamples(body) {
  let out = ''
  let i = 0
  for (;;) {
    const at = body.indexOf('<Example', i)
    if (at < 0 || !/\s/.test(body[at + 8] ?? '')) {
      if (at >= 0) {
        out += body.slice(i, at + 8)
        i = at + 8
        continue
      }
      return out + body.slice(i)
    }
    out += body.slice(i, at)
    // Attributes, up to the closing `/>`.
    const props = {}
    let j = at + 8
    for (;;) {
      while (/\s/.test(body[j])) j++
      if (body.startsWith('/>', j)) {
        j += 2
        break
      }
      const m = /^[\w:-]+/.exec(body.slice(j))
      if (!m) throw new Error(`cannot parse <Example> near: ${body.slice(j, j + 60)}`)
      const name = m[0]
      j += name.length
      if (body[j] !== '=') {
        props[name] = true
        continue
      }
      j++
      if (body[j] === '{') {
        const end = scanBraces(body, j)
        const expr = body.slice(j + 1, end - 1)
        props[name] = new Function('getData', 'getVersionedDocsPath', `return (${expr})`)(getData, (p) => docsPath(p))
        j = end
      } else {
        const q = body[j]
        const end = skipString(body, j, q)
        props[name] = body.slice(j + 1, end)
        j = end + 1
      }
    }
    const markup = Array.isArray(props.code) ? props.code.join('\n') : props.code
    const cls = ['bd-example m-0 border-0', props.class].filter(Boolean).join(' ')
    const id = props.id ? ` id="${props.id}"` : ''
    out += `<div class="bd-example-snippet bd-code-snippet">${props.showPreview === false ? '' : `<div${id} class="${cls}">${markup}</div>`}</div>`
    i = j
  }
}

// ---------------------------------------------------------------- layout

const layoutSource = read(path.join(VENDOR, 'site/src/layouts/ExamplesLayout.astro'))
const layoutStyle = layoutSource.match(/<style is:global>([\s\S]*?)<\/style>/)[1]
const icons = read(path.join(VENDOR, 'site/src/layouts/partials/Icons.astro'))

// ThemeToggler.astro, `examples` layout, with its template expressions resolved.
const themeToggler = `
<button class="btn btn-bd-primary py-2 dropdown-toggle d-flex align-items-center" id="bd-theme" type="button" aria-expanded="false" data-bs-toggle="dropdown" aria-label="Toggle theme (auto)">
  <svg class="bi my-1 theme-icon-active" aria-hidden="true"><use href="#circle-half"></use></svg>
  <span class="visually-hidden" id="bd-theme-text">Toggle theme</span>
</button>
<ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="bd-theme-text">
  ${[
    ['light', 'Light', 'sun-fill', false],
    ['dark', 'Dark', 'moon-stars-fill', false],
    ['auto', 'Auto', 'circle-half', true],
  ]
    .map(
      ([value, label, icon, active]) => `<li>
    <button type="button" class="dropdown-item d-flex align-items-center${active ? ' active' : ''}" data-bs-theme-value="${value}" aria-pressed="${active}">
      <svg class="bi me-2 opacity-50" aria-hidden="true"><use href="#${icon}"></use></svg>
      ${label}
      <svg class="bi ms-auto d-none" aria-hidden="true"><use href="#check2"></use></svg>
    </button>
  </li>`,
    )
    .join('\n  ')}
</ul>`

// `--font roboto`: Bootstrap sets the font in one place (`body { font-family:
// var(--bs-body-font-family) }`), and buttons/inputs inherit it.
const fontOverride =
  (font === 'roboto'
    ? `
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <style>:root, [data-bs-theme] { --bs-body-font-family: Roboto, sans-serif; }</style>`
    : '') +
  (grayscale ? `\n    <style>html { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }</style>` : '')

function renderPage({ title, extraCss, extraJs, bodyClass, htmlClass, direction, includeJs }, body) {
  const rtl = direction === 'rtl'
  const css = rtl ? '/dist/css/bootstrap.rtl.css' : '/dist/css/bootstrap.css'
  return `<!doctype html>
<html ${rtl ? 'lang="ar" dir="rtl"' : 'lang="en"'}${htmlClass ? ` class="${htmlClass}"` : ''} data-bs-theme="auto">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${title ?? 'Example'} · Bootstrap v${DOCS_VERSION}</title>
    <script src="/docs/assets/js/color-modes.js"></script>
    <link href="${css}" rel="stylesheet" />
    <style>${layoutStyle}</style>${fontOverride}
${extraCss.map((href) => `    <link href="${href}" rel="stylesheet" />`).join('\n')}
  </head>
  <body${bodyClass ? ` class="${bodyClass}"` : ''}>
${icons}
    <div class="dropdown position-fixed bottom-0 end-0 mb-3 me-3 bd-mode-toggle">${themeToggler}
    </div>

${body}
${
  includeJs === false
    ? ''
    : `    <script src="/dist/js/bootstrap.bundle.min.js"></script>\n` +
      extraJs
        .map(
          (js) =>
            `    <script src="${js.src}"${js.async ? ' async' : ''}${js.integrity ? ` integrity="${js.integrity}" crossorigin="anonymous"` : ''}></script>`,
        )
        .join('\n')
}
  </body>
</html>
`
}

// -------------------------------------------------------------- one example

function buildExample(name) {
  const dir = path.join(EXAMPLES, name)
  const source = read(path.join(dir, 'index.astro'))
  const [, frontmatter, rawBody] = source.split(/^---\s*$/m)

  // Frontmatter is JS: drop the imports, turn `export const` into `const`, evaluate.
  const code = frontmatter
    .split('\n')
    .filter((line) => !/^\s*import\s/.test(line))
    .join('\n')
    .replace(/export const/g, 'const')
  const names = ['title', 'extra_css', 'extra_js', 'body_class', 'html_class', 'direction', 'include_js']
  const meta = new Function(`${code}\nreturn {${names.map((n) => `${n}: typeof ${n} === 'undefined' ? undefined : ${n}`).join(',')}}`)()

  const year = String(new Date().getFullYear())
  let body = expandExamples(rawBody)
    .replace(/=\{getVersionedDocsPath\((['"])(.*?)\1\)\}/g, (_, __, p) => `="${docsPath(p)}"`)
    .replace(/\{new Date\(\)\.getFullYear\(\)\}/g, year)
    .replace(/<Placeholder\s+([\s\S]*?)\/>/g, (_, attrs) => renderPlaceholder(attrs))

  const leftover = body.match(/<[A-Z][A-Za-z]+[\s/>]|getVersionedDocsPath/)
  if (leftover) return { name, unsupported: `unexpanded Astro syntax (${leftover[0].trim()})` }

  const html = renderPage(
    {
      title: meta.title,
      extraCss: meta.extra_css ?? [],
      extraJs: meta.extra_js ?? [],
      bodyClass: meta.body_class,
      htmlClass: meta.html_class,
      direction: meta.direction ?? (name.endsWith('-rtl') ? 'rtl' : undefined),
      includeJs: meta.include_js,
    },
    body,
  )

  const dest = path.join(OUT, 'examples', name)
  copyDir(dir, dest, (f) => f === 'index.astro')
  fs.writeFileSync(path.join(dest, 'index.html'), html)
  return { name, title: meta.title }
}

// -------------------------------------------------------------------- build

function build() {
  fs.rmSync(OUT, { recursive: true, force: true })
  fs.mkdirSync(OUT, { recursive: true })

  copyDir(path.join(VENDOR, 'dist/css'), path.join(OUT, 'dist/css'), (f) => f.endsWith('.map') || f.includes('.min.') || f.includes('grid') || f.includes('reboot') || f.includes('utilities'))
  fs.mkdirSync(path.join(OUT, 'dist/js'), { recursive: true })
  fs.copyFileSync(path.join(VENDOR, 'dist/js/bootstrap.bundle.min.js'), path.join(OUT, 'dist/js/bootstrap.bundle.min.js'))
  copyDir(path.join(VENDOR, 'site/static/docs/[version]/assets'), path.join(OUT, 'docs/assets'))

  const results = fs
    .readdirSync(EXAMPLES, { withFileTypes: true })
    .filter((e) => e.isDirectory() && fs.existsSync(path.join(EXAMPLES, e.name, 'index.astro')))
    .map((e) => buildExample(e.name))

  const ok = results.filter((r) => !r.unsupported)
  const skipped = results.filter((r) => r.unsupported)
  const li = (r) => `<li><a href="/examples/${r.name}/">${r.name}</a>${r.title ? ` <small>${r.title}</small>` : ''}</li>`
  fs.writeFileSync(
    path.join(OUT, 'index.html'),
    `<!doctype html><meta charset="utf-8"><title>Bootstrap v${DOCS_VERSION} examples (local)</title>
<link href="/dist/css/bootstrap.css" rel="stylesheet">
<main class="container py-5"><h1>Bootstrap v${DOCS_VERSION} examples</h1>
<p class="text-body-secondary">Built from <code>vendor/bootstrap</code> by <code>tool/vendor_examples.mjs</code>.</p>
<ul>${ok.map(li).join('')}</ul>
${skipped.length ? `<h2 class="h5 mt-4">Not built</h2><ul>${skipped.map((r) => `<li>${r.name} <small class="text-body-secondary">${r.unsupported}</small></li>`).join('')}</ul>` : ''}
</main>`,
  )
  console.log(`Built ${ok.length} examples into ${path.relative(ROOT, OUT)}${font ? ` (font: ${font})` : ''}${grayscale ? ' (grayscale smoothing)' : ''}`)
  for (const r of skipped) console.log(`  skipped ${r.name}: ${r.unsupported}`)
}

// -------------------------------------------------------------------- serve

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
  '.ico': 'image/x-icon',
  '.woff2': 'font/woff2',
}

function startServer() {
  http
    .createServer((req, res) => {
      let p = path.join(OUT, decodeURIComponent(new URL(req.url, 'http://x').pathname))
      if (!p.startsWith(OUT)) return res.writeHead(403).end()
      if (fs.existsSync(p) && fs.statSync(p).isDirectory()) p = path.join(p, 'index.html')
      if (!fs.existsSync(p)) return res.writeHead(404).end('Not found')
      res.writeHead(200, { 'content-type': MIME[path.extname(p)] ?? 'application/octet-stream' })
      fs.createReadStream(p).pipe(res)
    })
    .listen(port, '127.0.0.1', () => console.log(`Serving http://localhost:${port}/ (Ctrl-C to stop)`))
}

build()
if (serve) startServer()
