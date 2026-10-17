// ---------- Constructeurs d'exercices ----------
// mc : question de cours · fb : phrase à trou (___) · ro : remettre dans l'ordre
// tk : traduire vers le coréen · tf : traduire vers le français · ls : écoute
export const mc = (fr, ko, options, answer, expl, tags, d = 1) => ({ type: 'multiple_choice', fr, ko, options, answer, expl, tags, d });
export const fb = (ko, fr, options, answer, expl, tags, d = 1) => ({ type: 'fill_blank', ko, fr, options, answer, expl, tags, d });
export const ro = (fr, words, answer, expl, tags, d = 2) => ({ type: 'reorder', fr, options: words, answer, expl, tags: [...tags, 'word_order'], d });
export const tk = (fr, answer, expl, tags, d = 2) => ({ type: 'translate_ko', fr, answer, expl, tags, d });
export const tf = (ko, answer, expl, tags, d = 2) => ({ type: 'translate_fr', ko, answer, expl, tags, d });
export const ls = (ko, options, answer, expl, tags, d = 2) => ({ type: 'listening', ko, fr: 'Écoute et choisis la phrase entendue', options, answer, expl, tags: [...tags, 'listening'], d });

// fp : production libre, corrigée par l'IA (jouable seulement si la couche IA est configurée).
// `target` = le point de grammaire visé, donné à l'IA et affiché à l'élève.
export const fp = (fr, target, expl, tags, d = 3) => ({ type: 'free_production', fr, answer: target, expl, tags: [...tags, 'production'], d });

// sj : « laquelle sonne juste ? » — l'élève écoute chaque phrase (voix coréenne) et choisit celle qui sonne bien.
// `options` = phrases complètes (2 ou 3), dont une seule est correcte.
export const sj = (options, answer, expl, tags, d = 2) => ({
  type: 'sounds_right', fr: 'Écoute les phrases : laquelle sonne juste ?', options, answer, expl, tags: [...tags, 'listening'], d,
});
