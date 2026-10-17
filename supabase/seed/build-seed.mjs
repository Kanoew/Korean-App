// Génère supabase/seed.sql (étages 1 à 5) et un document de relecture par étage (docs/relecture-etage<N>.md).
// Usage : node supabase/seed/build-seed.mjs
import { writeFileSync, mkdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

import { mc, fb, ro, tk, tf, ls, fp, sj } from './helpers.mjs';
import { floor2 } from './floor2.mjs';
import { floor3 } from './floor3.mjs';
import { floor4 } from './floor4.mjs';
import { floor5 } from './floor5.mjs';

const floor1 = {
  floor_number: 1,
  title_ko: '기초 다지기',
  title_fr: 'Les fondations',
  cefr_level: 'A2',
  description: 'Consolider les bases : particules, lieu, temps, nombres.',
  units: [
    // ============================================================ UNITÉ 1
    {
      unit_number: 1,
      title_ko: '조사 복습',
      title_fr: 'Particules : rappel',
      topic: 'grammar',
      description: '은/는, 이/가, 을/를',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '은/는 · 이/가 · 을/를',
          title_fr: 'Les trois grandes particules',
          content: {
            intro: 'Trois particules qui reviennent dans presque toutes les phrases. Si elles sont solides, tout le reste devient plus facile, mon chou.',
            sections: [
              {
                title: '은/는 — le thème',
                body: 'Elle pose le sujet dont on parle ("quant à…") ou crée un contraste. Après une consonne : 은. Après une voyelle : 는.',
                examples: [
                  { ko: '저는 학생이에요.', rom: 'jeo-neun hak-saeng-i-e-yo', fr: 'Moi, je suis étudiant(e).' },
                  { ko: '책은 재미있어요.', rom: 'chae-geun jae-mi-i-sseo-yo', fr: 'Le livre, il est intéressant.' },
                ],
              },
              {
                title: '이/가 — le sujet',
                body: 'Elle marque le sujet grammatical, surtout pour une information nouvelle ("c\'est X qui…"). Après une consonne : 이. Après une voyelle : 가.',
                examples: [
                  { ko: '친구가 와요.', rom: 'chin-gu-ga wa-yo', fr: 'Un ami vient.' },
                  { ko: '책이 있어요.', rom: 'chae-gi i-sseo-yo', fr: 'Il y a un livre.' },
                  { ko: '비가 와요.', rom: 'bi-ga wa-yo', fr: 'Il pleut.' },
                ],
              },
              {
                title: '을/를 — le complément d\'objet',
                body: 'Elle marque ce sur quoi porte l\'action (le COD). Après une consonne : 을. Après une voyelle : 를.',
                examples: [
                  { ko: '커피를 마셔요.', rom: 'keo-pi-reul ma-syeo-yo', fr: 'Je bois du café.' },
                  { ko: '물을 마셔요.', rom: 'mu-reul ma-syeo-yo', fr: 'Je bois de l\'eau.' },
                ],
              },
            ],
            tip: 'Regarde toujours la dernière lettre du mot : consonne → 은 / 이 / 을, voyelle → 는 / 가 / 를. Le choix entre 은/는 et 이/가 dépend de ce que tu veux dire, pas du mot.',
          },
          exercises: [
            fb('저___ 학생이에요.', 'Moi, je suis étudiant(e). (thème)', ['는', '가', '를', '에'], '는', '저 finit par une voyelle et on pose le thème : 저는.', ['topic_particle', 'particles']),
            fb('책___ 읽어요.', 'Je lis un livre. (COD)', ['을', '를', '이', '가'], '을', '책 finit par une consonne (ㄱ) → 을.', ['object_particle', 'particles']),
            fb('친구___ 왔어요.', 'Un ami est arrivé. (information nouvelle)', ['가', '이', '을', '를'], '가', '친구 finit par une voyelle → 가.', ['subject_particle', 'particles']),
            fb('물___ 마셔요.', 'Je bois de l\'eau.', ['을', '를', '이', '는'], '을', '물 finit par ㄹ, une consonne → 을.', ['object_particle', 'particles']),
            fb('이것___ 뭐예요?', 'Qu\'est-ce que c\'est ?', ['은', '는', '을', '를'], '은', '이것 finit par ㅅ, une consonne → 은 (thème).', ['topic_particle', 'particles']),
            mc('Quelle particule marque le thème ("quant à moi…") ?', null, ['은/는', '이/가', '을/를', '에'], '은/는', '은/는 pose le thème ; 이/가 marque le sujet ; 을/를 l\'objet.', ['topic_particle', 'particles']),
            ro('Je bois du café.', ['저는', '커피를', '마셔요'], '저는 커피를 마셔요', 'Ordre coréen : thème → objet → verbe (le verbe est toujours à la fin).', ['object_particle', 'particles'], 1),
            tk('Je suis professeur.', '저는 선생님이에요 | 선생님이에요', '저(moi) + 는 + 선생님(professeur) + 이에요(être, poli).', ['topic_particle', 'particles']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '조사 연습',
          title_fr: 'Entraînement : particules',
          exercises: [
            fb('학교___ 멀어요.', 'L\'école est loin.', ['가', '이', '을', '를'], '가', '학교 finit par une voyelle → 가.', ['subject_particle', 'particles']),
            fb('영화___ 봐요.', 'Je regarde un film.', ['를', '을', '가', '이'], '를', '영화 finit par une voyelle → 를.', ['object_particle', 'particles']),
            fb('선생님___ 한국 사람이에요.', 'Le professeur, il est coréen. (thème)', ['은', '는', '를', '을'], '은', '선생님 finit par ㅁ, une consonne → 은.', ['topic_particle', 'particles']),
            fb('우리___ 영화를 봐요.', 'Nous, on regarde un film.', ['는', '를', '에서', '로'], '는', '"우리를" est une erreur fréquente : 를 marque l\'objet (영화를). Pour dire "nous" en thème, on met 는 : 우리는.', ['topic_particle', 'object_particle', 'particles'], 2),
            fb('비___ 와요.', 'Il pleut.', ['가', '이', '를', '을'], '가', '비 finit par une voyelle → 가.', ['subject_particle', 'particles']),
            mc('Forme polie de "moi" + particule de sujet :', null, ['제가', '저가', '내가', '저이'], '제가', 'Avec 이/가, 저 devient 제 : 제가. (저가 n\'existe pas.)', ['subject_particle', 'particles']),
            ro('Mon ami aime la cuisine coréenne.', ['친구가', '한국', '음식을', '좋아해요'], '친구가 한국 음식을 좋아해요 | 한국 음식을 친구가 좋아해요', 'Sujet (이/가) → objet (을/를) → verbe.', ['subject_particle', 'object_particle', 'particles'], 2),
            tf('저는 한국어를 공부해요.', 'J\'étudie le coréen | J\'apprends le coréen | Moi, j\'étudie le coréen', '한국어(coréen) + 를 + 공부해요(étudier).', ['object_particle', 'particles']),
            tk('Je bois de l\'eau.', '저는 물을 마셔요 | 물을 마셔요', '물 finit par une consonne → 을.', ['object_particle', 'particles']),
            fp('Dis ce que tu regardes ou ce que tu bois, en une phrase.', 'La particule d\'objet 을/를', 'Exemple : 저는 영화를 봐요.', ['object_particle', 'particles']),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 2
    {
      unit_number: 2,
      title_ko: '장소 조사',
      title_fr: 'Particules de lieu : 에, 에서, 으로',
      topic: 'grammar',
      description: 'Le point faible n°1 : 에 vs 에서',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '에 vs 에서',
          title_fr: '에 ou 에서 : une petite liste',
          content: {
            intro: "Oublie « action » et « état ». Pour 에 ou 에서, il suffit de connaître une toute petite liste de verbes, et de l'avoir dite à voix haute assez souvent pour qu'elle sonne juste.",
            sections: [
              {
                title: 'La liste des verbes en 에 : cinq verbes',
                body: "가다 (aller), 오다 (venir), 도착하다 (arriver), 있다 (être là, il y a), 없다 (ne pas être là). Si ton verbe est dans cette liste, le lieu prend 에. Apprends-les comme des mots, pas comme une règle.",
                examples: [
                  { ko: '학교에 가요.', rom: 'hak-gyo-e ga-yo', fr: "Je vais à l'école." },
                  { ko: '집에 와요.', rom: 'ji-be wa-yo', fr: 'Je rentre à la maison.' },
                  { ko: '공항에 도착해요.', rom: 'gong-hang-e do-cha-kae-yo', fr: "J'arrive à l'aéroport." },
                  { ko: '집에 있어요.', rom: 'ji-be i-sseo-yo', fr: 'Je suis à la maison.' },
                  { ko: '방에 없어요.', rom: 'bang-e eop-sseo-yo', fr: "Il n'est pas dans la chambre." },
                ],
              },
              {
                title: 'Tous les autres verbes : 에서',
                body: "Manger, boire, étudier, travailler, voir quelqu'un, acheter… Si le verbe n'est pas dans la liste, le lieu prend 에서. Pas besoin de réfléchir : liste → 에, sinon → 에서.",
                examples: [
                  { ko: '카페에서 커피를 마셔요.', rom: 'ka-pe-e-seo keo-pi-reul ma-syeo-yo', fr: 'Je bois un café au café.' },
                  { ko: '도서관에서 공부해요.', rom: 'do-seo-gwa-ne-seo gong-bu-hae-yo', fr: "J'étudie à la bibliothèque." },
                  { ko: '사무실에서 일해요.', rom: 'sa-mu-si-re-seo il-hae-yo', fr: 'Je travaille au bureau.' },
                  { ko: '식당에서 친구를 만나요.', rom: 'sik-dang-e-seo chin-gu-reul man-na-yo', fr: 'Je retrouve un ami au restaurant.' },
                ],
              },
              {
                title: 'Écoute, puis dis-le à voix haute',
                body: "Touche 🔊 sur chaque phrase ci-dessus et répète-la trois fois à voix haute. Le but n'est pas de comprendre pourquoi, mais que 집에 있어요 et 집에서 먹어요 deviennent des blocs que ta bouche connaît. Les exercices te feront écouter deux versions, et tu choisiras celle qui sonne juste.",
                examples: [],
              },
              {
                title: '으로/로 — direction ou moyen',
                body: 'Direction ("vers") ou moyen ("en bus", "avec la main"). Après une voyelle ou ㄹ : 로. Après une autre consonne : 으로.',
                examples: [
                  { ko: '버스로 가요.', rom: 'beo-seu-ro ga-yo', fr: "J'y vais en bus." },
                  { ko: '손으로 먹어요.', rom: 'so-neu-ro meo-geo-yo', fr: 'Je mange avec les mains.' },
                ],
              },
            ],
            tip: "Deux détails pour plus tard : 에서 veut aussi dire « de, depuis » (프랑스에서 왔어요 : je viens de France), et 살다 (habiter) accepte les deux, 서울에 살아요 étant le plus courant. Quelques verbes de placement (앉다, 놓다, 넣다) prennent aussi 에 : tu les verras en temps voulu.",
          },
          exercises: [
            sj(['학교에 가요', '학교에서 가요'], '학교에 가요', '가다 est dans la liste des verbes en 에 : 학교에 가요.', ['e_vs_eseo', 'particles']),
            sj(['집에서 공부해요', '집에 공부해요'], '집에서 공부해요', '공부하다 n\'est pas dans la liste → 에서 : 집에서 공부해요.', ['e_vs_eseo', 'particles']),
            fb('집___ 있어요.', 'Je suis à la maison.', ['에', '에서', '으로', '를'], '에', '있다 est dans la liste des verbes en 에.', ['e_vs_eseo', 'particles']),
            fb('카페___ 커피를 마셔요.', 'Je bois un café dans un café.', ['에', '에서', '으로', '가'], '에서', '마시다 n\'est pas dans la liste → 에서.', ['e_vs_eseo', 'particles']),
            mc('Lequel de ces verbes est dans la liste des verbes en 에 ?', null, ['도착하다 (arriver)', '먹다 (manger)', '일하다 (travailler)', '마시다 (boire)'], '도착하다 (arriver)', 'La liste : 가다, 오다, 도착하다, 있다, 없다.', ['e_vs_eseo', 'particles']),
            ls('도서관에서 공부해요', ['도서관에서 공부해요', '도서관에 가요', '도서관에서 일해요', '도서관에 있어요'], '도서관에서 공부해요', '공부해요 n\'est pas dans la liste → 에서. Écoute bien le verbe.', ['e_vs_eseo', 'particles']),
            tk('Je vais à la bibliothèque.', '도서관에 가요 | 저는 도서관에 가요', '가다 est dans la liste → 에.', ['e_vs_eseo', 'particles']),
            tk('Je travaille au café.', '카페에서 일해요 | 저는 카페에서 일해요', '일하다 n\'est pas dans la liste → 에서.', ['e_vs_eseo', 'particles'], 3),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '장소 조사 연습',
          title_fr: 'Entraînement : 에 / 에서 / 으로',
          exercises: [
            fb('친구가 서울___ 있어요.', 'Mon ami est à Séoul.', ['에', '에서', '를', '로'], '에', '있다 est dans la liste des verbes en 에.', ['e_vs_eseo', 'particles']),
            fb('도서관___ 가요.', 'Je vais à la bibliothèque.', ['에', '에서', '를', '가'], '에', '가다 est dans la liste des verbes en 에 : jamais 에서. 도서관에 가요.', ['e_vs_eseo', 'particles'], 2),
            fb('식당___ 점심을 먹어요.', 'Je déjeune au restaurant.', ['에서', '에', '로', '를'], '에서', '먹다 n\'est pas dans la liste des verbes en 에 → 에서.', ['e_vs_eseo', 'particles']),
            fb('우리는 공원___ 운동해요.', 'Nous faisons du sport au parc.', ['에서', '에', '으로', '가'], '에서', '운동하다 n\'est pas dans la liste des verbes en 에 → 에서.', ['e_vs_eseo', 'particles']),
            fb('저는 프랑스___ 왔어요.', 'Je viens de France. (origine)', ['에서', '에', '로', '를'], '에서', 'Origine ("de") → 에서.', ['e_vs_eseo', 'particles'], 3),
            fb('버스___ 가요.', 'J\'y vais en bus.', ['로', '으로', '에', '에서'], '로', '버스 finit par une voyelle → 로 (moyen de transport).', ['direction', 'particles']),
            fb('지하철___ 가요.', 'J\'y vais en métro.', ['로', '으로', '에서', '에'], '로', '지하철 finit par ㄹ → 로 (comme après une voyelle).', ['direction', 'particles'], 3),
            fb('손___ 먹어요.', 'Je mange avec les mains.', ['으로', '로', '에', '에서'], '으로', '손 finit par ㄴ (consonne ≠ ㄹ) → 으로.', ['direction', 'particles'], 3),
            sj(['식당에서 점심을 먹어요', '식당에 점심을 먹어요'], '식당에서 점심을 먹어요', '먹다 n\'est pas dans la liste → 에서.', ['e_vs_eseo', 'particles']),
            sj(['친구가 서울에 있어요', '친구가 서울에서 있어요'], '친구가 서울에 있어요', '있다 est dans la liste des verbes en 에.', ['e_vs_eseo', 'particles']),
            sj(['공원에서 운동해요', '공원에 운동해요'], '공원에서 운동해요', '운동하다 n\'est pas dans la liste → 에서.', ['e_vs_eseo', 'particles']),
            ls('학교에 가요', ['학교에 가요', '학교에서 가요', '학교를 가요', '학교가 가요'], '학교에 가요', '가다 est dans la liste des verbes en 에.', ['e_vs_eseo', 'particles']),
            ro('J\'étudie à la bibliothèque.', ['저는', '도서관에서', '공부해요'], '저는 도서관에서 공부해요', 'Lieu de l\'action (에서) juste avant le verbe.', ['e_vs_eseo', 'particles'], 2),
            tk('Je mange au restaurant.', '식당에서 먹어요 | 저는 식당에서 먹어요', '먹다 n\'est pas dans la liste des verbes en 에 → 에서.', ['e_vs_eseo', 'particles'], 3),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 3
    {
      unit_number: 3,
      title_ko: '시간 표현',
      title_fr: 'Le temps et les connecteurs',
      topic: 'grammar',
      description: '때, 전에, 후에, 동안',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '때 · 전에 · 후에 · 동안',
          title_fr: 'Quand, avant, après, pendant',
          content: {
            intro: 'Les connecteurs temporels, ton deuxième point faible. Quatre mots à retenir, et un piège avec 에.',
            sections: [
              {
                title: '때 — quand / à l\'époque où',
                body: 'Après un nom : 방학 때. Après un verbe : radical + (으)ㄹ 때, ou au passé radical + 았/었을 때.',
                examples: [
                  { ko: '방학 때 한국에 갈 거예요.', rom: 'bang-hak ttae han-gu-ge gal geo-ye-yo', fr: 'Pendant les vacances, j\'irai en Corée.' },
                  { ko: '어렸을 때 서울에 살았어요.', rom: 'eo-ryeo-sseul ttae seo-u-re sa-ra-sseo-yo', fr: 'Quand j\'étais petit, j\'habitais à Séoul.' },
                ],
              },
              {
                title: '전에 / 후에 — avant / après',
                body: 'Nom + 전에 / 후에. Avec un verbe : radical + 기 전에 (avant de…) et radical + (으)ㄴ 후에 (après avoir…).',
                examples: [
                  { ko: '자기 전에 책을 읽어요.', rom: 'ja-gi jeo-ne chae-geul il-geo-yo', fr: 'Avant de dormir, je lis un livre.' },
                  { ko: '식사 후에 커피를 마셔요.', rom: 'sik-sa hu-e keo-pi-reul ma-syeo-yo', fr: 'Après le repas, je bois un café.' },
                ],
              },
              {
                title: '동안 — pendant (une durée)',
                body: 'Nom de durée + 동안, ou radical + 는 동안 pour "pendant que".',
                examples: [
                  { ko: '한 시간 동안 기다렸어요.', rom: 'han si-gan dong-an gi-da-ryeo-sseo-yo', fr: 'J\'ai attendu pendant une heure.' },
                ],
              },
              {
                title: 'Le piège : 에 avec le temps',
                body: 'On met 에 avec une heure ou un jour précis (3시에, 월요일에, 주말에). Mais PAS avec 어제, 오늘, 내일, 지금.',
                examples: [
                  { ko: '3시에 도착해요.', rom: 'se-si-e do-cha-kae-yo', fr: 'J\'arrive à 3 heures.' },
                  { ko: '내일 만나요.', rom: 'nae-il man-na-yo', fr: 'On se voit demain.' },
                ],
              },
            ],
            tip: 'Retiens la série : 전 = avant, 후 = après, 동안 = durée, 때 = moment. Et pas de 에 après 어제 / 오늘 / 내일 / 지금.',
          },
          exercises: [
            fb('밥을 먹기 ___ 손을 씻어요.', 'Je me lave les mains avant de manger.', ['전에', '후에', '동안', '때'], '전에', '"Avant de" = radical + 기 전에.', ['temporal']),
            fb('수업 ___ 커피를 마셔요.', 'Je bois un café après le cours.', ['후에', '전에', '동안', '에서'], '후에', '"Après" = 후에.', ['temporal']),
            fb('방학 ___ 한국에 갈 거예요.', 'Pendant les vacances, j\'irai en Corée.', ['때', '전에', '후에', '으로'], '때', '방학 때 = au moment des vacances.', ['temporal']),
            fb('저는 3시___ 도착해요.', 'J\'arrive à 3 heures.', ['에', '에서', '를', '은'], '에', 'Heure précise → 에.', ['time_particle', 'temporal']),
            mc('Quel mot signifie "pendant" (une durée) ?', null, ['동안', '전에', '후에', '때'], '동안', '동안 exprime la durée : 한 시간 동안 = pendant une heure.', ['temporal']),
            mc('Avec lequel de ces mots n\'utilise-t-on PAS la particule 에 ?', null, ['내일', '3시', '월요일', '주말'], '내일', 'Pas de 에 avec 어제, 오늘, 내일, 지금.', ['time_particle', 'temporal'], 3),
            tk('Avant de dormir, je lis un livre.', '자기 전에 책을 읽어요 | 저는 자기 전에 책을 읽어요', '자다 → 자기 전에 (radical + 기 전에).', ['temporal'], 3),
            ro('Après le repas, je bois un café.', ['식사', '후에', '커피를', '마셔요'], '식사 후에 커피를 마셔요', 'Nom + 후에 en tête de phrase, verbe à la fin.', ['temporal'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '시간 표현 연습',
          title_fr: 'Entraînement : le temps',
          exercises: [
            fb('한국에 가기 ___ 한국어를 공부했어요.', 'J\'ai étudié le coréen avant d\'aller en Corée.', ['전에', '후에', '동안', '때'], '전에', 'Radical + 기 전에 = avant de.', ['temporal']),
            fb('일이 끝난 ___ 운동해요.', 'Je fais du sport après le travail.', ['후에', '전에', '동안', '때'], '후에', '끝나다 → 끝난 후에 (après avoir fini).', ['temporal']),
            fb('1시간 ___ 기다렸어요.', 'J\'ai attendu pendant une heure.', ['동안', '전에', '후에', '때'], '동안', 'Durée → 동안.', ['temporal']),
            fb('어렸을 ___ 서울에 살았어요.', 'Quand j\'étais petit, j\'habitais à Séoul.', ['때', '전에', '후에', '동안'], '때', '어렸을 때 = quand j\'étais petit.', ['temporal']),
            fb('주말___ 뭐 해요?', 'Que fais-tu le week-end ?', ['에', '에서', '을', '가'], '에', 'Un moment précis (주말) prend 에.', ['time_particle', 'temporal']),
            mc('Quelle phrase est correcte ? (aujourd\'hui, on se voit)', null, ['오늘 만나요', '오늘에 만나요', '오늘에서 만나요', '오늘으로 만나요'], '오늘 만나요', 'Pas de 에 après 오늘.', ['time_particle', 'temporal'], 3),
            ls('식사 후에 커피를 마셔요', ['식사 후에 커피를 마셔요', '식사 전에 커피를 마셔요', '식사 동안 커피를 마셔요', '식사 때 커피를 마셔요'], '식사 후에 커피를 마셔요', '후에 = après. Écoute bien la différence avec 전에 !', ['temporal']),
            tf('저는 수업 후에 도서관에 가요.', 'Après le cours, je vais à la bibliothèque | Je vais à la bibliothèque après le cours | Après le cours je vais à la bibliothèque | Après les cours, je vais à la bibliothèque | Je vais à la bibliothèque après les cours | Après les cours je vais à la bibliothèque', '수업 후에 = après le cours ; 도서관에 가요 = je vais à la bibliothèque.', ['temporal', 'e_vs_eseo'], 3),
            tk('Pendant les vacances, je voyage.', '방학 때 여행해요 | 방학 동안 여행해요 | 저는 방학 때 여행해요 | 저는 방학 동안 여행해요 | 방학에 여행해요 | 저는 방학에 여행해요', '방학 때 (au moment des vacances) ou 방학 동안 (durant les vacances).', ['temporal'], 3),
            ro('Avant de dormir, je prends une douche.', ['저는', '자기', '전에', '샤워해요'], '저는 자기 전에 샤워해요', 'Radical + 기 전에 se place avant le verbe principal.', ['temporal'], 2),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 4
    {
      unit_number: 4,
      title_ko: '한자어 숫자',
      title_fr: 'Nombres sino-coréens',
      topic: 'vocabulary',
      description: '일, 이, 삼… et leurs compteurs',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '일, 이, 삼',
          title_fr: 'Le système sino-coréen',
          content: {
            intro: 'Deux systèmes de nombres, deux usages. Aujourd\'hui : le système sino-coréen, celui de l\'argent, des dates et des minutes.',
            sections: [
              {
                title: 'Les nombres',
                body: '1 일 · 2 이 · 3 삼 · 4 사 · 5 오 · 6 육 · 7 칠 · 8 팔 · 9 구 · 10 십 · 100 백 · 1 000 천 · 10 000 만. On les assemble comme en maths : 15 = 십오, 2 000 = 이천.',
                examples: [
                  { ko: '삼천 원', rom: 'sam-cheon won', fr: '3 000 wons' },
                  { ko: '이십 분', rom: 'i-sip bun', fr: '20 minutes' },
                  { ko: '이천이십육 년', rom: 'i-cheo-ni-sim-nyung nyeon', fr: 'l\'année 2026' },
                ],
              },
              {
                title: 'Quand les utiliser ?',
                body: 'Argent (원), minutes (분), dates (년, 월, 일), étages (층), numéros (번), téléphone. Pour 10 000, on dit 만 (pas 일만) : 만 원.',
                examples: [
                  { ko: '오월 십오일', rom: 'o-wol si-bo-il', fr: 'le 15 mai' },
                  { ko: '오 층', rom: 'o cheung', fr: '5e étage' },
                ],
              },
              {
                title: 'Deux exceptions de mois',
                body: '6月 se dit 유월 (pas 육월) et 10月 se dit 시월 (pas 십월).',
                examples: [{ ko: '유월', rom: 'yu-wol', fr: 'juin' }],
              },
            ],
            tip: 'Moyen mnémotechnique : l\'argent, le calendrier et les numéros = sino. Les heures, l\'âge et le comptage d\'objets = natifs (unité suivante).',
          },
          exercises: [
            mc('Comment dit-on 5 en sino-coréen ?', null, ['오', '다섯', '사', '육'], '오', '5 = 오 (sino) ; 다섯 est la version native.', ['numbers_sino']),
            mc('Comment lit-on 3 000원 ?', null, ['삼천 원', '세천 원', '삼십 원', '셋천 원'], '삼천 원', '3 = 삼 et 1 000 = 천 → 삼천.', ['numbers_sino', 'counters']),
            mc('Pour les minutes (분), quel système de nombres utilise-t-on ?', null, ['Sino-coréen', 'Coréen natif', 'Les deux au choix', 'Aucun'], 'Sino-coréen', 'Minutes = sino (십 분). Heures = natif (열 시).', ['numbers_sino', 'counters']),
            mc('Comment lit-on 10분 ?', null, ['십 분', '열 분', '십 시', '열 시'], '십 분', '10 minutes = 십 분 (sino + 분).', ['numbers_sino', 'counters']),
            mc('Comment lit-on 6월 (juin) ?', null, ['유월', '육월', '여섯월', '륙월'], '유월', 'Exception : 6月 = 유월, 10月 = 시월.', ['numbers_sino'], 3),
            mc('Quel nombre signifie 100 ?', null, ['백', '십', '천', '만'], '백', '백 = 100 ; 천 = 1 000 ; 만 = 10 000.', ['numbers_sino']),
            tk('Dix mille wons.', '만 원', 'On dit simplement 만 원 (pas 일만 원).', ['numbers_sino', 'counters'], 3),
            tk('Le 15 mai.', '오월 십오일 | 오월 십오 일 | 5월 15일', '5月 = 오월 ; 15日 = 십오일.', ['numbers_sino'], 3),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '한자어 숫자 연습',
          title_fr: 'Entraînement : nombres sino-coréens',
          exercises: [
            mc('Comment lit-on 1 500원 ?', null, ['천오백 원', '십오백 원', '백오십 원', '천오십 원'], '천오백 원', '1 000 + 500 → 천 + 오백.', ['numbers_sino', 'counters']),
            mc('Comment lit-on 2024년 ?', null, ['이천이십사 년', '이천이십사 월', '두천스물네 년', '이천사십이 년'], '이천이십사 년', 'Année = nombres sino + 년.', ['numbers_sino']),
            mc('Comment lit-on 20분 ?', null, ['이십 분', '스무 분', '이 분십', '열 분'], '이십 분', 'Minutes = sino : 이십 분.', ['numbers_sino', 'counters']),
            mc('Comment lit-on "2번 버스" ?', null, ['이 번 버스', '두 번 버스', '둘 번 버스', '이 개 버스'], '이 번 버스', 'Un numéro (번호) se dit en sino : 이 번.', ['numbers_sino', 'counters'], 3),
            mc('Trouve l\'intrus (nombres sino-coréens) :', null, ['하나', '일', '이', '삼'], '하나', '하나 est un nombre natif, pas sino-coréen.', ['numbers_sino']),
            ls('삼십 분', ['삼십 분', '십삼 분', '삼 분', '삼백 분'], '삼십 분', '삼십 = 30 ; 십삼 = 13 ; 삼 = 3 ; 삼백 = 300.', ['numbers_sino']),
            tk('Je suis au 5e étage.', '저는 오 층에 있어요 | 오 층에 있어요 | 오층에 있어요 | 5층에 있어요 | 저는 5층에 있어요', '오 + 층 (étage) ; lieu d\'existence → 에 있어요.', ['numbers_sino', 'e_vs_eseo'], 3),
            tf('삼만 원이에요.', 'Ça fait 30000 wons | C\'est 30000 wons | Ça fait trente mille wons | C\'est trente mille wons | Ça coûte 30000 wons', '삼만 = 3 × 10 000 = 30 000.', ['numbers_sino', 'counters'], 3),
            ro('Ce livre coûte 10 000 wons.', ['이', '책은', '만', '원이에요'], '이 책은 만 원이에요', '만 원 : pas besoin de 일.', ['numbers_sino', 'topic_particle'], 3),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 5
    {
      unit_number: 5,
      title_ko: '고유어 숫자',
      title_fr: 'Nombres coréens natifs',
      topic: 'vocabulary',
      description: '하나, 둘, 셋… et les compteurs',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '하나, 둘, 셋',
          title_fr: 'Le système natif',
          content: {
            intro: 'Le deuxième système : celui du quotidien (heures, âge, comptage). Attention, il se transforme devant un compteur.',
            sections: [
              {
                title: 'Les nombres',
                body: '1 하나 · 2 둘 · 3 셋 · 4 넷 · 5 다섯 · 6 여섯 · 7 일곱 · 8 여덟 · 9 아홉 · 10 열 · 20 스물 · 30 서른 · 40 마흔.',
                examples: [
                  { ko: '스물다섯 살', rom: 'seu-mul-da-seot sal', fr: '25 ans' },
                ],
              },
              {
                title: 'Devant un compteur, 4 nombres changent',
                body: '하나 → 한 · 둘 → 두 · 셋 → 세 · 넷 → 네 · 스물 → 스무. On écrit : nom + nombre + compteur.',
                examples: [
                  { ko: '커피 두 잔', rom: 'keo-pi du jan', fr: 'deux cafés (tasses)' },
                  { ko: '사과 세 개', rom: 'sa-gwa se gae', fr: 'trois pommes' },
                ],
              },
              {
                title: 'Les compteurs essentiels',
                body: '개 = objets · 명 (ou 사람) = personnes · 마리 = animaux · 권 = livres · 잔 = tasses · 병 = bouteilles · 살 = âge · 시 = heures.',
                examples: [
                  { ko: '학생 네 명', rom: 'hak-saeng ne myeong', fr: 'quatre étudiants' },
                  { ko: '세 시', rom: 'se si', fr: '3 heures' },
                ],
              },
            ],
            tip: 'Heures = natif (세 시), minutes = sino (십 분) : "세 시 십 분" = 3 h 10. Les deux systèmes dans la même phrase, c\'est tout le charme du coréen 😏 Et pour la demie, on dit souvent 반 : 두 시 반 = 2 h 30.',
          },
          exercises: [
            mc('Comment dit-on 3 en coréen natif ?', null, ['셋', '삼', '넷', '사'], '셋', '셋 = 3 natif (devant un compteur : 세).', ['numbers_native']),
            mc('Devant un compteur, "un" (하나) devient :', null, ['한', '하나', '일', '첫'], '한', '하나 → 한 devant un compteur : 한 명, 한 잔.', ['numbers_native', 'counters']),
            fb('커피 ___ 잔 주세요.', 'Deux cafés, s\'il vous plaît.', ['두', '둘', '이', '둘이'], '두', '둘 → 두 devant un compteur.', ['numbers_native', 'counters']),
            mc('Quel compteur pour les personnes ?', null, ['명', '개', '마리', '권'], '명', '명 (ou 사람) pour les personnes.', ['counters']),
            mc('Quel compteur pour les livres ?', null, ['권', '개', '병', '명'], '권', '권 pour les livres, cahiers, magazines.', ['counters']),
            mc('Comment lit-on 3시 (3 heures) ?', null, ['세 시', '삼 시', '셋 시', '사 시'], '세 시', 'Heures = natif : 셋 → 세 devant 시.', ['numbers_native', 'counters']),
            tk('Deux personnes.', '두 명 | 두 사람', '둘 → 두 + 명.', ['numbers_native', 'counters']),
            tk('Trois cafés, s\'il vous plaît.', '커피 세 잔 주세요', '커피 + 세 + 잔 + 주세요 (s\'il vous plaît, donnez-moi).', ['numbers_native', 'counters'], 3),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '고유어 숫자 연습',
          title_fr: 'Entraînement : nombres natifs',
          exercises: [
            fb('저는 ___ 살이에요. (25 ans)', 'J\'ai 25 ans.', ['스물다섯', '이십오', '스무다섯', '이십다섯'], '스물다섯', 'L\'âge (살) se dit en natif : 스물다섯 살.', ['numbers_native', 'counters']),
            fb('물 ___ 병 주세요.', 'Une bouteille d\'eau, s\'il vous plaît.', ['한', '하나', '일', '첫'], '한', '하나 → 한 devant 병.', ['numbers_native', 'counters']),
            fb('고양이 ___ 마리가 있어요.', 'J\'ai quatre chats.', ['네', '넷', '사', '너'], '네', '넷 → 네 devant 마리.', ['numbers_native', 'counters']),
            fb('사과가 ___ 개 있어요.', 'Il y a trois pommes.', ['세', '셋', '삼', '사'], '세', '셋 → 세 devant 개.', ['numbers_native', 'counters']),
            mc('Quel système utilise-t-on pour l\'âge (살) ?', null, ['Coréen natif', 'Sino-coréen', 'Les deux au choix', 'Aucun'], 'Coréen natif', 'Âge = natif (스물다섯 살).', ['numbers_native', 'counters']),
            mc('Comment lit-on 2시 30분 ?', null, ['두 시 삼십 분', '이 시 삼십 분', '두 시 서른 분', '이 시 서른 분'], '두 시 삼십 분', 'Heures = natif (두 시), minutes = sino (삼십 분).', ['numbers_native', 'numbers_sino', 'counters'], 3),
            ls('커피 두 잔 주세요', ['커피 두 잔 주세요', '커피 세 잔 주세요', '커피 한 잔 주세요', '커피 네 잔 주세요'], '커피 두 잔 주세요', '두 = deux. Écoute bien 두 / 세 / 한 / 네.', ['numbers_native', 'counters']),
            tf('저는 책 두 권을 샀어요.', 'J\'ai acheté deux livres | J\'ai acheté 2 livres | Moi, j\'ai acheté deux livres', '책 두 권 = deux livres ; 샀어요 = j\'ai acheté.', ['numbers_native', 'counters']),
            mc('Quelle phrase est correcte ? (trois pommes)', null, ['사과 세 개', '세 사과 개', '세 개 사과', '사과 개 세'], '사과 세 개', 'Ordre : nom + nombre + compteur (사과 + 세 + 개).', ['counters', 'numbers_native'], 2),
            mc('Quelle phrase est correcte ? (deux cafés)', null, ['커피 두 잔', '두 커피 잔', '두 잔 커피', '잔 두 커피'], '커피 두 잔', 'Même ordre : nom + nombre + compteur ; et 둘 devient 두 devant le compteur.', ['counters', 'numbers_native'], 2),
            ro('J\'ai mangé trois pommes.', ['저는', '사과', '세', '개를', '먹었어요'], '저는 사과 세 개를 먹었어요', 'Nom + nombre + compteur + particule + verbe.', ['numbers_native', 'counters', 'object_particle'], 3),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 6 — BOSS
    {
      unit_number: 6,
      title_ko: '종합 평가',
      title_fr: 'Boss : évaluation mixte',
      topic: 'grammar',
      description: 'Tout l\'étage 1 en un seul combat',
      lessons: [
        {
          lesson_number: 1,
          type: 'boss',
          title_ko: '1층 보스',
          title_fr: 'Boss de l\'étage 1',
          exercises: [
            fb('저는 회사___ 일해요.', 'Je travaille au bureau.', ['에서', '에', '로', '를'], '에서', '일하다 n\'est pas dans la liste des verbes en 에 → 에서.', ['e_vs_eseo', 'particles'], 3),
            fb('내일 부산___ 가요.', 'Demain, je vais à Busan.', ['에', '에서', '로', '를'], '에', '가다 + destination → 에.', ['e_vs_eseo', 'particles'], 3),
            fb('저___ 프랑스 사람이에요.', 'Moi, je suis français(e).', ['는', '가', '를', '에'], '는', 'Thème "quant à moi" → 저는.', ['topic_particle', 'particles'], 2),
            fb('저는 커피___ 마셔요.', 'Je bois du café.', ['를', '을', '가', '이'], '를', '커피 finit par une voyelle → 를.', ['object_particle', 'particles'], 2),
            fb('자기 ___ 샤워해요.', 'Je prends une douche avant de dormir.', ['전에', '후에', '동안', '때'], '전에', '"Avant de" = 기 전에.', ['temporal'], 3),
            fb('택시___ 가요.', 'J\'y vais en taxi.', ['로', '으로', '에', '에서'], '로', '택시 finit par une voyelle → 로.', ['direction', 'particles'], 3),
            mc('Comment lit-on 10분 ?', null, ['십 분', '열 분', '십 시', '열 시'], '십 분', 'Minutes = sino.', ['numbers_sino', 'counters'], 2),
            ls('저는 식당에서 밥을 먹어요', ['저는 식당에서 밥을 먹어요', '저는 식당에 밥을 먹어요', '저는 식당에서 밥이 먹어요', '저는 식당에서 밥을 마셔요'], '저는 식당에서 밥을 먹어요', '먹다 n\'est pas dans la liste des verbes en 에 → 에서.', ['e_vs_eseo', 'listening'], 3),
            ro('Je lis un livre à la bibliothèque.', ['저는', '도서관에서', '책을', '읽어요'], '저는 도서관에서 책을 읽어요', 'Thème → lieu de l\'action → objet → verbe.', ['e_vs_eseo', 'object_particle'], 3),
            tf('저는 학교에서 한국어를 공부해요.', 'J\'étudie le coréen à l\'école | J\'apprends le coréen à l\'école | Moi, j\'étudie le coréen à l\'école', '학교에서 = à l\'école (action) ; 한국어를 = le coréen (COD).', ['e_vs_eseo', 'object_particle'], 3),
            tk('Trois mille wons.', '삼천 원', 'Argent = sino : 삼천 원.', ['numbers_sino', 'counters'], 3),
            tk('Quatre personnes.', '네 명 | 네 사람', '넷 → 네 devant 명.', ['numbers_native', 'counters'], 3),
            tk('Je prends le petit-déjeuner à 7 heures.', '일곱 시에 아침을 먹어요 | 저는 일곱 시에 아침을 먹어요 | 7시에 아침을 먹어요 | 저는 7시에 아침을 먹어요', 'Heures = natif (일곱 시) + 에 (heure précise).', ['numbers_native', 'time_particle', 'temporal'], 4),
          ],
        },
      ],
    },
  ],
};

// ---------- Génération SQL ----------
const q = (s) => (s === null || s === undefined ? 'NULL' : `'${String(s).replaceAll("'", "''")}'`);
const json = (v) => (v === null || v === undefined ? 'NULL' : `'${JSON.stringify(v).replaceAll("'", "''")}'::jsonb`);
const arr = (a) => (a && a.length ? `ARRAY[${[...new Set(a)].map(q).join(', ')}]::text[]` : 'NULL');

const FLOORS = [floor1, floor2, floor3, floor4, floor5];
const here = dirname(fileURLToPath(import.meta.url));

const out = [];
out.push('-- ============================================================');
out.push('-- 한글 with Karina — Seed : étages 1 à 5');
out.push('-- Fichier GÉNÉRÉ par supabase/seed/build-seed.mjs — ne pas éditer à la main.');
out.push("-- À exécuter APRÈS schema.sql. Rejouable : remplace le contenu statique de chaque étage.");
out.push('-- ============================================================');
out.push('');

let exCount = 0;
let lessonCount = 0;
for (const f of FLOORS) {
  out.push(`-- ################ Étage ${f.floor_number} : ${f.title_fr} ################`);
  out.push(
    `insert into floors (floor_number, title_ko, title_fr, cefr_level, description, unlock_xp)
values (${f.floor_number}, ${q(f.title_ko)}, ${q(f.title_fr)}, ${q(f.cefr_level)}, ${q(f.description)}, 0)
on conflict (floor_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr,
  cefr_level = excluded.cefr_level, description = excluded.description;`,
  );
  out.push('');

  for (const u of f.units) {
    out.push(`-- ---------- Étage ${f.floor_number} · Unité ${u.unit_number} : ${u.title_fr} ----------`);
    out.push(
      `insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, ${u.unit_number}, ${q(u.title_ko)}, ${q(u.title_fr)}, ${q(u.topic)}, ${q(u.description)} from floors where floor_number = ${f.floor_number}
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;`,
    );

    for (const l of u.lessons) {
      lessonCount++;
      const where = `from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = ${f.floor_number} and u.unit_number = ${u.unit_number} and l.lesson_number = ${l.lesson_number}`;
      out.push(
        `insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, ${l.lesson_number}, ${q(l.title_ko)}, ${q(l.title_fr)}, ${q(l.type)}, ${json(l.content ?? null)}
from units u join floors f on f.id = u.floor_id where f.floor_number = ${f.floor_number} and u.unit_number = ${u.unit_number}
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;`,
      );
      out.push(`delete from exercises where is_llm_generated = false and lesson_id in (select l.id ${where});`);
      for (const e of l.exercises) {
        exCount++;
        out.push(
          `insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, ${q(e.type)}, ${q(e.ko ?? null)}, ${q(e.fr ?? null)}, ${q(e.answer)}, ${json(e.options ?? null)}, ${q(e.expl)}, ${e.d}, ${arr(e.tags)}, false
${where};`,
        );
      }
      out.push('');
    }
  }
}
out.push(`-- ${exCount} exercices au total.`);
writeFileSync(join(here, '..', 'seed.sql'), out.join('\n') + '\n');
console.log(`seed.sql écrit : ${exCount} exercices, ${lessonCount} leçons, ${FLOORS.length} étages.`);

// ---------- Documents de relecture pour un humain (docs/relecture-etage<N>.md) ----------
const docsDir = join(here, '..', '..', 'docs');
mkdirSync(docsDir, { recursive: true });
const bodies = [];
for (const f of FLOORS) {
  const md = [];
  md.push(`# Relecture du coréen — étage ${f.floor_number} : ${f.title_fr} (${f.title_ko})`);
  md.push('');
  md.push("Document généré depuis le contenu de l'application (`supabase/seed/build-seed.mjs`). Les phrases ont été écrites par une IA, **sans relecteur humain**.");
  md.push('');
  md.push('## Consigne pour la personne qui relit');
  md.push('');
  md.push('Pour chaque ligne, répondre **OK**, ou **à corriger** avec la version correcte. Merci de vérifier :');
  md.push('');
  md.push('1. **La justesse** : la phrase coréenne est-elle grammaticalement correcte ?');
  md.push("2. **Le naturel** : est-ce ce qu'un natif dirait ? (une phrase peut être correcte mais bizarre)");
  md.push('3. **Les mauvaises options** : sont-elles bien fausses ? (une option « fausse » qui serait en fait acceptable est un vrai problème)');
  md.push('4. **La traduction française** correspond-elle ?');
  md.push("5. **Les romanisations** des cours (romanisation simplifiée : syllabes séparées par des tirets, liaison à l'intérieur d'un mot, pas de liaison entre deux mots).");
  md.push('');
  md.push('Le niveau visé est A2 → B1. Les phrases sont volontairement simples.');
  md.push('');
  const body = [];
  let n = 0;
  for (const u of f.units) {
    body.push(`## Unité ${u.unit_number} — ${u.title_fr} (${u.title_ko})`);
    body.push('');
    for (const l of u.lessons) {
      body.push(`### ${l.title_fr} (${l.title_ko}) — ${l.type}`);
      body.push('');
      if (l.content) {
        body.push("**Cours (texte affiché dans l'application)**");
        body.push('');
        for (const sec of l.content.sections) {
          body.push(`- *${sec.title}* — ${sec.body}`);
          for (const ex of sec.examples || []) body.push(`  - ${ex.ko} (${ex.rom}) — ${ex.fr}`);
        }
        if (l.content.tip) body.push(`- Astuce : ${l.content.tip}`);
        body.push('');
      }
      body.push('**Exercices**');
      body.push('');
      body.push('| # | Phrase / question | Réponse attendue | Options fausses | Traduction / consigne | Avis |');
      body.push('| --- | --- | --- | --- | --- | --- |');
      for (const e of l.exercises) {
        n++;
        const answers = e.answer.split('|').map((x) => x.trim());
        const cell = (t) => String(t ?? '').replaceAll('|', '\\|').replaceAll('\n', ' ');
        let sentence;
        let wrong = '';
        if (e.type === 'fill_blank') {
          sentence = e.ko.replace('___', `**${answers[0]}**`);
          wrong = e.options.filter((o) => !answers.includes(o)).join(' · ');
        } else if (e.type === 'multiple_choice') {
          sentence = e.fr + (e.ko ? ` — ${e.ko}` : '');
          wrong = e.options.filter((o) => !answers.includes(o)).join(' · ');
        } else if (e.type === 'sounds_right') {
          sentence = `(écoute — laquelle sonne juste ?) ${e.options.join(' / ')}`;
          wrong = e.options.filter((o) => !answers.includes(o)).join(' · ');
        } else if (e.type === 'listening') {
          sentence = `(écoute) ${e.ko}`;
          wrong = e.options.filter((o) => !answers.includes(o)).join(' · ');
        } else if (e.type === 'reorder') {
          sentence = `(remettre en ordre) ${e.options.join(' / ')}`;
        } else if (e.type === 'free_production') {
          sentence = `(production libre, corrigée par l'IA) ${e.fr}`;
        } else if (e.type === 'translate_fr') {
          sentence = `(traduire en français) ${e.ko}`;
        } else {
          sentence = `(traduire en coréen) ${e.fr}`;
        }
        const shown = e.type === 'fill_blank' ? answers.join(' / ') : answers.join('  ·  ');
        body.push(`| ${n} | ${cell(sentence)} | ${cell(shown)} | ${cell(wrong)} | ${cell(e.type === 'fill_blank' ? e.fr : e.type === 'multiple_choice' || e.type === 'translate_ko' ? '' : e.fr || '')} | |`);
      }
      body.push('');
    }
  }
  md.push(...body);
  bodies.push({ f, body, n });
  writeFileSync(join(docsDir, `relecture-etage${f.floor_number}.md`), md.join('\n') + '\n');
  console.log(`docs/relecture-etage${f.floor_number}.md écrit : ${n} exercices à relire.`);
}

// ---------- Document unique étages 1 à 5, avec les corrections déjà prises en charge ----------
{
  const all = [];
  all.push('# Relecture du coréen — étages 1 à 5');
  all.push('');
  all.push("Document généré depuis le contenu de l'application (`supabase/seed/build-seed.mjs`). Les phrases ont été écrites par une IA ; les étages 3 à 5 ont déjà reçu une première série de corrections (voir plus bas), les étages 1 et 2 ont été relus par une IA, **aucun par un humain**.");
  all.push('');
  all.push('## Consigne pour la personne qui relit');
  all.push('');
  all.push('Pour chaque ligne, répondre **OK**, ou **à corriger** avec la version correcte. Merci de vérifier :');
  all.push('');
  all.push('1. **La justesse** : la phrase coréenne est-elle grammaticalement correcte ?');
  all.push("2. **Le naturel** : est-ce ce qu'un natif dirait ? (une phrase peut être correcte mais bizarre)");
  all.push('3. **Les mauvaises options** : sont-elles bien fausses ? (une option « fausse » qui serait en fait acceptable est un vrai problème, y compris une terminaison qui apparaît ailleurs comme réponse acceptée)');
  all.push('4. **Les réponses acceptées** des exercices de traduction : en manque-t-il, y en a-t-il de trop ?');
  all.push('5. **La traduction française** correspond-elle ?');
  all.push("6. **Les romanisations** des cours (romanisation simplifiée : syllabes séparées par des tirets, liaison à l'intérieur d'un mot, pas de liaison entre deux mots).");
  all.push('');
  all.push('Les numéros (#) **recommencent à 1 à chaque étage** : citer toujours « étage + numéro + début de la phrase ». Niveau visé : A2 → B1.');
  all.push('');
  try {
    const log = readFileSync(join(docsDir, 'corrections-opus-etages-3-5.md'), 'utf8').trim();
    all.push(log.replace(/^# /gm, '## ').replace(/^## (?!Corrections)/gm, '### '));
    all.push('');
  } catch {
    /* pas de journal de corrections */
  }
  for (const { f, body, n } of bodies) {
    all.push('---');
    all.push('');
    all.push(`# Étage ${f.floor_number} — ${f.title_fr} (${f.title_ko}) · ${n} exercices`);
    all.push('');
    all.push(...body);
  }
  writeFileSync(join(docsDir, 'relecture-etages-1-a-5.md'), all.join('\n') + '\n');
  console.log('docs/relecture-etages-1-a-5.md écrit.');
}
