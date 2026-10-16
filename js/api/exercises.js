import { supabase } from '../supabase.js';
import { PLAYABLE, shuffle } from '../utils/helpers.js';
import { state } from '../state.js';

// « Production libre » demande la couche IA : sans elle, on saute ces exercices.
const playable = (e) => PLAYABLE.has(e.exercise_type) && (e.exercise_type !== 'free_production' || state.llm?.configured);

export async function loadExercises(lessonId) {
  await state.llmReady;
  const { data, error } = await supabase.from('exercises').select('*').eq('lesson_id', lessonId);
  if (error) throw error;
  return data.filter(playable);
}

// Entraînement ciblé : exercices déjà en cache qui portent les tags les plus faibles.
// (En V1, l'Edge Function generate-exercises complétera quand le pool est épuisé.)
export async function loadWeakExercises(tags, limit = 10) {
  if (!tags.length) return [];
  await state.llmReady;
  const { data, error } = await supabase.from('exercises').select('*').overlaps('tags', tags).limit(80);
  if (error) throw error;
  return shuffle(data.filter(playable)).slice(0, limit);
}
