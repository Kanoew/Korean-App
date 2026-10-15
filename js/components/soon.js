// Écrans prévus en V1 : pour l'instant, une page d'attente propre.
const page = (icon, title, text) => ({
  render(root) {
    root.innerHTML = `
      <div class="center stack fade-in soon">
        <div class="results-emoji">${icon}</div>
        <h1>${title}</h1>
        <p class="muted">${text}</p>
        <a class="btn ghost" href="#/">Retour à l'accueil</a>
      </div>`;
  },
});

export const review = page('🔄', 'Révisions', 'Le système de révision espacée (SRS, SM-2) arrive en V1. Tes mots et structures seront planifiés automatiquement.');
export const rewards = page('🎖️', 'Récompenses', 'La galerie de Karina arrive en V1 : badges, messages et images à débloquer à chaque étage.');
