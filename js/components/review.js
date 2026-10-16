// Onglet « Réviser » : révisions espacées J+1 / J+3 / J+7 / J+16.
import { state } from '../state.js';
import { finishSession } from '../api/progress.js';
import { recordReviews } from '../api/srs.js';
import { playExercises } from './exercise-player.js';
import { STEPS, SESSION_SIZE, buildQueue, summarize } from '../srs.js';
import { esc, $, spreadTypes, todayStr, daysBetween, tagLabel } from '../utils/helpers.js';
import { reviewPromptMessage, resultLine } from '../karina.js';
import { xpBoostActive } from '../state.js';
import { clearBubble } from './karina-bubble.js';
import { spriteImg, hydrateSprites, showLoading } from '../utils/sprites.js';

const frDate = (day) => {
  const gap = daysBetween(todayStr(), day);
  if (gap === 1) return 'demain';
  const [y, m, d] = day.split('-').map(Number);
  return `dans ${gap} jours (${new Date(y, m - 1, d).toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long' })})`;
};
const plural = (n, one, many) => `${n} ${n > 1 ? many : one}`;

export const dueCount = () => (state.srs.available ? summarize(state.srs.cards, todayStr()).due : 0);

export function render(root) {
  const today = todayStr();
  const { available, cards } = state.srs;
  const s = summarize(cards, today);
  const queue = buildQueue(cards, today);

  if (!available) {
    root.innerHTML = `
      <div class="center stack fade-in soon">
        <div class="results-emoji">🔄</div>
        <h1>Révisions</h1>
        <p class="muted">Les cartes de révision ne sont pas encore prêtes dans la base.</p>
        <p class="msg error">Rejoue <code>supabase/schema.sql</code> dans Supabase → SQL Editor (rejouable sans danger), puis recharge l'app.</p>
        <a class="btn ghost" href="#/">Retour à l'accueil</a>
      </div>`;
    return;
  }

  const labels = STEPS.map((d) => `J+${d}`);
  const ladder = s.byStep
    .map((n, i) => `<div class="rung ${n ? 'on' : ''}"><strong>${n}</strong><span>${labels[i]}</span></div>`)
    .join('') + `<div class="rung ${s.mastered ? 'on done' : ''}"><strong>${s.mastered}</strong><span>✓ acquises</span></div>`;

  const hello =
    reviewPromptMessage({ overdue: s.overdue > 0 }) ||
    (s.overdue > 0 ? 'Elles attendent depuis un moment, mon chou… On les rattrape ensemble ? 😏' : s.due ? 'Quelques petites révisions, rien de méchant. Cinq minutes ?' : 'Rien à réviser aujourd\'hui. Profites-en, ou file grimper un étage 😌');

  let action;
  if (s.due) {
    const n = queue.length;
    action = `<button class="btn primary block big" id="start">▶ Réviser ${plural(n, 'carte', 'cartes')}${s.due > n ? `<small>${s.due - n} de plus après celle-ci</small>` : ''}</button>`;
  } else if (s.total) {
    action = `<div class="card center"><strong>✅ Tout est à jour</strong><p class="muted small">${s.nextDate ? `Prochaine révision ${esc(frDate(s.nextDate))}.` : 'Toutes tes cartes sont acquises.'}</p></div>`;
  } else {
    action = `<div class="card"><strong>Pas encore de cartes</strong><p class="muted small">Une carte naît quand tu rates un exercice, et quelques-unes à la première validation de chaque leçon. Elles reviennent à J+1, J+3, J+7 puis J+16.</p><a class="btn primary block" href="#/learn">Aller apprendre</a></div>`;
  }

  root.innerHTML = `
    <div class="review fade-in">
      <h1>🔄 Révisions <span class="ko-title">복습</span></h1>
      <div class="card karina"><p>${esc(hello)}</p></div>
      <div class="stat-row">
        <div class="stat ${s.due ? 'gold' : ''}"><strong>${s.due}</strong><span>à réviser${s.overdue ? ` · ${s.overdue} en retard` : ''}</span></div>
        <div class="stat"><strong>${s.total ? s.tomorrow : 0}</strong><span>demain · ${s.week} cette semaine</span></div>
      </div>
      ${action}
      <h4>Où en sont tes cartes</h4>
      <div class="ladder">${ladder}</div>
      <p class="muted small">Chaque réussite fait monter une carte d'un cran : J+1 → J+3 → J+7 → J+16, puis elle est acquise. Une erreur la renvoie au début.</p>
    </div>`;

  const start = $('#start', root);
  if (start) start.onclick = () => startSession(root, queue);
}

