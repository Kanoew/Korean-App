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
- **Karina à l'écran** : avatar rond dans l'en-tête, carte des étages où elle marche vers sa leçon courante, messages personnalisables (voir plus bas)
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

## Karina : sprites et messages

### Sprites (bucket `karina-sprites`)

`schema.sql` crée le bucket public `karina-sprites`. Dépose-y tes PNG (Storage → karina-sprites → Upload), avec **exactement** ces noms :

| Fichier | Où il sert |
| --- | --- |
| `karina-idle.png` | debout de face : accueil, carte des étages (flotte doucement) |
| `karina-walk-right.png` | marche vers la droite : quand elle avance ou change d'étage |
| `karina-celebrate.png` | écran de résultats quand la leçon est validée (rebond) |
| `karina-thinking.png` | écrans d'attente (balancement) |

Ordre de recherche : **bucket → `assets/karina/` → pose de repli (idle)**. Livrés dans le dépôt : `karina-idle.png` et `karina-walk-right.png` (découpés de la planche de poses, fond transparent, contour blanc pour rester lisibles sur le thème sombre). Tant que `celebrate` et `thinking` ne sont pas déposés, c'est `idle` qui s'affiche avec l'animation correspondante. Hauteur : 120 px sur mobile, 180 px sur grand écran.

`assets/karina/avatar.webp` est l'avatar de l'en-tête (tête cadrée en cercle).

### Messages (table `karina_messages`)

Saisis-les dans Supabase → Table Editor → `karina_messages`. L'app les lit au chargement ; s'il n'y en a pas pour un cas, elle utilise ses messages intégrés.

| category | subcategory | Quand |
| --- | --- | --- |
| `greeting` | `first_time`, `comeback_long` (≥ 7 j), `comeback` (≥ 3 j), `streak_30`, `streak_7`, `streak` (≥ 2 j), `morning`, `afternoon`, `evening`, `night` | accueil |
| `feedback` | `correct`, `partial`, `wrong` | après chaque réponse |
| `result` | `perfect`, `pass`, `fail`, `boss_pass`, `boss_fail` | fin de leçon |
| `floor_clear` | *(vide)* | étage terminé |

- `min_floor` : le message n'apparaît pas avant cet étage. `is_active` : décoche pour le désactiver.
- `trigger_context` : note libre pour toi (non lue par l'app).
- Une sous-catégorie précise l'emporte sur une ligne sans sous-catégorie ; plusieurs messages possibles → tirage au sort.
- Variables dans `message_text` : `{name}` `{streak}` `{xp}` `{floor}` `{level}` `{gap}` `{floor_title}`.

```sql
insert into karina_messages (category, subcategory, trigger_context, message_text) values
  ('greeting', 'streak_7', 'accueil, série ≥ 7 jours', '{streak} jours de suite, {name}. Je ne dis rien… mais je suis fière 😏'),
  ('feedback', 'wrong', 'mauvaise réponse', 'Non, mon chou. Relis l''explication, c''est rapide.');
```

## Structure

```
index.html · manifest.webmanifest
css/        main.css (thème) · components.css · animations.css
js/
  app.js            routeur (hash) + garde d'authentification
  auth.js · supabase.js · config.js · state.js · karina.js
  api/              lessons · exercises · progress · messages
  components/       dashboard · floor-map · learn · lesson-view · exercise-player · exercise-types · stats · soon
  utils/            helpers (correction, dates, XP) · tts · sprites
assets/karina/      avatar.webp · karina-idle.png · karina-walk-right.png
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
