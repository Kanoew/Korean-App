// Rendu des 6 types d'exercices jouables en V0 :
// multiple_choice · fill_blank · reorder · translate_ko · translate_fr · listening
// (speaking & free_production arrivent en V1/V2).
import { esc, $, $$, shuffle, getMode, answerAlternatives } from '../utils/helpers.js';
import { speak, ttsSupported } from '../utils/tts.js';

const speakBtn = (text) =>
  ttsSupported && text ? `<button type="button" class="icon-btn" data-speak="${esc(text)}" aria-label="Écouter">🔊</button>` : '';

function head(ex) {
  switch (ex.exercise_type) {
    case 'multiple_choice':
      return `<p class="ex-label">${esc(ex.prompt_fr || 'Choisis la bonne réponse')}</p>
        ${ex.prompt_ko ? `<div class="ex-ko">${esc(ex.prompt_ko)} ${speakBtn(ex.prompt_ko)}</div>` : ''}`;
    case 'fill_blank': {
      const [before, ...rest] = String(ex.prompt_ko || '___').split('___');
      const after = rest.join('___');
      return `<p class="ex-label">Complète la phrase</p>
        <div class="ex-ko">${esc(before)}<span class="blank" id="blank">&nbsp;</span>${esc(after)}</div>
        ${ex.prompt_fr ? `<p class="ex-fr">${esc(ex.prompt_fr)}</p>` : ''}`;
    }
    case 'reorder':
      return `<p class="ex-label">Remets les mots dans l'ordre</p><div class="ex-fr big">${esc(ex.prompt_fr)}</div>`;
    case 'translate_ko':
      return `<p class="ex-label">Traduis en coréen</p><div class="ex-fr big">${esc(ex.prompt_fr)}</div>`;
    case 'translate_fr':
      return `<p class="ex-label">Traduis en français</p>
        <div class="ex-ko">${esc(ex.prompt_ko)} ${speakBtn(ex.prompt_ko)}</div>`;
    case 'listening':
      return `<p class="ex-label">${esc(ex.prompt_fr || 'Écoute et choisis ce que tu as entendu')}</p>
        <div class="listen">
          <button type="button" class="btn big-play" data-speak="${esc(ex.prompt_ko)}">🔊 Écouter</button>
          <button type="button" class="btn ghost" data-speak="${esc(ex.prompt_ko)}" data-slow="1">🐢 Lentement</button>
        </div>
        ${ttsSupported ? '' : `<p class="msg error">Voix indisponible sur ce navigateur — voici le texte : ${esc(ex.prompt_ko)}</p>`}`;
    default:
      return '';
  }
}

// -> { reveal(result, given), lock() }
export function renderExercise(ex, box, { onAnswer, onSubmit }) {
  const mode = getMode(ex);
  const alts = answerAlternatives(ex);
  let body = '';
  let optionList = [];

  if (mode === 'choice') {
    optionList = shuffle(ex.options || []);
    body = `<div class="opts">${optionList.map((o) => `<button type="button" class="opt" data-v="${esc(o)}">${esc(o)}</button>`).join('')}</div>`;
  } else if (mode === 'typed') {
    const lang = ex.exercise_type === 'translate_fr' ? 'fr' : 'ko';
    body = `<input class="input answer-input" id="typed" type="text" lang="${lang}" autocomplete="off" autocapitalize="off"
      autocorrect="off" spellcheck="false" placeholder="${lang === 'ko' ? '한국어로 쓰기…' : 'Ta réponse en français…'}">`;
  } else {
    let words = [...(ex.options || [])];
    let order = shuffle(words.map((_, i) => i));
    if (order.length > 1 && order.every((v, i) => v === i)) order = [...order].reverse();
    body = `<div class="answer-line" id="line"><span class="placeholder">Touche les mots…</span></div>
      <div class="bank" id="bank">${order.map((i) => `<button type="button" class="chip" data-i="${i}">${esc(words[i])}</button>`).join('')}</div>`;
  }

  box.innerHTML = `${head(ex)}${body}`;
  let locked = false;

  // 🔊 sur tout élément data-speak
  $$('[data-speak]', box).forEach((b) => {
    b.onclick = () => speak(b.dataset.speak, { rate: b.dataset.slow ? 0.55 : 0.9 });
  });
  if (ex.exercise_type === 'listening') setTimeout(() => speak(ex.prompt_ko), 250);

  if (mode === 'choice') {
    let selected = null;
    $$('.opt', box).forEach((btn) => {
      btn.onclick = () => {
        if (locked) return;
        selected = btn.dataset.v;
        $$('.opt', box).forEach((b) => b.classList.toggle('selected', b === btn));
        const blank = $('#blank', box);
        if (blank) blank.textContent = selected;
        onAnswer(selected);
      };
    });
    return {
      lock: () => {
        locked = true;
        $$('.opt', box).forEach((b) => (b.disabled = true));
      },
      reveal: (result) => {
        $$('.opt', box).forEach((b) => {
          if (alts.includes(b.dataset.v)) b.classList.add('correct');
          else if (b.dataset.v === selected && result === 'wrong') b.classList.add('wrong');
        });
      },
    };
  }

  if (mode === 'typed') {
    const input = $('#typed', box);
    input.oninput = () => onAnswer(input.value.trim() || null);
    input.onkeydown = (e) => {
      if (e.key === 'Enter') onSubmit();
    };
    setTimeout(() => input.focus(), 50);
    return {
      lock: () => (input.disabled = true),
      reveal: (result) => input.classList.add(result === 'wrong' ? 'wrong' : 'correct'),
    };
  }

  // reorder
  const words = ex.options || [];
  const chosen = []; // indices dans l'ordre choisi
  const line = $('#line', box);
  const bank = $('#bank', box);
  const redraw = () => {
    line.innerHTML = chosen.length
      ? chosen.map((i) => `<button type="button" class="chip placed" data-i="${i}">${esc(words[i])}</button>`).join('')
      : '<span class="placeholder">Touche les mots…</span>';
    $$('.chip', bank).forEach((b) => b.classList.toggle('used', chosen.includes(Number(b.dataset.i))));
    $$('.placed', line).forEach((b) => {
      b.onclick = () => {
        if (locked) return;
        chosen.splice(chosen.indexOf(Number(b.dataset.i)), 1);
        redraw();
      };
    });
    onAnswer(chosen.length === words.length ? chosen.map((i) => words[i]).join(' ') : null);
  };
  $$('.chip', bank).forEach((b) => {
    b.onclick = () => {
      const i = Number(b.dataset.i);
      if (locked || chosen.includes(i)) return;
      chosen.push(i);
      redraw();
    };
  });
  return {
    lock: () => {
      locked = true;
      $$('.chip', box).forEach((b) => (b.disabled = true));
    },
    reveal: (result) => line.classList.add(result === 'wrong' ? 'wrong' : 'correct'),
  };
}