function startSession(root, queue) {
  // Chaque carte rejoue l'exercice d'origine ; srs_key sert à retrouver la carte au retour
  const exercises = spreadTypes(queue.map((c) => ({ ...c.exercise, srs_key: c.source_key })), 3);
  const startedAt = new Date();
  playExercises(root, {
    exercises,
    streakActive: xpBoostActive(),
    label: 'Révision espacée',
    onExit: () => (location.hash = '#/review'),
    onDone: async (results) => {
      showLoading(root, 'Karina range tes cartes…');
      try {
        const summary = await finishSession({ lesson: null, results, startedAt, review: true });
        let changes = [];
        try {
          changes = await recordReviews(results);
        } catch (e) {
          console.error(e);
        }
        showResults(root, summary, changes);
      } catch (e) {
        console.error(e);
        root.innerHTML = `<div class="center stack fade-in"><p class="msg error">Résultats non enregistrés.<br><small>${esc(e.message)}</small></p><a class="btn ghost" href="#/review">Retour</a></div>`;
      }
    },
  });
}

function showResults(root, s, changes) {
  const pct = Math.round(s.score * 100);
  const promoted = changes.filter((c) => c.result === 'correct' && c.patch.status !== 'mastered').length;
  const mastered = changes.filter((c) => c.patch.status === 'mastered').length;
  const back = changes.filter((c) => c.result === 'wrong').length;
  const left = summarize(state.srs.cards, todayStr());
  const weakTags = [...new Set(changes.filter((c) => c.result === 'wrong').flatMap((c) => c.card.tags || []))].map(tagLabel);
  root.innerHTML = `
    <div class="results center stack fade-in">
      <div class="results-hero">${spriteImg(s.score >= 0.8 ? 'celebrate' : 'idle', s.score >= 0.8 ? 'cheer' : '')}</div>
      <h1>Révision terminée</h1>
      <div class="score-ring"><strong>${pct}%</strong><span>${s.correct}/${s.attempted} justes${s.partial ? ` · ${s.partial} presque` : ''}</span></div>
      <div class="stat-row">
        <div class="stat"><strong>+${s.xpEarned}</strong><span>XP</span></div>
        <div class="stat"><strong>🔥 ${s.streak}</strong><span>jour${s.streak > 1 ? 's' : ''} de série</span></div>
      </div>
      <div class="card w100 left">
        ${promoted ? `<p>⬆️ ${plural(promoted, 'carte monte', 'cartes montent')} d'un cran</p>` : ''}
        ${mastered ? `<p>🎓 ${plural(mastered, 'carte acquise', 'cartes acquises')} !</p>` : ''}
        ${back ? `<p>↩️ ${plural(back, 'carte repart', 'cartes repartent')} à J+1${weakTags.length ? ` <span class="muted small">(${esc(weakTags.join(', '))})</span>` : ''}</p>` : ''}
        <p class="muted small">${left.due ? `Il en reste ${left.due} à réviser aujourd'hui.` : left.nextDate ? `Prochaine révision ${esc(frDate(left.nextDate))}.` : 'Tout est acquis.'}</p>
      </div>
      <p class="karina-line">${esc(resultLine({ score: s.score, passed: s.score >= 0.7, boss: false }))}</p>
      <div class="stack w100">
        ${left.due ? '<a class="btn primary block" href="#/review" id="more">Continuer à réviser</a>' : ''}
        <a class="btn ghost block" href="#/">Retour à l'accueil</a>
      </div>
    </div>`;
  hydrateSprites(root);
  clearBubble();
  const more = $('#more', root);
  if (more) more.onclick = (e) => { e.preventDefault(); render(root); window.scrollTo(0, 0); };
}
