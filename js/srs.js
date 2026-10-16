// Révisions espacées (SRS) — échelle de Jordan : J+1, J+3, J+7, J+16.
// Logique pure (aucun accès réseau ni DOM) : testée par tests/srs.test.mjs.
//
// Une carte est un exercice raté (ou appris) rejoué tel quel. Elle avance d'un cran à chaque bonne révision :
//   étape 0 → révision à J+1, étape 1 → J+3, étape 2 → J+7, étape 3 → J+16, puis « maîtrisée ».
// Les écarts sont calculés depuis le jour réel de la révision (2, 4 puis 9 jours) : en retard, on ne
// tasse jamais plusieurs révisions sur des jours consécutifs.
import { dateStr } from './utils/helpers.js';

export const STEPS = [1, 3, 7, 16]; // jours après l'apprentissage
export const MASTERED_AFTER = STEPS.length; // nombre de révisions réussies avant « maîtrisée »
export const SESSION_SIZE = 15; // cartes par séance de révision
export const FIRST_LESSON_CARDS = 5; // cartes minimum créées à la première validation d'une leçon

export function addDays(day, n) {
  const [y, m, d] = day.split('-').map(Number);
  return dateStr(new Date(y, m - 1, d + n));
}

// Identité d'une carte : le texte de l'exercice (les identifiants changent à chaque seed.sql).
export const cardKey = (ex) =>
  [ex.exercise_type, ex.prompt_ko, ex.prompt_fr, String(ex.correct_answer ?? '').split('|')[0]]
    .map((s) => String(s ?? '').normalize('NFC').trim().toLowerCase())
    .join('¦');

// Copie rejouable de l'exercice (sans identifiants : l'exercice peut disparaître au prochain seed).
export function snapshotOf(ex) {
  const { id, created_at, ...rest } = ex; // eslint-disable-line no-unused-vars
  return { ...rest, id: null };
}

// La production libre dépend de l'IA (quota, réseau) : on ne la met pas en révision.
export const isReviewable = (ex) => ex.exercise_type !== 'free_production' && !!ex.correct_answer;

export function newCardRow(userId, ex, today) {
  const snap = snapshotOf(ex);
  return {
    user_id: userId,
    source_key: cardKey(ex),
    card_type: ex.exercise_type,
    front_ko: ex.prompt_ko || ex.prompt_fr || '',
    back_fr: String(ex.correct_answer ?? '').split('|')[0],
    tags: ex.tags || null,
    exercise: snap,
    step: 0,
    status: 'active',
    lapses: 0,
    repetitions: 0,
    interval_days: STEPS[0],
    next_review: addDays(today, STEPS[0]),
    last_review: null,
  };
}

// Applique le résultat d'une révision (ou d'un exercice raté en leçon) → champs à modifier.
export function afterReview(card, result, today) {
  const step = card.step || 0;
  const tomorrow = addDays(today, 1);
  if (result === 'correct') {
    if (step + 1 >= MASTERED_AFTER) {
      return { step: MASTERED_AFTER, repetitions: MASTERED_AFTER, status: 'mastered', next_review: null, interval_days: 0, last_review: today };
    }
    const gap = Math.max(1, STEPS[step + 1] - STEPS[step]);
    return { step: step + 1, repetitions: step + 1, status: 'active', next_review: addDays(today, gap), interval_days: gap, last_review: today };
  }
  if (result === 'partial') {
    // Presque : on repose la question demain, sans reculer ni avancer
    return { step, repetitions: step, status: 'active', next_review: tomorrow, interval_days: 1, last_review: today };
  }
  // Raté : retour au début de l'échelle
  return { step: 0, repetitions: 0, status: 'active', next_review: tomorrow, interval_days: 1, lapses: (card.lapses || 0) + 1, last_review: today };
}

export const isDue = (card, today) => card.status !== 'mastered' && !!card.next_review && card.next_review <= today;

// Les plus en retard d'abord, puis les plus fragiles (étape basse).
export function buildQueue(cards, today, limit = SESSION_SIZE) {
  return cards
    .filter((c) => isDue(c, today))
    .sort((a, b) => (a.next_review < b.next_review ? -1 : a.next_review > b.next_review ? 1 : (a.step || 0) - (b.step || 0)))
    .slice(0, limit);
}

export function summarize(cards, today) {
  const active = cards.filter((c) => c.status !== 'mastered');
  const tomorrow = addDays(today, 1);
  const weekEnd = addDays(today, 7);
  const upcoming = active.filter((c) => c.next_review && c.next_review > today).map((c) => c.next_review).sort();
  return {
    total: cards.length,
    mastered: cards.length - active.length,
    due: active.filter((c) => isDue(c, today)).length,
    overdue: active.filter((c) => c.next_review && c.next_review < today).length,
    tomorrow: active.filter((c) => c.next_review === tomorrow).length,
    week: active.filter((c) => c.next_review && c.next_review > today && c.next_review <= weekEnd).length,
    nextDate: upcoming[0] || null,
    byStep: STEPS.map((_, s) => active.filter((c) => (c.step || 0) === s).length),
  };
}

// Après une session de leçon : quelles cartes créer / faire reculer ?
//  - tout exercice raté ou « presque » ;
//  - à la première validation d'une leçon, des exercices réussis pour atteindre FIRST_LESSON_CARDS cartes.
// Renvoie [{ ex, result }] sans doublon, ordre conservé.
export function selectForCards(results, { firstCompletion = false, rand = Math.random } = {}) {
  const seen = new Set();
  const out = [];
  const take = (r) => {
    const key = cardKey(r.ex);
    if (seen.has(key) || !isReviewable(r.ex)) return;
    seen.add(key);
    out.push(r);
  };
  results.filter((r) => r.result !== 'correct').forEach(take);
  if (firstCompletion) {
    const good = results.filter((r) => r.result === 'correct' && isReviewable(r.ex)).map((r) => [rand(), r]).sort((a, b) => a[0] - b[0]);
    for (const [, r] of good) {
      if (out.length >= FIRST_LESSON_CARDS) break;
      take(r);
    }
  }
  return out;
}

// Confronte la sélection aux cartes déjà connues : { inserts, updates } (lignes complètes à enregistrer).
export function planCardWrites(userId, selection, existing, today) {
  const byKey = new Map(existing.map((c) => [c.source_key, c]));
  const rows = [];
  for (const { ex, result } of selection) {
    const known = byKey.get(cardKey(ex));
    if (!known) {
      const row = newCardRow(userId, ex, today);
      // Raté dès l'apprentissage : on le compte comme une erreur, révision à J+1 comme les autres
      rows.push(result === 'wrong' ? { ...row, lapses: 1 } : row);
    } else if (result !== 'correct') {
      rows.push({ ...known, ...afterReview(known, result, today), exercise: snapshotOf(ex) });
    }
    // Déjà en carte et réussi en leçon : pas un rappel espacé, on ne touche à rien.
  }
  return rows;
}
