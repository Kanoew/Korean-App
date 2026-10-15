import { state, currentStreak } from '../state.js';
import { loadSessions } from '../api/progress.js';
import { esc, tagLabel, dateStr } from '../utils/helpers.js';

export async function render(root) {
  root.innerHTML = '<div class="center muted">Chargement…</div>';
  let sessions = [];
  try {
    sessions = await loadSessions(state.user.id, 100);
  } catch (e) {
    root.innerHTML = `<p class="msg error">Statistiques indisponibles.<br><small>${esc(e.message)}</small></p>`;
    return;
  }

  const attempted = sessions.reduce((s, x) => s + x.exercises_attempted, 0);
  const correct = sessions.reduce((s, x) => s + x.exercises_correct, 0);
  const seconds = sessions.reduce((s, x) => s + (x.duration_seconds || 0), 0);
  const accuracy = attempted ? Math.round((correct / attempted) * 100) : 0;
  const done = [...state.progress.values()].filter((p) => p.completed).length;

  // XP des 7 derniers jours
  const days = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    days.push({ key: dateStr(d), label: d.toLocaleDateString('fr-FR', { weekday: 'short' }).slice(0, 3), xp: 0 });
  }
  for (const s of sessions) {
    const d = days.find((x) => x.key === dateStr(new Date(s.started_at)));
    if (d) d.xp += s.xp_earned || 0;
  }
  const max = Math.max(10, ...days.map((d) => d.xp));

  const weakCount = new Map();
  for (const s of sessions) for (const t of s.weak_points || []) weakCount.set(t, (weakCount.get(t) || 0) + 1);
  const topWeak = [...weakCount.entries()].sort((a, b) => b[1] - a[1]).slice(0, 5);

  root.innerHTML = `
    <div class="fade-in">
      <h1>Statistiques</h1>
      <div class="stat-row">
        <div class="stat gold"><strong>✨ ${state.profile.xp ?? 0}</strong><span>XP total</span></div>
        <div class="stat"><strong>🔥 ${currentStreak()}</strong><span>série</span></div>
      </div>
      <div class="stat-row">
        <div class="stat"><strong>${done}/${state.lessons.length}</strong><span>leçons validées</span></div>
        <div class="stat"><strong>${accuracy}%</strong><span>réussite</span></div>
      </div>
      <div class="card">
        <strong>XP — 7 derniers jours</strong>
        <div class="bars">${days
          .map((d) => `<div class="bar-col"><div class="bar" style="height:${Math.round((d.xp / max) * 100)}%" title="${d.xp} XP"></div><span>${esc(d.label)}</span></div>`)
          .join('')}</div>
      </div>
      <div class="card">
        <strong>Points faibles récurrents</strong>
        ${
          topWeak.length
            ? `<ul class="weak-list">${topWeak.map(([t, n]) => `<li><span>${esc(tagLabel(t))}</span><span class="muted small">${n} session${n > 1 ? 's' : ''}</span></li>`).join('')}</ul>`
            : '<p class="muted small">Pas encore de données.</p>'
        }
      </div>
      <p class="muted small center">${sessions.length} session${sessions.length > 1 ? 's' : ''} · ${Math.round(seconds / 60)} min au total</p>
    </div>`;
}
