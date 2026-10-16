// XP, séries, étages, points faibles — tout ce qui est écrit à la fin d'une session.
import { supabase } from '../supabase.js';
import { state } from '../state.js';
import { recordLessonCards } from './srs.js';
import { todayStr, streakForToday, hasXpBoost, XP_LESSON, XP_BOSS, STREAK_MULTIPLIER, PASS_SCORE } from '../utils/helpers.js';

export async function ensureProfile(user) {
  const { data, error } = await supabase.from('user_profile').select('*').eq('user_id', user.id).maybeSingle();
  if (error) throw error;
  if (data) return data;
  const { data: created, error: insErr } = await supabase.from('user_profile').insert({ user_id: user.id }).select().single();
  if (insErr) throw insErr;
  return created;
}

export async function loadWeaknesses(userId, limit = 3) {
  const { data, error } = await supabase
    .from('weakness_log')
    .select('*')
    .eq('user_id', userId)
    .eq('resolved', false)
    .gt('error_count', 0)
    .order('error_count', { ascending: false })
    .limit(limit);
  if (error) throw error;
  return data;
}

// Chaque erreur incrémente le tag ; 5 bonnes réponses de suite sur ce tag le résolvent.
async function updateWeakness(userId, results) {
  const tags = [...new Set(results.flatMap((r) => r.ex.tags || []))];
  if (!tags.length) return;
  const { data: rows, error } = await supabase.from('weakness_log').select('*').eq('user_id', userId).in('tag', tags);
  if (error) throw error;
  const map = new Map(rows.map((r) => [r.tag, { ...r }]));
  const changed = new Set();
  const now = new Date().toISOString();

  for (const { ex, result } of results) {
    for (const tag of ex.tags || []) {
      if (result === 'wrong') {
        const row = map.get(tag) || { user_id: userId, tag, error_count: 0, streak_correct: 0, resolved: false };
        row.error_count += 1;
        row.streak_correct = 0;
        row.resolved = false;
        row.last_error_at = now;
        map.set(tag, row);
        changed.add(tag);
      } else if (result === 'correct' && map.has(tag)) {
        const row = map.get(tag);
        row.streak_correct += 1;
        if (row.streak_correct >= 5) row.resolved = true;
        changed.add(tag);
      }
    }
  }
  if (!changed.size) return;
  const payload = [...changed].map((tag) => {
    const { id, ...row } = map.get(tag); // eslint-disable-line no-unused-vars
    return row;
  });
  const { error: upErr } = await supabase.from('weakness_log').upsert(payload, { onConflict: 'user_id,tag' });
  if (upErr) throw upErr;
}

// Enregistre une session terminée et met à jour profil / progression.
// results: [{ ex, result, xp }] ; review = séance de révision espacée (pas de nouvelles cartes)
export async function finishSession({ lesson, results, startedAt, review = false }) {
  const user = state.user;
  const profile = state.profile;
  const today = todayStr();
  const weak = !lesson;

  const attempted = results.length;
  const correct = results.filter((r) => r.result === 'correct').length;
  const partial = results.filter((r) => r.result === 'partial').length;
  const score = attempted ? (correct + partial * 0.5) / attempted : 0;
  const passed = !weak && score >= PASS_SCORE;
  const boost = hasXpBoost(profile);
  const boss = lesson?.lesson_type === 'boss';

  const previous = lesson ? state.progress.get(lesson.id) : null;
  const firstCompletion = passed && !previous?.completed;
  const bonus = firstCompletion ? Math.round((boss ? XP_BOSS : XP_LESSON) * (boost ? STREAK_MULTIPLIER : 1)) : 0;
  const xpEarned = results.reduce((sum, r) => sum + r.xp, 0) + bonus;

  // Série : +1 si la dernière session était hier, 1 si interruption, inchangée si déjà faite aujourd'hui.
  const streak = streakForToday(profile);
  const xpBefore = profile.xp || 0;
  const streakBefore = profile.streak_days || 0;

  // Progression de la leçon
  let floorCleared = null;
  if (lesson) {
    const row = {
      user_id: user.id,
      lesson_id: lesson.id,
      completed: !!(previous?.completed || passed),
      best_score: Math.max(previous?.best_score || 0, score),
      attempts: (previous?.attempts || 0) + 1,
      completed_at: previous?.completed_at || (passed ? new Date().toISOString() : null),
      updated_at: new Date().toISOString(),
    };
    const { error } = await supabase.from('lesson_progress').upsert(row, { onConflict: 'user_id,lesson_id' });
    if (error) throw error;
    state.progress.set(lesson.id, row);

    if (firstCompletion) {
      const floorLessons = state.lessons.filter((l) => l.floor.id === lesson.floor.id);
      if (floorLessons.every((l) => state.progress.get(l.id)?.completed)) floorCleared = lesson.floor;
    }
  }

  // Étage / niveau courant = celui de la première leçon non validée
  const next = state.lessons.find((l) => !state.progress.get(l.id)?.completed);
  const floor = next ? next.floor : state.floors[state.floors.length - 1];
  const profilePatch = {
    xp: (profile.xp || 0) + xpEarned,
    streak_days: streak,
    last_session_date: today,
    current_floor: floor?.floor_number ?? profile.current_floor,
    current_level: floor?.cefr_level ?? profile.current_level,
  };
  const { data: updated, error: pErr } = await supabase
    .from('user_profile')
    .update(profilePatch)
    .eq('user_id', user.id)
    .select()
    .single();
  if (pErr) throw pErr;
  state.profile = updated;

  const weakTags = [...new Set(results.filter((r) => r.result === 'wrong').flatMap((r) => r.ex.tags || []))];
  const now = new Date();
  const { error: sErr } = await supabase.from('sessions').insert({
    user_id: user.id,
    started_at: startedAt.toISOString(),
    ended_at: now.toISOString(),
    lesson_id: lesson?.id ?? null,
    exercises_attempted: attempted,
    exercises_correct: correct,
    xp_earned: xpEarned,
    weak_points: weakTags,
    duration_seconds: Math.round((now - startedAt) / 1000),
  });
  if (sErr) throw sErr;

  try {
    await updateWeakness(user.id, results);
  } catch (e) {
    console.warn('weakness_log non mis à jour', e);
  }

  // Révisions espacées : les exercices ratés (et quelques réussis à la 1re validation) deviennent des cartes.
  // Une séance de révision gère ses cartes elle-même (voir components/review.js).
  if (!review) {
    try {
      await recordLessonCards({ results, firstCompletion });
    } catch (e) {
      console.warn('cartes de révision non enregistrées', e);
    }
  }

  return {
    attempted, correct, partial, score, passed, boss, xpEarned, bonus, streak, floorCleared, weak,
    xpBefore, xpAfter: xpBefore + xpEarned, streakBefore, durationSeconds: Math.round((now - startedAt) / 1000),
  };
}

export async function loadSessions(userId, limit = 50) {
  const { data, error } = await supabase
    .from('sessions')
    .select('*')
    .eq('user_id', userId)
    .order('started_at', { ascending: false })
    .limit(limit);
  if (error) throw error;
  return data;
}
