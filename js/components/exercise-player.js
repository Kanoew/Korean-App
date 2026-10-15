// Joue une suite d'exercices : vérifier → feedback → continuer. Renvoie les résultats via onDone.
import { esc, $, checkAnswer, xpFor, tagLabel } from '../utils/helpers.js';
import { renderExercise } from './exercise-types.js';
import { feedbackLine } from '../karina.js';
import { stopSpeaking } from '../utils/tts.js';

export function playExercises(root, { exercises, streakActive, label = '', onDone, onExit }) {
  let i = 0;
  const results = [];

  function show() {
    const ex = exercises[i];
    root.innerHTML = `
      <div class="player fade-in">
        <div class="player-top">
          <button class="icon-btn" id="quit" aria-label="Quitter">✕</button>
          <div class="progress"><div class="progress-bar" style="width:${(i / exercises.length) * 100}%"></div></div>
          <span class="muted small">${i + 1}/${exercises.length}</span>
        </div>
        ${label ? `<div class="player-label">${esc(label)}</div>` : ''}
        <div class="ex-card" id="ex"></div>
        <div class="feedback" id="fb" hidden></div>
        <div class="player-actions"><button class="btn primary block" id="main" disabled>Vérifier</button></div>
      </div>`;

    let answer = null;
    let phase = 'answering';
    const main = $('#main', root);
    const view = renderExercise(ex, $('#ex', root), {
      onAnswer: (v) => {
        answer = v;
        if (phase === 'answering') main.disabled = v == null || v === '';
      },
      onSubmit: () => {
        if (phase === 'answering' && !main.disabled) main.click();
      },
    });

    $('#quit', root).onclick = () => {
      if (confirm('Quitter la leçon ? Ta progression sur cette leçon sera perdue.')) {
        stopSpeaking();
        onExit();
      }
    };

    main.onclick = () => {
      if (phase === 'answering') {
        phase = 'feedback';
        stopSpeaking();
        const { result, expected } = checkAnswer(ex, answer);
        const xp = xpFor(result, streakActive);
        results.push({ ex, result, xp, given: answer });
        view.lock();
        view.reveal(result);
        showFeedback(ex, result, expected, xp);
        main.textContent = i + 1 === exercises.length ? 'Terminer' : 'Continuer';
        main.classList.toggle('wrong-btn', result === 'wrong');
        main.focus();
      } else {
        i += 1;
        if (i >= exercises.length) onDone(results);
        else show();
      }
    };
  }

  function showFeedback(ex, result, expected, xp) {
    const fb = $('#fb', root);
    fb.hidden = false;
    fb.className = `feedback ${result} slide-up`;
    const tags = (ex.tags || []).map((t) => `<span class="tag">${esc(tagLabel(t))}</span>`).join('');
    fb.innerHTML = `
      <div class="fb-head">${esc(feedbackLine(result))}${xp ? `<span class="xp-pop">+${xp} XP</span>` : ''}</div>
      ${result !== 'correct' ? `<div class="fb-answer">Réponse : <strong>${esc(expected)}</strong></div>` : ''}
      ${ex.explanation_fr ? `<div class="fb-expl">${esc(ex.explanation_fr)}</div>` : ''}
      ${result === 'wrong' && tags ? `<div class="fb-tags">${tags}</div>` : ''}`;
    $('#ex', root).classList.add(result === 'wrong' ? 'shake' : 'pulse');
  }

  show();
}
