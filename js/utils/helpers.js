// Petits utilitaires partagés : DOM, dates, mélange, correction des réponses.

export const esc = (s) =>
  String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

export const $ = (sel, root = document) => root.querySelector(sel);
export const $$ = (sel, root = document) => [...root.querySelectorAll(sel)];

// ---------- Dates (locales, format YYYY-MM-DD) ----------
const pad = (n) => String(n).padStart(2, '0');
export const dateStr = (d) => `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
export const todayStr = () => dateStr(new Date());
export function yesterdayStr() {
  const d = new Date();
  d.setDate(d.getDate() - 1);
  return dateStr(d);
}
// Série "du jour" : 1 si interruption / première session, +1 si la dernière session date d'hier, inchangée si déjà faite aujourd'hui.
export function streakForToday(profile) {
  const streak = profile?.streak_days || 0;
  const last = profile?.last_session_date;
  if (last === todayStr()) return Math.max(streak, 1);
  if (last === yesterdayStr()) return streak + 1;
  return 1;
}
// Bonus XP ×1.5 : dès 2 jours de suite.
export const hasXpBoost = (profile) => streakForToday(profile) >= 2;

export function daysBetween(a, b) {
  const [ya, ma, da] = a.split('-').map(Number);
  const [yb, mb, db] = b.split('-').map(Number);
  return Math.round((Date.UTC(yb, mb - 1, db) - Date.UTC(ya, ma - 1, da)) / 86400000);
}

// ---------- Aléatoire ----------
export function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
export const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];

// Mélange en évitant plus de `max` exercices du même type d'affilée.
export function spreadTypes(exercises, max = 3) {
  const longestRun = (seq) => {
    let best = 0;
    let run = 0;
    seq.forEach((e, i) => {
      run = i > 0 && e.exercise_type === seq[i - 1].exercise_type ? run + 1 : 1;
      best = Math.max(best, run);
    });
    return best;
  };
  // Tirages aléatoires jusqu'à respecter la règle ; sinon on garde le moins mauvais.
  let best = shuffle(exercises);
  let bestRun = longestRun(best);
  for (let k = 0; k < 300 && bestRun > max; k++) {
    const candidate = shuffle(exercises);
    const run = longestRun(candidate);
    if (run < bestRun) {
      best = candidate;
      bestRun = run;
    }
  }
  return best;
}

// ---------- Libellés des points faibles ----------
export const TAG_LABELS = {
  particles: 'Particules',
  topic_particle: 'Particules 은/는',
  subject_particle: 'Particules 이/가',
  object_particle: 'Particules 을/를',
  e_vs_eseo: '에 / 에서',
  direction: '으로 / 로',
  temporal: 'Connecteurs temporels',
  time_particle: '에 avec le temps',
  numbers_sino: 'Nombres sino-coréens',
  numbers_native: 'Nombres coréens natifs',
  counters: 'Compteurs',
  word_order: 'Ordre des mots',
  listening: 'Compréhension orale',
  production: 'Production écrite',
  copula: 'Être (이에요 / 예요)',
  adjectives: 'Adjectifs (-아요 / 어요)',
  requests: 'Demander (주세요, 얼마예요)',
  directions: 'Chemin et transports',
  location_words: 'Position (옆, 앞, 뒤)',
  future: 'Futur (-(으)ㄹ 거예요)',
  past: 'Passé (-았 / 었-)',
  linking: 'Relier : 하고 / 랑 / 그리고',
  want_to: 'Vouloir (-고 싶어요)',
  can: 'Pouvoir (-(으)ㄹ 수 있어요)',
  negation: 'Négation (안 / 못)',
  honorific: 'Consigne polie (-(으)세요)',
  request_verb: 'Demander (-아/어 주세요)',
  suggest: 'Proposer (-(으)ㄹ까요)',
  reason: 'Cause (-아/어서, -(으)니까)',
  contrast: 'Opposition (-지만, 하지만)',
  conditional: 'Condition (-(으)면)',
  when: 'Quand (-(으)ㄹ 때)',
  experience: 'Expérience (-아/어 보다)',
  progressive: 'En train de (-고 있어요)',
  purpose: 'But (-(으)러 가요)',
  comparison: 'Comparer (보다, 더, 제일)',
  modifier: 'Décrire un nom (-는 / -(으)ㄴ)',
};
export const tagLabel = (t) => TAG_LABELS[t] || t;

// ---------- Correction des réponses ----------
export function normalize(s) {
  return String(s ?? '')
    .normalize('NFC')
    .toLowerCase()
    .replace(/[’‘`´]/g, "'")
    .replace(/[.,!?;:"“”«»…~()\-]/g, ' ')
    .replace(/(\d)\s+(?=\d)/g, '$1')
    .replace(/\s+/g, ' ')
    .trim();
}
const noSpace = (s) => normalize(s).replace(/\s/g, '');
const fold = (s) => noSpace(s).normalize('NFD').replace(/[\u0300-\u036f]/g, '').normalize('NFC');

export function levenshtein(a, b) {
  const m = a.length;
  const n = b.length;
  if (!m) return n;
  if (!n) return m;
  let prev = Array.from({ length: n + 1 }, (_, j) => j);
  for (let i = 1; i <= m; i++) {
    const cur = [i];
    for (let j = 1; j <= n; j++) {
      cur[j] = Math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
    }
    prev = cur;
  }
  return prev[n];
}

export const PLAYABLE = new Set(['multiple_choice', 'fill_blank', 'reorder', 'translate_ko', 'translate_fr', 'listening', 'sounds_right', 'free_production']);

// 'choice' = boutons, 'typed' = champ texte, 'reorder' = mots à remettre dans l'ordre
export function getMode(ex) {
  switch (ex.exercise_type) {
    case 'reorder':
      return 'reorder';
    case 'translate_ko':
    case 'translate_fr':
    case 'free_production':
      return 'typed';
    case 'multiple_choice':
      return 'choice';
    default:
      return Array.isArray(ex.options) && ex.options.length ? 'choice' : 'typed';
  }
}

export const answerAlternatives = (ex) =>
  String(ex.correct_answer ?? '')
    .split('|')
    .map((s) => s.trim())
    .filter(Boolean);

// -> { result: 'correct' | 'partial' | 'wrong', expected }
export function checkAnswer(ex, given) {
  const alts = answerAlternatives(ex);
  const expected = alts[0] ?? '';
  const mode = getMode(ex);
  const g = String(given ?? '').trim();

  if (mode === 'choice') {
    return { result: alts.includes(g) ? 'correct' : 'wrong', expected };
  }
  if (alts.some((a) => normalize(a) === normalize(g))) return { result: 'correct', expected };

  // Presque juste : espaces, accents ou une faute de frappe
  const loose = ex.exercise_type === 'translate_fr' ? fold : noSpace;
  const gl = loose(g);
  const near = alts.some((a) => {
    const al = loose(a);
    if (al === gl) return true;
    return al.length >= 4 && levenshtein(al, gl) <= 1;
  });
  return { result: near ? 'partial' : 'wrong', expected };
}

export const XP_CORRECT = 10;
export const XP_PARTIAL = 5;
export const XP_LESSON = 50;
export const XP_BOSS = 200;
export const STREAK_MULTIPLIER = 1.5;
export const PASS_SCORE = 0.7;

export function xpFor(result, streakActive) {
  const base = result === 'correct' ? XP_CORRECT : result === 'partial' ? XP_PARTIAL : 0;
  return Math.round(base * (streakActive ? STREAK_MULTIPLIER : 1));
}
