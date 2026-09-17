# pdoc

My personal docs site — references for tools I use daily (git, ffmpeg,
imagemagick) and docs for packages I've written (`pdata`, `penv`, `ptgb`,
`ptgc`).

## Get it

- **Web**: [doc.psdkjoon.ir](https://doc.psdkjoon.ir) or
  [doc.psdk.space](https://doc.psdk.space)
- **Android**: grab the APK from
  [Releases](https://github.com/psdkjoon/pdoc/releases)
- **Linux**: grab the AppImage from
  [Releases](https://github.com/psdkjoon/pdoc/releases)

  ```bash
  chmod +x pdoc-x86_64.AppImage
  ./pdoc-x86_64.AppImage
  ```

  To install it system-wide (desktop entry, icon, binary in
  `~/.local/bin`):

  ```bash
  ./pdoc-x86_64.AppImage --install
  ```

  To remove it again:

  ```bash
  ./pdoc-x86_64.AppImage --uninstall
  ```

## Running from source

```bash
flutter pub get
flutter run -d chrome/linux/android
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
