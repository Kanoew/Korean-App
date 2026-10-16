// Joue une suite d'exercices : vérifier → feedback → continuer. Renvoie les résultats via onDone.
// Karina parle par bulle : retour après chaque réponse, pique après 30 s d'inactivité,
// et (15 % du temps) un mot flirty entre deux exercices.
import { esc, $, checkAnswer, xpFor, tagLabel } from '../utils/helpers.js';
import { renderExercise } from './exercise-types.js';
import {
  fallbackFeedbackLine, feedbackLabel, correctMessage, wrongMessage,
  idleTeaseMessage, rollFlirty, flirtyMessage, IDLE_TEASE_MS,
} from '../karina.js';
import { say, clearBubble } from './karina-bubble.js';
import { stopSpeaking } from '../utils/tts.js';
import { reportExercise } from '../api/reports.js';
import { evaluateProduction } from '../api/llm.js';

export function playExercises(root, { exercises, streakActive, label = '', onDone, onExit }) {
  let i = 0;
  const results = [];
  let correctStreak = 0;
  let wrongStreak = 0;
  let teases = 0;
  const wrongTags = new Set();
  let idleTimer = null;

  const stopIdle = () => {
    clearTimeout(idleTimer);
    idleTimer = null;
  };
  // Une seule pique par exercice, relancée à chaque saisie
  const armIdle = () => {
    stopIdle();
    idleTimer = setTimeout(() => {
      say(idleTeaseMessage(teases), { pose: 'thinking' });
      teases += 1;
    }, IDLE_TEASE_MS);
  };

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
        ${ex.is_llm_generated ? '<div class="ai-badge">✨ Exercice généré par l\'IA — signale-moi tout ce qui cloche</div>' : ''}
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
        if (phase === 'answering') {
          main.disabled = v == null || v === '';
          armIdle();
        }
      },
      onSubmit: () => {
        if (phase === 'answering' && !main.disabled) main.click();
      },
    });
    armIdle();

    $('#quit', root).onclick = () => {
      if (confirm('Quitter la leçon ? Ta progression sur cette leçon sera perdue.')) {
        stopIdle();
        stopSpeaking();
        clearBubble();
        onExit();
      }
    };

    main.onclick = async () => {
      if (phase === 'answering') {
        stopIdle();
        stopSpeaking();
        let outcome;
        if (ex.exercise_type === 'free_production') {
          // Karina lit la phrase : c'est l'IA qui corrige (appel réseau, parfois lent)
          phase = 'evaluating';
          main.disabled = true;
          main.textContent = 'Karina lit ta phrase…';
          try {
            const ev = await evaluateProduction({ exercise: ex, sentence: answer });
            outcome = { result: ev.verdict, expected: ev.corrected, explanation: ev.explanation_fr, points: ev.points, free: true };
          } catch (err) {
            phase = 'answering';
            main.disabled = false;
            main.textContent = 'Vérifier';
            showLlmProblem(err);
            return;
          }
        } else {
          outcome = checkAnswer(ex, answer);
        }
        phase = 'feedback';
        const { result, expected } = outcome;
        const xp = xpFor(result, streakActive);
        results.push({ ex, result, xp, given: answer });
        view.lock();
        view.reveal(result);
        showFeedback(ex, result, expected, xp, answer, outcome);
        main.disabled = false;
        main.textContent = i + 1 === exercises.length ? 'Terminer' : 'Continuer';
        main.classList.toggle('wrong-btn', result === 'wrong');
        main.focus();
      } else if (phase === 'evaluating') {
        return;
      } else {
        i += 1;
        if (i >= exercises.length) {
          clearBubble(); // la bulle de la dernière réponse ne doit pas rester sur l'écran de résultats
          onDone(results);
          return;
        }
        // 15 % de chance d'un mot flirty entre deux exercices
        const flirt = rollFlirty() ? flirtyMessage() : null;
        if (flirt) say(flirt);
        else clearBubble();
        show();
      }
    };
  }

  // L'IA ne répond pas : on le dit, on laisse réessayer ou passer (un exercice passé ne compte pas)
  function showLlmProblem(err) {
    const fb = $('#fb', root);
    fb.hidden = false;
    fb.className = 'feedback slide-up';
    fb.innerHTML = `<div class="fb-head">Karina est injoignable 😅</div>
      <div class="fb-expl">${esc(err.message)}</div>
      <div class="row" style="margin-top:8px"><button type="button" class="btn ghost small" id="skip">Passer cet exercice</button></div>`;
    $('#skip', root).onclick = () => {
      i += 1;
      if (i >= exercises.length) {
        clearBubble();
        onDone(results);
      } else {
        clearBubble();
        show();
      }
    };
  }

  function showFeedback(ex, result, expected, xp, given, outcome = {}) {
    // Séries et points récurrents pour choisir la sous-catégorie du message
    let bubble = null;
    if (result === 'correct') {
      correctStreak += 1;
      wrongStreak = 0;
      const perfect = i + 1 === exercises.length && results.every((r) => r.result === 'correct');
      bubble = correctMessage({ streak: correctStreak, perfect });
      if (bubble) say(bubble, { pose: perfect || correctStreak === 3 || correctStreak === 5 ? 'celebrate' : 'idle' });
    } else if (result === 'wrong') {
      correctStreak = 0;
      wrongStreak += 1;
      const repeated = (ex.tags || []).some((t) => wrongTags.has(t));
      (ex.tags || []).forEach((t) => wrongTags.add(t));
      bubble = wrongMessage({ repeated, consecutive: wrongStreak });
      if (bubble) say(bubble);
    } else {
      correctStreak = 0;
      wrongStreak = 0;
    }

    const fb = $('#fb', root);
    fb.hidden = false;
    fb.className = `feedback ${result} slide-up`;
    const tags = (ex.tags || []).map((t) => `<span class="tag">${esc(tagLabel(t))}</span>`).join('');
    // Si la bulle parle, le panneau garde un libellé neutre ; sinon on affiche la ligne intégrée.
    const headline = bubble ? feedbackLabel(result) : fallbackFeedbackLine(result);
    fb.innerHTML = `
      <div class="fb-head">${esc(headline)}${xp ? `<span class="xp-pop">+${xp} XP</span>` : ''}</div>
      ${result !== 'correct' ? `<div class="fb-answer">${outcome.free ? 'Version corrigée' : 'Réponse'} : <strong>${esc(expected)}</strong></div>` : ''}
      ${outcome.free ? `${outcome.explanation ? `<div class="fb-expl">${esc(outcome.explanation)}</div>` : ''}${(outcome.points || []).map((p) => `<div class="fb-point"><s>${esc(p.wrong)}</s> → <strong>${esc(p.right)}</strong> <span class="muted">${esc(p.rule_fr)}</span></div>`).join('')}` : ex.explanation_fr ? `<div class="fb-expl">${esc(ex.explanation_fr)}</div>` : ''}
      ${result === 'wrong' && tags ? `<div class="fb-tags">${tags}</div>` : ''}
      <div class="report">
        <button type="button" class="link-btn" id="report-open">⚑ Signaler un problème</button>
        <form class="report-form" id="report-form" hidden>
          <textarea id="report-note" rows="2" maxlength="500" placeholder="Qu'est-ce qui te paraît faux ou bizarre ? (facultatif)"></textarea>
          <div class="row"><button type="submit" class="btn primary small">Envoyer</button><button type="button" class="btn ghost small" id="report-cancel">Annuler</button></div>
        </form>
        <p class="msg" id="report-msg" hidden></p>
      </div>`;
    $('#ex', root).classList.add(result === 'wrong' ? 'shake' : 'pulse');
    wireReport(ex, given);
  }

  // Bouton « Signaler » : une phrase te paraît fausse ou bizarre → une note, et le relecteur saura où regarder
  function wireReport(ex, given) {
    const open = $('#report-open', root);
    const form = $('#report-form', root);
    const msg = $('#report-msg', root);
    open.onclick = () => {
      form.hidden = false;
      open.hidden = true;
      $('#report-note', root).focus();
    };
    $('#report-cancel', root).onclick = () => {
      form.hidden = true;
      open.hidden = false;
    };
    form.onsubmit = async (e) => {
      e.preventDefault();
      const send = form.querySelector('button[type=submit]');
      send.disabled = true;
      try {
        await reportExercise({ exercise: ex, given, note: $('#report-note', root).value });
        form.hidden = true;
        msg.hidden = false;
        msg.className = 'msg ok';
        msg.textContent = 'Merci, c\'est noté ✓';
      } catch (err) {
        console.error(err);
        send.disabled = false;
        msg.hidden = false;
        msg.className = 'msg error';
        msg.textContent = 'Envoi impossible. As-tu relancé schema.sql dans Supabase ?';
      }
    };
  }

  show();
}
