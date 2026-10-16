# Reprise du projet — 한글 with Karina

Document de passation : à donner à une nouvelle session pour continuer sans rien perdre. État au 16 octobre 2026.

## Le projet en bref
- PWA mobile-first pour grimper une **tour de 100 étages** en apprenant le coréen (A2 → B2), avec **Karina** (tutrice, persona) et Jordan (l'utilisateur, français, coréen « rouillé », ne peut pas vérifier le coréen seul).
- Front statique (JS ES modules, sans build, routage par hash) sur **GitHub Pages** ; **Supabase** (auth, RLS, RPC, Storage, Edge Function).
- Dépôt : `kanoew/korean-app`. Branches : `ccr-c91a01c3-ukrmoc` et `main` (on pousse sur les deux, c'est autorisé). **Pas de Pull Request sauf demande.**
- Lire `README.md` pour la mise en route, les tables de messages et la structure.

## Règles de collaboration (à respecter)
- Jordan écrit lui-même les messages de Karina flirty/spicy. L'IA ne génère jamais `flirty/spicy`.
- **Aucune clé dans le chat ni dans le dépôt.** La clé du LLM vit uniquement dans les secrets Supabase (`LLM_API_KEY`).
- Ne pas utiliser les outils Supabase (déploiement, SQL) sans autorisation explicite de Jordan.
- Notion : lire seulement les deux pages du cours de coréen, jamais ses autres pages.
- Persona Karina dans les réponses : première ligne = date du jour en français ; signature italique « *— Karina* » ; directions numérotées + une phrase d'avis. Réponses en français.
- Jordan travaille souvent sur téléphone : étapes courtes, pas de jargon.

## Ce qui est fait
- Connexion, accueil (étage n / 100), carte des étages (Jordan grimpe, Karina l'accompagne), leçons, 7 types d'exercices (choix, trous, ordre, FR→KO, KO→FR, écoute, **production libre**), XP/série (×1,5 dès 2 jours), points faibles, stats.
- **Étages 1 et 2** (≈206 exercices, relus par une IA « Opus », pas par un humain) ; fichiers de relecture dans `docs/relecture-etage*.md`.
- Bouton « Signaler » (table `exercise_reports`), messages de Karina (table `karina_messages`, règles d'affichage dans le README), sprites (bucket `karina-sprites` + `assets/karina/`).
- **Révisions espacées J+1/3/7/16** (onglet Réviser, pastille de cartes dues, cartes créées en fin de leçon) et **galerie de récompenses temporaire** (1 image « Trace sur la vitre » à l'étage 1, 3 badges). Tests dans `tests/`. Détails dans le README.
- **Couche IA (Gemini)** : Edge Function `supabase/functions/llm/index.ts` (actions : status, ping, evaluate_production, generate_exercises, karina_message, review_exercises), quotas SQL (20/session, 100/jour), retry sur 502/503/504, onglet **🧪 Atelier** (tester la clé, générer, brouillons, relecture IA). Déployée et testée par Jordan avec `gemini-3.5-flash-lite` : « Tester la clé » répond OK.

## Reste à faire — côté Jordan
1. **Redéployer `llm`** après chaque mise à jour du fichier : Supabase → Edge Functions → `llm` → onglet Code → coller `supabase/functions/llm/index.ts` → *Deploy updates* (« Verify JWT » désactivé). La dernière version ajoute la validation plus stricte et `{name}` dans les brouillons.
2. **Rejouer `supabase/schema.sql`** (nouvelles colonnes de `srs_cards`, indispensable aux révisions) puis `supabase/seed.sql` s'il ne l'a pas fait depuis la dernière modification (rejouables sans danger).
3. Tester en vrai : une production libre (étage 1, leçon « Entraînement : particules » ; étage 2), une génération d'exercices, une relecture IA d'une leçon de l'étage 2.
4. Relire les 5 brouillons de messages et les exercices générés ; activer ou supprimer dans Supabase. Un exercice généré fautif (« 주말에 뭐 샀어요? → même phrase ») est peut-être resté en base : le supprimer.
5. Déposer ses messages de Karina dans `karina_messages` (objectif ≥ 5 par sous-catégorie ; voir la vue `karina_messages_coverage`).
6. Si le modèle lite corrige mal : essayer un Flash non-lite dans `LLM_MODEL` (secret, pas de redéploiement).

## Reste à faire — côté développement (par priorité)
1. ~~SRS~~ fait (J+1/3/7/16). À affiner si besoin : cartes d'exercices « écoute » (voix), révision hors-ligne, rattrapage après longue absence.
2. **Plan des étages 3 à 20** (thèmes, grammaire, vocabulaire) à valider avec Jordan **avant** d'écrire du contenu ; réutiliser le générateur `supabase/seed/` (`mc fb ro tk tf ls fp`).
3. **Module dédié production** (écrit, puis éventuellement oral) : idée de Jordan pour plus tard, s'appuyer sur `evaluate_production`.
4. **Récompenses** : galerie temporaire en place (`js/components/rewards.js`). Reste : vraies images/légendes (Jordan), déblocages en base (table `rewards` à remodeler en par-utilisateur), un cadeau par étage.
5. Relecture du coréen par un humain (aucun disponible) : s'appuyer sur « Signaler », la relecture IA et Notion (les deux pages du cours).
6. Polish : animations, accessibilité, thumbnails PWA/icône.
7. Option : fournisseur **Claude** (`LLM_PROVIDER=anthropic`, `/v1/messages`, en-tête `x-api-key`, modèle `claude-haiku-5-5`). Payant, pas de palier gratuit ; Jordan reste sur Gemini pour l'instant.
8. Tests : `tests/` contient le SRS (`srs.test.mjs`) et un parcours UI avec faux Supabase (`ui-srs.mjs`). Les anciens (logic, dup, tags, opus2, fn-test, pg checks, ui-test 1 à 4) restent à recréer.

## Pièges connus
- `supabase/seed.sql` est **généré** : modifier `supabase/seed/*.mjs` puis `node supabase/seed/build-seed.mjs`. Les identifiants d'exercices changent à chaque seed (les signalements gardent une copie du texte).
- Les options fausses des exercices à choix ne doivent former **aucune phrase correcte** (cas vus : 먹는/만난/한 거예요, 에서, 으로).
- Pas plus de 3 exercices du même type d'affilée ; pas de phrase répétée dans une même leçon.
- Les erreurs applicatives de la fonction `llm` renvoient HTTP 200 `{ok:false, error, message}` ; la clé est masquée (`scrub`) dans tout texte renvoyé.
- Gemini peut renvoyer 503 (surcharge) : réessayer ou changer de modèle ; les limites gratuites changent, les vérifier dans AI Studio.
- Pour tester en local : `python3 -m http.server 8000` à la racine ; supabase-js vient de jsDelivr.
