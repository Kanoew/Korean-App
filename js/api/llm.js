// Appels à la couche IA (Edge Function `llm`). La clé du fournisseur reste dans les secrets Supabase :
// ici on n'envoie que le jeton de session de l'utilisateur.
import { supabase } from '../supabase.js';
import { state } from '../state.js';

// Une « session » = un chargement de la page : sert au plafond de 20 appels par session (appliqué côté base).
const SESSION = globalThis.crypto?.randomUUID?.() ?? String(Math.random()).slice(2);

export class LlmError extends Error {
  constructor(code, message, extra = {}) {
    super(message);
    this.code = code;
    this.extra = extra;
  }
}

export async function llm(action, payload = {}) {
  const { data, error } = await supabase.functions.invoke('llm', { body: { action, session: SESSION, ...payload } });
  if (error) {
    let body = null;
    try {
      body = await error.context?.json?.();
    } catch {
      /* pas de corps lisible */
    }
    throw new LlmError(body?.error || 'unreachable', body?.message || "Le service d'IA n'est pas joignable (fonction non déployée ?).");
  }
  if (!data?.ok) throw new LlmError(data?.error || 'unknown', data?.message || "Erreur du service d'IA.", data || {});
  return data;
}

// Sans secret configuré (ou fonction absente), l'appli fonctionne comme avant : aucun exercice « production libre ».
export async function loadLlmStatus() {
  try {
    const d = await llm('status');
    return { configured: !!d.configured, model: d.model || null, deployed: true };
  } catch (e) {
    return { configured: false, model: null, deployed: e.code !== 'unreachable' };
  }
}

export const evaluateProduction = ({ exercise, sentence }) =>
  llm('evaluate_production', { sentence, instruction: exercise.prompt_fr, target: exercise.correct_answer });

export const generateExercises = ({ tag, focus, count = 6 }) =>
  llm('generate_exercises', { tag, focus, count, level: String(state.profile?.current_level || 'A2') });

export const pingLlm = () => llm('ping');
export const draftMessages = ({ category, subcategory, count = 5 }) => llm('karina_message', { category, subcategory, count });
export const reviewLesson = (lessonId) => llm('review_exercises', { lesson_id: lessonId });
