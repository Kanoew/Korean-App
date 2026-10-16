// Étage 5 — 경험과 비교 : expériences, actions en cours, comparaisons, noms décrits (B1).
// ⚠️ Contenu écrit par une IA et PAS ENCORE relu par un humain : voir docs/relecture-etage5.md.
import { mc, fb, ro, tk, tf, ls, fp } from './helpers.mjs';

export const floor5 = {
  floor_number: 5,
  title_ko: '경험과 비교',
  title_fr: 'Expériences et comparaisons',
  cefr_level: 'B1',
  description: "Raconter ce que tu as déjà essayé, dire ce que tu fais en ce moment, comparer, et décrire un nom avec un verbe ou un adjectif.",
  units: [
    // ============================================================ UNITÉ 1 — expérience
    {
      unit_number: 1,
      title_ko: '-아/어 보다',
      title_fr: "Parler d'expériences",
      topic: 'grammar',
      description: '-아/어 보다 (essayer) et -(으)ㄴ 적이 있어요 (avoir déjà fait)',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-아/어 봤어요 · -(으)ㄴ 적이 있어요',
          title_fr: "Essayer et avoir déjà fait",
          content: {
            intro: "« Tu as déjà goûté le kimchi ? » « Tu es déjà allé(e) en Corée ? » : ce sont les questions de base pour apprendre à connaître quelqu'un. Deux structures te donnent la réponse.",
            sections: [
              {
                title: '-아/어 보다 — « essayer de, goûter à »',
                body: "On conjugue le verbe comme au présent poli, sans le 요 (먹다 → 먹어, 가다 → 가, 입다 → 입어), puis on ajoute 보다. 먹어 보세요 : goûtez-le. 먹어 봤어요 : j'ai déjà goûté. 가 보고 싶어요 : j'aimerais aller voir.",
                examples: [
                  { ko: '김치를 먹어 봤어요.', rom: 'gim-chi-reul meo-geo bwa-sseo-yo', fr: "J'ai déjà goûté le kimchi." },
                  { ko: '이거 한번 먹어 보세요.', rom: 'i-geo han-beon meo-geo bo-se-yo', fr: 'Goûtez ça une fois.' },
                  { ko: '한국에 가 보고 싶어요.', rom: 'han-gu-ge ga bo-go si-peo-yo', fr: "J'aimerais aller voir la Corée." },
                  { ko: '한국에 가 봤어요?', rom: 'han-gu-ge ga bwa-sseo-yo', fr: 'Es-tu déjà allé(e) en Corée ?' },
                ],
              },
              {
                title: '-(으)ㄴ 적이 있어요 / 없어요 — « ça m\'est déjà arrivé »',
                body: "Radical qui finit par une voyelle : + ㄴ 적이 있어요 (가다 → 간 적이 있어요). Par une consonne : + 은 적이 있어요 (먹다 → 먹은 적이 있어요). Radical en ㄹ : le ㄹ tombe (만들다 → 만든 적이 있어요). Le contraire : 적이 없어요 (« jamais »). On l'associe souvent à -아/어 보다 : 가 본 적이 있어요.",
                examples: [
                  { ko: '한국에 가 본 적이 있어요.', rom: 'han-gu-ge ga bon jeo-gi i-sseo-yo', fr: 'Je suis déjà allé(e) en Corée.' },
                  { ko: '한국 영화를 본 적이 없어요.', rom: 'han-guk yeong-hwa-reul bon jeo-gi eop-sseo-yo', fr: "Je n'ai jamais vu de film coréen." },
                ],
              },
            ],
            tip: "-아/어 봤어요 = « j'ai déjà essayé ». -(으)ㄴ 적이 있어요 = « ça m'est déjà arrivé / je l'ai déjà fait ». Les deux répondent à « Tu as déjà… ? ».",
          },
          exercises: [
            fb('이거 한번 먹어 ___.', 'Goûtez ça une fois.', ['보세요', '봐세요', '보어요', '보세'], '보세요', '먹어 + 보세요 : essayez de manger.', ['experience']),
            fb('김치를 먹어 ___.', "J'ai déjà goûté le kimchi.", ['봤어요', '보았요', '봤요', '보세요'], '봤어요', '보다 → 봤어요 (passé).', ['experience']),
            fb('한국에 가 본 ___ 있어요.', 'Je suis déjà allé(e) en Corée.', ['적이', '수가', '거가', '번이'], '적이', '-(으)ㄴ 적이 있어요 : avoir déjà fait.', ['experience'], 2),
            fb('한국 영화를 본 적이 ___.', "Je n'ai jamais vu de film coréen.", ['없어요', '않아요', '아니에요', '안 있어요'], '없어요', '적이 없어요 = je ne l\'ai jamais fait.', ['experience']),
            mc('Que signifie « 한국에 가 봤어요? » ?', null, ['Es-tu déjà allé(e) en Corée ?', 'Veux-tu aller en Corée ?', 'Iras-tu en Corée ?', 'Pourquoi vas-tu en Corée ?'], 'Es-tu déjà allé(e) en Corée ?', '가 봤어요 = as-tu déjà fait l\'expérience d\'y aller.', ['experience']),
            mc("Comment dit-on « Je n'ai jamais goûté de kimchi » ?", null, ['김치를 먹어 본 적이 없어요', '김치를 먹어 본 적이 안 있어요', '김치를 먹은 적이 안요', '김치를 먹어 봐요 없어요'], '김치를 먹어 본 적이 없어요', '적이 없어요 = jamais.', ['experience'], 3),
            tk("J'ai déjà vu un film coréen.", '한국 영화를 본 적이 있어요 | 한국 영화를 봐 본 적이 있어요', '보다 → 본 적이 있어요.', ['experience'], 3),
            tk('Goûtez ça !', '이거 먹어 보세요 | 이거 한번 먹어 보세요 | 한번 먹어 보세요', '먹어 + 보세요.', ['experience']),
            ro("J'ai déjà goûté du bibimbap.", ['비빔밥을', '먹어', '봤어요'], '비빔밥을 먹어 봤어요', 'Objet → verbe conjugué → 봤어요.', ['experience'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '경험 연습',
          title_fr: 'Entraînement : expériences',
          exercises: [
            fb('한복을 입어 ___.', "J'ai déjà essayé un hanbok.", ['봤어요', '보았요', '봄어요', '보세요'], '봤어요', '입다 → 입어 + 봤어요.', ['experience']),
            fb('제주도에 가 본 적이 ___?', "Es-tu déjà allé(e) à Jeju ?", ['있어요', '있서요', '있으요', '있에요'], '있어요', '적이 있어요 = oui, déjà.', ['experience']),
            fb('저는 한국에 가 본 적이 ___.', "Je ne suis jamais allé(e) en Corée.", ['없어요', '않아요', '못해요', '안이에요'], '없어요', '적이 없어요 = jamais.', ['experience']),
            fb('이 옷 한번 입어 ___.', 'Essayez ce vêtement.', ['보세요', '보어요', '보으세요', '보요'], '보세요', '입어 + 보세요.', ['experience']),
            mc('Que signifie « 먹어 봤어요 » ?', null, ["J'ai déjà goûté / mangé (par expérience)", 'Je veux manger', 'Je ne peux pas manger', 'Mangeons'], "J'ai déjà goûté / mangé (par expérience)", '-아/어 봤어요 = avoir déjà essayé.', ['experience']),
            mc('Quelle phrase est correcte ?', null, ['한국에 간 적이 있어요', '한국에 가은 적이 있어요', '한국에 가ㄴ 적이 있어요', '한국에 갈 적이 있어요'], '한국에 간 적이 있어요', '가다 finit par une voyelle → ㄴ 적이 있어요 : 간 적이.', ['experience'], 3),
            ls('한국 음식을 먹어 봤어요', ['한국 음식을 먹어 봤어요', '한국 음식을 먹고 싶어요', '한국 음식을 먹어 보세요', '한국 음식을 먹을 수 있어요'], '한국 음식을 먹어 봤어요', '먹어 봤어요 = j\'ai déjà goûté. Écoute bien la fin.', ['experience']),
            tk("Je suis déjà allé(e) en Corée.", '한국에 가 본 적이 있어요 | 한국에 간 적이 있어요 | 저는 한국에 간 적이 있어요 | 저는 한국에 가 본 적이 있어요 | 한국에 가 봤어요 | 저는 한국에 가 봤어요', '가 본 적이 있어요 ou 가 봤어요 : les deux disent « j\'y suis déjà allé(e) ».', ['experience'], 3),
            tk("Je n'ai jamais mangé de tteokbokki.", '떡볶이를 먹어 본 적이 없어요 | 떡볶이를 먹은 적이 없어요 | 저는 떡볶이를 먹어 본 적이 없어요 | 저는 떡볶이를 먹은 적이 없어요', '먹어 본 적이 없어요 = jamais goûté.', ['experience'], 3),
            fp("Dis une chose en lien avec la Corée que tu as déjà essayée, ou que tu n'as jamais essayée.", '-아/어 봤어요 ou -(으)ㄴ 적이 있어요 / 없어요', 'Exemple : 김치를 먹어 봤어요. 한국에 간 적은 없어요.', ['experience'], 4),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 2 — -고 있어요 / -(으)러
    {
      unit_number: 2,
      title_ko: '-고 있어요 · -(으)러',
      title_fr: 'Ce que tu fais en ce moment, et pourquoi tu y vas',
      topic: 'grammar',
      description: '-고 있어요 (en train de) et -(으)러 가요 (aller pour)',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-고 있어요 · -(으)러 가요',
          title_fr: 'En train de… et aller pour…',
          content: {
            intro: "Dans une conversation, on dit souvent ce qu'on fait là, tout de suite, ou pourquoi on va quelque part. Deux structures qui reviennent sans cesse, avec des formes très proches de ce que tu connais déjà.",
            sections: [
              {
                title: 'Radical + 고 있어요 — « être en train de »',
                body: "Même construction que -고 싶어요, avec 있어요 à la place de 싶어요. 지금 + -고 있어요 : ce que je fais en ce moment. Attention à ne pas confondre : 먹고 싶어요 (je veux manger) et 먹고 있어요 (je suis en train de manger). Avec certains verbes de situation comme 살다 (habiter) ou 다니다 (fréquenter), -고 있어요 décrit une situation durable : 한국에 살고 있어요 (j'habite en Corée).",
                examples: [
                  { ko: '지금 공부하고 있어요.', rom: 'ji-geum gong-bu-ha-go i-sseo-yo', fr: "En ce moment, je suis en train d'étudier." },
                  { ko: '친구를 기다리고 있어요.', rom: 'chin-gu-reul gi-da-ri-go i-sseo-yo', fr: "J'attends un ami." },
                  { ko: '한국에 살고 있어요.', rom: 'han-gu-ge sal-go i-sseo-yo', fr: "J'habite en Corée." },
                ],
              },
              {
                title: 'Radical + (으)러 가다 / 오다 — « aller / venir pour… »',
                body: "Radical qui finit par une voyelle ou par ㄹ : + 러 (보다 → 보러, 놀다 → 놀러). Par une consonne : + 으러 (먹다 → 먹으러). Puis 가요 (aller) ou 와요 (venir). On dit où on va, et pourquoi.",
                examples: [
                  { ko: '점심을 먹으러 가요.', rom: 'jeom-si-meul meo-geu-reo ga-yo', fr: 'Je vais déjeuner.' },
                  { ko: '영화를 보러 극장에 가요.', rom: 'yeong-hwa-reul bo-reo geuk-jang-e ga-yo', fr: 'Je vais au cinéma voir un film.' },
                  { ko: '친구를 만나러 왔어요.', rom: 'chin-gu-reul man-na-reo wa-sseo-yo', fr: "Je suis venu(e) voir un ami." },
                  { ko: '주말에 놀러 가요.', rom: 'ju-ma-re nol-leo ga-yo', fr: "Ce week-end, je vais m'amuser." },
                ],
              },
            ],
            tip: "싶 = je veux (désir), 있 = je suis en train de (action). Une seule lettre change, mais le sens aussi ! Et avec -(으)러, le verbe qui suit est toujours un verbe de déplacement : 가다, 오다.",
          },
          exercises: [
            fb('지금 공부하___ 있어요.', "En ce moment, je suis en train d'étudier.", ['고', '러', '면', '서'], '고', '-고 있어요 : radical + 고 + 있어요.', ['progressive']),
            fb('친구를 기다리___ 있어요.', "J'attends un ami.", ['고', '러', '으러', '면'], '고', '기다리다 + 고 있어요.', ['progressive']),
            fb('점심을 먹___ 가요.', 'Je vais déjeuner.', ['으러', '러', '을러', '으고'], '으러', '먹다 finit par une consonne → 으러.', ['purpose']),
            fb('영화를 ___ 극장에 가요.', 'Je vais au cinéma voir un film.', ['보러', '보으러', '봐러', '볼러'], '보러', '보다 finit par une voyelle → 러 : 보러.', ['purpose']),
            mc('Quelle est la différence entre « 먹고 싶어요 » et « 먹고 있어요 » ?', null, ['Je veux manger / Je suis en train de manger', 'Je suis en train de manger / Je veux manger', "J'ai mangé / Je mangerai", 'Je ne mange pas / Je mange'], 'Je veux manger / Je suis en train de manger', '싶어요 = vouloir ; 있어요 (avec -고) = être en train de.', ['progressive', 'want_to'], 2),
            mc('Quelle phrase veut dire « Je vais voir un ami » ?', null, ['친구를 만나러 가요', '친구를 만나고 가요', '친구를 만나면 가요', '친구를 만나서 가요'], '친구를 만나러 가요', '-(으)러 가요 = aller pour faire. Les autres expriment une suite, une condition ou une cause.', ['purpose'], 3),
            tk('Je suis en train de manger.', '밥을 먹고 있어요 | 지금 밥을 먹고 있어요 | 저는 지금 밥을 먹고 있어요 | 먹고 있어요', '먹다 + 고 있어요.', ['progressive']),
            ro('Je vais au marché pour acheter du pain.', ['빵을', '사러', '시장에', '가요'], '빵을 사러 시장에 가요 | 시장에 빵을 사러 가요', 'But (-(으)러) → destination → verbe de déplacement.', ['purpose'], 3),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '-고 있어요 · -(으)러 연습',
          title_fr: 'Entraînement : en train de, aller pour',
          exercises: [
            fb('저는 지금 커피를 마시___ 있어요.', 'Je suis en train de boire un café.', ['고', '러', '으러', '면'], '고', '마시다 + 고 있어요.', ['progressive']),
            fb('저는 한국에 ___ 있어요.', "J'habite en Corée.", ['살고', '살으고', '살러', '살면'], '살고', '살다 + 고 있어요 : le radical garde son ㄹ.', ['progressive'], 3),
            fb('친구를 ___ 학교에 가요.', "Je vais à l'école voir un ami.", ['만나러', '만나으러', '만날러', '만나라'], '만나러', '만나다 finit par une voyelle → 러.', ['purpose']),
            fb('책을 ___ 도서관에 가요.', 'Je vais à la bibliothèque lire un livre.', ['읽으러', '읽러', '읽어러', '읽을러'], '읽으러', '읽다 finit par une consonne → 으러.', ['purpose']),
            fb('주말에 친구하고 ___ 가요.', "Ce week-end, je vais m'amuser avec un ami.", ['놀러', '노러', '놀으러', '놀아러'], '놀러', '놀다 (radical en ㄹ) + 러 : 놀러.', ['purpose'], 3),
            mc('Que signifie « 뭐 하고 있어요? » ?', null, ['Que fais-tu en ce moment ?', 'Que veux-tu faire ?', 'Que feras-tu ?', "Qu'as-tu fait ?"], 'Que fais-tu en ce moment ?', '하고 있어요 = être en train de faire.', ['progressive']),
            mc('Quelle phrase est correcte ?', null, ['밥을 먹으러 가요', '밥을 먹러 가요', '밥을 먹고러 가요', '밥을 먹으러서 가요'], '밥을 먹으러 가요', '먹다 → 먹으러 가요.', ['purpose'], 2),
            ls('친구를 만나러 가고 있어요', ['친구를 만나러 가고 있어요', '친구를 만나고 싶어요', '친구를 만나러 갔어요', '친구를 기다리고 있어요'], '친구를 만나러 가고 있어요', '만나러 = pour voir ; 가고 있어요 = je suis en route.', ['progressive', 'purpose'], 3),
            tk('Je vais déjeuner avec un ami.', '친구하고 점심을 먹으러 가요 | 친구랑 점심을 먹으러 가요 | 점심을 먹으러 친구랑 가요', '먹으러 가요 = aller manger ; 하고 / 랑 = avec.', ['purpose', 'linking'], 3),
            tk('Que fais-tu en ce moment ?', '지금 뭐 하고 있어요 | 뭐 하고 있어요', '하고 있어요 = tu es en train de faire.', ['progressive']),
            fp('Dis ce que tu es en train de faire, puis ce que tu vas faire ensuite.', '-고 있어요 et -(으)러 가요', 'Exemple : 지금 한국어를 공부하고 있어요. 그다음에 점심을 먹으러 가요.', ['progressive', 'purpose'], 4),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 3 — comparer
    {
      unit_number: 3,
      title_ko: '비교',
      title_fr: 'Comparer',
      topic: 'grammar',
      description: '보다, 더, 제일 / 가장, 중에서',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '보다 · 더 · 제일',
          title_fr: 'Plus que, le plus',
          content: {
            intro: "Quel est le plus grand, le plus cher, le meilleur ? Comparer est un réflexe de la conversation. Trois mots suffisent : 보다, 더 et 제일.",
            sections: [
              {
                title: 'A는 B보다 더 + adjectif — « A est plus… que B »',
                body: "보다 se colle au nom qui sert de comparaison (celui qui vient après « que » en français) : B보다. Le mot 더 (« plus ») renforce la comparaison : il est facultatif mais très courant. On peut aussi inverser : B보다 A가 더…",
                examples: [
                  { ko: '서울이 부산보다 더 커요.', rom: 'seo-u-ri bu-san-bo-da deo keo-yo', fr: 'Séoul est plus grande que Busan.' },
                  { ko: '지하철이 버스보다 더 편해요.', rom: 'ji-ha-cheo-ri beo-seu-bo-da deo pyeon-hae-yo', fr: 'Le métro est plus pratique que le bus.' },
                ],
              },
              {
                title: '제일 / 가장 et 중에서 — « le plus », « parmi »',
                body: "제일 et 가장 veulent tous deux dire « le plus » (superlatif). 중에서 signifie « parmi, entre » et indique l'ensemble dans lequel on compare. Pour demander laquelle de deux choses est la meilleure : A하고 B 중에서 뭐가 더 좋아요 ?",
                examples: [
                  { ko: '커피하고 차 중에서 뭐가 더 좋아요?', rom: 'keo-pi-ha-go cha jung-e-seo mwo-ga deo jo-a-yo', fr: 'Entre le café et le thé, lequel préfères-tu ?' },
                  { ko: '한국 음식 중에서 김치찌개를 제일 좋아해요.', rom: 'han-guk eum-sik jung-e-seo gim-chi-jji-gae-reul je-il jo-a-hae-yo', fr: "Parmi les plats coréens, c'est le kimchi-jjigae que j'aime le plus." },
                ],
              },
            ],
            tip: "Ne confonds pas 보다 « que » (qui se colle à un nom) avec le verbe 보다 « voir » : 서울보다 (que Séoul) ≠ 영화를 보다 (voir un film). Le contexte tranche toujours.",
          },
          exercises: [
            fb('서울이 부산___ 더 커요.', 'Séoul est plus grande que Busan.', ['보다', '에서', '하고', '처럼'], '보다', '부산보다 = que Busan.', ['comparison']),
            fb('이 가방이 저 가방보다 ___ 비싸요.', 'Ce sac est plus cher que celui-là.', ['더', '제일', '가장', '같이'], '더', '보다 va avec 더 (plus) ; 제일 / 가장 expriment le superlatif.', ['comparison']),
            fb('한국 음식 중에서 김치찌개를 ___ 좋아해요.', "Parmi les plats coréens, c'est le kimchi-jjigae que j'aime le plus.", ['제일', '보다', '부터', '밖에'], '제일', '제일 = le plus.', ['comparison'], 2),
            fb('지하철이 버스보다 더 ___.', 'Le métro est plus pratique que le bus.', ['편해요', '편하요', '편아요', '편어요'], '편해요', '편하다 → 편해요.', ['comparison', 'adjectives']),
            mc('Où place-t-on 보다 dans « Séoul est plus grande que Busan » ?', null, ['Juste après Busan : 부산보다', 'Juste après Séoul', 'Avant Busan', 'À la fin de la phrase'], 'Juste après Busan : 부산보다', '보다 se colle au nom de comparaison.', ['comparison']),
            mc('Quelle phrase veut dire « Le café est plus cher que le thé » ?', null, ['커피가 차보다 더 비싸요', '차가 커피보다 더 비싸요', '커피가 차보다 더 싸요', '차보다 커피가 제일 싸요'], '커피가 차보다 더 비싸요', 'A가 B보다 더 비싸요 = A est plus cher que B.', ['comparison'], 3),
            tk('Le métro est plus pratique que le bus.', '지하철이 버스보다 더 편해요 | 지하철이 버스보다 편해요', 'B보다 + adjectif ; 더 est facultatif.', ['comparison'], 3),
            ro('Séoul est plus grande que Busan.', ['서울이', '부산보다', '더', '커요'], '서울이 부산보다 더 커요', 'A → B보다 → 더 → adjectif.', ['comparison'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '비교 연습',
          title_fr: 'Entraînement : comparer',
          exercises: [
            fb('저는 커피___ 차를 더 좋아해요.', 'Je préfère le thé au café.', ['보다', '에서', '까지', '부터'], '보다', '커피보다 = plus que le café.', ['comparison']),
            fb('이 옷이 저 옷보다 ___ 싸요.', 'Ce vêtement est moins cher que celui-là.', ['더', '제일', '가장', '같이'], '더', '보다 va avec 더.', ['comparison']),
            fb('서울에서 이 식당이 ___ 맛있어요.', "C'est ce restaurant qui est le meilleur de Séoul.", ['제일', '보다', '도', '밖에'], '제일', '제일 = le plus.', ['comparison']),
            fb('우리 집은 친구 집___ 커요.', 'Ma maison est plus grande que celle de mon ami.', ['보다', '하고', '를', '가'], '보다', '친구 집보다 = que la maison de mon ami.', ['comparison'], 2),
            mc('Que signifie « 제일 » ?', null, ['le plus', 'plus que', 'un peu', 'jamais'], 'le plus', '제일 = le plus (comme 가장).', ['comparison']),
            mc('Que signifie « 뭐가 더 좋아요? » ?', null, ['Lequel est le mieux (que tu préfères) ?', 'Que veux-tu ?', 'Quand aimes-tu ?', "Qu'as-tu acheté ?"], 'Lequel est le mieux (que tu préfères) ?', '뭐가 더 좋아요 = lequel est le mieux.', ['comparison']),
            ls('커피보다 차를 더 좋아해요', ['커피보다 차를 더 좋아해요', '차보다 커피를 더 좋아해요', '커피하고 차를 좋아해요', '커피를 제일 좋아해요'], '커피보다 차를 더 좋아해요', 'Écoute bien qui est « plus que » qui : 커피보다 → on préfère le thé.', ['comparison'], 3),
            tk('Je préfère le thé au café.', '커피보다 차를 더 좋아해요 | 저는 커피보다 차를 더 좋아해요 | 차를 커피보다 더 좋아해요 | 저는 차를 커피보다 더 좋아해요', '커피보다 + 차를 더 좋아해요.', ['comparison'], 3),
            tk('Parmi les plats coréens, lequel préfères-tu ?', '한국 음식 중에서 뭐를 제일 좋아해요 | 한국 음식 중에서 뭐가 제일 좋아요 | 한국 음식 중에서 뭘 제일 좋아해요', '중에서 = parmi ; 제일 = le plus.', ['comparison'], 4),
            fp('Compare deux choses de ton choix (deux villes, deux plats…).', 'A는 B보다 더 + adjectif', 'Exemple : 서울이 부산보다 더 커요.', ['comparison'], 4),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 4 — décrire un nom
    {
      unit_number: 4,
      title_ko: '명사 꾸미기',
      title_fr: 'Décrire un nom avec un verbe ou un adjectif',
      topic: 'grammar',
      description: 'Adjectif + nom (-(으)ㄴ, -는) et verbe + nom (-는, -(으)ㄴ)',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-는 · -(으)ㄴ + 명사',
          title_fr: 'Le plat que j\'aime, le film que j\'ai vu',
          content: {
            intro: "En coréen, il n'y a pas de pronom relatif (« que », « qui »). Pour dire « le plat que j'aime » ou « un joli vêtement », on place le verbe ou l'adjectif DEVANT le nom, sous une forme spéciale. C'est la dernière grande pièce du puzzle de ton étage 5.",
            sections: [
              {
                title: 'Adjectif + nom : -(으)ㄴ',
                body: "Radical qui finit par une voyelle : + ㄴ (예쁘다 → 예쁜 옷, 크다 → 큰 가방). Par une consonne : + 은 (좋다 → 좋은 사람, 작다 → 작은 방). Radical en ㄹ : le ㄹ tombe (달다 → 단 음식). Exception à retenir : 있다 et 없다 se comportent comme des verbes : 맛있는 음식, 재미없는 영화.",
                examples: [
                  { ko: '예쁜 옷을 샀어요.', rom: 'ye-ppeun o-seul sa-sseo-yo', fr: "J'ai acheté un joli vêtement." },
                  { ko: '맛있는 음식을 먹고 싶어요.', rom: 'ma-sin-neun eum-si-geul meok-go si-peo-yo', fr: 'Je veux manger un plat délicieux.' },
                ],
              },
              {
                title: 'Verbe + nom : -는 (présent), -(으)ㄴ (passé)',
                body: "Présent : radical + 는 (좋아하다 → 좋아하는, 먹다 → 먹는, 마시다 → 마시는). Radical en ㄹ : le ㄹ tombe (만들다 → 만드는). Passé : radical + ㄴ après une voyelle (보다 → 본), + 은 après une consonne (읽다 → 읽은). La phrase qui suit dit ce qu'on dit du nom.",
                examples: [
                  { ko: '제가 좋아하는 음식은 김치찌개예요.', rom: 'je-ga jo-a-ha-neun eum-si-geun gim-chi-jji-gae-ye-yo', fr: "Le plat que j'aime est le kimchi-jjigae." },
                  { ko: '어제 읽은 책이 재미있었어요.', rom: 'eo-je il-geun chae-gi jae-mi-i-sseo-sseo-yo', fr: "Le livre que j'ai lu hier était intéressant." },
                ],
              },
            ],
            tip: "Pour le futur, on utilise -(으)ㄹ + nom (먹을 음식 : le plat que je mangerai). Et rappelle-toi : le verbe ou l'adjectif descriptif vient TOUJOURS avant le nom, jamais après.",
          },
          exercises: [
            fb('___ 옷을 샀어요.', "J'ai acheté un joli vêtement.", ['예쁜', '예쁘', '예쁜는', '예쁠는'], '예쁜', '예쁘다 finit par une voyelle → ㄴ : 예쁜.', ['modifier']),
            fb('저는 ___ 음식을 좋아해요.', "J'aime les plats délicieux.", ['맛있는', '맛있은', '맛있어', '맛있게'], '맛있는', '맛있다 se comporte comme un verbe : 맛있는.', ['modifier'], 2),
            fb('제가 좋아하___ 음식은 김치찌개예요.', "Le plat que j'aime est le kimchi-jjigae.", ['는', '은', '을', '게'], '는', '좋아하다 + 는 + nom.', ['modifier']),
            fb('어제 ___ 책이 재미있었어요.', "Le livre que j'ai lu hier était intéressant.", ['읽은', '읽어', '읽으', '읽고'], '읽은', '읽다 finit par une consonne → 은 (passé).', ['modifier'], 3),
            mc('Devant un nom, 크다 devient :', null, ['큰', '크은', '크는', '킨'], '큰', '크다 finit par une voyelle → ㄴ : 큰.', ['modifier']),
            mc('Que signifie « 어제 먹은 음식 » ?', null, ["la nourriture que j'ai mangée hier", 'la nourriture que je mange', 'la nourriture que je mangerai', 'la nourriture que je veux manger'], "la nourriture que j'ai mangée hier", '-(으)ㄴ + nom = passé.', ['modifier'], 3),
            tk("J'ai acheté un joli vêtement.", '예쁜 옷을 샀어요 | 저는 예쁜 옷을 샀어요', '예쁜 + 옷 (adjectif devant le nom).', ['modifier']),
            tf('제가 좋아하는 음식은 김치찌개예요.', "Le plat que j'aime est le kimchi-jjigae | Mon plat préféré est le kimchi-jjigae | La nourriture que j'aime, c'est le kimchi-jjigae", '좋아하는 음식 = le plat que j\'aime.', ['modifier']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '명사 꾸미기 연습',
          title_fr: 'Entraînement : décrire un nom',
          exercises: [
            fb('저는 ___ 가방을 샀어요.', "J'ai acheté un grand sac.", ['큰', '크', '크은', '크는'], '큰', '크다 + ㄴ : 큰.', ['modifier']),
            fb('이 식당에는 ___ 음식이 많아요.', 'Il y a beaucoup de plats délicieux dans ce restaurant.', ['맛있는', '맛있은', '맛있', '맛있게'], '맛있는', '맛있다 → 맛있는.', ['modifier'], 2),
            fb('지금 마시___ 커피가 맛있어요.', 'Le café que je bois en ce moment est bon.', ['는', '은', '을', '게'], '는', '마시다 + 는 (présent).', ['modifier']),
            fb('어제 ___ 영화는 정말 재미있었어요.', "Le film que j'ai vu hier était vraiment amusant.", ['본', '보은', '봐', '보고'], '본', '보다 finit par une voyelle → ㄴ : 본.', ['modifier'], 3),
            fb('저는 ___ 음식을 좋아해요.', "J'aime les plats sucrés.", ['단', '달은', '다는', '달는'], '단', '달다 : radical en ㄹ → le ㄹ tombe devant ㄴ : 단.', ['modifier'], 4),
            mc('Quelle phrase est correcte ?', null, ['제가 읽는 책은 재미있어요', '제가 읽은는 책은 재미있어요', '제가 읽ㄴ 책은 재미있어요', '제가 읽으 책은 재미있어요'], '제가 읽는 책은 재미있어요', '읽다 + 는 + nom (présent).', ['modifier'], 3),
            mc('Que signifie « 좋은 사람 » ?', null, ['une bonne personne', 'une grande personne', 'une personne qui part', 'une personne en retard'], 'une bonne personne', '좋다 + 은 + 사람.', ['modifier']),
            ls('어제 읽은 책이 재미있었어요', ['어제 읽은 책이 재미있었어요', '어제 읽는 책이 재미있어요', '어제 읽은 책이 재미없었어요', '내일 읽을 책이 재미있어요'], '어제 읽은 책이 재미있었어요', '읽은 = passé ; 재미있었어요 / 재미없었어요 : écoute bien 있 / 없.', ['modifier'], 3),
            tk("Le plat que j'aime est le bibimbap.", '제가 좋아하는 음식은 비빔밥이에요 | 좋아하는 음식은 비빔밥이에요', '좋아하는 음식 + 비빔밥이에요.', ['modifier'], 3),
            tk("J'ai mangé un plat délicieux.", '맛있는 음식을 먹었어요 | 저는 맛있는 음식을 먹었어요', '맛있는 + 음식 (adjectif devant le nom).', ['modifier']),
            ro("Le film que j'ai vu hier était amusant.", ['어제', '본', '영화가', '재미있었어요'], '어제 본 영화가 재미있었어요', 'Temps → verbe qui décrit le nom → nom → verbe principal.', ['modifier'], 3),
            fp('Décris ton plat ou ton film préféré avec -는 ou -(으)ㄴ.', 'Verbe ou adjectif + nom (-는 / -(으)ㄴ)', 'Exemple : 제가 좋아하는 영화는 재미있는 영화예요.', ['modifier'], 4),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 5 — BOSS
    {
      unit_number: 5,
      title_ko: '서울 여행',
      title_fr: 'Boss : un week-end à Séoul',
      topic: 'grammar',
      description: "Tout l'étage 5 dans un week-end de visite",
      lessons: [
        {
          lesson_number: 1,
          type: 'boss',
          title_ko: '5층 보스',
          title_fr: "Boss de l'étage 5",
          exercises: [
            fb('저는 불고기를 먹어 ___.', "J'ai déjà goûté du bulgogi.", ['봤어요', '보았요', '봤요', '보세요'], '봤어요', '먹어 + 봤어요.', ['experience'], 2),
            fb('제주도에 간 ___ 없어요.', "Je ne suis jamais allé(e) à Jeju.", ['적이', '수가', '번이', '거가'], '적이', '간 적이 없어요 = jamais allé.', ['experience'], 3),
            fb('지금 친구를 기다리___ 있어요.', "En ce moment, j'attends un ami.", ['고', '러', '면', '서'], '고', '-고 있어요 = être en train de.', ['progressive'], 2),
            fb('내일 친구를 만나___ 시내에 가요.', 'Demain, je vais en ville voir un ami.', ['러', '으러', '는', '어서'], '러', '만나다 finit par une voyelle → 러 + 가요.', ['purpose'], 3),
            fb('버스가 택시___ 더 싸요.', 'Le bus est moins cher que le taxi.', ['보다', '하고', '까지', '부터'], '보다', '택시보다 = que le taxi.', ['comparison'], 2),
            fb('한국 가수 중에서 누구를 ___ 좋아해요?', 'Parmi les chanteurs coréens, qui préfères-tu ?', ['제일', '보다', '도', '밖에'], '제일', '중에서 + 제일 : superlatif.', ['comparison'], 3),
            fb('저는 ___ 집에 살아요.', "J'habite dans une petite maison.", ['작은', '작', '작는', '작어'], '작은', '작다 finit par une consonne → 은 : 작은 집.', ['modifier'], 3),
            mc('Quelle phrase veut dire « Je veux goûter ça ! » ?', null, ['이거 먹어 보고 싶어요', '이거 먹고 있어요', '이거 먹어 본 적이 없어요', '이거 먹으러 가요'], '이거 먹어 보고 싶어요', '먹어 보다 + 고 싶어요.', ['experience', 'want_to'], 3),
            mc('Que signifie « 점심을 먹으러 가고 있어요 » ?', null, ['Je suis en route pour déjeuner', 'Je veux déjeuner', "J'ai déjà déjeuné", "Je déjeunerai si j'y vais"], 'Je suis en route pour déjeuner', '먹으러 = pour manger ; 가고 있어요 = je suis en train d\'aller.', ['progressive', 'purpose'], 4),
            ro("J'ai déjà vu un film coréen.", ['한국', '영화를', '본', '적이', '있어요'], '한국 영화를 본 적이 있어요', 'Objet → verbe en -(으)ㄴ → 적이 있어요.', ['experience'], 3),
            tk('Je suis en train de manger du bibimbap.', '비빔밥을 먹고 있어요 | 저는 비빔밥을 먹고 있어요 | 지금 비빔밥을 먹고 있어요', '먹다 + 고 있어요.', ['progressive'], 3),
            tk('Je préfère le métro au bus.', '버스보다 지하철을 더 좋아해요 | 저는 버스보다 지하철을 더 좋아해요 | 지하철을 버스보다 더 좋아해요 | 저는 지하철을 버스보다 더 좋아해요', '버스보다 + 지하철을 더 좋아해요.', ['comparison'], 3),
            tf('제가 어제 본 영화는 정말 재미있었어요.', "Le film que j'ai vu hier était vraiment amusant | Le film que j'ai vu hier était très intéressant | Le film que j'ai regardé hier était vraiment amusant", '제가 어제 본 영화 = le film que j\'ai vu hier.', ['modifier'], 4),
            fp("Parle d'une expérience en Corée (réelle ou imaginée) : ce que tu as déjà essayé, ou ce que tu es en train de faire.", '-아/어 봤어요, -(으)ㄴ 적이 있어요 ou -고 있어요', 'Exemple : 서울에 가 본 적이 있어요. 지금 한국어를 공부하고 있어요.', ['experience', 'progressive'], 4),
          ],
        },
      ],
    },
  ],
};
