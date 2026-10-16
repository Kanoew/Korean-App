// Étage 4 — 이유와 연결 : raisons, contrastes, conditions (B1).
// ⚠️ Contenu écrit par une IA et PAS ENCORE relu par un humain : voir docs/relecture-etage4.md.
import { mc, fb, ro, tk, tf, ls, fp } from './helpers.mjs';

export const floor4 = {
  floor_number: 4,
  title_ko: '이유와 연결',
  title_fr: 'Raisons et liens',
  cefr_level: 'B1',
  description: 'Expliquer pourquoi, opposer deux idées, parler de conditions et de moments : relier tes phrases pour de vrai.',
  units: [
    // ============================================================ UNITÉ 1 — -아/어서
    {
      unit_number: 1,
      title_ko: '-아/어서',
      title_fr: 'Dire pourquoi : -아/어서',
      topic: 'grammar',
      description: '-아/어서 (cause), 그래서 et 왜',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-아/어서',
          title_fr: 'Donner une cause',
          content: {
            intro: "Jusqu'ici tes phrases étaient courtes et indépendantes. À partir d'ici, tu les relies : d'abord pour dire pourquoi quelque chose arrive.",
            sections: [
              {
                title: 'Radical + 아/어서 — « parce que, donc »',
                body: "On forme -아/어서 comme le présent poli, mais on remplace 요 par 서 : dernière voyelle ㅏ ou ㅗ → 아서 (좋다 → 좋아서) ; autres voyelles → 어서 (늦다 → 늦어서) ; 하다 → 해서. Si le radical finit par ㅡ, il tombe et on regarde la syllabe d'avant, comme au présent : 고프다 → 고파서, 예쁘다 → 예뻐서. Le sens : la première partie est la cause, la seconde la conséquence. Règle importante : on ne met jamais de temps avant 서 (비가 와서, pas 비가 왔어서), et la fin de phrase ne peut être ni un ordre ni une proposition.",
                examples: [
                  { ko: '비가 와서 집에 있어요.', rom: 'bi-ga wa-seo ji-be i-sseo-yo', fr: "Il pleut, donc je reste à la maison." },
                  { ko: '피곤해서 일찍 잤어요.', rom: 'pi-gon-hae-seo il-jjik ja-sseo-yo', fr: "J'étais fatigué(e), alors j'ai dormi tôt." },
                  { ko: '배가 고파서 빵을 샀어요.', rom: 'bae-ga go-pa-seo ppang-eul sa-sseo-yo', fr: "J'avais faim, alors j'ai acheté du pain." },
                  { ko: '늦어서 미안해요.', rom: 'neu-jeo-seo mi-an-hae-yo', fr: "Désolé(e) d'être en retard." },
                ],
              },
              {
                title: '그래서 et 왜 — « donc » et « pourquoi »',
                body: "그래서 relie deux phrases : on le met au début de la seconde. 왜 ? signifie « pourquoi ? » ; on répond souvent avec -아/어서요.",
                examples: [
                  { ko: '비가 와요. 그래서 집에 있어요.', rom: 'bi-ga wa-yo. geu-rae-seo ji-be i-sseo-yo', fr: "Il pleut. Donc je reste à la maison." },
                  { ko: '왜 한국어를 배워요?', rom: 'wae han-gu-geo-reul bae-wo-yo', fr: 'Pourquoi apprends-tu le coréen ?' },
                  { ko: '한국 드라마를 좋아해서요.', rom: 'han-guk deu-ra-ma-reul jo-a-hae-seo-yo', fr: "Parce que j'aime les dramas coréens." },
                ],
              },
            ],
            tip: "S'excuser ou remercier passe toujours par -아/어서 : 늦어서 미안해요. Et retiens le piège : jamais de passé avant 서, le temps se met à la fin de la phrase.",
          },
          exercises: [
            fb('비가 와___ 집에 있어요.', 'Il pleut, donc je reste à la maison.', ['서', '면', '러', '까'], '서', '오다 : 오 + 아 → 와, puis 서 : 와서.', ['reason']),
            fb('피곤___ 일찍 잤어요.', "J'étais fatigué(e), alors j'ai dormi tôt.", ['해서', '하서', '했서', '해어서'], '해서', '하다 → 해서.', ['reason']),
            fb('늦___ 미안해요.', "Désolé(e) d'être en retard.", ['어서', '아서', '해서', '여서'], '어서', '늦다 : dernière voyelle ㅡ → 어서 : 늦어서.', ['reason'], 2),
            fb('배가 ___ 빵을 샀어요.', "J'avais faim, alors j'ai acheté du pain.", ['고파서', '고프어서', '고프서', '고픈서'], '고파서', '고프다 : ㅡ tombe, voyelle précédente ㅗ → 아서 : 고파서.', ['reason'], 3),
            mc('Avec -아/어서, la fin de la phrase ne peut PAS être :', null, ['un ordre (-(으)세요)', 'un verbe au passé', 'un verbe au présent', 'une négation'], 'un ordre (-(으)세요)', 'Après -아/어서, ni ordre ni proposition (on utilisera -(으)니까, voir l\'unité suivante).', ['reason'], 3),
            mc('Que signifie « 왜 » ?', null, ['Pourquoi', 'Quand', 'Où', 'Qui'], 'Pourquoi', '왜 = pourquoi.', ['reason']),
            tk('Il pleut, donc je reste à la maison.', '비가 와서 집에 있어요 | 비가 와요. 그래서 집에 있어요', '와서 = parce qu\'il pleut ; 그래서 = donc.', ['reason']),
            ro("J'étais fatigué(e), alors j'ai dormi tôt.", ['피곤해서', '일찍', '잤어요'], '피곤해서 일찍 잤어요', "Cause avec 서 → complément → verbe au passé.", ['reason'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '-아/어서 연습',
          title_fr: 'Entraînement : donner une cause',
          exercises: [
            fb('날씨가 좋___ 공원에 갔어요.', "Il faisait beau, alors je suis allé(e) au parc.", ['아서', '어서', '해서', '와서'], '아서', '좋다 : dernière voyelle ㅗ → 아서.', ['reason']),
            fb('음식이 맛있___ 많이 먹었어요.', "C'était délicieux, alors j'ai beaucoup mangé.", ['어서', '아서', '해서', '있서'], '어서', '맛있다 : dernière voyelle ㅣ → 어서.', ['reason']),
            fb('시간이 없___ 택시를 탔어요.', "Je n'avais pas le temps, alors j'ai pris un taxi.", ['어서', '아서', '해서', '없서'], '어서', '없다 : dernière voyelle ㅓ → 어서.', ['reason']),
            fb('일이 많___ 바빠요.', "J'ai beaucoup de travail, donc je suis occupé(e).", ['아서', '어서', '해서', '많서'], '아서', '많다 : dernière voyelle ㅏ → 아서.', ['reason']),
            fb('비가 와요. ___ 집에 있어요.', 'Il pleut. Donc je reste à la maison.', ['그래서', '하지만', '그런데', '그러면'], '그래서', '그래서 = donc, c\'est pourquoi.', ['reason']),
            mc('Quelle phrase est correcte ?', null, ['피곤해서 일찍 잤어요', '피곤했어서 일찍 잤어요', '피곤해서 일찍 자세요', '피곤해서 일찍 잘까요'], '피곤해서 일찍 잤어요', "Pas de passé avant 서 ; après 서, ni ordre ni proposition.", ['reason'], 3),
            mc('Comment demande-t-on « Pourquoi ? » ?', null, ['왜요?', '뭐요?', '어디요?', '언제요?'], '왜요?', '왜 = pourquoi.', ['reason']),
            ls('비가 와서 집에 있어요', ['비가 와서 집에 있어요', '비가 와요. 그래서 집에 갔어요', '비가 와서 집에 없어요', '비가 오면 집에 있어요'], '비가 와서 집에 있어요', '와서 = parce qu\'il pleut. Écoute bien la forme du verbe.', ['reason']),
            tk("Désolé(e) d'être en retard.", '늦어서 미안해요 | 늦어서 죄송해요', '늦어서 = parce que je suis en retard.', ['reason']),
            tk("Il faisait beau, alors j'ai fait du sport au parc.", '날씨가 좋아서 공원에서 운동했어요 | 날씨가 좋아서 공원에서 운동을 했어요', '좋아서 + 공원에서 (lieu d\'une action) + 운동했어요.', ['reason', 'e_vs_eseo'], 3),
            fp('Dis pourquoi tu apprends le coréen (une phrase avec -아/어서).', '-아/어서 : donner une raison', 'Exemple : 한국 드라마를 좋아해서 한국어를 배워요.', ['reason']),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 2 — -(으)니까
    {
      unit_number: 2,
      title_ko: '-(으)니까',
      title_fr: 'Une raison pour proposer ou ordonner : -(으)니까',
      topic: 'grammar',
      description: '-(으)니까, et quand le choisir à la place de -아/어서',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-(으)니까',
          title_fr: "Donner une raison avant un ordre ou une proposition",
          content: {
            intro: "-아/어서 a une limite : après lui, impossible d'ordonner ou de proposer. Pour dire « Il pleut, prenez un parapluie » ou « Je suis occupé(e), voyons-nous demain ? », il faut un autre outil.",
            sections: [
              {
                title: 'Radical + (으)니까 — « comme, puisque »',
                body: "Radical qui finit par une voyelle : + 니까 (바쁘다 → 바쁘니까). Par une consonne : + 으니까 (없다 → 없으니까). Radical en ㄹ : le ㄹ tombe (살다 → 사니까, 멀다 → 머니까). Contrairement à 서, on peut mettre le passé (늦었으니까), et la fin de la phrase peut être un ordre ou une proposition. On rencontre aussi -(으)니, sans 까 : même sens, registre plus écrit (늦었으니 빨리 가요).",
                examples: [
                  { ko: '비가 오니까 우산을 가져가세요.', rom: 'bi-ga o-ni-kka u-sa-neul ga-jyeo-ga-se-yo', fr: 'Il pleut, prenez un parapluie.' },
                  { ko: '오늘은 바쁘니까 내일 만날까요?', rom: 'o-neu-reun ba-ppeu-ni-kka nae-il man-nal-kka-yo', fr: "Aujourd'hui, je suis occupé(e) : on se voit demain ?" },
                  { ko: '늦었으니까 빨리 가요.', rom: 'neu-jeo-sseu-ni-kka ppal-li ga-yo', fr: 'Il est tard, partons vite.' },
                  { ko: '서울에 사니까 서울을 잘 알아요.', rom: 'seo-u-re sa-ni-kka seo-u-reul jal a-ra-yo', fr: "J'habite à Séoul, donc je connais bien Séoul." },
                ],
              },
              {
                title: '-아/어서 ou -(으)니까 ?',
                body: "Si la fin de ta phrase est un ordre (-(으)세요) ou une proposition (-(으)ㄹ까요, -아/어요 « allons-y »), choisis -(으)니까. Pour un simple lien de cause, -아/어서 est plus courant et plus neutre. Pour s'excuser ou remercier, toujours -아/어서.",
                examples: [
                  { ko: '시간이 없으니까 택시를 타세요.', rom: 'si-ga-ni eop-sseu-ni-kka taek-si-reul ta-se-yo', fr: "Vous n'avez pas le temps, prenez un taxi." },
                ],
              },
            ],
            tip: "Test rapide : ta phrase finit par un ordre ou une proposition ? → -(으)니까. Ta phrase finit par une information, une excuse ou un remerciement ? → -아/어서.",
          },
          exercises: [
            fb('비가 오___ 우산을 가져가세요.', 'Il pleut, prenez un parapluie.', ['니까', '러', '아서', '서'], '니까', '오다 finit par une voyelle → 니까.', ['reason']),
            fb('시간이 없___ 빨리 가요.', "On n'a pas le temps, partons vite.", ['으니까', '니까', '어서', '으러'], '으니까', '없다 finit par une consonne → 으니까.', ['reason'], 2),
            fb('오늘은 바쁘___ 내일 만날까요?', "Aujourd'hui, je suis occupé(e) : on se voit demain ?", ['니까', '으니까', '아서', '어서'], '니까', '바쁘다 finit par une voyelle (ㅡ) → 니까 ; 서 est impossible avant une proposition.', ['reason'], 2),
            fb('저는 서울에 ___ 서울을 잘 알아요.', "J'habite à Séoul, donc je connais bien Séoul.", ['사니까', '살니까', '살으니까', '사으니까'], '사니까', '살다 (radical en ㄹ) : le ㄹ tombe devant 니까.', ['reason'], 3),
            mc('Avec -(으)니까, la fin de la phrase peut être :', null, ['un ordre ou une proposition', 'seulement un verbe au passé', 'seulement une question', 'jamais un ordre'], 'un ordre ou une proposition', 'C\'est justement la différence avec -아/어서.', ['reason']),
            mc('Quelle phrase est correcte ?', null, ['늦었으니까 빨리 가요', '늦었어서 빨리 가요', '늦으니까니 빨리 가요', '늦었니까니 빨리 가요'], '늦었으니까 빨리 가요', 'Le passé est possible avec -(으)니까, jamais avec 서.', ['reason'], 3),
            tk('Il pleut, prenez un parapluie.', '비가 오니까 우산을 가져가세요 | 비가 오니까 우산 가져가세요', '오니까 + ordre en -(으)세요.', ['reason']),
            tf('바쁘니까 내일 만날까요?', "Comme je suis occupé(e), on se voit demain ? | Je suis occupé(e), alors on se voit demain ? | Je suis occupé(e), alors et si on se voyait demain ?", '바쁘니까 = comme je suis occupé(e) ; 만날까요 = proposition.', ['reason', 'suggest']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '-(으)니까 연습',
          title_fr: 'Entraînement : raison avant un ordre',
          exercises: [
            fb('너무 많이 먹었___ 좀 쉬어요.', 'On a trop mangé, reposons-nous un peu.', ['으니까', '니까', '어서', '서'], '으니까', '먹었다 finit par une consonne (ㅆ) → 으니까.', ['reason'], 3),
            fb('길이 ___ 택시를 타세요.', "C'est loin, prenez un taxi.", ['머니까', '멀으니까', '멀니까', '머서'], '머니까', '멀다 (radical en ㄹ) : le ㄹ tombe devant 니까.', ['reason'], 3),
            fb('피곤하니까 일찍 ___.', 'Vous êtes fatigué(e), reposez-vous tôt.', ['쉬세요', '쉬으세요', '쉬어세요', '쉬요세요'], '쉬세요', '쉬다 finit par une voyelle → 세요.', ['reason', 'honorific']),
            mc('Quelle phrase est correcte ?', null, ['시간이 없으니까 택시를 타세요', '시간이 없어서 택시를 타세요', '시간이 없었어서 택시를 타세요', '시간이 없으니 택시까를 타세요'], '시간이 없으니까 택시를 타세요', 'Ordre à la fin → -(으)니까, pas 서.', ['reason'], 3),
            mc('Pour donner une raison avant un ordre (« Dépêchez-vous, il est tard ! »), on utilise :', null, ['-(으)니까', '-아/어서', '-고', '-지만'], '-(으)니까', '-(으)니까 accepte les ordres et les propositions.', ['reason']),
            ls('비가 오니까 우산을 가져가세요', ['비가 오니까 우산을 가져가세요', '비가 와서 우산을 가져갔어요', '비가 오니까 우산을 샀어요', '비가 오면 우산을 가져가세요'], '비가 오니까 우산을 가져가세요', '오니까 + -(으)세요. Écoute bien la fin.', ['reason']),
            tk("Il est tard, partons vite.", '늦었으니까 빨리 가요 | 시간이 늦었으니까 빨리 가요 | 늦었으니 빨리 가요', '늦었으니까 : passé + 으니까.', ['reason'], 3),
            tk("Il fait beau, allons au parc ensemble.", '날씨가 좋으니까 같이 공원에 가요 | 날씨가 좋으니까 같이 공원에 갈까요 | 날씨가 좋으니까 공원에 같이 가요', '좋으니까 + proposition.', ['reason', 'suggest'], 3),
            tf('피곤하니까 일찍 쉬세요.', "Vous êtes fatigué(e), reposez-vous tôt | Comme vous êtes fatigué(e), reposez-vous tôt", '피곤하니까 = comme tu es fatigué(e) ; 쉬세요 = repose-toi.', ['reason']),
            fp('Propose à un ami de faire quelque chose en donnant une raison avec -(으)니까.', '-(으)니까 : raison + proposition', 'Exemple : 날씨가 좋으니까 같이 산책할까요?', ['reason', 'suggest'], 4),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 3 — -지만 / 하지만
    {
      unit_number: 3,
      title_ko: '-지만',
      title_fr: 'Opposer deux idées : -지만',
      topic: 'grammar',
      description: '-지만, 하지만, 그런데',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-지만',
          title_fr: 'Dire « mais »',
          content: {
            intro: "Les raisons, c'est fait. Maintenant, les contrastes : « c'est bon mais cher », « je suis fatigué mais je viens ». Bonne surprise : -지만 est la forme la plus régulière du coréen.",
            sections: [
              {
                title: 'Radical + 지만 — « mais »',
                body: "On colle 지만 directement au radical, sans rien changer : 먹다 → 먹지만, 좋다 → 좋지만, 하다 → 하지만. Pas de voyelle ou de consonne à surveiller, pas de ㅡ qui tombe. Pour le passé, on met 았/었 avant : 왔지만, 먹었지만.",
                examples: [
                  { ko: '이 음식은 맛있지만 비싸요.', rom: 'i eum-si-geun ma-sit-ji-man bi-ssa-yo', fr: 'Ce plat est délicieux mais cher.' },
                  { ko: '한국어는 어렵지만 재미있어요.', rom: 'han-gu-geo-neun eo-ryeop-ji-man jae-mi-i-sseo-yo', fr: 'Le coréen est difficile mais amusant.' },
                  { ko: '저는 수영은 못 하지만 운동은 좋아해요.', rom: 'jeo-neun su-yeong-eun mot ha-ji-man un-dong-eun jo-a-hae-yo', fr: "Je ne sais pas nager, mais j'aime le sport." },
                  { ko: '비가 왔지만 갔어요.', rom: 'bi-ga wat-ji-man ga-sseo-yo', fr: "Il pleuvait, mais j'y suis allé(e)." },
                ],
              },
              {
                title: 'Au début d\'une phrase : 하지만 et 그런데',
                body: "Pour commencer une nouvelle phrase, 하지만 veut dire « mais, cependant » (opposition nette). 그런데 est plus souple : « mais », « or », ou « au fait » pour changer de sujet.",
                examples: [
                  { ko: '저는 커피를 좋아해요. 하지만 오늘은 마시고 싶지 않아요.', rom: 'jeo-neun keo-pi-reul jo-a-hae-yo. ha-ji-man o-neu-reun ma-si-go sip-ji a-na-yo', fr: "J'aime le café. Mais aujourd'hui, je ne veux pas en boire." },
                  { ko: '오늘 날씨가 좋아요. 그런데 너무 바빠요.', rom: 'o-neul nal-ssi-ga jo-a-yo. geu-reon-de neo-mu ba-ppa-yo', fr: "Il fait beau aujourd'hui. Mais je suis très occupé(e)." },
                ],
              },
            ],
            tip: "-지만 se colle au radical, sans condition. Il relie DEUX PARTIES d'une phrase ; 하지만 et 그런데 relient DEUX PHRASES.",
          },
          exercises: [
            fb('이 음식은 맛있___ 비싸요.', 'Ce plat est délicieux mais cher.', ['지만', '아서', '니까', '면서'], '지만', '-지만 se colle au radical : 맛있 + 지만.', ['contrast']),
            fb('한국어는 어렵___ 재미있어요.', 'Le coréen est difficile mais amusant.', ['지만', '어서', '으니까', '고서'], '지만', '어렵 + 지만, sans autre changement.', ['contrast']),
            fb('저는 커피를 좋아해요. ___ 오늘은 마시고 싶지 않아요.', "J'aime le café. Mais aujourd'hui, je ne veux pas en boire.", ['하지만', '그래서', '그리고', '그러면'], '하지만', '하지만 = mais (début de phrase).', ['contrast']),
            fb('오늘 날씨가 좋아요. ___ 너무 바빠요.', 'Il fait beau aujourd\'hui. Mais je suis très occupé(e).', ['그런데', '그래서', '그리고', '그러니까'], '그런데', '그런데 = mais / or (début de phrase).', ['contrast']),
            mc('Que signifie « -지만 » ?', null, ['mais', 'parce que', 'si', 'quand'], 'mais', '-지만 oppose deux idées.', ['contrast']),
            mc("Comment dit-on « Il pleuvait, mais j'y suis allé(e) » ?", null, ['비가 왔지만 갔어요', '비가 왔서 갔어요', '비가 와지만 갔어요', '비가 왔지만이 갔어요'], '비가 왔지만 갔어요', 'Passé : 왔 + 지만.', ['contrast'], 2),
            tk('Ce plat est délicieux mais cher.', '이 음식은 맛있지만 비싸요 | 음식이 맛있지만 비싸요', '맛있다 + 지만 ; 비싸요 = c\'est cher.', ['contrast']),
            ro('Le coréen est difficile mais amusant.', ['한국어는', '어렵지만', '재미있어요'], '한국어는 어렵지만 재미있어요', 'Thème → adjectif + 지만 → second adjectif.', ['contrast'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '-지만 연습',
          title_fr: 'Entraînement : opposer deux idées',
          exercises: [
            fb('저는 고기를 좋아하___ 생선은 안 먹어요.', "J'aime la viande, mais je ne mange pas de poisson.", ['지만', '아서', '어서', '러'], '지만', '좋아하다 + 지만.', ['contrast']),
            fb('저는 수영은 못 하___ 운동은 좋아해요.', "Je ne sais pas nager, mais j'aime le sport.", ['지만', '아서', '어서', '러'], '지만', '하다 + 지만.', ['contrast']),
            fb('집은 작___ 깨끗해요.', 'La maison est petite mais propre.', ['지만', '면서', '고서', '니서'], '지만', '작다 + 지만, sans changement.', ['contrast']),
            fb('주말에 쉬고 싶어요. ___ 일이 많아요.', "Je veux me reposer ce week-end. Mais j'ai beaucoup de travail.", ['하지만', '그래서', '그리고', '그러니까'], '하지만', '하지만 = mais.', ['contrast']),
            mc('Quelle phrase est correcte ?', null, ['비싸지만 맛있어요', '비싸지만이 맛있어요', '비싸지마 맛있어요', '비싸자만 맛있어요'], '비싸지만 맛있어요', '비싸다 + 지만.', ['contrast']),
            mc('Quel mot signifie « mais » et se place au début d\'une phrase ?', null, ['하지만', '-지만', '-아서', '-고'], '하지만', '하지만 commence une phrase ; -지만 se colle au radical.', ['contrast']),
            ls('이 음식은 맛있지만 비싸요', ['이 음식은 맛있지만 비싸요', '이 음식은 맛없지만 비싸요', '이 음식은 맛있지만 싸요', '이 음식은 맛있어서 비싸요'], '이 음식은 맛있지만 비싸요', '맛있다 (bon) ≠ 맛없다 (pas bon) ; 비싸다 (cher) ≠ 싸다 (bon marché).', ['contrast'], 3),
            tk("J'aime le café, mais aujourd'hui je ne veux pas en boire.", '커피를 좋아하지만 오늘은 마시고 싶지 않아요 | 저는 커피를 좋아하지만 오늘은 마시고 싶지 않아요 | 커피는 좋아하지만 오늘은 마시고 싶지 않아요 | 저는 커피는 좋아하지만 오늘은 마시고 싶지 않아요', '좋아하다 + 지만 ; 마시고 싶지 않아요 = je ne veux pas boire.', ['contrast', 'want_to'], 4),
            tk('Il fait beau, mais je suis très occupé(e).', '날씨가 좋지만 너무 바빠요 | 날씨는 좋지만 너무 바빠요 | 날씨가 좋지만 아주 바빠요 | 날씨는 좋지만 아주 바빠요 | 날씨가 좋지만 정말 바빠요', '좋다 + 지만 ; 너무 / 아주 / 정말 = très.', ['contrast'], 3),
            fp("Décris quelque chose (un plat, une ville…) avec un bon et un mauvais côté, en utilisant -지만.", '-지만 : relier deux idées opposées', 'Exemple : 서울은 복잡하지만 재미있어요.', ['contrast'], 4),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 4 — -(으)면 / -(으)ㄹ 때
    {
      unit_number: 4,
      title_ko: '-(으)면 · -(으)ㄹ 때',
      title_fr: 'Conditions et moments',
      topic: 'grammar',
      description: '-(으)면 (si) et -(으)ㄹ 때 (quand)',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-(으)면 · -(으)ㄹ 때',
          title_fr: 'Si… et quand…',
          content: {
            intro: "Deux petits mots pour parler de conditions (« s'il pleut, je reste ») et de moments (« quand je suis fatigué(e), je bois un café »). Ils servent partout, du plan de week-end à la conversation de tous les jours.",
            sections: [
              {
                title: 'Radical + (으)면 — « si »',
                body: "Radical qui finit par une voyelle : + 면 (오다 → 오면, 하다 → 하면). Par une consonne : + 으면 (있다 → 있으면, 좋다 → 좋으면). Radical en ㄹ : + 면 (살다 → 살면). La fin de la phrase peut être un futur, un ordre ou une proposition.",
                examples: [
                  { ko: '시간이 있으면 같이 가요.', rom: 'si-ga-ni i-sseu-myeon ga-chi ga-yo', fr: "Si tu as le temps, allons-y ensemble." },
                  { ko: '비가 오면 집에 있을 거예요.', rom: 'bi-ga o-myeon ji-be i-sseul geo-ye-yo', fr: "S'il pleut, je resterai à la maison." },
                  { ko: '피곤하면 쉬세요.', rom: 'pi-gon-ha-myeon swi-se-yo', fr: 'Si vous êtes fatigué(e), reposez-vous.' },
                  { ko: '한국에 가면 김치를 먹고 싶어요.', rom: 'han-gu-ge ga-myeon gim-chi-reul meok-go si-peo-yo', fr: 'Si je vais en Corée, je veux manger du kimchi.' },
                ],
              },
              {
                title: 'Radical + (으)ㄹ 때 — « quand, au moment où »',
                body: "Radical qui finit par une voyelle ou par ㄹ : + ㄹ 때 (심심하다 → 심심할 때). Par une consonne : + 을 때 (있다 → 있을 때). 때 est un nom qui veut dire « moment » : on décrit le moment avec le verbe qui précède. C'est la fin de la phrase qui donne le temps.",
                examples: [
                  { ko: '심심할 때 영화를 봐요.', rom: 'sim-sim-hal ttae yeong-hwa-reul bwa-yo', fr: "Quand je m'ennuie, je regarde un film." },
                  { ko: '시간이 있을 때 책을 읽어요.', rom: 'si-ga-ni i-sseul ttae chae-geul il-geo-yo', fr: "Quand j'ai le temps, je lis." },
                  { ko: '한국에 갈 때 비행기를 타요.', rom: 'han-gu-ge gal ttae bi-haeng-gi-reul ta-yo', fr: "Quand je vais en Corée, je prends l'avion." },
                  { ko: '피곤할 때 커피를 마셔요.', rom: 'pi-gon-hal ttae keo-pi-reul ma-syeo-yo', fr: 'Quand je suis fatigué(e), je bois un café.' },
                ],
              },
            ],
            tip: "-(으)면 pose une condition (« si »), -(으)ㄹ 때 un moment (« quand »). Pour un moment passé, on ajoute 았/었 avant : 갔을 때 (quand j'y suis allé(e)). Attention : 갈 때 = au moment d'y aller (le trajet) ; 갔을 때 = une fois là-bas. Pour « quand je serai en Corée », dis 한국에 가면.",
          },
          exercises: [
            fb('시간이 있___ 같이 가요.', "Si tu as le temps, allons-y ensemble.", ['으면', '면', '어면', '으며'], '으면', '있다 finit par une consonne → 으면.', ['conditional']),
            fb('비가 ___ 집에 있을 거예요.', "S'il pleut, je resterai à la maison.", ['오면', '오으면', '와면', '오서'], '오면', '오다 finit par une voyelle → 면.', ['conditional']),
            fb('피곤___ 쉬세요.', 'Si vous êtes fatigué(e), reposez-vous.', ['하면', '해면', '하으면', '하서'], '하면', '하다 + 면.', ['conditional']),
            fb('___ 때 영화를 봐요.', "Quand je m'ennuie, je regarde un film.", ['심심할', '심심하을', '심심해', '심심하'], '심심할', '심심하다 finit par une voyelle → ㄹ 때 : 심심할 때.', ['when'], 2),
            fb('시간이 있___ 때 책을 읽어요.', "Quand j'ai le temps, je lis.", ['을', '으', '아', '어'], '을', '있다 finit par une consonne → 을 때.', ['when'], 2),
            mc('Que signifie « -(으)면 » ?', null, ['si (condition)', 'parce que', 'mais', 'pour'], 'si (condition)', '-(으)면 pose une condition.', ['conditional']),
            mc('Que signifie « 때 » dans « 피곤할 때 » ?', null, ['au moment où, quand', 'si', 'parce que', 'mais'], 'au moment où, quand', '때 = moment.', ['when']),
            tk("Si je vais en Corée, je veux manger du kimchi.", '한국에 가면 김치를 먹고 싶어요 | 저는 한국에 가면 김치를 먹고 싶어요', '가면 = si je vais ; 먹고 싶어요 = je veux manger.', ['conditional', 'want_to'], 3),
            ro('Si tu as le temps, allons-y ensemble.', ['시간이', '있으면', '같이', '가요'], '시간이 있으면 같이 가요', 'Condition en -(으)면 → conséquence.', ['conditional'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '-(으)면 · -(으)ㄹ 때 연습',
          title_fr: 'Entraînement : si et quand',
          exercises: [
            fb('내일 비가 ___ 뭐 할 거예요?', "S'il pleut demain, que feras-tu ?", ['오면', '오으면', '와면', '오는면'], '오면', '오다 + 면.', ['conditional']),
            fb('주말에 시간이 ___ 뭐 하고 싶어요?', "Si tu as du temps ce week-end, que veux-tu faire ?", ['있으면', '있면', '있어면', '있으며'], '있으면', '있다 + 으면.', ['conditional']),
            fb('한국에 ___ 때 비행기를 타요.', "Quand je vais en Corée, je prends l'avion.", ['갈', '가', '가을', '갔'], '갈', '가다 + ㄹ 때 : 갈 때.', ['when'], 2),
            fb('배가 고플 ___ 빵을 먹어요.', "Quand j'ai faim, je mange du pain.", ['때', '면', '서', '까'], '때', '고플 때 = quand j\'ai faim.', ['when']),
            mc('Quelle phrase est correcte ?', null, ['시간이 있을 때 전화하세요', '시간이 있어 때 전화하세요', '시간이 있을면 전화하세요', '시간이 있으 때 전화하세요'], '시간이 있을 때 전화하세요', '있다 + 을 때.', ['when'], 2),
            mc("Comment dit-on « S'il fait beau, allons au parc » ?", null, ['날씨가 좋으면 공원에 가요', '날씨가 좋때 공원에 가요', '날씨가 좋으니면 공원에 가요', '날씨가 좋아면 공원에 가요'], '날씨가 좋으면 공원에 가요', '좋다 : consonne finale → 으면.', ['conditional'], 2),
            ls('비가 오면 집에 있어요', ['비가 오면 집에 있어요', '비가 와서 집에 있어요', '비가 올 때 집에 있어요', '비가 오면 집에 없어요'], '비가 오면 집에 있어요', '오면 = si il pleut. Écoute la terminaison du verbe.', ['conditional']),
            tk("S'il pleut demain, je resterai à la maison.", '내일 비가 오면 집에 있을 거예요 | 비가 오면 내일 집에 있을 거예요', '오면 + 있을 거예요 (futur).', ['conditional', 'future'], 3),
            tk("Quand j'ai faim, je mange du pain.", '배가 고플 때 빵을 먹어요 | 배고플 때 빵을 먹어요', '고프다 + ㄹ 때.', ['when'], 3),
            fp('Dis ce que tu fais quand tu es fatigué(e), ou quand tu as du temps.', '-(으)ㄹ 때 ou -(으)면', 'Exemple : 시간이 있을 때 영화를 봐요.', ['when', 'conditional'], 4),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 5 — BOSS
    {
      unit_number: 5,
      title_ko: '약속',
      title_fr: 'Boss : le rendez-vous sous la pluie',
      topic: 'grammar',
      description: "Tout l'étage 4 : raisons, contrastes et conditions autour d'un rendez-vous",
      lessons: [
        {
          lesson_number: 1,
          type: 'boss',
          title_ko: '4층 보스',
          title_fr: "Boss de l'étage 4",
          exercises: [
            fb('비가 와___ 집에 있었어요.', "Il pleuvait, alors je suis resté(e) à la maison.", ['서', '면', '러', '까'], '서', '와서 : cause ; le passé se met à la fin.', ['reason'], 2),
            fb('길이 막히___ 택시를 타지 마세요.', "Il y a des bouchons, ne prenez pas de taxi.", ['니까', '서', '아서', '으니까'], '니까', '막히다 finit par une voyelle → 니까 ; ordre à la fin → pas de 서.', ['reason'], 3),
            fb('이 가방은 예쁘___ 비싸요.', 'Ce sac est joli mais cher.', ['지만', '아서', '고서', '니서'], '지만', '예쁘다 + 지만.', ['contrast'], 2),
            fb('시간이 있___ 같이 영화 볼까요?', "Si tu as le temps, on va voir un film ?", ['으면', '면', '어면', '으니면'], '으면', '있다 + 으면.', ['conditional'], 3),
            fb('___ 때는 전화하지 마세요.', "Quand je suis occupé(e), ne m'appelez pas.", ['바쁠', '바쁘', '바빠', '바쁘을'], '바쁠', '바쁘다 + ㄹ 때 : 바쁠 때.', ['when'], 3),
            mc('Quelle phrase est correcte ?', null, ['늦어서 미안해요', '늦었어서 미안해요', '늦으니서 미안해요', '늦고서서 미안해요'], '늦어서 미안해요', 'Pas de passé avant 서.', ['reason'], 3),
            mc("Que signifie « 그런데 » au début d'une phrase ?", null, ['mais, or (ou « au fait »)', 'parce que', 'donc', 'si'], 'mais, or (ou « au fait »)', '그런데 oppose ou change de sujet.', ['contrast'], 2),
            ro("S'il pleut demain, je resterai à la maison.", ['내일', '비가', '오면', '집에', '있을', '거예요'], '내일 비가 오면 집에 있을 거예요', 'Moment → condition en -(으)면 → conséquence au futur.', ['conditional', 'future'], 3),
            tk("Je suis fatigué(e), alors je vais me coucher tôt.", '피곤해서 일찍 잘 거예요 | 저는 피곤해서 일찍 잘 거예요', '피곤해서 + 일찍 잘 거예요 (futur de 자다).', ['reason', 'future'], 3),
            tk("Le coréen est difficile, mais je veux l'apprendre.", '한국어는 어렵지만 배우고 싶어요 | 한국어는 어렵지만 저는 배우고 싶어요 | 한국어가 어렵지만 배우고 싶어요', '어렵지만 + 배우고 싶어요.', ['contrast', 'want_to'], 3),
            tk("S'il fait beau demain, allons au parc ensemble.", '내일 날씨가 좋으면 같이 공원에 가요 | 내일 날씨가 좋으면 같이 공원에 갈까요 | 내일 날씨가 좋으면 공원에 같이 가요', '좋으면 + 같이 가요 / 갈까요.', ['conditional', 'suggest'], 4),
            tf('시간이 없으니까 택시를 타세요.', "Vous n'avez pas le temps, prenez un taxi | Comme vous n'avez pas le temps, prenez un taxi | Il n'y a pas le temps, alors prenez un taxi", '없으니까 + 타세요.', ['reason'], 3),
            ls('피곤하지만 오늘은 운동하고 싶어요', ['피곤하지만 오늘은 운동하고 싶어요', '피곤해서 오늘은 운동하고 싶지 않아요', '피곤하면 오늘은 운동하고 싶어요', '피곤하니까 오늘은 운동하세요'], '피곤하지만 오늘은 운동하고 싶어요', '피곤하지만 = fatigué(e) mais… Écoute la liaison au début.', ['contrast', 'want_to'], 4),
            fp('Raconte une journée : une raison (-아/어서) et un contraste (-지만) dans la même réponse.', '-아/어서 et -지만', 'Exemple : 비가 와서 집에 있었지만 재미있었어요.', ['reason', 'contrast'], 4),
          ],
        },
      ],
    },
  ],
};
