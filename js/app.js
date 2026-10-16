// Point d'entrée : routeur par hash (compatible GitHub Pages) + garde d'authentification.
import { getSession, onAuthChange, renderLogin } from './auth.js';
import { state, loadAll, resetState } from './state.js';
import { esc, $, $$ } from './utils/helpers.js';
import * as dashboard from './components/dashboard.js';
import * as learn from './components/learn.js';
import * as lessonView from './components/lesson-view.js';
import * as stats from './components/stats.js';
import * as lab from './components/lab.js';
import { review, rewards } from './components/soon.js';
import { preloadSprites, showLoading } from './utils/sprites.js';
import { clearBubble } from './components/karina-bubble.js';
import { resetShownMessages } from './karina.js';

const root = $('#app');
const nav = $('#nav');

// [regex, vue, onglet actif]
const ROUTES = [
  [/^#\/?$/, dashboard, 'home'],
  [/^#\/learn$/, learn, 'learn'],
  [/^#\/lesson\/(\d+)$/, lessonView, null],
  [/^#\/weak$/, lessonView, null],
  [/^#\/review$/, review, 'review'],
  [/^#\/rewards$/, rewards, 'rewards'],
  [/^#\/stats$/, stats, 'stats'],
  [/^#\/lab$/, lab, 'lab'],
];

let token = 0;

async function route() {
  const my = ++token;
  clearBubble();
  const session = await getSession();

  if (!session) {
    resetState();
    nav.hidden = true;
    return renderLogin(root);
  }

  try {
    if (!state.profile || state.user?.id !== session.user.id) {
      showLoading(root, '한글 …');
      await loadAll(session.user);
    }
  } catch (e) {
    console.error(e);
    nav.hidden = true;
    root.innerHTML = `
      <div class="center stack">
        <h2>Connexion à la base impossible</h2>
        <p class="msg error">${esc(e.message || e)}</p>
        <p class="muted small">As-tu exécuté supabase/schema.sql puis supabase/seed.sql dans le SQL Editor ?</p>
        <button class="btn primary" id="retry">Réessayer</button>
      </div>`;
    $('#retry').onclick = () => route();
    return;
  }
  if (my !== token) return;

  const hash = location.hash || '#/';
  const match = ROUTES.map(([re, view, tab]) => ({ m: hash.match(re), view, tab })).find((r) => r.m);
  if (!match) {
    location.hash = '#/';
    return;
  }
  nav.hidden = !match.tab;
  $$('#nav a').forEach((a) => a.classList.toggle('active', a.dataset.tab === match.tab));
  window.scrollTo(0, 0);
  await match.view.render(root, match.m.slice(1));
}

preloadSprites();
window.addEventListener('hashchange', route);

// Connexion / déconnexion. (Pas d'appel Supabase async directement dans le callback.)
onAuthChange((event, session) => {
  if (event === 'SIGNED_OUT') {
    resetState();
    resetShownMessages();
    setTimeout(route, 0);
  } else if (event === 'SIGNED_IN' && state.user?.id !== session?.user?.id) {
    setTimeout(route, 0);
  }
});

route();
