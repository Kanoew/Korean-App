# 한글 with Karina

Application web (PWA) pour apprendre le coréen, de A2 vers B2, avec Karina comme tutrice.
Front statique (HTML/CSS/JS, sans build) hébergé sur GitHub Pages · Supabase pour l'auth et la base de données.

**État : V0 terminée** — boucle complète *connexion → leçon → exercices → progression*.
Les révisions espacées (SRS), les récompenses, les Edge Functions LLM et la reconnaissance vocale arrivent en V1/V2 (voir la spec).

## Ce que fait la V0

- Connexion email / mot de passe (session mémorisée)
- Accueil : étage courant, progression, série 🔥, XP, message de Karina contextuel, points faibles
- Parcours étages → unités → leçons, déblocage linéaire (leçon validée à 70 %)
- 6 types d'exercices : choix multiple, texte à trous, remise en ordre, traduction FR→KO, KO→FR, écoute (synthèse vocale)
- Jamais plus de 3 exercices du même type d'affilée
- XP (+10 juste, +5 « presque », +50 leçon, +200 boss, ×1,5 dès 2 jours de suite), série quotidienne
- Suivi des points faibles (`weakness_log`) : une erreur incrémente le tag, 5 bonnes réponses d'affilée le résolvent ; bouton « Points faibles » pour s'entraîner dessus
- Stats : XP sur 7 jours, taux de réussite, points faibles récurrents
- Contenu de l'**étage 1** : 6 unités, 11 leçons, 99 exercices (particules 은/는 이/가 을/를, **에 / 에서 / 으로**, connecteurs temporels, nombres sino-coréens et natifs, boss)

## Mise en route

### 1. Base de données (Supabase)

Dans le projet Supabase → **SQL Editor** :

1. Colle et exécute `supabase/schema.sql` (tables, trigger de profil, RLS).
2. Colle et exécute `supabase/seed.sql` (contenu de l'étage 1).

Les deux scripts sont rejouables sans danger.

### 2. Authentification

**Authentication → Providers → Email** : activé.

Usage perso : crée ton compte (page d'inscription de l'app, ou **Authentication → Users → Add user**), puis désactive les inscriptions publiques (**Authentication → Sign In / Providers → Allow new users to sign up** : off). Si tu gardes la confirmation par email, règle **Authentication → URL Configuration → Site URL** sur l'adresse GitHub Pages.

### 3. Configuration du front

`js/config.js` contient l'URL du projet et la clé **publishable**. Elle est publique par conception : la sécurité repose sur le RLS.
**Ne mets jamais la clé `secret` / `service_role` dans le front.**

### 4. Lancer en local

Les modules ES nécessitent un serveur HTTP (pas d'ouverture directe du fichier) :

```bash
python3 -m http.server 8000
# puis http://localhost:8000
```

### 5. Déployer sur GitHub Pages

**Settings → Pages → Build and deployment → Deploy from a branch** → branche `main`, dossier `/ (root)`.

## Structure

```
index.html · manifest.webmanifest
css/        main.css (thème) · components.css · animations.css
js/
  app.js            routeur (hash) + garde d'authentification
  auth.js · supabase.js · config.js · state.js · karina.js
  api/              lessons · exercises · progress
  components/       dashboard · learn · lesson-view · exercise-player · exercise-types · stats · soon
  utils/            helpers (correction, dates, XP) · tts
supabase/
  schema.sql        tables + RLS
  seed.sql          GÉNÉRÉ — ne pas éditer à la main
  seed/build-seed.mjs   source du contenu de l'étage 1
```

## Modifier ou ajouter du contenu

Le contenu pédagogique vit dans `supabase/seed/build-seed.mjs` (constructeurs `mc`, `fb`, `ro`, `tk`, `tf`, `ls`). Après modification :

```bash
node supabase/seed/build-seed.mjs   # régénère supabase/seed.sql
```

puis recolle `seed.sql` dans le SQL Editor. Conventions :

- `fill_blank` : le blanc est `___` dans `prompt_ko`, `options` = choix, `correct_answer` = la particule.
- `reorder` : `options` = les mots **dans le bon ordre** (l'app les mélange), `correct_answer` = la phrase.
- Réponses multiples : sépare par ` | ` dans `correct_answer`.
- Les `tags` (slugs ASCII : `e_vs_eseo`, `temporal`, `numbers_sino`…) alimentent le suivi des points faibles ; leurs libellés sont dans `js/utils/helpers.js` (`TAG_LABELS`).

## Notes techniques

- **Voix** : Web Speech API (`ko-KR`). Chrome a les meilleures voix coréennes ; si le navigateur n'en a pas, les exercices d'écoute affichent le texte.
- **Série** : une session par jour suffit (dates locales). Plus de 24 h sans leçon remet la série à 1.
- **Plan gratuit Supabase** : un projet inactif 7 jours est mis en pause — il se réveille en un clic depuis le dashboard.
