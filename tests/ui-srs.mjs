// node tests/ui-srs.mjs — parcours réel dans Chromium avec un faux client Supabase en mémoire.
// Prérequis : playwright global → PLAYWRIGHT_PATH=$(npm root -g)/playwright ; sert l'app avec python3 -m http.server.
import { createRequire } from 'node:module';
import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';

// playwright est installé globalement : on le résout via NODE_PATH (npm root -g), ce que l'ESM ne fait pas seul
const { chromium } = createRequire(import.meta.url)(process.env.PLAYWRIGHT_PATH || 'playwright');
const PORT = 8123;
const server = spawn('python3', ['-m', 'http.server', String(PORT)], { stdio: 'ignore' });
await new Promise((r) => setTimeout(r, 800));

// ---- faux supabase-js (module ES servi à la place du CDN) ----
const FAKE = `
const saved = sessionStorage.getItem('__db');
const db = window.__db ||= saved ? JSON.parse(saved) : {
  floors: [{ id: 1, floor_number: 1, title_ko: '시작', title_fr: 'Départ', cefr_level: 'A2' }],
  units: [{ id: 1, floor_id: 1, unit_number: 1, title_ko: '단위', title_fr: 'Unité', topic: 't' }],
  lessons: [1, 2].map((n) => ({ id: n, unit_id: 1, lesson_number: n, title_ko: '과' + n, title_fr: 'Leçon ' + n, lesson_type: 'practice', content_json: null })),
  exercises: [1, 2, 3, 4, 5, 6].map((n) => ({ id: n, lesson_id: 1, exercise_type: 'multiple_choice', prompt_ko: '문장' + n, prompt_fr: 'Phrase ' + n, correct_answer: 'bon' + n, options: ['bon' + n, 'faux' + n], tags: ['particles'], explanation_fr: 'ex' + n })),
  user_profile: [{ user_id: 'u1', display_name: 'Jordan', current_level: 'A2', current_floor: 1, xp: 0, streak_days: 0, last_session_date: null }],
  lesson_progress: [], sessions: [], weakness_log: [], karina_messages: [], srs_cards: [], exercise_reports: [],
};
const seq = { srs_cards: 100 };
function table(name) {
  const q = { f: [], single: false, lim: null, op: 'select', payload: null, conflict: null };
  const rows = () => (db[name] ||= []);
  const run = () => {
    let r = rows();
    if (q.op === 'insert') { const add = [].concat(q.payload).map((x) => ({ id: ++seq[name] || 1, created_at: new Date().toISOString(), ...x })); r.push(...add); return add; }
    if (q.op === 'upsert') {
      const keys = q.conflict.split(',');
      return [].concat(q.payload).map((x) => {
        const hit = r.find((y) => keys.every((k) => y[k] === x[k]));
        if (hit) { Object.assign(hit, x); return hit; }
        const row = { id: ++seq[name] || 1, created_at: new Date().toISOString(), ...x }; r.push(row); return row;
      });
    }
    const m = r.filter((y) => q.f.every((fn) => fn(y)));
    if (q.op === 'update') { m.forEach((y) => Object.assign(y, q.payload)); return m; }
    return q.lim ? m.slice(0, q.lim) : m;
  };
  const b = {
    select() { return b; }, order() { return b; }, limit(n) { q.lim = n; return b; },
    eq(k, v) { q.f.push((y) => y[k] === v); return b; }, in(k, v) { q.f.push((y) => v.includes(y[k])); return b; },
    gt(k, v) { q.f.push((y) => y[k] > v); return b; }, overlaps() { return b; },
    insert(p) { q.op = 'insert'; q.payload = p; return b; }, update(p) { q.op = 'update'; q.payload = p; return b; },
    upsert(p, o) { q.op = 'upsert'; q.payload = p; q.conflict = o?.onConflict; return b; },
    single() { q.single = true; return b; }, maybeSingle() { q.single = true; q.maybe = true; return b; },
    then(res, rej) {
      try {
        let data = run();
        if (q.single) data = data[0] ?? null;
        if (name === 'floors' && !q.single) data = data.map((f) => ({ ...f, units: db.units.filter((u) => u.floor_id === f.id).map((u) => ({ ...u, lessons: db.lessons.filter((l) => l.unit_id === u.id) })) }));
        return Promise.resolve({ data, error: null }).then(res, rej);
      } catch (e) { return Promise.resolve({ data: null, error: e }).then(res, rej); }
    },
  };
  return b;
}
const session = { user: { id: 'u1', email: 'j@x.fr' } };
export const createClient = () => ({
  from: table,
  auth: { getSession: async () => ({ data: { session } }), onAuthStateChange: () => ({ data: {} }), signOut: async () => {} },
  functions: { invoke: async () => ({ data: null, error: { context: null, message: 'off' } }) },
});
`;

