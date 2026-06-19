# Development Notes

## Windows
- `background` is the `start_window`. It runs headless and routes the user to
  either the `desktop` or `overlay` window based on `getRunningGameInfo`.
- `overlay` is `in_game_only` + `transparent`; `desktop` is `desktop_only` +
  `native_window`.

## Adding a game
Add the relevant game IDs to a `game_targeting` / `launch_events` block in
`manifest.json` once a specific game is targeted. The current scaffold does not
target a specific game.

## API wrappers
`src/utils/overwolf-utils.js` wraps the callback-based Overwolf APIs in Promises
and no-ops outside Overwolf so the windows can be previewed in a browser.

## Conventions
- ES modules (`type="module"`) for all window scripts.
- Shared styles live in `assets/css/common.css`; per-window styles sit next to
  their HTML.
