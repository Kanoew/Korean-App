// Navigateur du curriculum : étages → unités → leçons.
import { state, isCompleted, isUnlocked, floorProgress, currentFloor } from '../state.js';
import { esc } from '../utils/helpers.js';

const TYPE = {
  teach: { icon: '📖', label: 'Cours' },
  practice: { icon: '✏️', label: 'Pratique' },
  review: { icon: '🔁', label: 'Révision' },
  boss: { icon: '👹', label: 'Boss' },
};

export async function render(root) {
  const cur = currentFloor();
  const floors = state.floors
    .map((floor) => {
      const fp = floorProgress(floor);
      const units = floor.units
        .map((unit) => {
          const lessons = unit.lessons
            .map((l) => {
              const lesson = state.lessons.find((x) => x.id === l.id);
              const done = isCompleted(l.id);
              const open = isUnlocked(lesson);
              const t = TYPE[l.lesson_type] || TYPE.practice;
              const best = state.progress.get(l.id)?.best_score;
              const status = done ? '✓' : open ? '▶' : '🔒';
              const inner = `
                <span class="node-icon">${t.icon}</span>
                <span class="node-text"><strong>${esc(l.title_fr)}</strong><small>${t.label}${best ? ` · meilleur ${Math.round(best * 100)}%` : ''}</small></span>
                <span class="node-status">${status}</span>`;
              return open
                ? `<a class="node ${done ? 'done' : 'open'}" href="#/lesson/${l.id}">${inner}</a>`
                : `<div class="node locked" aria-disabled="true">${inner}</div>`;
            })
            .join('');
          return `<div class="unit"><h4>${esc(unit.title_fr)} <span class="ko-title">${esc(unit.title_ko)}</span></h4>${lessons}</div>`;
        })
        .join('');
      return `
        <details class="floor" ${cur && floor.id === cur.id ? 'open' : ''}>
          <summary>
            <span class="floor-num">${floor.floor_number}F</span>
            <span class="floor-title"><strong>${esc(floor.title_fr)}</strong><small>${esc(floor.cefr_level)} · ${fp.done}/${fp.total}</small></span>
            <span class="progress mini"><span class="progress-bar" style="width:${Math.round(fp.ratio * 100)}%"></span></span>
          </summary>
          ${units}
        </details>`;
    })
    .join('');

  root.innerHTML = `
    <div class="fade-in">
      <h1>Apprendre</h1>
      <p class="muted">Monte la tour étage par étage. Chaque leçon s'ouvre quand la précédente est validée (70 %).</p>
      ${floors || '<div class="card center muted">Aucun contenu. Lance supabase/seed.sql dans le SQL Editor.</div>'}
    </div>`;
}
