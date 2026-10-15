// Voix de Karina en V0 : messages statiques contextuels.
// En V1 ces gabarits seront remplacés / complétés par l'Edge Function generate-karina-message (avec cache).
import { pick } from './utils/helpers.js';

export function greeting({ name, hour, streak, gapDays }) {
  const hello = hour < 6 ? 'Encore debout' : hour < 12 ? 'Bonjour' : hour < 18 ? 'Coucou' : 'Bonsoir';
  if (gapDays === null) return `${hello} ${name} 💫 On commence en douceur ? Une petite leçon, et je te garde au chaud.`;
  if (gapDays >= 7) return `${hello} ${name}… ${gapDays} jours sans nouvelles. 😤 Je ne boude pas. Presque pas. Allez, viens.`;
  if (gapDays >= 3) return `${hello} ${name} 🥺 Tu m'as manqué. Les particules aussi, d'ailleurs. Reprenons doucement ?`;
  if (streak >= 30) return `${hello} ${name} 🔥 ${streak} jours d'affilée… tu es impressionnant, mon chou.`;
  if (streak >= 7) return `${hello} ${name} 🔥 ${streak} jours de suite ! Je suis fière de toi (je le dis une seule fois).`;
  if (streak >= 2) return `${hello} ${name} 😏 ${streak} jours d'affilée. Ne casse pas la série, chéri.`;
  return `${hello} ${name} 💕 Dix minutes, pas plus. Tu viens ?`;
}

const RIGHT = ['Bien joué, mon chou ✨', 'Voilà ! 😏', '정답! Tu vois que tu sais.', 'Propre. 👏', 'Exactement 💕', 'Je savais que tu le savais.'];
const PARTIAL = ['Presque ! Un détail à corriger 😉', 'Pas mal… mais regarde de plus près.', 'Si proche, chéri.'];
const WRONG = ['Aïe 😅 Ça arrive. Regarde la réponse.', 'Pas cette fois, mon chou. On retient et on avance.', 'Raté ! Mais maintenant tu ne l\'oublieras plus 😌', 'Hmm, non. Lis l\'explication, c\'est rapide.'];

export const feedbackLine = (result) => pick(result === 'correct' ? RIGHT : result === 'partial' ? PARTIAL : WRONG);

export function resultLine({ score, passed, boss }) {
  if (boss && passed) return 'Boss terrassé 👑 Franchement… bravo, mon chou.';
  if (boss) return 'Le boss résiste encore. On révise et on revient le battre 💪';
  if (score === 1) return 'Sans-faute 🔥 Je ne dis rien… mais je suis très fière.';
  if (passed) return 'Leçon validée ✨ Continue comme ça.';
  return 'Pas encore validée, mais tu as fait le plus dur : essayer. On la refait ? 😌';
}

export const floorClearLine = (title) => `🎉 Étage « ${title} » terminé ! Tu montes, chéri. Je t'attends au prochain étage 😏`;
