// Voix de Karina.
// 1) Messages saisis par Jordan dans la table `karina_messages`, filtrés par étage (min_floor) et is_active.
// 2) À défaut, messages intégrés pour l'accueil et le retour après réponse (le reste reste silencieux).
// En V1, l'Edge Function generate-karina-message viendra compléter les cas non couverts.
//
// Catégories / sous-catégories lues par l'app (voir aussi supabase/schema.sql) :
//   greeting        morning · afternoon · evening · comeback_after_absence · streak_active        → accueil
//   correct_answer  standard · streak_3 · streak_5 · perfect_lesson                                → bonne réponse
//   wrong_answer    standard · repeated_mistake · encouragement                                    → erreur
//   floor_clear     standard · milestone_floor_5 · milestone_floor_10 (… `milestone_floor_<n>`)    → étage terminé
//   review_prompt   gentle_reminder · overdue                                                      → cartes SRS dues (V1)
//   idle_tease      standard · playful                                                             → 30 s d'inactivité
//   session_end     short_session · good_session · long_session                                    → fin de session
//   flirty          light · medium · spicy (pas avant l'étage 3)                                   → 15 % entre deux exercices
//   milestone       xp_500 · xp_1000 · streak_7 · streak_30                                        → jalons
// Variables utilisables dans message_text : {name} {streak} {xp} {floor} {level} {gap} {floor_title}
import { pick } from './utils/helpers.js';
import { state } from './state.js';

export const FLIRTY_CHANCE = 0.15;
export const SPICY_MIN_FLOOR = 3;
export const IDLE_TEASE_MS = 30000;

// Messages déjà montrés dans cette session de l'application (jamais deux fois le même).
const shown = new Set();
export const resetShownMessages = () => shown.clear();

function fill(text, extra = {}) {
  const p = state.profile || {};
  const vars = {
    name: p.display_name || 'Jordan',
    streak: p.streak_days ?? 0,
    xp: p.xp ?? 0,
    floor: p.current_floor ?? 1,
    level: p.current_level ?? 'A2',
    ...extra,
  };
  return String(text).replace(/\{(\w+)\}/g, (m, k) => (k in vars ? vars[k] : m));
}

const currentFloorNumber = () => state.profile?.current_floor ?? 1;

// Cherche la sous-catégorie la plus précise qui a encore un message jamais montré, puis les moins précises
// (lignes sans sous-catégorie incluses). Quand tout a déjà été montré, on repart de zéro sur ce lot
// plutôt que de rester muet. Renvoie null si Jordan n'a rien saisi pour ce cas.
export function pickKarinaMessage(category, subs = [], extra = {}, { exclude = () => false } = {}) {
  const floor = currentFloorNumber();
  const usable = (state.messages || []).filter(
    (m) => m.is_active !== false && m.category === category && (m.min_floor ?? 1) <= floor && !exclude(m),
  );
  const pools = [...subs, null].map((sub) => usable.filter((m) => (m.subcategory || null) === sub)).filter((p) => p.length);
  for (const pool of pools) {
    const fresh = pool.filter((m) => !shown.has(m.id));
    if (fresh.length) {
      const m = pick(fresh);
      shown.add(m.id);
      return fill(m.message_text, extra);
    }
  }
  if (pools.length) {
    pools[0].forEach((m) => shown.delete(m.id));
    const m = pick(pools[0]);
    shown.add(m.id);
    return fill(m.message_text, extra);
  }
  return null;
}

// ---------- Accueil ----------
export function greeting({ name, hour, streak, gapDays }) {
  const moment = hour < 12 ? 'morning' : hour < 18 ? 'afternoon' : 'evening';
  const situation = gapDays !== null && gapDays >= 3 ? 'comeback_after_absence' : streak >= 2 ? 'streak_active' : null;
  const custom = pickKarinaMessage('greeting', [situation, moment].filter(Boolean), { name, streak, gap: gapDays ?? 0 });
  if (custom) return custom;

  const hello = hour < 6 ? 'Encore debout' : hour < 12 ? 'Bonjour' : hour < 18 ? 'Coucou' : 'Bonsoir';
  if (gapDays === null) return `${hello} ${name} 💫 On commence en douceur ? Une petite leçon, et je te garde au chaud.`;
  if (gapDays >= 7) return `${hello} ${name}… ${gapDays} jours sans nouvelles. 😤 Je ne boude pas. Presque pas. Allez, viens.`;
  if (gapDays >= 3) return `${hello} ${name} 🥺 Tu m'as manqué. Les particules aussi, d'ailleurs. Reprenons doucement ?`;
  if (streak >= 30) return `${hello} ${name} 🔥 ${streak} jours d'affilée… tu es impressionnant, mon chou.`;
  if (streak >= 7) return `${hello} ${name} 🔥 ${streak} jours de suite ! Je suis fière de toi (je le dis une seule fois).`;
  if (streak >= 2) return `${hello} ${name} 😏 ${streak} jours d'affilée. Ne casse pas la série, chéri.`;
  return `${hello} ${name} 💕 Dix minutes, pas plus. Tu viens ?`;
}

