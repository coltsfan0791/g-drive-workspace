import { isOverwolf } from '../../utils/overwolf-utils.js';

const statusEl = document.getElementById('overlay-status');

if (isOverwolf()) {
  overwolf.games.getRunningGameInfo((info) => {
    if (info && info.isRunning) {
      statusEl.textContent = `Overlay active in ${info.title}.`;
    }
  });
} else {
  statusEl.textContent = 'Overlay preview (Overwolf not detected).';
}
