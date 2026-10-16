import { supabase } from '../supabase.js';

// Messages de Karina saisis par Jordan dans Supabase (table karina_messages).
// Si la table n'existe pas encore ou est vide, l'app retombe sur les messages intégrés (js/karina.js).
export async function loadKarinaMessages() {
  try {
    const { data, error } = await supabase.from('karina_messages').select('*').eq('is_active', true);
    if (error) throw error;
    return data || [];
  } catch (e) {
    console.warn('karina_messages indisponible, messages intégrés utilisés', e?.message || e);
    return [];
  }
}
