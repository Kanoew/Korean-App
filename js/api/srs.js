// Cartes de révision espacée (table srs_cards). Les écritures échouent sans casser l'app
// si schema.sql n'a pas encore été rejoué (colonnes manquantes).
import { supabase } from '../supabase.js';
import { state } from '../state.js';
import { todayStr } from '../utils/helpers.js';
import { afterReview, cardKey, planCardWrites, selectForCards } from '../srs.js';

export async function loadSrsCards(userId) {
  try {
    const { data, error } = await supabase.from('srs_cards').select('*').eq('user_id', userId);
    if (error) throw error;
    // Sans les colonnes du SRS (schema.sql pas rejoué), les cartes ne sont pas exploitables
    const ready = !data.length || 'source_key' in data[0];
    return { available: ready, cards: ready ? data : [] };
  } catch (e) {
    console.warn('srs_cards indisponible', e?.message || e);
    return { available: false, cards: [] };
  }
}

async function saveRows(rows) {
  if (!rows.length) return;
  const { data, error } = await supabase.from('srs_cards').upsert(rows, { onConflict: 'user_id,source_key' }).select();
  if (error) throw error;
  const byKey = new Map(state.srs.cards.map((c) => [c.source_key, c]));
  data.forEach((c) => byKey.set(c.source_key, c));
  state.srs = { available: true, cards: [...byKey.values()] };
  window.dispatchEvent(new Event('srs-changed')); // met à jour la pastille de l'onglet Réviser
}

// Fin d'une leçon / d'un entraînement ciblé : crée ou fait reculer les cartes concernées.
export async function recordLessonCards({ results, firstCompletion }) {
  if (!state.srs.available) return;
  const selection = selectForCards(results, { firstCompletion });
  await saveRows(planCardWrites(state.user.id, selection, state.srs.cards, todayStr()));
}

// Fin d'une séance de révision : chaque carte avance d'un cran (ou recule). Renvoie le détail pour l'écran de bilan.
export async function recordReviews(results) {
  const today = todayStr();
  const byKey = new Map(state.srs.cards.map((c) => [c.source_key, c]));
  const rows = [];
  const changes = [];
  for (const { ex, result } of results) {
    const card = byKey.get(ex.srs_key || cardKey(ex));
    if (!card) continue;
    const patch = afterReview(card, result, today);
    rows.push({ ...card, ...patch });
    changes.push({ card, patch, result });
  }
  await saveRows(rows);
  return changes;
}
