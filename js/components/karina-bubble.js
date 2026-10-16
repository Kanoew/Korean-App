// Bulle de dialogue de Karina.
// - Sans ancre : Karina (sprite) apparaît en surimpression en bas à droite avec sa bulle.
// - Avec une ancre (ex. le héros de l'écran de résultats) : la bulle se pose au-dessus du sprite déjà affiché.
// Disparaît seule après 4 s ou au toucher ; les messages suivants s'enchaînent.
import { esc } from '../utils/helpers.js';
import { spriteImg, hydrateSprites } from '../utils/sprites.js';

export const BUBBLE_MS = 4000;
let el = null;
let timer = null;
let queue = [];

function remove() {
  clearTimeout(timer);
  timer = null;
  el?.remove();
  el = null;
}

function next() {
  remove();
  const item = queue.shift();
  if (item) display(item);
}

function display({ text, pose, anchor }) {
  el = document.createElement('div');
  el.className = anchor ? 'kb kb-anchored' : 'kb kb-overlay';
  el.setAttribute('role', 'status');
  el.setAttribute('aria-live', 'polite');
  el.innerHTML = `<div class="kb-bubble">${esc(text)}</div>${anchor ? '' : spriteImg(pose)}`;
  (anchor || document.body).appendChild(el);
  if (!anchor) hydrateSprites(el);
  el.addEventListener('click', next);
  timer = setTimeout(next, BUBBLE_MS);
}

// interrupt : remplace tout de suite ce qui est affiché (retours de réponse, piques…).
// sinon le message est mis en file et s'affiche après les précédents.
export function say(text, { pose = 'idle', anchor = null, interrupt = true } = {}) {
  if (!text) return;
  const item = { text, pose, anchor };
  if (interrupt) {
    queue = [];
    remove();
    display(item);
  } else if (el) {
    queue.push(item);
  } else {
    display(item);
  }
}

export const sayAll = (texts, opts = {}) => texts.forEach((t) => say(t, { ...opts, interrupt: false }));

export function clearBubble() {
  queue = [];
  remove();
}
