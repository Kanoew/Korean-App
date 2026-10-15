// Parcours d'une leçon : intro (teach) → exercices → résultats. Gère aussi l'entraînement "points faibles".
import { state, isUnlocked, xpBoostActive } from '../state.js';
import { loadExercises, loadWeakExercises } from '../api/exercises.js';
import { loadWeaknesses, finishSession } from '../api/progress.js';
import { playExercises } from './exercise-player.js';
import { esc, $, spreadTypes, shuffle, tagLabel } from '../utils/helpers.js';
import { resultLine, floorClearLine } from '../karina.js';
import { speak, ttsSupported } from '../utils/tts.js';

const message = (root, html) => {
  root.innerHTML = `<div class="center stack fade-in">${html}<a class="btn ghost" href="#/">Retour</a></div>`;
};

export async function render(root, params) {
  const weakMode = location.hash.startsWith('#/weak');
  let lesson = null;
  let weakTags = [];

  if (!weakMode) {
    lesson = state.lessons.find((l) => l.id === Number(params[0]));
    if (!lesson || !isUnlocked(lesson)) {
      location.hash = '#/learn';
      return;
    }
  }

  root.innerHTML = '<div class="center muted">Chargement…</div>';
  let pool;
  try {
    if (weakMode) {
      weakTags = (await loadWeaknesses(state.user.id, 5)).map((w) => w.tag);
      pool = await loadWeakExercises(weakTags, 10);
    } else {
      pool = await loadExercises(lesson.id);
    }
  } catch (e) {
    console.error(e);
    return message(root, `<p class="msg error">Impossible de charger les exercices.<br><small>${esc(e.message)}</small></p>`);
  }

  if (!pool.length) {
    return message(
      root,
      weakMode
        ? '<h2>Aucun point faible actif 🎉</h2><p class="muted">Rien à travailler en ciblé pour l\'instant. Continue le parcours !</p>'
        : '<h2>Cette leçon est vide</h2><p class="muted">Les exercices n\'ont pas encore été ajoutés (as-tu lancé seed.sql ?).</p>',
    );
  }

  const limit = lesson?.lesson_type === 'boss' ? 12 : 10;
  const exercises = spreadTypes(shuffle(pool).slice(0, limit), 3);
  const startedAt = new Date();
  const streakActive = xpBoostActive();
  const label = weakMode ? `Points faibles · ${weakTags.map(tagLabel).join(', ')}` : `${lesson.unit.title_fr} · ${lesson.title_fr}`;

  const startPlayer = () =>
    playExercises(root, {
      exercises,
      streakActive,
      label,
      onExit: () => (location.hash = weakMode ? '#/' : '#/learn'),
      onDone: async (results) => {
        root.innerHTML = '<div class="center muted">On compte tes points…</div>';
        try {
          const summary = await finishSession({ lesson, results, startedAt });
          showResults(root, lesson, summary);
        } catch (e) {
          console.error(e);
          message(root, `<p class="msg error">Résultats non enregistrés.<br><small>${esc(e.message)}</small></p>`);
        }
      },
    });

  const content = lesson?.content_json;
  if (content?.sections?.length) showIntro(root, lesson, content, startPlayer);
  else startPlayer();
}

function showIntro(root, lesson, content, start) {
  const example = (ex) => `
    <li class="example">
      <div class="ko">${esc(ex.ko)}${ttsSupported ? ` <button class="icon-btn" data-speak="${esc(ex.ko)}" aria-label="Écouter">🔊</button>` : ''}</div>
      <div class="rom">(${esc(ex.rom)})</div>
      <div class="fr">${esc(ex.fr)}</div>
    </li>`;
  root.innerHTML = `
    <div class="intro fade-in">
      <a class="back" href="#/learn">← Retour</a>
      <div class="badge">📖 ${esc(lesson.unit.title_fr)}</div>
      <h1>${esc(lesson.title_fr)} <span class="ko-title">${esc(lesson.title_ko)}</span></h1>
      ${content.intro ? `<p class="lead">${esc(content.intro)}</p>` : ''}
      ${content.sections
        .map(
          (s) => `<section class="card">
            <h3>${esc(s.title)}</h3>
            <p>${esc(s.body)}</p>
            ${s.examples?.length ? `<ul class="examples">${s.examples.map(example).join('')}</ul>` : ''}
          </section>`,
        )
        .join('')}
      ${content.tip ? `<div class="tip">💡 ${esc(content.tip)}</div>` : ''}
      <button class="btn primary block" id="go">C'est parti 💪</button>
    </div>`;
  root.querySelectorAll('[data-speak]').forEach((b) => (b.onclick = () => speak(b.dataset.speak)));
  $('#go', root).onclick = start;
  window.scrollTo(0, 0);
}

function showResults(root, lesson, s) {
  const pct = Math.round(s.score * 100);
  const next = lesson ? state.lessons[lesson.index + 1] : null;
  const emoji = s.passed ? (s.score === 1 ? '🌟' : '✅') : '💪';
  root.innerHTML = `
    <div class="results center stack fade-in">
      <div class="results-emoji pop">${s.floorCleared ? '🏆' : emoji}</div>
      <h1>${s.weak ? 'Entraînement terminé' : s.passed ? 'Leçon validée !' : 'Pas encore…'}</h1>
      <div class="score-ring"><strong>${pct}%</strong><span>${s.correct}/${s.attempted} justes${s.partial ? ` · ${s.partial} presque` : ''}</span></div>
      <div class="stat-row">
        <div class="stat"><strong>+${s.xpEarned}</strong><span>XP${s.bonus ? ` (dont ${s.bonus} de bonus)` : ''}</span></div>
        <div class="stat"><strong>🔥 ${s.streak}</strong><span>jour${s.streak > 1 ? 's' : ''} de série</span></div>
      </div>
      <p class="karina-line">${esc(s.floorCleared ? floorClearLine(s.floorCleared.title_fr) : resultLine({ score: s.score, passed: s.passed, boss: s.boss }))}</p>
      <div class="stack w100">
        ${s.passed && next ? `<a class="btn primary block" href="#/lesson/${next.id}">Leçon suivante →</a>` : ''}
        ${!s.passed && lesson ? `<a class="btn primary block" href="#/lesson/${lesson.id}" id="retry">Réessayer</a>` : ''}
        <a class="btn ghost block" href="#/${s.weak ? '' : 'learn'}">Retour</a>
      </div>
    </div>`;
  // Même route → forcer le rechargement quand on rejoue la même leçon
  const retry = $('#retry', root);
  if (retry) retry.onclick = (e) => { e.preventDefault(); window.dispatchEvent(new HashChangeEvent('hashchange')); };
}
