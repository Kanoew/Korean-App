// node tests/srs.test.mjs — logique des révisions espacées (J+1/3/7/16)
import assert from 'node:assert/strict';
import { STEPS, addDays, afterReview, isDue, buildQueue, summarize, selectForCards, planCardWrites, newCardRow, cardKey } from '../js/srs.js';

const T = '2026-10-16';
const ex = (n, extra = {}) => ({ id: n, exercise_type: 'translate_ko', prompt_ko: `문장${n}`, prompt_fr: `phrase ${n}`, correct_answer: `réponse ${n}`, tags: ['particles'], ...extra });
let n = 0;
const test = (name, fn) => { fn(); n += 1; console.log('ok  ', name); };

test('échelle', () => assert.deepEqual(STEPS, [1, 3, 7, 16]));

test('addDays gère fins de mois et d\'année', () => {
  assert.equal(addDays('2026-10-16', 16), '2026-11-01');
  assert.equal(addDays('2026-12-30', 3), '2027-01-02');
  assert.equal(addDays('2028-02-28', 1), '2028-02-29');
});

test('une carte neuve est due à J+1', () => {
  const c = newCardRow('u', ex(1), T);
  assert.equal(c.next_review, '2026-10-17');
  assert.equal(c.step, 0);
  assert.equal(isDue(c, T), false);
  assert.equal(isDue(c, '2026-10-17'), true);
});

test('révisions réussies à l\'heure : J+1, J+3, J+7, J+16 puis maîtrisée', () => {
  let c = newCardRow('u', ex(1), T);
  const days = [];
  let today = c.next_review;
  for (let i = 0; i < 4; i++) {
    days.push(today);
    c = { ...c, ...afterReview(c, 'correct', today) };
    if (c.status === 'mastered') break;
    today = c.next_review;
  }
  assert.deepEqual(days.map((d) => (Date.parse(d) - Date.parse(T)) / 86400000), [1, 3, 7, 16]);
  assert.equal(c.status, 'mastered');
  assert.equal(c.next_review, null);
});

test('en retard : l\'écart suivant part du jour réel (pas de révisions collées)', () => {
  let c = newCardRow('u', ex(1), T);
  c = { ...c, ...afterReview(c, 'correct', '2026-10-25') }; // J+9 au lieu de J+1
  assert.equal(c.step, 1);
  assert.equal(c.next_review, '2026-10-27'); // +2, pas « demain »
});

test('raté : retour au début, demain, une faute de plus', () => {
  let c = { ...newCardRow('u', ex(1), T), step: 2, lapses: 1 };
  c = { ...c, ...afterReview(c, 'wrong', T) };
  assert.equal(c.step, 0);
  assert.equal(c.lapses, 2);
  assert.equal(c.next_review, '2026-10-17');
});

test('« presque » : même étape, demain, sans faute', () => {
  const c0 = { ...newCardRow('u', ex(1), T), step: 2 };
  const c = { ...c0, ...afterReview(c0, 'partial', T) };
  assert.equal(c.step, 2);
  assert.equal(c.lapses, 0);
  assert.equal(c.next_review, '2026-10-17');
});

test('file : seulement les dues, les plus en retard d\'abord, plafonnée', () => {
  const mk = (i, next, step = 0, status = 'active') => ({ id: i, step, status, next_review: next });
  const cards = [mk(1, '2026-10-16'), mk(2, '2026-10-10'), mk(3, '2026-10-17'), mk(4, '2026-10-10', 2), mk(5, null, 4, 'mastered')];
  assert.deepEqual(buildQueue(cards, T).map((c) => c.id), [2, 4, 1]);
  assert.deepEqual(buildQueue(cards, T, 2).map((c) => c.id), [2, 4]);
});

test('résumé', () => {
  const cards = [
    { step: 0, status: 'active', next_review: '2026-10-16' },
    { step: 0, status: 'active', next_review: '2026-10-14' },
    { step: 1, status: 'active', next_review: '2026-10-17' },
    { step: 2, status: 'active', next_review: '2026-10-22' },
    { step: 3, status: 'active', next_review: '2026-11-20' },
    { step: 4, status: 'mastered', next_review: null },
  ];
  const s = summarize(cards, T);
  assert.deepEqual([s.total, s.mastered, s.due, s.overdue, s.tomorrow, s.week], [6, 1, 2, 1, 1, 2]);
  assert.equal(s.nextDate, '2026-10-17');
  assert.deepEqual(s.byStep, [2, 1, 1, 1]);
});

test('sélection : ratés toujours, réussis seulement à la 1re validation, jusqu\'à 5, sans free_production', () => {
  const results = [
    { ex: ex(1), result: 'wrong' },
    { ex: ex(2), result: 'partial' },
    ...[3, 4, 5, 6, 7, 8].map((i) => ({ ex: ex(i), result: 'correct' })),
    { ex: ex(9, { exercise_type: 'free_production', correct_answer: null }), result: 'wrong' },
    { ex: ex(1), result: 'wrong' }, // doublon
  ];
  assert.equal(selectForCards(results, { firstCompletion: false }).length, 2);
  const first = selectForCards(results, { firstCompletion: true, rand: () => 0.5 });
  assert.equal(first.length, 5);
  assert.deepEqual(first.slice(0, 2).map((r) => r.result), ['wrong', 'partial']);
  assert.ok(first.every((r) => r.ex.exercise_type !== 'free_production'));
});

test('écritures : neuf → carte J+1 ; connu raté → recule ; connu réussi → intact', () => {
  const known = { ...newCardRow('u', ex(2), '2026-10-01'), id: 7, step: 2, next_review: '2026-10-20' };
  const rows = planCardWrites('u', [
    { ex: ex(1), result: 'wrong' },
    { ex: ex(2), result: 'partial' },
    { ex: ex(3), result: 'correct' },
  ], [known], T);
  assert.equal(rows.length, 3);
  assert.equal(rows[0].lapses, 1);
  assert.equal(rows[0].next_review, '2026-10-17');
  assert.equal(rows[1].id, 7);
  assert.equal(rows[1].step, 2);
  assert.equal(rows[1].next_review, '2026-10-17');
  const none = planCardWrites('u', [{ ex: ex(2), result: 'correct' }], [known], T);
  assert.equal(none.length, 0);
});

test('clé stable malgré un nouvel identifiant d\'exercice (reseed)', () => {
  assert.equal(cardKey(ex(1, { id: 10 })), cardKey(ex(1, { id: 999 })));
  assert.notEqual(cardKey(ex(1)), cardKey(ex(2)));
  assert.equal(newCardRow('u', ex(1), T).exercise.id, null);
});

console.log(`\n${n} tests OK`);
