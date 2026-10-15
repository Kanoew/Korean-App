// État partagé de l'application (utilisateur, profil, curriculum, progression).
import { loadCurriculum, loadProgress } from './api/lessons.js';
import { ensureProfile } from './api/progress.js';
import { todayStr, yesterdayStr, hasXpBoost } from './utils/helpers.js';

export const state = {
  user: null,
  profile: null,
  floors: [],
  lessons: [], // liste à plat, ordonnée : { ...lesson, unit, floor, index }
  progress: new Map(), // lesson_id -> ligne lesson_progress
};

export function resetState() {
  state.user = null;
  state.profile = null;
  state.floors = [];
  state.lessons = [];
  state.progress = new Map();
}

export async function loadAll(user) {
  state.user = user;
  const [floors, progress, profile] = await Promise.all([loadCurriculum(), loadProgress(user.id), ensureProfile(user)]);
  state.floors = floors;
  state.progress = progress;
  state.profile = profile;
  state.lessons = [];
  for (const floor of floors) {
    for (const unit of floor.units) {
      for (const lesson of unit.lessons) {
        state.lessons.push({ ...lesson, unit, floor, index: state.lessons.length });
      }
    }
  }
}

export const isCompleted = (lessonId) => !!state.progress.get(lessonId)?.completed;

// Déblocage linéaire : une leçon s'ouvre quand la précédente est validée.
export function isUnlocked(lesson) {
  if (lesson.index === 0) return true;
  return isCompleted(state.lessons[lesson.index - 1].id);
}

export const nextLesson = () => state.lessons.find((l) => !isCompleted(l.id)) || null;

export function floorProgress(floor) {
  const lessons = state.lessons.filter((l) => l.floor.id === floor.id);
  const done = lessons.filter((l) => isCompleted(l.id)).length;
  return { done, total: lessons.length, ratio: lessons.length ? done / lessons.length : 0 };
}

export const currentFloor = () => {
  const next = nextLesson();
  if (next) return next.floor;
  return state.floors[state.floors.length - 1] || null;
};

// Série valide : dernière session aujourd'hui ou hier.
export function isStreakActive(profile = state.profile) {
  if (!profile?.last_session_date || !profile.streak_days) return false;
  return profile.last_session_date === todayStr() || profile.last_session_date === yesterdayStr();
}
export const xpBoostActive = () => hasXpBoost(state.profile);
export const currentStreak = (profile = state.profile) => (isStreakActive(profile) ? profile.streak_days : 0);
