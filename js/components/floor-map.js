// Carte des étages : Jordan se tient à sa leçon courante et marche (translateX/translateY)
// quand elle avance ou change d'étage depuis ta dernière visite.
import { state, currentFloor, floorProgress } from '../state.js';
import { esc } from '../utils/helpers.js';
import { useSprite } from '../utils/sprites.js';

const POS_KEY = 'karina-pos';
const readPos = () => {
  try {
    return JSON.parse(localStorage.getItem(POS_KEY));
  } catch {
    return null;
  }
};
const writePos = (v) => {
  try {
    localStorage.setItem(POS_KEY, JSON.stringify(v));
  } catch {
    /* stockage indisponible : pas grave */
  }
};
const reducedMotion = () => window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;

let onResize = null; // un seul écouteur actif à la fois

export function renderFloorMap(box) {
  if (onResize) window.removeEventListener('resize', onResize);
  onResize = null;

  const cur = currentFloor();
  if (!cur || !state.floors.length) {
    box.innerHTML = '';
    return;
  }

  // Fenêtre autour de l'étage courant (utile quand la tour grandira)
  const shown = state.floors
    .filter((f) => f.floor_number >= cur.floor_number - 1 && f.floor_number <= cur.floor_number + 2)
    .sort((a, b) => b.floor_number - a.floor_number);
  const top = state.floors[state.floors.length - 1];
  const teaser = shown[0].id === top.id; // pas d'étage au-dessus dans la base : on annonce la suite

  const rows = shown.map((floor) => {
    const fp = floorProgress(floor);
    const lessons = state.lessons.filter((l) => l.floor.id === floor.id);
    const status = floor.id === cur.id ? 'current' : floor.floor_number < cur.floor_number ? 'cleared' : 'locked';
    const dots = lessons
      .map((l, i) => `<span class="fm-dot ${i < fp.done ? 'done' : i === fp.done && status === 'current' ? 'next' : ''}"></span>`)
      .join('');
    const meta = status === 'locked' ? '🔒' : status === 'cleared' ? '✓' : `${fp.done}/${fp.total}`;
    return `
      <div class="fm-row ${status}" data-floor="${floor.floor_number}">
        <div class="fm-label"><strong>${esc(floor.floor_number)}F</strong><small>${esc(floor.title_fr)}</small><small class="fm-meta">${meta}</small></div>
        <div class="fm-track">${dots}</div>
      </div>`;
  });
  if (teaser) {
    rows.unshift(`<div class="fm-row locked ghost"><div class="fm-label"><strong>?</strong><small>Prochain étage</small><small class="fm-meta">bientôt</small></div><div class="fm-track"></div></div>`);
  }

  box.innerHTML = `
    <div class="fm card" aria-label="Progression dans la tour">
      ${rows.join('')}
      <div class="fm-karina"><img class="sprite" alt="Jordan" draggable="false"></div>
    </div>`;

  const fm = box.querySelector('.fm');
  const holder = fm.querySelector('.fm-karina');
  const img = holder.querySelector('img');
  useSprite(img, 'jordan');

  // Position (coin haut-gauche du sprite) correspondant à une leçon d'un étage
  const spot = (floorNumber, index) => {
    const row = fm.querySelector(`.fm-row[data-floor="${floorNumber}"]`);
    if (!row) return null;
    const dots = row.querySelectorAll('.fm-dot');
    if (!dots.length) return null;
    const dot = dots[Math.max(0, Math.min(index, dots.length - 1))];
    const f = fm.getBoundingClientRect();
    const d = dot.getBoundingClientRect();
    const r = row.getBoundingClientRect();
    const h = holder.offsetHeight || 120;
    const w = holder.offsetWidth || h * 0.25;
    return { x: d.left + d.width / 2 - f.left - w / 2, y: r.bottom - f.top - h - 6 };
  };
  const put = (p, animate) => {
    holder.style.transition = animate ? 'transform 1.7s cubic-bezier(0.45, 0, 0.25, 1)' : 'none';
    holder.style.transform = `translate(${p.x}px, ${p.y}px)`;
  };

  const target = { floor: cur.floor_number, idx: floorProgress(cur).done };
  const to = spot(target.floor, target.idx);
  if (!to) return;
  const previous = readPos();
  const from = previous && (previous.floor !== target.floor || previous.idx !== target.idx) ? spot(previous.floor, previous.idx) || spot(target.floor, 0) : null;

  holder.classList.add('ready');
  if (!from || reducedMotion()) {
    put(to, false);
  } else {
    // Marche de l'ancienne position vers la nouvelle
    holder.classList.toggle('flip', to.x > from.x); // le sprite regarde vers la gauche : on le retourne pour aller à droite
    put(from, false);
    holder.getBoundingClientRect(); // force le reflow
    holder.classList.add('walking');
    let finished = false;
    const done = () => {
      if (finished) return;
      finished = true;
      holder.classList.remove('walking', 'flip');
    };
    holder.addEventListener('transitionend', done, { once: true });
    setTimeout(done, 2300);
    requestAnimationFrame(() => requestAnimationFrame(() => put(to, true)));
  }
  writePos(target);

  // Réajuste sans animation si la fenêtre change de taille
  onResize = () => {
    if (!holder.classList.contains('walking')) {
      const p = spot(target.floor, target.idx);
      if (p) put(p, false);
    }
  };
  window.addEventListener('resize', onResize);
}
