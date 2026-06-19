// Small helpers around the Overwolf windows API.
// All functions are no-ops with a clear warning when run outside Overwolf
// (e.g. in a plain browser), so the windows can still be opened for preview.

const hasOverwolf = typeof overwolf !== 'undefined' && overwolf.windows;

export function isOverwolf() {
  return hasOverwolf;
}

export function getCurrentWindow() {
  return new Promise((resolve, reject) => {
    if (!hasOverwolf) {
      reject(new Error('overwolf API not available'));
      return;
    }
    overwolf.windows.getCurrentWindow((result) => {
      if (result && result.success) {
        resolve(result.window);
      } else {
        reject(new Error(result && result.error ? result.error : 'getCurrentWindow failed'));
      }
    });
  });
}

export function obtainWindow(name) {
  return new Promise((resolve, reject) => {
    if (!hasOverwolf) {
      reject(new Error('overwolf API not available'));
      return;
    }
    overwolf.windows.obtainDeclaredWindow(name, (result) => {
      if (result && result.success) {
        resolve(result.window);
      } else {
        reject(new Error(result && result.error ? result.error : `obtainDeclaredWindow(${name}) failed`));
      }
    });
  });
}

export async function restoreWindow(name) {
  const win = await obtainWindow(name);
  return new Promise((resolve, reject) => {
    overwolf.windows.restore(win.id, (result) => {
      if (result && result.success) {
        resolve();
      } else {
        reject(new Error(result && result.error ? result.error : `restore(${name}) failed`));
      }
    });
  });
}

export async function closeCurrentWindow() {
  if (!hasOverwolf) {
    window.close();
    return;
  }
  const win = await getCurrentWindow();
  overwolf.windows.close(win.id);
}
