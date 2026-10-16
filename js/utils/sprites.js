// Sprites de Karina. Source principale : bucket Supabase Storage public `karina-sprites`
// (Jordan y dépose ses PNG). Repli : fichiers livrés dans assets/karina/.
// Pose absente partout (celebrate, thinking) → on affiche idle, l'animation CSS fait le reste.
import { SUPABASE_URL } from '../config.js';

const FILES = {
  idle: 'karina-idle.png', //           debout de face (accueil)
  walk: 'karina-walk-right.png', //     marche vers la droite (changement de position / d'étage)
  celebrate: 'karina-celebrate.png', // célébration (étage terminé, jalon)
  thinking: 'karina-thinking.png', //   main sur le menton (chargement)
};
const SHIPPED = new Set(['idle', 'walk']); // présents dans le dépôt
const FALLBACK = { celebrate: 'idle', thinking: 'idle', walk: 'idle' };

export const AVATAR = 'assets/karina/avatar.webp';
const bucketUrl = (key) => `${SUPABASE_URL}/storage/v1/object/public/karina-sprites/${FILES[key]}`;
const localUrl = (key) => `assets/karina/${FILES[key]}`;

// URL immédiate (sans réseau) : la version du dépôt, ou idle à défaut.
export const localSprite = (key) => localUrl(SHIPPED.has(key) ? key : FALLBACK[key] || 'idle');

const canLoad = (url) =>
  new Promise((resolve) => {
    const img = new Image();
    img.onload = () => resolve(true);
    img.onerror = () => resolve(false);
    img.src = url;
  });

const cache = new Map();
// Résout la meilleure URL disponible : bucket > dépôt > pose de repli.
export function resolveSprite(key) {
  if (!FILES[key]) key = 'idle';
  if (!cache.has(key)) {
    cache.set(
      key,
      (async () => {
        if (await canLoad(bucketUrl(key))) return bucketUrl(key);
        if (SHIPPED.has(key)) return localUrl(key);
        return FALLBACK[key] ? resolveSprite(FALLBACK[key]) : localUrl('idle');
      })(),
    );
  }
  return cache.get(key);
}

export function preloadSprites() {
  Object.keys(FILES).forEach(resolveSprite);
}

// Applique une pose à un <img> existant (utile quand le même élément change de pose).
export function useSprite(img, key) {
  img.dataset.sprite = key;
  img.src = localSprite(key);
  resolveSprite(key).then((src) => {
    if (img.dataset.sprite === key && img.getAttribute('src') !== src) img.src = src;
  });
}

export const spriteImg = (key, cls = '') =>
  `<img class="sprite sprite-${key} ${cls}" data-sprite="${key}" src="${localSprite(key)}" alt="Karina" draggable="false">`;

// À appeler après avoir injecté du HTML contenant des spriteImg().
export function hydrateSprites(root = document) {
  root.querySelectorAll('img[data-sprite]').forEach((img) => useSprite(img, img.dataset.sprite));
}

// Écran d'attente : Karina réfléchit.
export function showLoading(root, text = 'Chargement…') {
  root.innerHTML = `<div class="center stack loading fade-in">${spriteImg('thinking')}<p class="muted">${text}</p></div>`;
  hydrateSprites(root);
}
