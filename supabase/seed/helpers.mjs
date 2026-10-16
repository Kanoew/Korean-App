// ---------- Constructeurs d'exercices ----------
// mc : question de cours · fb : phrase à trou (___) · ro : remettre dans l'ordre
// tk : traduire vers le coréen · tf : traduire vers le français · ls : écoute
export const mc = (fr, ko, options, answer, expl, tags, d = 1) => ({ type: 'multiple_choice', fr, ko, options, answer, expl, tags, d });
export const fb = (ko, fr, options, answer, expl, tags, d = 1) => ({ type: 'fill_blank', ko, fr, options, answer, expl, tags, d });
export const ro = (fr, words, answer, expl, tags, d = 2) => ({ type: 'reorder', fr, options: words, answer, expl, tags: [...tags, 'word_order'], d });
export const tk = (fr, answer, expl, tags, d = 2) => ({ type: 'translate_ko', fr, answer, expl, tags, d });
export const tf = (ko, answer, expl, tags, d = 2) => ({ type: 'translate_fr', ko, answer, expl, tags, d });
export const ls = (ko, options, answer, expl, tags, d = 2) => ({ type: 'listening', ko, fr: 'Écoute et choisis la phrase entendue', options, answer, expl, tags: [...tags, 'listening'], d });

