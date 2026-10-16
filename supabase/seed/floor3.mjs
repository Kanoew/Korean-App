// Étage 3 — 하고 싶은 것 : vouloir, pouvoir, demander, proposer (A2+).
// ⚠️ Contenu écrit par une IA et PAS ENCORE relu par un humain : voir docs/relecture-etage3.md.
import { mc, fb, ro, tk, tf, ls, fp } from './helpers.mjs';

export const floor3 = {
  floor_number: 3,
  title_ko: '하고 싶은 것',
  title_fr: 'Vouloir, pouvoir, demander',
  cefr_level: 'A2+',
  description: 'Dire ce que tu veux et ce que tu peux, demander poliment, donner une consigne et faire une proposition.',
  units: [
    // ============================================================ UNITÉ 1 — vouloir
    {
      unit_number: 1,
      title_ko: '-고 싶어요',
      title_fr: 'Dire ce que tu veux',
      topic: 'grammar',
      description: '-고 싶어요 : vouloir faire quelque chose',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-고 싶어요',
          title_fr: 'Vouloir faire quelque chose',
          content: {
            intro: "Jusqu'ici tu décris, tu achètes, tu racontes. Maintenant tu exprimes une envie. Bonne nouvelle : c'est l'une des formes les plus faciles du coréen, car le verbe ne change presque pas.",
            sections: [
              {
                title: 'Verbe + 고 싶어요 — « vouloir »',
                body: "On prend le radical du verbe et on ajoute 고 싶어요. Rien à surveiller : pas de voyelle, pas de consonne, pas de 으. Le radical reste intact (먹다 → 먹고 싶어요, 가다 → 가고 싶어요). Les verbes en 하다 suivent la même règle (공부하다 → 공부하고 싶어요). Seul 싶어요 se conjugue.",
                examples: [
                  { ko: '저는 커피를 마시고 싶어요.', rom: 'jeo-neun keo-pi-reul ma-si-go si-peo-yo', fr: 'Je veux boire un café.' },
                  { ko: '한국에 가고 싶어요.', rom: 'han-gu-ge ga-go si-peo-yo', fr: 'Je veux aller en Corée.' },
                  { ko: '영화를 보고 싶어요.', rom: 'yeong-hwa-reul bo-go si-peo-yo', fr: 'Je veux voir un film.' },
                  { ko: '한국어를 배우고 싶어요.', rom: 'han-gu-geo-reul bae-u-go si-peo-yo', fr: 'Je veux apprendre le coréen.' },
                ],
              },
              {
                title: 'Poser la question, refuser',
                body: "Pour demander l'envie de quelqu'un, on garde la même forme : 뭐 먹고 싶어요 ? (Que veux-tu manger ?). Pour dire qu'on ne veut pas : radical + 고 싶지 않아요.",
                examples: [
                  { ko: '뭐 먹고 싶어요?', rom: 'mwo meok-go si-peo-yo', fr: 'Que veux-tu manger ?' },
                  { ko: '지금은 먹고 싶지 않아요.', rom: 'ji-geu-meun meok-go sip-ji a-na-yo', fr: 'Je ne veux pas manger maintenant.' },
                ],
              },
            ],
            tip: "Les radicaux en ㄹ ne perdent pas leur ㄹ devant 고 : 만들다 → 만들고 싶어요 (et non 만드고). Cette forme sert pour « je » ou « tu » ; pour parler de ce que veut quelqu'un d'autre, on utilise une forme voisine qu'on verra plus tard.",
          },
          exercises: [
            fb('저는 커피를 마시___ 싶어요.', 'Je veux boire un café.', ['고', '아', '서', '는'], '고', '-고 싶어요 : radical + 고. Ici 마시 + 고 싶어요.', ['want_to']),
            fb('한국에 가___ 싶어요.', 'Je veux aller en Corée.', ['고', '아서', '면', '러'], '고', 'Radical 가 + 고 싶어요.', ['want_to']),
            mc('Quelle est la forme correcte pour « je veux manger » ?', null, ['먹고 싶어요', '먹으고 싶어요', '먹어 싶어요', '먹고 싶요'], '먹고 싶어요', 'Le radical ne change pas : 먹 + 고 싶어요. Pas de 으 devant 고.', ['want_to']),
            mc('Que signifie « 한국어를 배우고 싶어요 » ?', null, ['Je veux apprendre le coréen', "J'apprends le coréen", "J'ai appris le coréen", 'Je voudrais enseigner le coréen'], 'Je veux apprendre le coréen', '배우다 = apprendre ; -고 싶어요 = vouloir. (Enseigner se dit 가르치다.)', ['want_to']),
            fb('저는 한국어를 공부하___.', 'Je veux étudier le coréen.', ['고 싶어요', '고 싶요', '어 싶어요', '고 시퍼요'], '고 싶어요', 'Radical 공부하 + 고 싶어요.', ['want_to']),
            tk('Je veux aller en Corée.', '한국에 가고 싶어요 | 저는 한국에 가고 싶어요', '가다 + 고 싶어요 ; 한국에 (destination).', ['want_to', 'e_vs_eseo']),
            ro('Je veux voir un film.', ['영화를', '보고', '싶어요'], '영화를 보고 싶어요', "Objet → radical + 고 → 싶어요, toujours à la fin.", ['want_to'], 2),
            tf('저는 커피를 마시고 싶어요.', 'Je veux boire un café | Moi, je veux boire un café | Je voudrais boire un café', '마시고 싶어요 = je veux boire.', ['want_to']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '-고 싶어요 연습',
          title_fr: 'Entraînement : vouloir',
          exercises: [
            fb('내일은 집에서 ___.', 'Demain, je veux me reposer à la maison.', ['쉬고 싶어요', '쉬어 싶어요', '쉬고 싶요', '쉬으고 싶어요'], '쉬고 싶어요', '쉬다 + 고 싶어요, le radical ne change pas.', ['want_to']),
            fb('저는 한국 음식을 ___.', 'Je veux faire de la cuisine coréenne.', ['만들고 싶어요', '만드고 싶어요', '만들어 싶어요', '만들으고 싶어요'], '만들고 싶어요', 'Le radical en ㄹ garde son ㄹ devant 고 : 만들고.', ['want_to'], 3),
            mc('Comment dit-on « Je ne veux pas manger » ?', null, ['먹고 싶지 않아요', '먹고 싶지 않요', '먹고 싶 않아요', '먹고지 싶어요'], '먹고 싶지 않아요', 'Radical + 고 싶지 않아요.', ['want_to'], 2),
            mc('Que signifie « 뭐 하고 싶어요? » ?', null, ['Que veux-tu faire ?', 'Que fais-tu ?', "Qu'as-tu fait ?", 'Que feras-tu ?'], 'Que veux-tu faire ?', '뭐 = quoi ; 하고 싶어요 = vouloir faire.', ['want_to']),
            ls('저는 한국에 가고 싶어요', ['저는 한국에 가고 싶어요', '저는 한국에 갈 거예요', '저는 한국에 갔어요', '저는 한국에서 살고 싶어요'], '저는 한국에 가고 싶어요', '가고 싶어요 = je veux aller. Écoute bien la fin du verbe.', ['want_to']),
            tk('Je veux apprendre le coréen.', '한국어를 배우고 싶어요 | 저는 한국어를 배우고 싶어요', '배우다 + 고 싶어요.', ['want_to', 'object_particle']),
            tk('Je ne veux pas manger maintenant.', '지금은 먹고 싶지 않아요 | 지금 먹고 싶지 않아요 | 저는 지금 먹고 싶지 않아요', '지금 = maintenant ; 먹고 싶지 않아요 = je ne veux pas manger.', ['want_to'], 3),
            tf('주말에 친구를 만나고 싶어요.', 'Ce week-end, je veux voir un ami | Je veux voir un ami ce week-end | Je veux rencontrer un ami ce week-end', '만나다 = rencontrer / voir (quelqu\'un).', ['want_to', 'time_particle']),
            ro("Que veux-tu manger ?", ['뭐', '먹고', '싶어요'], '뭐 먹고 싶어요', 'Question : pronom → verbe → 싶어요.', ['want_to'], 2),
            fp('Dis ce que tu veux faire ce week-end.', '-고 싶어요 : vouloir faire quelque chose', 'Exemple : 주말에 영화를 보고 싶어요.', ['want_to']),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 2 — pouvoir / ne pas
    {
      unit_number: 2,
      title_ko: '-(으)ㄹ 수 있어요 · 안 · 못',
      title_fr: 'Pouvoir, ne pas pouvoir, ne pas faire',
      topic: 'grammar',
      description: '-(으)ㄹ 수 있어요 / 없어요, et les négations 안 et 못',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-(으)ㄹ 수 있어요',
          title_fr: 'Pouvoir, savoir, et les deux négations',
          content: {
            intro: "En français, « je ne mange pas » et « je ne peux pas manger » sont deux idées différentes. En coréen aussi, avec deux petits mots distincts : 안 et 못. Et pour dire « pouvoir » à l'affirmatif, une structure à retenir.",
            sections: [
              {
                title: '-(으)ㄹ 수 있어요 / 없어요 — « pouvoir, savoir »',
                body: "Radical qui finit par une voyelle : + ㄹ 수 있어요 (가다 → 갈 수 있어요). Par une consonne : + 을 수 있어요 (읽다 → 읽을 수 있어요). Radical en ㄹ : on ne rajoute rien (만들다 → 만들 수 있어요). Verbes en 하다 : 할 수 있어요. Le contraire est 수 없어요. Cette forme dit à la fois la capacité (« je sais nager ») et la possibilité (« je peux venir »).",
                examples: [
                  { ko: '저는 수영할 수 있어요.', rom: 'jeo-neun su-yeong-hal su i-sseo-yo', fr: 'Je sais nager.' },
                  { ko: '한국어를 읽을 수 있어요.', rom: 'han-gu-geo-reul il-geul su i-sseo-yo', fr: 'Je peux lire le coréen.' },
                  { ko: '오늘은 갈 수 없어요.', rom: 'o-neu-reun gal su eop-sseo-yo', fr: "Aujourd'hui, je ne peux pas y aller." },
                ],
              },
              {
                title: '안 et 못 — deux négations',
                body: "안 + verbe = « ne pas » : un choix ou une simple négation (안 가요 : je ne vais pas). 못 + verbe = « ne pas pouvoir » : incapacité ou empêchement (못 가요 : je ne peux pas y aller). Ils se placent juste avant le verbe. Avec un verbe en 하다, on les met entre le nom et 하다 : 운동 안 해요, 수영 못 해요. Pour un verbe qui n'est pas un nom + 하다 (좋아하다), 안 et 못 se placent devant le verbe entier : 안 좋아해요 (et non 좋아 안 해요).",
                examples: [
                  { ko: '저는 고기를 안 먹어요.', rom: 'jeo-neun go-gi-reul an meo-geo-yo', fr: 'Je ne mange pas de viande.' },
                  { ko: '오늘은 못 가요.', rom: 'o-neu-reun mot ga-yo', fr: "Aujourd'hui, je ne peux pas y aller." },
                  { ko: '운동 안 해요.', rom: 'un-dong an hae-yo', fr: 'Je ne fais pas de sport.' },
                  { ko: '수영 못 해요.', rom: 'su-yeong mot hae-yo', fr: 'Je ne sais pas nager.' },
                ],
              },
            ],
            tip: "안 = « je ne fais pas » (j'ai choisi, ou c'est un fait). 못 = « je n'y arrive pas » (je n'ai pas la capacité, ou quelque chose m'en empêche). Avec un adjectif, seul 안 existe : 안 커요 (ce n'est pas grand).",
          },
          exercises: [
            fb('저는 수영할 ___ 있어요.', 'Je sais nager.', ['수', '것', '거', '때'], '수', '-(으)ㄹ 수 있어요 : le mot 수 est la clé.', ['can']),
            fb('저는 김치를 먹을 수 ___.', 'Je peux manger du kimchi.', ['있어요', '없어요', '있었요', '있예요'], '있어요', '수 있어요 = je peux ; 수 없어요 = je ne peux pas.', ['can']),
            fb('한국어를 ___ 수 있어요.', 'Je peux lire le coréen.', ['읽을', '읽', '읽는', '읽은'], '읽을', '읽다 : consonne finale → 을 수 있어요.', ['can'], 2),
            mc("Quelle négation signifie « je n'y arrive pas / je ne peux pas » ?", null, ['못', '안', '아니', '말'], '못', '못 = incapacité ou empêchement ; 안 = négation simple.', ['negation']),
            mc('Comment dit-on « Je ne fais pas de sport » ?', null, ['운동 안 해요', '안 운동해요', '운동해 안요', '운동하 안요'], '운동 안 해요', 'Avec un verbe en 하다 : nom + 안 + 해요.', ['negation']),
            tk('Je ne mange pas de viande.', '고기를 안 먹어요 | 저는 고기를 안 먹어요', '안 + verbe ; 고기를 (objet).', ['negation', 'object_particle']),
            ro('Je sais nager.', ['저는', '수영할', '수', '있어요'], '저는 수영할 수 있어요', 'Sujet → verbe + ㄹ → 수 있어요.', ['can'], 2),
            tf('오늘은 못 가요.', "Aujourd'hui, je ne peux pas y aller | Je ne peux pas y aller aujourd'hui", '못 가요 = je ne peux pas y aller.', ['negation']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '수 · 안 · 못 연습',
          title_fr: 'Entraînement : pouvoir et négations',
          exercises: [
            fb('저는 한국어를 말할 ___ 있어요.', 'Je peux parler coréen.', ['수', '지', '도', '만'], '수', '-(으)ㄹ 수 있어요 : 말하다 → 말할 수 있어요.', ['can']),
            fb('저는 고기를 못 ___.', 'Je ne peux pas manger de viande.', ['먹어요', '먹으요', '먹아요', '먹요'], '먹어요', '못 + verbe au présent poli : 먹어요.', ['negation']),
            fb('저는 운전을 할 수 ___.', 'Je ne sais pas conduire.', ['없어요', '않아요', '못이에요', '아니에요'], '없어요', '수 없어요 = je ne peux / ne sais pas.', ['can'], 2),
            mc('Quelle phrase dit « Je ne mange pas de poisson » (je ne mange simplement pas de poisson) ?', null, ['저는 생선을 안 먹어요', '저는 생선을 못 먹어요', '저는 생선을 먹어 안요', '저는 생선을 안요 먹어요'], '저는 생선을 안 먹어요', '안 = négation simple ; 못 dirait « je ne peux pas en manger ».', ['negation'], 2),
            mc('Que signifie « 수영 못 해요 » ?', null, ['Je ne sais pas nager', 'Je ne nage pas (par choix)', 'Je vais nager', "J'ai nagé"], 'Je ne sais pas nager', '못 = incapacité.', ['negation']),
            ls('저는 수영할 수 있어요', ['저는 수영할 수 있어요', '저는 수영할 수 없어요', '저는 수영 못 해요', '저는 수영하고 싶어요'], '저는 수영할 수 있어요', '할 수 있어요 = je sais. Écoute bien 있어요 / 없어요.', ['can']),
            tk("Je ne peux pas aller à l'école aujourd'hui.", '오늘은 학교에 갈 수 없어요 | 오늘 학교에 갈 수 없어요 | 오늘은 학교에 못 가요 | 오늘 학교에 못 가요 | 저는 오늘 학교에 갈 수 없어요 | 저는 오늘 학교에 못 가요', '갈 수 없어요 ou 못 가요 : les deux disent « je ne peux pas ».', ['can', 'negation'], 3),
            tk('Je sais lire le coréen.', '한국어를 읽을 수 있어요 | 저는 한국어를 읽을 수 있어요', '읽다 → 읽을 수 있어요.', ['can'], 3),
            tf('저는 운동을 안 해요.', 'Je ne fais pas de sport | Moi, je ne fais pas de sport | Je ne fais pas d\'exercice', '안 해요 = je ne fais pas.', ['negation']),
            fp('Dis une chose que tu sais faire et une chose que tu ne sais pas faire.', '-(으)ㄹ 수 있어요 / 없어요, ou 못', 'Exemple : 저는 요리할 수 있어요. 수영은 못 해요.', ['can', 'negation']),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 3 — demander et consigner
    {
      unit_number: 3,
      title_ko: '-아/어 주세요 · -(으)세요',
      title_fr: 'Demander et donner des consignes',
      topic: 'grammar',
      description: "-아/어 주세요, -(으)세요 et -지 마세요",
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-아/어 주세요',
          title_fr: "Demander un service et donner une consigne",
          content: {
            intro: "Tu sais déjà dire 주세요 pour demander un objet. Voici comment demander une action, donner une consigne polie, ou interdire quelque chose. Tu les entendras partout en Corée.",
            sections: [
              {
                title: '-아/어 주세요 — « fais-le pour moi, s\'il te plaît »',
                body: "On conjugue le verbe comme au présent poli, sans le 요 (먹다 → 먹어, 말하다 → 말해, 열다 → 열어), puis on ajoute 주세요. C'est la manière polie de demander une action à quelqu'un.",
                examples: [
                  { ko: '사진을 찍어 주세요.', rom: 'sa-ji-neul jji-geo ju-se-yo', fr: "Prenez une photo, s'il vous plaît." },
                  { ko: '문을 열어 주세요.', rom: 'mu-neul yeo-reo ju-se-yo', fr: "Ouvrez la porte, s'il vous plaît." },
                  { ko: '천천히 말해 주세요.', rom: 'cheon-cheon-hi mal-hae ju-se-yo', fr: "Parlez lentement, s'il vous plaît." },
                  { ko: '다시 한번 말해 주세요.', rom: 'da-si han-beon mal-hae ju-se-yo', fr: "Répétez encore une fois, s'il vous plaît." },
                ],
              },
              {
                title: '-(으)세요 et -지 마세요 — consigne et interdiction',
                body: "Radical qui finit par une voyelle : + 세요 (오다 → 오세요). Par une consonne : + 으세요 (앉다 → 앉으세요). Radical en ㄹ : le ㄹ tombe (만들다 → 만드세요). Pour interdire : radical + 지 마세요 (가다 → 가지 마세요).",
                examples: [
                  { ko: '여기 앉으세요.', rom: 'yeo-gi an-jeu-se-yo', fr: 'Asseyez-vous ici.' },
                  { ko: '이쪽으로 오세요.', rom: 'i-jjo-geu-ro o-se-yo', fr: 'Venez par ici.' },
                  { ko: '책을 읽으세요.', rom: 'chae-geul il-geu-se-yo', fr: 'Lisez le livre.' },
                  { ko: '걱정하지 마세요.', rom: 'geok-jeong-ha-ji ma-se-yo', fr: "Ne vous inquiétez pas." },
                  { ko: '여기에서 사진을 찍지 마세요.', rom: 'yeo-gi-e-seo sa-ji-neul jjik-ji ma-se-yo', fr: 'Ne prenez pas de photo ici.' },
                ],
              },
            ],
            tip: "-(으)세요 est aussi la forme respectueuse d'une question ou d'une phrase : 어디 가세요 ? (Où allez-vous ?). Ici on l'apprend comme une consigne polie, mais ouvre l'oreille : tu l'entendras tout le temps, y compris dans les magasins.",
          },
          exercises: [
            fb('문을 열어 ___.', "Ouvrez la porte, s'il vous plaît.", ['주세요', '세요', '줘세요', '해요'], '주세요', '-아/어 주세요 : 열어 + 주세요.', ['request_verb']),
            fb('여기에 ___.', 'Asseyez-vous ici.', ['앉으세요', '앉세요', '앉아세요', '앉으요'], '앉으세요', '앉다 finit par une consonne → 으세요.', ['honorific']),
            fb('이쪽으로 ___.', 'Venez par ici.', ['오세요', '오으세요', '와세요', '오세'], '오세요', '오다 finit par une voyelle → 세요.', ['honorific']),
            mc('Que signifie « 천천히 말해 주세요 » ?', null, ["Parlez lentement, s'il vous plaît", "Parlez fort, s'il vous plaît", 'Ne parlez pas', "J'ai parlé lentement"], "Parlez lentement, s'il vous plaît", '천천히 = lentement ; 말해 주세요 = dites-le pour moi.', ['request_verb']),
            mc("Comment dit-on « Ne vous inquiétez pas » ?", null, ['걱정하지 마세요', '걱정 마지세요', '걱정하지 말세요', '걱정하세요 안'], '걱정하지 마세요', 'Interdiction : radical + 지 마세요.', ['honorific']),
            tk("Prenez une photo, s'il vous plaît.", '사진을 찍어 주세요 | 사진 찍어 주세요', '찍다 → 찍어 + 주세요.', ['request_verb', 'object_particle']),
            ro('Lisez le livre ici.', ['여기에서', '책을', '읽으세요'], '여기에서 책을 읽으세요', 'Lieu → objet → verbe en -(으)세요.', ['honorific'], 2),
            tf('다시 한번 말해 주세요.', "Répétez encore une fois, s'il vous plaît | Dites-le encore une fois, s'il vous plaît | Pouvez-vous le redire encore une fois ?", '다시 한번 = encore une fois.', ['request_verb']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '부탁과 지시 연습',
          title_fr: 'Entraînement : demander et consigner',
          exercises: [
            fb('사진을 ___ 주세요.', "Prenez une photo, s'il vous plaît.", ['찍어', '찍아', '찍으', '찍해'], '찍어', '찍다 : dernière voyelle ㅣ → 어 : 찍어 주세요.', ['request_verb']),
            fb('천천히 ___ 주세요.', "Parlez lentement, s'il vous plaît.", ['말해', '말아', '말하', '말어'], '말해', '말하다 → 말해 주세요.', ['request_verb']),
            fb('책을 ___.', 'Lisez le livre.', ['읽으세요', '읽세요', '읽어세요', '읽으니세요'], '읽으세요', '읽다 : consonne finale → 으세요.', ['honorific']),
            fb('여기에서 담배를 피우지 ___.', 'Ne fumez pas ici.', ['마세요', '않세요', '말세요', '안 세요'], '마세요', "Interdiction : radical + 지 마세요.", ['honorific']),
            fb('여기에 이름을 ___.', 'Écrivez votre nom ici.', ['쓰세요', '쓰으세요', '써세요', '쓰요'], '쓰세요', '쓰다 finit par une voyelle (ㅡ) → 세요.', ['honorific'], 2),
            mc('Quelle terminaison exprime une interdiction polie (« ne… pas ») ?', null, ['-지 마세요', '-지 않아요', '-고 싶어요', '-아/어 주세요'], '-지 마세요', '-지 마세요 = ne faites pas.', ['honorific']),
            ls('이쪽으로 오세요', ['이쪽으로 오세요', '이쪽으로 가세요', '이쪽으로 왔어요', '저쪽으로 오세요'], '이쪽으로 오세요', '오세요 = venez ; 이쪽 = par ici.', ['honorific']),
            tk("Ouvrez la porte, s'il vous plaît.", '문을 열어 주세요 | 문 열어 주세요', '열다 → 열어 + 주세요.', ['request_verb']),
            tk('Ne vous inquiétez pas.', '걱정하지 마세요 | 걱정 마세요', '걱정하지 마세요 : interdiction polie.', ['honorific']),
            tf('여기 앉으세요.', 'Asseyez-vous ici | Veuillez vous asseoir ici | Asseyez-vous là', '앉으세요 = asseyez-vous.', ['honorific']),
            fp("Demande poliment à quelqu'un de parler plus lentement.", '-아/어 주세요', 'Exemple : 천천히 말해 주세요.', ['request_verb']),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 4 — proposer
    {
      unit_number: 4,
      title_ko: '-(으)ㄹ까요?',
      title_fr: 'Faire une proposition',
      topic: 'grammar',
      description: "-(으)ㄹ까요 ? et répondre à une proposition",
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-(으)ㄹ까요?',
          title_fr: 'Proposer et répondre',
          content: {
            intro: "Pour inviter quelqu'un ou offrir ton aide, rien de plus naturel : -(으)ㄹ까요 ?. C'est un doux « et si… ? ». Tu apprends aussi à accepter ou à refuser avec élégance.",
            sections: [
              {
                title: '-(으)ㄹ까요 ? — « on… ? / je… ? »',
                body: "Radical qui finit par une voyelle : + ㄹ까요 (보다 → 볼까요). Par une consonne : + 을까요 (먹다 → 먹을까요). Radical en ㄹ : + 까요 (열다 → 열까요, 만들다 → 만들까요). Avec 같이 (ensemble), c'est une proposition à deux : « On… ensemble ? ». Avec 제가 (moi), c'est une offre : « Je… pour vous ? ».",
                examples: [
                  { ko: '같이 점심 먹을까요?', rom: 'ga-chi jeom-sim meo-geul-kka-yo', fr: 'On déjeune ensemble ?' },
                  { ko: '내일 영화 볼까요?', rom: 'nae-il yeong-hwa bol-kka-yo', fr: 'On va voir un film demain ?' },
                  { ko: '제가 문을 열까요?', rom: 'je-ga mu-neul yeol-kka-yo', fr: "J'ouvre la porte ?" },
                ],
              },
              {
                title: 'Accepter, refuser, proposer sans question',
                body: "Accepter : 네, 좋아요 ! Refuser poliment : 미안해요, suivi d'une raison. 좀 (« un peu ») adoucit la phrase et revient souvent. Et pour proposer sans question : 같이 + présent poli (같이 가요 : allons-y ensemble).",
                examples: [
                  { ko: '네, 좋아요.', rom: 'ne, jo-a-yo', fr: "Oui, avec plaisir." },
                  { ko: '미안해요. 오늘은 좀 바빠요.', rom: 'mi-an-hae-yo. o-neu-reun jom ba-ppa-yo', fr: "Désolé(e). Aujourd'hui, je suis un peu occupé(e)." },
                  { ko: '같이 가요!', rom: 'ga-chi ga-yo', fr: 'Allons-y ensemble !' },
                ],
              },
            ],
            tip: "같이 가요 (affirmation) = « allons-y ensemble » ; 같이 갈까요 ? (question) = « et si on y allait ensemble ? » — plus doux, on laisse l'autre choisir.",
          },
          exercises: [
            fb('같이 점심 먹___?', 'On déjeune ensemble ?', ['을까요', '를까요', '으까요', '는까요'], '을까요', '먹다 finit par une consonne → 을까요.', ['suggest']),
            fb('내일 영화 ___?', 'On va voir un film demain ?', ['볼까요', '보을까요', '보까요', '봐요까요'], '볼까요', '보다 finit par une voyelle → ㄹ까요 : 볼까요.', ['suggest']),
            fb('제가 문을 ___?', "J'ouvre la porte ?", ['열까요', '열을까요', '여을까요', '열어까요'], '열까요', '열다 : radical en ㄹ → on ajoute seulement 까요.', ['suggest'], 3),
            mc('Que signifie « 같이 갈까요? » ?', null, ["Et si on y allait ensemble ?", "Je suis allé(e) ensemble", "Allez-y tout seul", "Où allons-nous ?"], "Et si on y allait ensemble ?", '같이 = ensemble ; -(으)ㄹ까요 = proposition.', ['suggest']),
            mc('Quelle phrase refuse poliment une invitation ?', null, ['미안해요. 오늘은 좀 바빠요', '네, 좋아요! 같이 가요', '같이 갈까요', '언제 만날까요'], '미안해요. 오늘은 좀 바빠요', 'Un refus poli : excuse + raison.', ['suggest']),
            tk('On mange ensemble ?', '같이 먹을까요 | 우리 같이 먹을까요', '먹다 → 먹을까요.', ['suggest']),
            ro('On va voir un film ensemble ?', ['같이', '영화', '볼까요'], '같이 영화 볼까요', "Ensemble → objet → verbe en -(으)ㄹ까요.", ['suggest'], 2),
            tf('내일 커피 마실까요?', 'On prend un café demain ? | Et si on buvait un café demain ? | On boit un café demain ?', '마시다 → 마실까요.', ['suggest']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '제안 연습',
          title_fr: 'Entraînement : proposer et répondre',
          exercises: [
            fb('주말에 같이 ___?', 'On fait du sport ce week-end ?', ['운동할까요', '운동하을까요', '운동해까요', '운동하까요'], '운동할까요', '운동하다 → 운동할까요.', ['suggest']),
            fb('어디에서 ___?', 'Où se retrouve-t-on ?', ['만날까요', '만나을까요', '만나까요', '만날거까요'], '만날까요', '만나다 → 만날까요.', ['suggest']),
            fb('저녁에 뭐 ___?', 'Que mange-t-on ce soir ?', ['먹을까요', '먹를까요', '먹까요', '먹는까요'], '먹을까요', '먹다 : consonne finale → 을까요.', ['suggest']),
            fb('제가 창문을 ___?', 'Je ferme la fenêtre ?', ['닫을까요', '닫를까요', '닫까요', '닫아까요'], '닫을까요', '닫다 : consonne finale → 을까요.', ['suggest'], 2),
            mc("Quelle réponse accepte la proposition « 같이 먹을까요? » ?", null, ['네, 좋아요', '네, 먹었어요', '아니요, 먹을까요', '네, 먹고 싶지 않아요'], '네, 좋아요', '네, 좋아요 = oui, avec plaisir.', ['suggest']),
            ls('같이 영화 볼까요', ['같이 영화 볼까요', '같이 영화 봤어요', '같이 영화 보고 싶어요', '같이 영화 볼 거예요'], '같이 영화 볼까요', '볼까요 = proposition. Écoute la fin du verbe.', ['suggest']),
            tk("On va à la bibliothèque ensemble ?", '같이 도서관에 갈까요 | 우리 같이 도서관에 갈까요', '도서관에 = à la bibliothèque ; 갈까요 = on y va ?', ['suggest', 'e_vs_eseo']),
            tk("Désolé(e). Aujourd'hui, je suis un peu occupé(e).", '미안해요. 오늘은 좀 바빠요 | 죄송해요. 오늘은 좀 바빠요 | 미안해요. 오늘 좀 바빠요 | 죄송해요. 오늘 좀 바빠요', '미안해요 / 죄송해요 = désolé(e) ; 좀 = un peu.', ['suggest'], 3),
            tf('같이 가요!', "Allons-y ensemble ! | On y va ensemble ! | Allons ensemble !", '같이 + présent poli = allons-y.', ['suggest']),
            fp('Propose à un ami une activité pour ce week-end.', '-(으)ㄹ까요 ? (proposer)', 'Exemple : 주말에 같이 영화 볼까요?', ['suggest']),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 5 — BOSS
    {
      unit_number: 5,
      title_ko: '여행 준비',
      title_fr: 'Boss : préparer un voyage',
      topic: 'grammar',
      description: "Tout l'étage 3 dans la préparation d'un voyage en Corée",
      lessons: [
        {
          lesson_number: 1,
          type: 'boss',
          title_ko: '3층 보스',
          title_fr: "Boss de l'étage 3",
          exercises: [
            fb('저는 한국에 여행 가___ 싶어요.', 'Je veux voyager en Corée.', ['고', '어', '면', '서'], '고', '가다 + 고 싶어요.', ['want_to'], 2),
            fb('저는 한국어를 조금 할 ___ 있어요.', 'Je peux parler un peu coréen.', ['수', '번', '데', '곳'], '수', '할 수 있어요 = je peux / je sais.', ['can'], 2),
            fb('저는 운전을 ___ 해요.', 'Je ne sais pas conduire.', ['못', '않', '아니', '말'], '못', '못 + verbe = ne pas pouvoir. Avec 하다 : 운전 못 해요.', ['negation'], 3),
            fb('수업 시간에 전화하지 ___.', 'Ne téléphonez pas pendant le cours.', ['마세요', '않세요', '말세요', '안 세요'], '마세요', '-지 마세요 = interdiction polie.', ['honorific'], 3),
            fb('같이 공항에 ___?', "On va à l'aéroport ensemble ?", ['갈까요', '가을까요', '가까요', '가ㄹ까요'], '갈까요', '가다 + ㄹ까요 : 갈까요.', ['suggest'], 3),
            fb('호텔 이름을 ___ 주세요.', "Écrivez le nom de l'hôtel, s'il vous plaît.", ['써', '쓰어', '쓰', '쓰아'], '써', '쓰다 : ㅡ tombe → 써 주세요.', ['request_verb'], 4),
            mc('Quelle phrase veut dire « Je ne peux pas y aller (je suis empêché(e)) » ?', null, ['못 가요', '안 가요', '가고 싶어요', '갈까요'], '못 가요', '못 = empêchement.', ['negation'], 3),
            mc("Que signifie « 어디에서 만날까요? » ?", null, ["Où est-ce qu'on se retrouve ?", 'Où nous sommes-nous retrouvés ?', 'Je ne veux pas te retrouver', 'Je ne peux pas te retrouver'], "Où est-ce qu'on se retrouve ?", '-(으)ㄹ까요 = proposition / question sur le plan.', ['suggest'], 3),
            ro('Je veux apprendre le coréen en Corée.', ['한국에서', '한국어를', '배우고', '싶어요'], '한국에서 한국어를 배우고 싶어요', 'Lieu (에서) → objet → verbe + 고 싶어요.', ['want_to', 'e_vs_eseo'], 3),
            tk('Je veux acheter un billet de train.', '기차표를 사고 싶어요 | 저는 기차표를 사고 싶어요', '기차표 = billet de train ; 사다 + 고 싶어요.', ['want_to', 'object_particle'], 3),
            tk('Je ne sais pas nager. Je veux apprendre.', '수영을 못 해요. 배우고 싶어요 | 저는 수영을 못 해요. 배우고 싶어요 | 수영 못 해요. 배우고 싶어요 | 저는 수영 못 해요. 배우고 싶어요', '못 해요 = je ne sais pas ; 배우고 싶어요 = je veux apprendre.', ['negation', 'want_to'], 4),
            tf('내일 같이 시장에 갈까요? 저는 오늘은 갈 수 없어요.', "On va au marché ensemble demain ? Aujourd'hui, je ne peux pas y aller | Et si on allait ensemble au marché demain ? Aujourd'hui, je ne peux pas y aller", '갈까요 = proposition ; 갈 수 없어요 = je ne peux pas y aller.', ['suggest', 'can'], 4),
            ls('한국에서 한국 음식을 먹고 싶어요', ['한국에서 한국 음식을 먹고 싶어요', '한국에서 한국 음식을 먹었어요', '한국에서 한국 음식을 먹을까요', '한국에서 한국 음식을 먹을 수 있어요'], '한국에서 한국 음식을 먹고 싶어요', '먹고 싶어요 = je veux manger.', ['want_to'], 3),
            fp('Imagine ton voyage en Corée : dis ce que tu veux faire là-bas.', '-고 싶어요 : vouloir faire quelque chose', 'Exemple : 한국에서 김치를 먹고 싶어요.', ['want_to'], 4),
          ],
        },
      ],
    },
  ],
};
