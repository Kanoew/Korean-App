// Onglet « Récompenses » : la galerie de Karina.
// Contenu TEMPORAIRE : la liste vit ici (js/components/rewards.js) ; plus tard elle passera dans la base.
// Les images se déposent dans assets/gallery/. Un déblocage est mémorisé sur l'appareil (localStorage),
// pour qu'une récompense gagnée ne se reverrouille jamais (ex. série interrompue).
import { state, floorProgress } from '../state.js';
import { summarize } from '../srs.js';
import { esc, $, $$, todayStr } from '../utils/helpers.js';

const floorCleared = (n) => {
  const floor = state.floors.find((f) => f.floor_number === n);
  return !!floor && floorProgress(floor).ratio === 1;
};

export const REWARDS = [
  {
    id: 'floor-1',
    kind: 'image',
    title: 'Trace sur la vitre',
    hint: 'Termine l\'étage 1',
    image: 'assets/gallery/kiss-glass.webp',
    unlocked: () => floorCleared(1),
  },
  { id: 'floor-2', kind: 'image', title: 'Image à venir', hint: 'Termine l\'étage 2', image: null, unlocked: () => floorCleared(2) },
  { id: 'floor-3', kind: 'image', title: 'Image à venir', hint: 'Termine l\'étage 3', image: null, unlocked: () => floorCleared(3) },
  {
    id: 'streak-7',
    kind: 'badge',
    title: 'Semaine de feu',
    emoji: '🔥',
    hint: '7 jours de série',
    unlocked: () => (state.profile?.streak_days || 0) >= 7,
  },
  { id: 'xp-1000', kind: 'badge', title: 'Mille et un', emoji: '✨', hint: '1 000 XP', unlocked: () => (state.profile?.xp || 0) >= 1000 },
  {
    id: 'first-mastered',
    kind: 'badge',
    title: 'Mémoire d\'éléphant',
    emoji: '🧠',
    hint: 'Une carte de révision acquise (J+16)',
    unlocked: () => summarize(state.srs.cards, todayStr()).mastered >= 1,
  },
];

// Mémoire locale des déblocages, par utilisateur
const storeKey = () => `kr-rewards-${state.user?.id || 'anon'}`;
function remembered() {
  try {
    return new Set(JSON.parse(localStorage.getItem(storeKey()) || '[]'));
  } catch {
    return new Set();
  }
}
function remember(ids) {
  try {
    localStorage.setItem(storeKey(), JSON.stringify([...ids]));
  } catch {
    /* stockage indisponible : le déblocage se recalcule à chaque visite */
  }
}

export function unlockedIds() {
  const ids = remembered();
  let changed = false;
  for (const r of REWARDS) {
    if (!ids.has(r.id) && r.unlocked()) {
      ids.add(r.id);
      changed = true;
    }
  }
  if (changed) remember(ids);
  return ids;
}

export function render(root) {
  const ids = unlockedIds();
  const tile = (r) => {
    const open = ids.has(r.id);
    const art =
      r.kind === 'badge'
        ? `<div class="tile-badge">${r.emoji}</div>`
        : r.image
          ? `<img src="${esc(r.image)}" alt="${open ? esc(r.title) : ''}" loading="lazy">`
          : open ? '<div class="tile-badge">🖼️</div>' : '';
    return `
      <button type="button" class="tile ${r.kind} ${open ? 'open' : 'locked'}" data-id="${r.id}" ${open ? '' : 'aria-label="Verrouillé"'}>
        <div class="tile-art">${art}${open ? '' : '<span class="lock">🔒</span>'}</div>
        <div class="tile-cap"><strong>${esc(open ? r.title : '???')}</strong><span>${esc(open ? (r.image || r.kind === 'badge' ? 'Débloqué' : 'Bientôt') : r.hint)}</span></div>
      </button>`;
  };
  root.innerHTML = `
    <div class="gallery fade-in">
      <h1>🎖️ Récompenses</h1>
      <p class="muted">${ids.size} / ${REWARDS.length} débloquées · galerie temporaire, d'autres images arrivent.</p>
      <div class="tiles">${REWARDS.map(tile).join('')}</div>
    </div>`;
  $$('.tile.open', root).forEach((t) => {
    const r = REWARDS.find((x) => x.id === t.dataset.id);
    if (r.image) t.onclick = () => openViewer(r);
  });
}

function openViewer(r) {
  const view = document.createElement('div');
  view.className = 'viewer fade-in';
  view.setAttribute('role', 'dialog');
  view.setAttribute('aria-label', r.title);
  view.innerHTML = `<img src="${esc(r.image)}" alt="${esc(r.title)}"><div class="viewer-cap">${esc(r.title)}</div><button type="button" class="icon-btn" aria-label="Fermer">✕</button>`;
  const close = () => {
    view.remove();
    document.removeEventListener('keydown', onKey);
  };
  const onKey = (e) => e.key === 'Escape' && close();
  view.onclick = close;
  document.addEventListener('keydown', onKey);
  document.body.appendChild(view);
}