const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium' });
const page = await browser.newPage({ viewport: { width: 390, height: 800 } });
const errors = [];
page.on('pageerror', (e) => errors.push(e.message));
page.on('console', (m) => m.type() === 'error' && !/favicon|fonts\.g|Failed to load resource/.test(m.text()) && errors.push(m.text()));
await page.route('**/cdn.jsdelivr.net/**', (r) => r.fulfill({ contentType: 'text/javascript', body: FAKE }));
await page.route('**/fonts.g*/**', (r) => r.abort());

const go = async (hash) => { await page.evaluate((h) => (location.hash = h), hash); await page.waitForTimeout(500); };
const url = `http://localhost:${PORT}/index.html`;
// Recharge l'app en gardant la base factice (sessionStorage) et revient à l'accueil
const reload = async () => {
  await page.evaluate(() => { sessionStorage.setItem('__db', JSON.stringify(window.__db)); location.hash = '#/'; });
  await page.reload();
  await page.waitForSelector('.dash');
};
const today = () => page.evaluate(() => { const d = new Date(); return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`; });
const cards = () => page.evaluate(() => window.__db.srs_cards);
let step = 0;
const ok = (m) => console.log(`ok   ${++step}. ${m}`);

// Joue un exercice QCM : bonne ou mauvaise réponse selon wantRight
async function playOne(wantRight) {
  const ko = await page.textContent('.ex-ko');
  const n = ko.match(/\d+/)[0];
  await page.click(`.opt[data-v="${wantRight ? 'bon' : 'faux'}${n}"]`);
  await page.click('#main');
  await page.click('#main');
}

await page.goto(url);
await page.waitForSelector('.dash');

// 1. Réviser sans carte
await go('#/review');
assert.match(await page.textContent('.review'), /Pas encore de cartes/);
assert.equal(await page.locator('.nav-badge').count(), 0);
ok('Réviser vide : message d\'explication, pas de pastille');

// 2. Récompenses : tout verrouillé, image floutée mais présente
await go('#/rewards');
assert.equal(await page.locator('.tile.open').count(), 0);
assert.equal(await page.locator('.tile.locked img').count(), 1);
ok('Galerie : verrouillée, image en aperçu flouté');

// 3. Leçon 1 : 1 raté, 5 réussis (83 % : validée) → 1 raté + 4 réussis = 5 cartes (première validation)
await go('#/lesson/1');
await page.waitForSelector('.ex-card');
const seen = [];
for (let i = 0; i < 6; i++) {
  await page.waitForSelector('.ex-card .opt');
  const n = (await page.textContent('.ex-ko')).match(/\d+/)[0];
  seen.push(n);
  const wrong = seen.length === 1; // le premier exercice vu est raté
  await page.click(`.opt[data-v="${wrong ? 'faux' : 'bon'}${n}"]`);
  await page.click('#main');
  await page.click('#main');
}
await page.waitForSelector('.results');
await page.waitForTimeout(400);
let c = await cards();
assert.equal(c.length, 5, `5 cartes attendues, ${c.length}`);
const t = await today();
const tomorrow = await page.evaluate((d) => { const [y, m, dd] = d.split('-').map(Number); const x = new Date(y, m - 1, dd + 1); return `${x.getFullYear()}-${String(x.getMonth() + 1).padStart(2, '0')}-${String(x.getDate()).padStart(2, '0')}`; }, t);
assert.ok(c.every((x) => x.next_review === tomorrow && x.step === 0 && x.status === 'active'));
assert.equal(c.filter((x) => x.lapses === 1).length, 1);
assert.ok(c.every((x) => x.exercise && x.exercise.id === null && x.front_ko));
ok('1re validation : 5 cartes créées, due demain (J+1), 1 avec une faute');

// 4. Rien de dû aujourd'hui
await go('#/review');
assert.match(await page.textContent('.review'), /Tout est à jour/);
assert.match(await page.textContent('.review'), /demain/);
ok('Aujourd\'hui : tout est à jour, prochaine révision demain');

// 5. On avance le temps : toutes les cartes dues
await page.evaluate((d) => window.__db.srs_cards.forEach((x) => (x.next_review = d)), t);
await reload();
assert.equal((await page.textContent('.nav-badge')).trim(), '5');
assert.match(await page.textContent('.grid-2'), /5 à faire/);
await go('#/review');
assert.match(await page.textContent('#start'), /Réviser 5 cartes/);
ok('Pastille 5 sur l\'onglet, accueil « 5 à faire », bouton Réviser 5 cartes');

// 6. Séance : 4 justes, 1 ratée
await page.click('#start');
for (let i = 0; i < 5; i++) {
  await page.waitForSelector('.ex-card .opt');
  const n = (await page.textContent('.ex-ko')).match(/\d+/)[0];
  const wrong = i === 0;
  await page.click(`.opt[data-v="${wrong ? 'faux' : 'bon'}${n}"]`);
  await page.click('#main');
  await page.click('#main');
}
await page.waitForSelector('.results');
await page.waitForTimeout(400);
c = await cards();
const up = c.filter((x) => x.step === 1);
assert.equal(up.length, 4);
const d3 = await page.evaluate((d) => { const [y, m, dd] = d.split('-').map(Number); const x = new Date(y, m - 1, dd + 2); return `${x.getFullYear()}-${String(x.getMonth() + 1).padStart(2, '0')}-${String(x.getDate()).padStart(2, '0')}`; }, t);
assert.ok(up.every((x) => x.next_review === d3 && x.repetitions === 1)); // J+1 réussi → J+3 (2 jours plus tard)
assert.equal(c.filter((x) => x.step === 0).length, 1);
assert.match(await page.textContent('.results'), /monte|montent/);
assert.match(await page.textContent('.results'), /repart/);
assert.equal(await page.locator('.nav-badge').count(), 0);
ok('Séance : 4 cartes montent vers J+3, 1 repart à J+1, bilan affiché');
const sessions = await page.evaluate(() => window.__db.sessions.length);
assert.equal(sessions, 2);
ok('XP / série enregistrées pour la séance de révision (2 sessions)');

// 7. Galerie : leçon 2 validée → étage 1 terminé → image débloquée
await page.evaluate(() => window.__db.lesson_progress.push(
  { user_id: 'u1', lesson_id: 1, completed: true, best_score: 1, attempts: 1 },
  { user_id: 'u1', lesson_id: 2, completed: true, best_score: 1, attempts: 1 }));
await reload();
await go('#/rewards');
assert.equal(await page.locator('.tile.open').count(), 1);
assert.match(await page.textContent('.gallery'), /1 \/ 6 débloquées/);
await page.click('.tile.open');
await page.waitForSelector('.viewer img');
const nat = await page.evaluate(() => { const i = document.querySelector('.viewer img'); return i.complete && i.naturalWidth; });
assert.ok(nat > 500, 'image chargée');
await page.keyboard.press('Escape');
assert.equal(await page.locator('.viewer').count(), 0);
ok('Galerie : image débloquée à la fin de l\'étage 1, visionneuse plein écran, Échap ferme');

// 8. Schéma non rejoué : colonnes absentes → message clair, app vivante
await page.evaluate(() => { window.__db.srs_cards = [{ id: 1, user_id: 'u1', front_ko: 'x' }]; });
await reload();
await go('#/review');
assert.match(await page.textContent('.soon'), /schema\.sql/);
ok('Schéma ancien : message « rejoue schema.sql », l\'app reste utilisable');

await page.screenshot({ path: process.env.SHOT || '/tmp/ui-srs.png' });
assert.deepEqual(errors, [], 'erreurs console : ' + errors.join(' | '));
ok('Aucune erreur console');
await browser.close();
server.kill();
