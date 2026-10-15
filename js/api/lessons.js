import { supabase } from '../supabase.js';

// Curriculum complet : étages → unités → leçons (trié).
export async function loadCurriculum() {
  const { data, error } = await supabase
    .from('floors')
    .select('*, units(*, lessons(*))')
    .order('floor_number');
  if (error) throw error;
  for (const floor of data) {
    floor.units.sort((a, b) => a.unit_number - b.unit_number);
    for (const unit of floor.units) unit.lessons.sort((a, b) => a.lesson_number - b.lesson_number);
  }
  return data;
}

export async function loadProgress(userId) {
  const { data, error } = await supabase.from('lesson_progress').select('*').eq('user_id', userId);
  if (error) throw error;
  return new Map(data.map((row) => [row.lesson_id, row]));
}
