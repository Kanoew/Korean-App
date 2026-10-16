# 한글 with Karina

Application web (PWA) pour apprendre le coréen, de A2 vers B2, avec Karina comme tutrice : **gravir une tour de 100 étages**, avec Jordan qui monte et Karina qui l'accompagne.
Front statique (HTML/CSS/JS, sans build) hébergé sur GitHub Pages · Supabase pour l'auth et la base de données.

**État : V0 terminée** — boucle complète *connexion → leçon → exercices → progression*.
Les révisions espacées (J+1/3/7/16) et une première galerie de récompenses sont en place ; la reconnaissance vocale arrive ensuite. La **couche IA** (Gemini) est prête : il ne manque que ta clé (voir « Couche IA »).

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
- **Étage 1** (103 exercices) : particules 은/는 이/가 을/를, **에 / 에서 / 으로**, connecteurs temporels, nombres sino-coréens et natifs, boss.
- **Étage 2** (99 exercices) : se présenter (이에요/예요, adjectifs), commander (주세요, compteurs, prix), chemin et transports, futur (-(으)ㄹ 거예요), passé (-았/었-) et relier des noms (하고 / 랑 contre 그리고), boss « une journée au marché ». ⚠️ Pas encore relu par un humain.
- **Bouton « Signaler »** sous chaque correction : une phrase te paraît fausse ou bizarre → une note, enregistrée dans `exercise_reports` (avec une copie du texte, car les identifiants d'exercices changent à chaque `seed.sql`).

## Révisions espacées (onglet 🔄 Réviser)

Échelle **J+1 · J+3 · J+7 · J+16**. Une *carte* est un exercice rejoué tel quel (copie dans `srs_cards.exercise`, donc insensible aux `seed.sql`).
- **Naissance** : tout exercice raté ou « presque » en leçon / points faibles ; à la **première validation** d'une leçon, des exercices réussis complètent jusqu'à 5 cartes. La production libre n'en crée pas (elle dépend de l'IA).
- **Échelle** : carte neuve → due demain ; chaque révision réussie la fait monter (J+1 → J+3 → J+7 → J+16), la 4ᵉ la rend *acquise*. « Presque » : même étape, redemandée demain. Raté : retour à J+1. En retard, l'écart suivant part du jour réel (2, 4 puis 9 jours) : pas de révisions collées.
- **Séance** : jusqu'à 15 cartes (les plus en retard d'abord), XP et série comptés comme une session normale. Pastille rouge sur l'onglet et sur l'accueil = cartes dues.
- Code : logique pure dans `js/srs.js` (testée), accès base dans `js/api/srs.js`, écran dans `js/components/review.js`. **Rejouer `supabase/schema.sql`** (colonnes ajoutées à `srs_cards`) ; sans ça l'onglet affiche un message clair et le reste de l'app fonctionne.

## Récompenses (onglet 🎖️)

Galerie **temporaire** : la liste est dans `js/components/rewards.js` (images dans `assets/gallery/`). Une image se débloque à la fin d'un étage, des badges à 7 jours de série / 1 000 XP / première carte acquise. Les déblocages sont mémorisés sur l'appareil (`localStorage`) ; plus tard, la liste passera dans la table `rewards`. Image actuelle : « Trace sur la vitre » (étage 1).

## Tests

```
node tests/srs.test.mjs                                   # logique J+1/3/7/16
PLAYWRIGHT_PATH=$(npm root -g)/playwright node tests/ui-srs.mjs   # parcours réel dans Chromium (faux Supabase)
```

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

## Couche IA (Gemini) — clé côté serveur uniquement

Ce que ça ajoute : **production libre** (tu écris une phrase, Karina la corrige), **exercices générés** pour tes points faibles (badge « ✨ généré par l'IA »), **brouillons de messages** de Karina (toujours inactifs, jamais de `flirty` spicy : ceux-là, c'est toi) et **relecture IA** d'une leçon. Sans clé, l'appli marche exactement comme avant (les exercices « production libre » sont simplement masqués).

La clé ne passe **jamais** par le front ni par GitHub : elle vit dans les secrets d'une Edge Function Supabase (`supabase/functions/llm/index.ts`), qui vérifie ta connexion, applique un plafond (20 appels par session, 100 par jour, contrôlé en SQL) et renvoie le résultat.

1. **Rejoue `supabase/schema.sql`** puis **`supabase/seed.sql`** dans le SQL Editor (tables de quota + RPC, et les exercices de production libre).
2. **Secrets** : Supabase → Edge Functions → Secrets → ajoute
   - `LLM_API_KEY` : ta clé AI Studio ;
   - `LLM_MODEL` : l'identifiant **exact** du modèle, recopié depuis AI Studio (par ex. celui de Flash que tu vois dans le sélecteur) ;
   - (optionnel) `LLM_BASE_URL` : autre fournisseur compatible OpenAI ; par défaut `https://generativelanguage.googleapis.com/v1beta/openai`.
