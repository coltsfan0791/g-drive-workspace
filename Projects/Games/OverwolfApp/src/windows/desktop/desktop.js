import { isOverwolf, closeCurrentWindow } from '../../utils/overwolf-utils.js';

const statusEl = document.getElementById('status');
const closeBtn = document.getElementById('closeBtn');

closeBtn.addEventListener('click', () => {
  closeCurrentWindow().catch((err) => console.error(err));
});

if (isOverwolf()) {
  overwolf.games.getRunningGameInfo((info) => {
    statusEl.textContent = info && info.isRunning
      ? `Detected game: ${info.title}`
      : 'No game running.';
  });
} else {
  statusEl.textContent = 'Running outside Overwolf (preview mode).';
}