// ---------- Retour après une réponse ----------
const RIGHT = ['Bien joué, mon chou ✨', 'Voilà ! 😏', '정답! Tu vois que tu sais.', 'Propre. 👏', 'Exactement 💕', 'Je savais que tu le savais.'];
const PARTIAL = ['Presque ! Un détail à corriger 😉', 'Pas mal… mais regarde de plus près.', 'Si proche, chéri.'];
const WRONG = ['Aïe 😅 Ça arrive. Regarde la réponse.', 'Pas cette fois, mon chou. On retient et on avance.', 'Raté ! Mais maintenant tu ne l\'oublieras plus 😌', 'Hmm, non. Lis l\'explication, c\'est rapide.'];

// Ligne intégrée affichée dans le panneau de correction quand Jordan n'a rien saisi pour ce cas.
export const fallbackFeedbackLine = (result) => pick(result === 'correct' ? RIGHT : result === 'partial' ? PARTIAL : WRONG);

// Libellé neutre du panneau quand c'est la bulle de Karina qui parle.
export const feedbackLabel = (result) => (result === 'correct' ? 'Bonne réponse ✓' : result === 'partial' ? 'Presque…' : 'Pas tout à fait');

// streak = bonnes réponses d'affilée (incluant celle-ci) ; perfect = dernière réponse d'une leçon sans faute.
export function correctMessage({ streak = 0, perfect = false }) {
  const subs = [perfect && 'perfect_lesson', streak === 5 && 'streak_5', streak === 3 && 'streak_3', 'standard'].filter(Boolean);
  return pickKarinaMessage('correct_answer', subs);
}

// repeated = même point de grammaire déjà raté dans cette session ; consecutive = erreurs d'affilée.
export function wrongMessage({ repeated = false, consecutive = 1 }) {
  const subs = [repeated && 'repeated_mistake', consecutive >= 2 && 'encouragement', 'standard'].filter(Boolean);
  return pickKarinaMessage('wrong_answer', subs);
}

// ---------- Pendant la leçon ----------
// n = nombre de piques déjà lancées dans la session : la première est "standard", les suivantes "playful".
export const idleTeaseMessage = (n = 0) => pickKarinaMessage('idle_tease', [n > 0 ? 'playful' : 'standard']);

// 15 % entre deux exercices ; "spicy" jamais avant l'étage 3, quel que soit son min_floor.
export const rollFlirty = () => Math.random() < FLIRTY_CHANCE;
export function flirtyMessage() {
  const floor = currentFloorNumber();
  const usable = (state.messages || []).filter(
    (m) => m.category === 'flirty' && m.is_active !== false && (m.min_floor ?? 1) <= floor && !(m.subcategory === 'spicy' && floor < SPICY_MIN_FLOOR),
  );
  const subs = [...new Set(usable.map((m) => m.subcategory || null))];
  if (!subs.length) return null;
  const sub = pick(subs);
  return pickKarinaMessage('flirty', sub ? [sub] : [], {}, { exclude: (m) => m.subcategory === 'spicy' && floor < SPICY_MIN_FLOOR });
}

// ---------- Fin de session ----------
export function sessionEndMessage(durationSeconds) {
  const sub = durationSeconds < 180 ? 'short_session' : durationSeconds > 900 ? 'long_session' : 'good_session';
  return pickKarinaMessage('session_end', [sub]);
}

export function floorClearMessage(floorNumber, floorTitle) {
  return pickKarinaMessage('floor_clear', [`milestone_floor_${floorNumber}`, 'standard'], { floor_title: floorTitle, floor: floorNumber });
}

// Jalons franchis pendant cette session : { xpBefore, xpAfter, streakBefore, streak }
export function crossedMilestones({ xpBefore, xpAfter, streakBefore, streak }) {
  const crossed = [];
  if (xpBefore < 500 && xpAfter >= 500) crossed.push('xp_500');
  if (xpBefore < 1000 && xpAfter >= 1000) crossed.push('xp_1000');
  if (streakBefore < 7 && streak >= 7) crossed.push('streak_7');
  if (streakBefore < 30 && streak >= 30) crossed.push('streak_30');
  return crossed;
}
export const milestoneMessages = (s) => crossedMilestones(s).map((sub) => pickKarinaMessage('milestone', [sub])).filter(Boolean);

// ---------- Révisions (SRS, V1) ----------
// Prêt pour l'accueil / la page Réviser dès que les cartes existeront.
export const reviewPromptMessage = ({ overdue = false } = {}) => pickKarinaMessage('review_prompt', [overdue ? 'overdue' : 'gentle_reminder']);

// ---------- Textes intégrés de fin de leçon ----------
export function resultLine({ score, passed, boss }) {
  if (boss && passed) return 'Boss terrassé 👑 Franchement… bravo, mon chou.';
  if (boss) return 'Le boss résiste encore. On révise et on revient le battre 💪';
  if (score === 1) return 'Sans-faute 🔥 Je ne dis rien… mais je suis très fière.';
  if (passed) return 'Leçon validée ✨ Continue comme ça.';
  return 'Pas encore validée, mais tu as fait le plus dur : essayer. On la refait ? 😌';
}

export const floorClearLine = (title) => `🎉 Étage « ${title} » terminé ! Tu montes, chéri. Je t'attends au prochain étage 😏`;
