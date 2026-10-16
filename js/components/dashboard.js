import { state, nextLesson, currentFloor, currentStreak } from '../state.js';
import { loadWeaknesses } from '../api/progress.js';
import { signOut } from '../auth.js';
import { esc, $, tagLabel, todayStr, daysBetween } from '../utils/helpers.js';
import { greeting } from '../karina.js';
import { renderFloorMap } from './floor-map.js';
import { AVATAR } from '../utils/sprites.js';

export async function render(root) {
  const p = state.profile;
  const floor = currentFloor();
  const next = nextLesson();
  const streak = currentStreak(p);
  const gapDays = p.last_session_date ? daysBetween(p.last_session_date, todayStr()) : null;
  const hello = greeting({ name: p.display_name || 'Jordan', hour: new Date().getHours(), streak, gapDays });

  root.innerHTML = `
    <div class="dash fade-in">
      <header class="dash-top">
        <img class="avatar-img" src="${AVATAR}" alt="Karina" width="64" height="64">
        <div class="dash-title">
          <div class="muted small">${esc(p.current_level)} · Étage ${esc(floor?.floor_number ?? 1)} / 100</div>
          <h1>${esc(floor?.title_fr ?? 'Bienvenue')} <span class="ko-title">${esc(floor?.title_ko ?? '')}</span></h1>
        </div>
        <button class="icon-btn" id="logout" aria-label="Se déconnecter" title="Se déconnecter">⎋</button>
      </header>

      <div class="card karina"><img class="avatar-img sm" src="${AVATAR}" alt="Karina" width="44" height="44"><p>${esc(hello)}</p></div>

      <div class="stat-row">
        <div class="stat"><strong>🔥 ${streak}</strong><span>jour${streak > 1 ? 's' : ''} de série</span></div>
        <div class="stat gold"><strong>✨ ${p.xp ?? 0}</strong><span>XP</span></div>
      </div>

      ${
        next
          ? `<a class="btn primary block big" href="#/lesson/${next.id}">▶ Continuer<small>${esc(next.unit.title_fr)} · ${esc(next.title_fr)}</small></a>`
          : '<div class="card center"><strong>🏆 Tout le contenu actuel est terminé !</strong><p class="muted">Les étages suivants arrivent en V1.</p></div>'
      }

      <div id="floor-map"></div>

      <div class="grid-2">
        <a class="btn ghost block" href="#/review">🔄 Révisions <small>bientôt</small></a>
        <a class="btn ghost block" href="#/weak">🎯 Points faibles</a>
      </div>

      <div class="card" id="weak-card"><strong>Tes points faibles</strong><p class="muted small">Chargement…</p></div>
    </div>`;

  $('#logout', root).onclick = () => signOut();
  renderFloorMap($('#floor-map', root));

  const box = $('#weak-card', root);
  try {
    const weak = await loadWeaknesses(state.user.id, 3);
    box.innerHTML = weak.length
      ? `<strong>Tes points faibles</strong><ul class="weak-list">${weak
          .map((w) => `<li><span>${esc(tagLabel(w.tag))}</span><span class="muted small">${w.error_count} erreur${w.error_count > 1 ? 's' : ''}</span></li>`)
          .join('')}</ul>`
      : '<strong>Tes points faibles</strong><p class="muted small">Rien à signaler pour le moment. Ça viendra, ne t\'inquiète pas 😏</p>';
  } catch {
    box.innerHTML = '<strong>Tes points faibles</strong><p class="muted small">Indisponible pour le moment.</p>';
  }
}
