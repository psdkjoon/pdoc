# pdoc

My personal docs site, built with Flutter web. It renders a set of Markdown-ish
JSON documents — some are references for tools I use daily (git, ffmpeg,
imagemagick), others are docs for packages I've written (`pdata`, `penv`,
`ptgb`, `ptgc`).

No CMS, no build step for content, no backend. Each project is one JSON file
in `assets/data/`, versioned, sectioned, and rendered by a small custom
Markdown renderer built specifically for this app.

## Stack

- Flutter (web target only)
- Pure Dart, no state management package — just `ValueNotifier` and
  `setState`
- Content lives in `assets/data/*.json`, one file per project, loaded and
  decoded via [`pdata`](https://github.com/psdkjoon/pdata)

## Running it

```bash
flutter pub get
flutter run -d chrome
```

## Adding a project

Drop a new JSON file in `assets/data/`. Shape:

```json
{
  "title": "my-tool",
  "description": "One line, shown on the home page card.",
  "tags": ["dart", "cli"],
  "1.0.0": {
    "Getting Started": {
      "Installation": "Markdown content goes here."
    }
  }
}
```

Top-level keys other than `title`, `description`, and `tags` are treated as
versions. Each version is a map of section → page → Markdown body.

## Structure

```
lib/
  logic/      state: docs, theme, font size, search, link resolving
  markdown/   the Markdown parser and renderer, block by block
  pages/      home page, doc page
  widgets/    sidebar, search dialog, nav, toggles, footer
  src/        theme and shared constants
```

## Markdown support

Headings, paragraphs, lists (ordered/unordered), tables, code blocks with
syntax highlighting, blockquotes, images, horizontal rules, and a "link card"
block for cross-references between docs. No external Markdown package —
parsing and rendering are both hand-rolled to keep the renderer's behavior
(link resolving between projects/versions, in-app navigation) tightly
coupled to how this app actually uses it.
