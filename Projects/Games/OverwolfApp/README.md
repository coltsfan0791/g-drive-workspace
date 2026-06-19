# OverwolfApp

A minimal [Overwolf](https://overwolf.github.io/) app scaffold with three declared windows:

- **background** — a hidden controller window (`is_background_page`) that decides which window to open on launch.
- **desktop** — a native desktop window shown when no game is running.
- **overlay** — a transparent in-game overlay window.

## Structure

```
manifest.json            Overwolf app manifest (window + permission declarations)
icons/                   App icons referenced by the manifest
assets/css/common.css    Shared styles
src/
  background/            Controller window
  windows/desktop/       Desktop window (HTML/CSS/JS)
  windows/overlay/       In-game overlay window (HTML/CSS/JS)
  utils/overwolf-utils.js  Promise wrappers around the Overwolf windows API
```

## Develop / load

1. `npm install`
2. `npm run lint` and `npm run validate-manifest`
3. In the Overwolf client, enable developer options and **Load unpacked extension**, then select this folder.

The window scripts degrade gracefully when the `overwolf` API is unavailable, so the HTML can also be opened directly in a browser for a quick visual preview.
