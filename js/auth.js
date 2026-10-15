import { supabase } from './supabase.js';
import { esc, $ } from './utils/helpers.js';

export async function getSession() {
  const { data } = await supabase.auth.getSession();
  return data.session;
}

export const onAuthChange = (cb) => supabase.auth.onAuthStateChange(cb);
export const signOut = () => supabase.auth.signOut();

const ERRORS = {
  'Invalid login credentials': 'Email ou mot de passe incorrect.',
  'User already registered': 'Cet email est déjà inscrit — connecte-toi plutôt.',
  'Email not confirmed': 'Email non confirmé : clique sur le lien reçu par mail (ou désactive "Confirm email" dans Supabase).',
};
const frError = (msg) => {
  if (ERRORS[msg]) return ERRORS[msg];
  if (/password should be at least/i.test(msg)) return 'Mot de passe trop court (6 caractères minimum).';
  if (/rate limit/i.test(msg)) return 'Trop de tentatives, réessaie dans quelques minutes.';
  return msg;
};

export function renderLogin(root) {
  let mode = 'login';
  const draw = (message = '', kind = 'error', email = '') => {
    root.innerHTML = `
      <div class="auth fade-in">
        <div class="auth-logo">한</div>
        <h1>한글 with Karina</h1>
        <p class="muted">Apprends le coréen, un étage à la fois.</p>
        <form id="auth-form" class="card stack">
          <label class="field"><span>Email</span>
            <input class="input" type="email" name="email" autocomplete="email" value="${esc(email)}" required></label>
          <label class="field"><span>Mot de passe</span>
            <input class="input" type="password" name="password" minlength="6"
              autocomplete="${mode === 'login' ? 'current-password' : 'new-password'}" required></label>
          ${message ? `<p class="msg ${kind}">${esc(message)}</p>` : ''}
          <button class="btn primary block" type="submit">${mode === 'login' ? 'Se connecter' : 'Créer mon compte'}</button>
          <button class="btn ghost block" type="button" id="toggle">
            ${mode === 'login' ? 'Pas encore de compte ? Inscription' : 'Déjà un compte ? Connexion'}</button>
        </form>
      </div>`;
    $('#toggle', root).onclick = () => {
      mode = mode === 'login' ? 'signup' : 'login';
      draw();
    };
    $('#auth-form', root).onsubmit = async (e) => {
      e.preventDefault();
      const f = new FormData(e.target);
      const creds = { email: String(f.get('email')).trim(), password: String(f.get('password')) };
      const btn = $('button[type=submit]', root);
      btn.disabled = true;
      btn.textContent = '…';
      const { data, error } =
        mode === 'login' ? await supabase.auth.signInWithPassword(creds) : await supabase.auth.signUp(creds);
      if (error) return draw(frError(error.message), 'error', creds.email);
      if (mode === 'signup' && !data.session) {
        mode = 'login';
        return draw('Compte créé ! Vérifie tes mails pour confirmer, puis connecte-toi.', 'ok', creds.email);
      }
      // La session est reçue via onAuthStateChange → app.js reroute.
    };
  };
  draw();
}
