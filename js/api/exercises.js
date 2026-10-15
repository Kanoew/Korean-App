import { supabase } from '../supabase.js';
import { PLAYABLE, shuffle } from '../utils/helpers.js';

export async function loadExercises(lessonId) {
  const { data, error } = await supabase.from('exercises').select('*').eq('lesson_id', lessonId);
  if (error) throw error;
  return data.filter((e) => PLAYABLE.has(e.exercise_type));
}

// Entraînement ciblé : exercices déjà en cache qui portent les tags les plus faibles.
// (En V1, l'Edge Function generate-exercises complétera quand le pool est épuisé.)
export async function loadWeakExercises(tags, limit = 10) {
  if (!tags.length) return [];
  const { data, error } = await supabase.from('exercises').select('*').overlaps('tags', tags).limit(80);
  if (error) throw error;
  return shuffle(data.filter((e) => PLAYABLE.has(e.exercise_type))).slice(0, limit);
}
