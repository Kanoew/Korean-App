import { supabase } from '../supabase.js';
import { state } from '../state.js';

// Signale un exercice. On enregistre une copie du texte : l'identifiant d'un exercice change à chaque seed.sql.
export async function reportExercise({ exercise, given, note }) {
  const snapshot = {
    exercise_type: exercise.exercise_type,
    lesson_id: exercise.lesson_id,
    prompt_ko: exercise.prompt_ko,
    prompt_fr: exercise.prompt_fr,
    correct_answer: exercise.correct_answer,
    options: exercise.options,
    explanation_fr: exercise.explanation_fr,
  };
  const { error } = await supabase.from('exercise_reports').insert({
    user_id: state.user.id,
    exercise_id: exercise.id,
    note: note?.trim() || null,
    given_answer: given ?? null,
    snapshot,
  });
  if (error) throw error;
}
