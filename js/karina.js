// Voix de Karina.
// 1) Messages saisis par Jordan dans la table `karina_messages` (catégories ci-dessous), filtrés par étage.
// 2) À défaut, messages intégrés (repli) — l'app fonctionne même table vide ou absente.
// En V1, l'Edge Function generate-karina-message viendra compléter les cas non couverts.
//
// Catégories lues par l'app (category / subcategory) :
//   greeting      first_time · comeback_long (≥7 j) · comeback (≥3 j) · streak_30 · streak_7 · streak (≥2 j)
//                 · morning · afternoon · evening · night      → accueil
//   feedback      correct · partial · wrong                     → après chaque réponse
//   result        perfect · pass · fail · boss_pass · boss_fail → fin de leçon
//   floor_clear   (sans sous-catégorie)                         → étage terminé
// Variables utilisables dans message_text : {name} {streak} {xp} {floor} {level} {gap} {floor_title}
import { pick } from './utils/helpers.js';
import { state } from './state.js';

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

// Cherche d'abord la sous-catégorie la plus précise, puis la catégorie sans sous-catégorie.
// Renvoie null si Jordan n'a rien saisi pour ce cas (→ repli intégré).
export function pickKarinaMessage(category, subs = [], extra = {}) {
  const floor = state.profile?.current_floor ?? 1;
  const usable = (state.messages || []).filter((m) => m.is_active !== false && m.category === category && (m.min_floor ?? 1) <= floor);
  for (const sub of [...subs, null]) {
    const pool = usable.filter((m) => (m.subcategory || null) === sub);
    if (pool.length) return fill(pick(pool).message_text, extra);
  }
  return null;
}

// ---------- Accueil ----------
export function greeting({ name, hour, streak, gapDays }) {
  const moment = hour < 6 ? 'night' : hour < 12 ? 'morning' : hour < 18 ? 'afternoon' : 'evening';
  const situation =
    gapDays === null ? 'first_time' : gapDays >= 7 ? 'comeback_long' : gapDays >= 3 ? 'comeback' : streak >= 30 ? 'streak_30' : streak >= 7 ? 'streak_7' : streak >= 2 ? 'streak' : null;
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

// ---------- Retour après chaque réponse ----------
const RIGHT = ['Bien joué, mon chou ✨', 'Voilà ! 😏', '정답! Tu vois que tu sais.', 'Propre. 👏', 'Exactement 💕', 'Je savais que tu le savais.'];
const PARTIAL = ['Presque ! Un détail à corriger 😉', 'Pas mal… mais regarde de plus près.', 'Si proche, chéri.'];
const WRONG = ['Aïe 😅 Ça arrive. Regarde la réponse.', 'Pas cette fois, mon chou. On retient et on avance.', 'Raté ! Mais maintenant tu ne l\'oublieras plus 😌', 'Hmm, non. Lis l\'explication, c\'est rapide.'];

export const feedbackLine = (result) =>
  pickKarinaMessage('feedback', [result]) ?? pick(result === 'correct' ? RIGHT : result === 'partial' ? PARTIAL : WRONG);

// ---------- Fin de leçon ----------
export function resultLine({ score, passed, boss }) {
  const subs = boss ? [passed ? 'boss_pass' : 'boss_fail'] : score === 1 ? ['perfect', 'pass'] : passed ? ['pass'] : ['fail'];
  const custom = pickKarinaMessage('result', subs);
  if (custom) return custom;
  if (boss && passed) return 'Boss terrassé 👑 Franchement… bravo, mon chou.';
  if (boss) return 'Le boss résiste encore. On révise et on revient le battre 💪';
  if (score === 1) return 'Sans-faute 🔥 Je ne dis rien… mais je suis très fière.';
  if (passed) return 'Leçon validée ✨ Continue comme ça.';
  return 'Pas encore validée, mais tu as fait le plus dur : essayer. On la refait ? 😌';
}

export const floorClearLine = (title) =>
  pickKarinaMessage('floor_clear', [], { floor_title: title }) ??
  `🎉 Étage « ${title} » terminé ! Tu montes, chéri. Je t'attends au prochain étage 😏`;
