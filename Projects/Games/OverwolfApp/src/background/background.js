// Background (controller) window.
// Decides which window to show on launch: the desktop window when not in a
// game, and the in-game overlay otherwise.

import { isOverwolf, restoreWindow } from '../utils/overwolf-utils.js';

async function launch() {
  if (!isOverwolf()) {
    console.warn('overwolf API not available - background controller idle.');
    return;
  }

  overwolf.games.getRunningGameInfo((info) => {
    const inGame = info && info.isRunning && info.isInFocus;
    const target = inGame ? 'overlay' : 'desktop';
    restoreWindow(target).catch((err) => console.error('Failed to open window', err));
  });
}

launch();