3. **Déploie la fonction** `llm` : Edge Functions → Deploy a new function → colle `supabase/functions/llm/index.ts`, nom **`llm`**, et **désactive « Verify JWT »** (la fonction vérifie elle-même ton jeton). En CLI : `supabase functions deploy llm --no-verify-jwt`.
4. **Teste** : dans l'appli, onglet **🧪 Atelier** → « Tester la clé ». Les erreurs sont lisibles (clé refusée, modèle introuvable, quota atteint…).

Les quotas gratuits de Google changent : vérifie les limites actuelles dans AI Studio (elles dépendent aussi du modèle et de ta région). Le plafond de l'appli est volontairement bas pour ne jamais les dépasser.

## Karina : sprites et messages

### Sprites (bucket `karina-sprites`)

`schema.sql` crée le bucket public `karina-sprites`. Dépose-y tes PNG (Storage → karina-sprites → Upload), avec **exactement** ces noms :

| Fichier | Où il sert |
| --- | --- |
| `karina-idle.png` | debout de face : accueil, carte des étages (flotte doucement) |
| `karina-walk-right.png` | marche vers la droite : quand elle avance ou change d'étage |
| `karina-celebrate.png` | écran de résultats quand la leçon est validée (rebond) |
| `karina-thinking.png` | écrans d'attente (balancement) |
| `jordan-idle.png` | **Jordan** sur la carte des étages : c'est lui qui grimpe (retourné quand il va vers la droite) |
| `couple-hug.png` | écran de résultats : **étage terminé** |
| `couple-piggyback.png` | étage terminé **multiple de 5**, ou série de **30 jours** |
| `couple-forehead.png` | **leçon parfaite** ou **1 000 XP** franchis |

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
| `review_prompt` | `gentle_reminder` · `overdue` | page Réviser (`overdue` s'il y a des cartes en retard) | actif |
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
  api/              lessons · exercises · progress · messages · reports · llm
  components/       dashboard · floor-map · karina-bubble · learn · lesson-view · exercise-player · exercise-types · stats · lab · soon
  utils/            helpers (correction, dates, XP) · tts · sprites
assets/karina/      avatar.webp · karina-idle · karina-walk-right · karina-celebrate · karina-thinking (.png)
supabase/
  schema.sql        tables + RLS + quotas IA
  functions/llm/    Edge Function IA (Gemini, clé en secret)
  seed.sql          GÉNÉRÉ — ne pas éditer à la main
  seed/build-seed.mjs   source du contenu de l'étage 1
```

## Modifier ou ajouter du contenu

Le contenu pédagogique vit dans `supabase/seed/build-seed.mjs` (étage 1) et `supabase/seed/floor2.mjs` (étage 2), avec les constructeurs `mc`, `fb`, `ro`, `tk`, `tf`, `ls` de `supabase/seed/helpers.mjs`. Règle pour les options : exactement 3 mauvaises options, **qui ne forment aucune phrase correcte** (attention aux formes comme « 가는 거예요 » ou « 만난 거예요 », qui existent vraiment). Après modification :

```bash
node supabase/seed/build-seed.mjs   # régénère supabase/seed.sql
```

puis recolle `seed.sql` dans le SQL Editor. Conventions :

- `fill_blank` : le blanc est `___` dans `prompt_ko`, `options` = choix, `correct_answer` = la particule.
- `reorder` : `options` = les mots **dans le bon ordre** (l'app les mélange), `correct_answer` = la phrase.
- Réponses multiples : sépare par ` | ` dans `correct_answer`.
- Les `tags` (slugs ASCII : `e_vs_eseo`, `temporal`, `numbers_sino`…) alimentent le suivi des points faibles ; leurs libellés sont dans `js/utils/helpers.js` (`TAG_LABELS`).

## Relecture du coréen par un humain

`docs/relecture-etage1.md` et `docs/relecture-etage2.md` listent toutes les phrases de chaque étage (réponses attendues, **mauvaises options**, cours, romanisations) avec une consigne pour le relecteur et une colonne « Avis ». Ils sont régénérés par `node supabase/seed/build-seed.mjs` en même temps que `seed.sql`. Le coréen a été écrit par une IA : à faire relire avant d'ajouter d'autres étages.

Pour lire les signalements faits depuis l'app (Supabase → SQL Editor) :

```sql
select created_at, snapshot->>'prompt_ko' as ko, snapshot->>'prompt_fr' as fr,
       snapshot->>'correct_answer' as attendu, given_answer as donne, note
from exercise_reports where status = 'open' order by created_at desc;
```

## Notes techniques

- **Voix** : Web Speech API (`ko-KR`). Chrome a les meilleures voix coréennes ; si le navigateur n'en a pas, les exercices d'écoute affichent le texte.
- **Série** : une session par jour suffit (dates locales). Plus de 24 h sans leçon remet la série à 1.
- **Plan gratuit Supabase** : un projet inactif 7 jours est mis en pause — il se réveille en un clic depuis le dashboard.
