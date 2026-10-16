// Atelier IA : tester la clé, générer des exercices, brouillons de messages, relecture d'une leçon.
// Tout passe par l'Edge Function `llm` ; la clé du fournisseur n'arrive jamais ici.
import { state } from '../state.js';
import { esc, $, tagLabel, TAG_LABELS } from '../utils/helpers.js';
import { loadLlmStatus, pingLlm, generateExercises, draftMessages, reviewLesson } from '../api/llm.js';

// Mêmes cas que l'Edge Function (hors `flirty` spicy, que Jordan écrit à la main).
const MESSAGE_CASES = {
  greeting: ['morning', 'afternoon', 'evening', 'comeback_after_absence', 'streak_active'],
  correct_answer: ['standard', 'streak_3', 'streak_5', 'perfect_lesson'],
  wrong_answer: ['standard', 'repeated_mistake', 'encouragement'],
  floor_clear: ['standard', 'milestone_floor_5', 'milestone_floor_10'],
  review_prompt: ['gentle_reminder', 'overdue'],
  idle_tease: ['standard', 'playful'],
  session_end: ['short_session', 'good_session', 'long_session'],
  flirty: ['light', 'medium'],
  milestone: ['xp_500', 'xp_1000', 'streak_7', 'streak_30'],
};
const TAGS = Object.keys(TAG_LABELS).filter((t) => !['production', 'listening'].includes(t));

const opts = (list, label = (x) => x) => list.map((x) => `<option value="${esc(x)}">${esc(label(x))}</option>`).join('');

export async function render(root) {
  root.innerHTML = '<div class="center muted">Chargement…</div>';
  state.llm = await loadLlmStatus();
  const st = state.llm;
  const lessons = (state.lessons || []).filter((l) => l.lesson_type !== 'teach');

  root.innerHTML = `
    <div class="fade-in lab stack">
      <h1>🧪 Atelier IA</h1>
      <div class="card">
        <strong>Connexion</strong>
        <p class="muted small" id="lab-status">${
          !st.deployed
            ? "La fonction <code>llm</code> n'est pas déployée (voir le README)."
            : st.configured
              ? `Clé détectée · modèle <code>${esc(st.model || '?')}</code>`
              : "Fonction déployée, mais le secret <code>LLM_API_KEY</code> n'est pas configuré."
        }</p>
        <button class="btn" id="ping" ${st.deployed ? '' : 'disabled'}>Tester la clé</button>
        <p class="small" id="ping-out" aria-live="polite"></p>
      </div>
      <div class="card">
        <strong>Générer des exercices</strong>
        <select class="input" id="gen-tag">${opts(TAGS, tagLabel)}</select>
        <button class="btn" id="gen" ${st.configured ? '' : 'disabled'}>Générer 6 exercices</button>
        <p class="small" id="gen-out" aria-live="polite"></p>
      </div>
      <div class="card">
        <strong>Brouillons de messages de Karina</strong>
        <p class="muted small">Enregistrés inactifs : relis-les puis active-les dans Supabase.</p>
        <select class="input" id="msg-cat">${opts(Object.keys(MESSAGE_CASES))}</select>
        <select class="input" id="msg-sub"></select>
        <button class="btn" id="msg" ${st.configured ? '' : 'disabled'}>Écrire 5 brouillons</button>
        <div class="small" id="msg-out" aria-live="polite"></div>
      </div>
      <div class="card">
        <strong>Relecture IA d'une leçon</strong>
        <select class="input" id="rev-lesson">${lessons.map((l) => `<option value="${l.id}">${esc(l.unit?.title_fr || '')} · ${esc(l.title_fr)}</option>`).join('')}</select>
        <button class="btn" id="rev" ${st.configured ? '' : 'disabled'}>Relire</button>
        <div class="small" id="rev-out" aria-live="polite"></div>
      </div>
    </div>`;

  const fillSub = () => ($('#msg-sub', root).innerHTML = opts(MESSAGE_CASES[$('#msg-cat', root).value]));
  $('#msg-cat', root).onchange = fillSub;
  fillSub();

  // Exécute une action en désactivant le bouton ; affiche l'erreur lisible sinon.
  const run = (btnId, outId, fn) => {
    const btn = $(btnId, root);
    btn.onclick = async () => {
      const out = $(outId, root);
      btn.disabled = true;
      out.className = 'small muted';
      out.textContent = 'Karina réfléchit…';
      try {
        out.className = 'small';
        out.innerHTML = await fn();
      } catch (e) {
        out.className = 'small msg error';
        out.textContent = e.message || String(e);
      } finally {
        btn.disabled = false;
      }
    };
  };

  run('#ping', '#ping-out', async () => {
    const d = await pingLlm();
    state.llm = await loadLlmStatus();
    return `✅ Ça répond (« ${esc(d.reply)} », ${esc(d.model || '')}).`;
  });
  run('#gen', '#gen-out', async () => {
    const tag = $('#gen-tag', root).value;
    const d = await generateExercises({ tag, focus: tagLabel(tag), count: 6 });
    const list = (d.exercises || []).map((e) => `<li>${esc(e.prompt_ko || e.prompt_fr || '')} → ${esc(e.correct_answer || '')}</li>`).join('');
    return `✅ ${d.stored ?? d.exercises?.length ?? 0} exercice(s) ajouté(s) (${d.rejected?.length || 0} rejeté(s)). Ils apparaissent dans « Points faibles ».<ul>${list}</ul>`;
  });
  run('#msg', '#msg-out', async () => {
    const d = await draftMessages({ category: $('#msg-cat', root).value, subcategory: $('#msg-sub', root).value, count: 5 });
    return `✅ ${d.stored ?? d.messages.length} brouillon(s) enregistré(s) :<ul>${d.messages.map((m) => `<li>${esc(m)}</li>`).join('')}</ul>`;
  });
  run('#rev', '#rev-out', async () => {
    const d = await reviewLesson(Number($('#rev-lesson', root).value));
    if (!d.issues.length) return `✅ ${d.reviewed} exercices relus, rien à signaler.`;
    return `${d.reviewed} relus, ${d.issues.length} remarque(s) :<ul>${d.issues
      .map((i) => `<li>${i.severity === 'error' ? '❌' : '⚠️'} #${i.id} — ${esc(i.issue)}${i.suggestion ? ` <em>→ ${esc(i.suggestion)}</em>` : ''}</li>`)
      .join('')}</ul>`;
  });
}
