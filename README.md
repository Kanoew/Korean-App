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

Ordre de recherche : **bucket → `assets/karina/` → pose de repli (idle)**. Les quatre poses sont livrées dans le dépôt (`assets/karina/`, fond transparent, fin contour blanc pour rester lisibles sur le thème sombre). Si une pose manque partout, c'est `idle` qui s'affiche avec l'animation correspondante. Hauteur : 120 px sur mobile, 180 px sur grand écran.

`assets/karina/avatar.webp` est l'avatar rond de l'en-tête. Quand tu le remplaces, incrémente `?v=` dans `AVATAR` (`js/utils/sprites.js`) pour forcer le rechargement.

### Messages (table `karina_messages`)

Saisis-les dans Supabase → Table Editor → `karina_messages`. L'app les lit au chargement (recharge la page pour voir tes ajouts). Colonnes : `category`, `subcategory`, `trigger_context` (note libre, non lue), `message_text`, `min_floor` (pas avant cet étage), `is_active`.

| category | subcategory | Quand | Affichage |
| --- | --- | --- | --- |
| `greeting` | `morning` · `afternoon` · `evening` · `comeback_after_absence` (≥ 3 j) · `streak_active` (≥ 2 j) | accueil | carte de Karina |
| `correct_answer` | `standard` · `streak_3` · `streak_5` · `perfect_lesson` | bonne réponse | bulle |
| `wrong_answer` | `standard` · `repeated_mistake` (même point déjà raté) · `encouragement` (2 erreurs d'affilée) | erreur | bulle |
| `floor_clear` | `standard` · `milestone_floor_5` · `milestone_floor_10` (ou `milestone_floor_<n>`) | étage terminé | bulle sur l'écran de résultats |
| `review_prompt` | `gentle_reminder` · `overdue` | cartes SRS dues | *prévu pour la V1 (SRS)* |
| `idle_tease` | `standard` (1re) · `playful` (suivantes) | 30 s sans répondre | bulle |
| `session_end` | `short_session` (< 3 min) · `good_session` · `long_session` (> 15 min) | fin de leçon | bulle sur l'écran de résultats |
| `flirty` | `light` · `medium` · `spicy` (jamais avant l'étage 3) | 15 % entre deux exercices | bulle |
| `milestone` | `xp_500` · `xp_1000` · `streak_7` · `streak_30` | jalon franchi | bulle sur l'écran de résultats |

Règles d'affichage :

- Tirage au sort parmi les messages actifs de la catégorie + sous-catégorie (la plus précise d'abord, puis les moins précises, puis les lignes sans sous-catégorie).
- **Jamais deux fois le même message dans une session** (de la connexion à la déconnexion / au rechargement). Quand tout un lot a été vu, il repart de zéro plutôt que de se taire.
- La bulle sort de Karina, disparaît après **4 secondes ou au toucher** ; sur l'écran de résultats les bulles s'enchaînent (étage → jalons → fin de session).
- Si la bulle parle après une réponse, le panneau de correction garde un libellé neutre et la bonne réponse ; sans message en base, c'est la ligne intégrée qui s'affiche dans le panneau (comme avant).
- Variables dans `message_text` : `{name}` `{streak}` `{xp}` `{floor}` `{level}` `{gap}` `{floor_title}`.

**Objectif : au moins 5 messages par sous-catégorie.** Pour voir ce qui manque :

```sql
select * from karina_messages_coverage where statut <> 'ok';
```

Exemple :

```sql
insert into karina_messages (category, subcategory, trigger_context, message_text) values
  ('greeting', 'streak_active', 'accueil, série ≥ 2 jours', '{streak} jours de suite, {name}. Je ne dis rien… mais je suis fière 😏'),
  ('wrong_answer', 'standard', 'mauvaise réponse', 'Non, mon chou. Relis l''explication, c''est rapide.');
```

## Structure

```
index.html · manifest.webmanifest
css/        main.css (thème) · components.css · animations.css
js/
  app.js            routeur (hash) + garde d'authentification
  auth.js · supabase.js · config.js · state.js · karina.js
  api/              lessons · exercises · progress · messages
  components/       dashboard · floor-map · karina-bubble · learn · lesson-view · exercise-player · exercise-types · stats · soon
  utils/            helpers (correction, dates, XP) · tts · sprites
assets/karina/      avatar.webp · karina-idle · karina-walk-right · karina-celebrate · karina-thinking (.png)
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
