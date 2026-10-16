// Étage 2 — 일상 대화 : conversations du quotidien (A2+).
// ⚠️ Contenu écrit par une IA et PAS ENCORE relu par un humain : voir docs/relecture-etage2.md.
import { mc, fb, ro, tk, tf, ls } from './helpers.mjs';

export const floor2 = {
  floor_number: 2,
  title_ko: '일상 대화',
  title_fr: 'Conversations du quotidien',
  cefr_level: 'A2+',
  description: "Se présenter, faire ses courses, demander son chemin, parler de demain et d'hier.",
  units: [
    // ============================================================ UNITÉ 1 — se présenter et décrire
    {
      unit_number: 1,
      title_ko: '자기소개',
      title_fr: 'Se présenter et décrire',
      topic: 'grammar',
      description: '이에요/예요 et les adjectifs en -아요/어요',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '이에요 / 예요 · 형용사',
          title_fr: 'Être, et décrire avec les adjectifs',
          content: {
            intro: "Deux outils pour parler de toi et de ce qui t'entoure : le verbe « être » et les adjectifs. Rien de nouveau dans la logique : voyelle ou consonne, et c'est réglé.",
            sections: [
              {
                title: '이에요 / 예요 — « être » (poli)',
                body: "Après un nom qui finit par une consonne : 이에요. Après une voyelle : 예요. C'est la même logique que 은/는.",
                examples: [
                  { ko: '저는 프랑스 사람이에요.', rom: 'jeo-neun peu-rang-seu sa-ra-mi-e-yo', fr: 'Je suis français(e).' },
                  { ko: '제 이름은 조던이에요.', rom: 'je i-reu-meun jo-deo-ni-e-yo', fr: "Mon nom est Jordan." },
                  { ko: '저는 의사예요.', rom: 'jeo-neun ui-sa-ye-yo', fr: 'Je suis médecin.' },
                ],
              },
              {
                title: 'Les adjectifs : radical + 아요 / 어요',
                body: "En coréen, l'adjectif se conjugue comme un verbe. Dernière voyelle du radical ㅏ ou ㅗ → 아요 ; sinon → 어요 ; les adjectifs en 하다 → 해요. Si le radical finit par ㅡ, il tombe (크다 → 커요).",
                examples: [
                  { ko: '날씨가 좋아요.', rom: 'nal-ssi-ga jo-a-yo', fr: 'Il fait beau.' },
                  { ko: '방이 커요.', rom: 'bang-i keo-yo', fr: 'La chambre est grande.' },
                  { ko: '저는 바빠요.', rom: 'jeo-neun ba-ppa-yo', fr: 'Je suis occupé(e).' },
                  { ko: '이 음식은 맛있어요.', rom: 'i eum-si-geun ma-si-sseo-yo', fr: 'Ce plat est délicieux.' },
                  { ko: '오늘은 피곤해요.', rom: 'o-neu-reun pi-gon-hae-yo', fr: "Aujourd'hui, je suis fatigué(e)." },
                ],
              },
            ],
            tip: "Pas de verbe « être » devant un adjectif : on dit « La chambre grande-est » → 방이 커요, jamais 방이 이에요 커요.",
          },
          exercises: [
            fb('저는 학생___.', 'Je suis étudiant(e).', ['이에요', '예요', '이요', '에요'], '이에요', '학생 finit par une consonne (ㅇ) → 이에요.', ['copula', 'particles']),
            fb('저는 의사___.', 'Je suis médecin.', ['예요', '이에요', '이요', '에요'], '예요', '의사 finit par une voyelle → 예요.', ['copula', 'particles']),
            fb('제 이름은 조던___.', 'Mon nom est Jordan.', ['이에요', '예요', '이요', '에요'], '이에요', '조던 finit par ㄴ, une consonne → 이에요.', ['copula', 'particles']),
            mc('Après un nom qui finit par une voyelle, « être » (poli) se dit :', null, ['예요', '이에요', '아요', '어요'], '예요', '예요 après une voyelle, 이에요 après une consonne. 아요/어요 servent aux verbes et adjectifs.', ['copula']),
            fb('날씨가 ___.', 'Il fait beau.', ['좋아요', '좋어요', '좋해요', '좋요'], '좋아요', "좋다 : dernière voyelle ㅗ → 아요 : 좋아요.", ['adjectives']),
            fb('방이 ___.', 'La chambre est grande.', ['커요', '크어요', '큰요', '크아요'], '커요', '크다 : le ㅡ tombe → 커요.', ['adjectives'], 2),
            tk('Je suis français(e).', '저는 프랑스 사람이에요 | 프랑스 사람이에요', '사람 finit par une consonne (ㅁ) → 이에요.', ['copula']),
            ro('Ma chambre est grande.', ['제', '방이', '커요'], '제 방이 커요', 'Possesseur → sujet → adjectif à la fin.', ['adjectives'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '자기소개 연습',
          title_fr: 'Entraînement : être et adjectifs',
          exercises: [
            fb('이 음식은 ___.', 'Ce plat est délicieux.', ['맛있어요', '맛있아요', '맛있해요', '맛있요'], '맛있어요', '맛있다 : dernière voyelle ㅣ → 어요.', ['adjectives']),
            fb('저는 오늘 ___.', "Aujourd'hui, je suis occupé(e).", ['바빠요', '바쁘어요', '바빠어요', '바쁘요'], '바빠요', '바쁘다 : ㅡ tombe, la voyelle précédente est ㅏ → 아요 : 바빠요.', ['adjectives'], 3),
            fb('이 옷은 ___.', 'Ce vêtement est joli.', ['예뻐요', '예쁘어요', '예뻐어요', '예쁘요'], '예뻐요', '예쁘다 : ㅡ tombe, la voyelle précédente est ㅖ → 어요 : 예뻐요.', ['adjectives'], 3),
            fb('오늘은 정말 ___.', "Aujourd'hui, je suis vraiment fatigué(e).", ['피곤해요', '피곤아요', '피곤어요', '피곤요'], '피곤해요', "피곤하다 : les adjectifs en 하다 font 해요.", ['adjectives']),
            mc('Quelle est la forme polie de 작다 (petit) ?', null, ['작아요', '작어요', '작해요', '작요'], '작아요', '작다 : dernière voyelle ㅏ → 아요.', ['adjectives']),
            mc('Quelle est la forme polie de 많다 (beaucoup) ?', null, ['많아요', '많어요', '많해요', '만아요'], '많아요', '많다 : dernière voyelle ㅏ → 아요.', ['adjectives']),
            ls('저는 의사예요', ['저는 의사예요', '저는 학생이에요', '저는 의사가 아니에요', '저는 의사이에요'], '저는 의사예요', '의사 + 예요 (voyelle).', ['copula']),
            tf('날씨가 좋아요.', 'Il fait beau | Le temps est bon | La météo est bonne | Il fait bon', '좋아요 : « c\'est bien / agréable ».', ['adjectives']),
            tk('Mon nom est Jordan.', '제 이름은 조던이에요 | 이름은 조던이에요', '조던 + 이에요 (consonne finale ㄴ).', ['copula'], 2),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 2 — acheter et commander
    {
      unit_number: 2,
      title_ko: '쇼핑과 주문',
      title_fr: 'Acheter et commander',
      topic: 'vocabulary',
      description: '주세요, les compteurs et les prix',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '주세요',
          title_fr: "« S'il vous plaît » : demander quelque chose",
          content: {
            intro: "Au marché, au café, au restaurant : une seule structure te suffit pour presque tout demander. Et elle réutilise ce que tu sais déjà sur les compteurs.",
            sections: [
              {
                title: 'N + 주세요 — « donnez-moi… »',
                body: "On dit l'objet puis 주세요, sans particule. Pour la quantité : nom + nombre natif + compteur + 주세요. L'ordre est toujours nom → nombre → compteur.",
                examples: [
                  { ko: '커피 한 잔 주세요.', rom: 'keo-pi han jan ju-se-yo', fr: "Un café, s'il vous plaît." },
                  { ko: '물 한 병 주세요.', rom: 'mul han byeong ju-se-yo', fr: "Une bouteille d'eau, s'il vous plaît." },
                  { ko: '사과 세 개 주세요.', rom: 'sa-gwa se gae ju-se-yo', fr: "Trois pommes, s'il vous plaît." },
                  { ko: '두부 한 모 주세요.', rom: 'du-bu han mo ju-se-yo', fr: "Un bloc de tofu, s'il vous plaît." },
                ],
              },
              {
                title: '얼마예요 ? — le prix',
                body: "얼마예요 ? = « combien ça coûte ? ». La réponse utilise les nombres sino-coréens + 원, avec 이에요 / 예요.",
                examples: [
                  { ko: '이거 얼마예요?', rom: 'i-geo eol-ma-ye-yo', fr: 'Combien ça coûte ?' },
                  { ko: '삼천 원이에요.', rom: 'sam-cheon wo-ni-e-yo', fr: "C'est 3 000 wons." },
                ],
              },
            ],
            tip: "Compteurs utiles : 잔 (tasses, verres), 병 (bouteilles), 개 (objets), 명 (personnes), 모 (blocs de tofu). Le tofu a son propre compteur !",
          },
          exercises: [
            tk("Un café, s'il vous plaît.", '커피 한 잔 주세요', '커피 + 한 (하나 devant un compteur) + 잔 + 주세요.', ['requests', 'counters', 'numbers_native']),
            tk("Deux bouteilles d'eau, s'il vous plaît.", '물 두 병 주세요', '물 + 두 (둘 devant un compteur) + 병 + 주세요.', ['requests', 'counters', 'numbers_native']),
            fb('커피 ___ 잔 주세요.', "Un café, s'il vous plaît.", ['한', '하나', '일', '첫'], '한', '하나 → 한 devant le compteur 잔.', ['numbers_native', 'counters']),
            mc('Quel compteur pour un bloc de tofu ?', null, ['모', '마리', '권', '명'], '모', '모 est le compteur des blocs de tofu : 두부 한 모.', ['counters']),
            mc('Comment demande-t-on le prix ?', null, ['얼마예요?', '뭐예요?', '어디예요?', '누구예요?'], '얼마예요?', '얼마 = combien. 뭐 = quoi, 어디 = où, 누구 = qui.', ['requests']),
            mc('Quelle phrase est correcte ? (deux cafés, s\'il vous plaît)', null, ['커피 두 잔 주세요', '두 커피 잔 주세요', '커피 잔 두 주세요', '주세요 커피 두 잔'], '커피 두 잔 주세요', 'Ordre : nom + nombre + compteur, puis 주세요.', ['counters', 'requests'], 2),
            ro("Un café, s'il vous plaît.", ['커피', '한', '잔', '주세요'], '커피 한 잔 주세요', 'Nom → nombre → compteur → 주세요.', ['counters', 'requests'], 2),
            tf('이거 얼마예요?', "Combien ça coûte | Ça coûte combien | C'est combien | Combien ça fait", '이거 = ceci ; 얼마예요 = combien ça coûte.', ['requests']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '쇼핑 연습',
          title_fr: 'Entraînement : commander et payer',
          exercises: [
            fb('삼천 원___.', "C'est 3 000 wons.", ['이에요', '예요', '이요', '에요'], '이에요', '원 finit par ㄴ, une consonne → 이에요.', ['copula', 'numbers_sino']),
            fb('사과 세 ___ 주세요.', "Trois pommes, s'il vous plaît.", ['개', '명', '마리', '권'], '개', '개 : compteur des objets (et des fruits).', ['counters']),
            fb('친구 두 ___ 있어요.', "J'ai deux amis.", ['명', '개', '마리', '잔'], '명', '명 : compteur des personnes.', ['counters']),
            tk("Trois pommes, s'il vous plaît.", '사과 세 개 주세요', '사과 + 세 (셋 devant un compteur) + 개 + 주세요.', ['requests', 'counters', 'numbers_native']),
            tk("Un bloc de tofu, s'il vous plaît.", '두부 한 모 주세요', '두부 + 한 + 모 (compteur du tofu) + 주세요.', ['requests', 'counters', 'numbers_native']),
            tk('Combien coûte ceci ?', '이거 얼마예요 | 이것 얼마예요 | 이거 얼마예요?', '이거 + 얼마예요.', ['requests']),
            ls('물 한 병 주세요', ['물 한 병 주세요', '물 두 병 주세요', '물 세 병 주세요', '물 네 병 주세요'], '물 한 병 주세요', '한 = un. Écoute bien 한 / 두 / 세 / 네.', ['numbers_native', 'counters']),
            tf('두부 한 모 주세요.', "Un bloc de tofu, s'il vous plaît | Un tofu, s'il vous plaît | Donnez-moi un bloc de tofu | Je voudrais un bloc de tofu", '모 = bloc de tofu.', ['requests', 'counters']),
            ro("Deux pommes, s'il vous plaît.", ['사과', '두', '개', '주세요'], '사과 두 개 주세요', 'Nom → nombre → compteur → 주세요.', ['counters', 'requests'], 2),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 3 — chemin et transports
    {
      unit_number: 3,
      title_ko: '길 찾기와 교통',
      title_fr: 'Demander son chemin et se déplacer',
      topic: 'grammar',
      description: '어디, 옆에, 가세요, 에서…까지',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '어디에 있어요?',
          title_fr: 'Où est… ? Directions',
          content: {
            intro: "Demander son chemin, c'est surtout 에 (où ça se trouve) et (으)로 (dans quelle direction / avec quoi). Tu connais déjà les deux : on les assemble.",
            sections: [
              {
                title: 'Où est… ? → 어디에 있어요 ?',
                body: "N이/가 + 어디에 있어요 ? Pour répondre : lieu + 에 + 있어요. Mots de position : 옆 (à côté), 앞 (devant), 뒤 (derrière), 위 (dessus).",
                examples: [
                  { ko: '은행이 어디에 있어요?', rom: 'eun-haeng-i eo-di-e i-sseo-yo', fr: 'Où est la banque ?' },
                  { ko: '병원은 시장 옆에 있어요.', rom: 'byeong-wo-neun si-jang yeo-pe i-sseo-yo', fr: "L'hôpital est à côté du marché." },
                ],
              },
              {
                title: 'Donner une direction : -(으)로 + 가세요',
                body: "오른쪽 (droite), 왼쪽 (gauche) + 으로 ; 똑바로 = tout droit. 가세요 est la forme polie pour dire « allez ». Avec un transport : 지하철로 (en métro), 버스로 (en bus), 택시로 (en taxi).",
                examples: [
                  { ko: '오른쪽으로 가세요.', rom: 'o-reun-jjo-geu-ro ga-se-yo', fr: 'Allez à droite.' },
                  { ko: '똑바로 가세요.', rom: 'ttok-ba-ro ga-se-yo', fr: 'Allez tout droit.' },
                  { ko: '지하철로 가요.', rom: 'ji-ha-cheol-lo ga-yo', fr: "J'y vais en métro." },
                ],
              },
              {
                title: 'De… à… : 에서 … 까지',
                body: "에서 donne le point de départ, 까지 l'arrivée. Pour la durée : 걸려요 (« ça prend »).",
                examples: [
                  { ko: '집에서 학교까지 걸어서 십 분 걸려요.', rom: 'ji-be-seo hak-gyo-kka-ji geo-reo-seo sip bun geol-lyeo-yo', fr: "De chez moi à l'école, il faut dix minutes à pied." },
                ],
              },
            ],
            tip: "Piège classique : 가다 (aller) prend 에 pour la destination, jamais 에서 : 도서관에 가요. Et on « prend » un transport avec 를/을 : 버스를 타요.",
          },
          exercises: [
            fb('은행은 시장 ___ 있어요.', 'La banque est à côté du marché.', ['옆에', '앞에', '뒤에', '위에'], '옆에', '옆 = à côté.', ['location_words', 'e_vs_eseo']),
            fb('화장실이 ___ 있어요?', 'Où sont les toilettes ?', ['어디에', '누구에', '무엇을', '어디를'], '어디에', '어디 = où ; lieu où l\'on se trouve → 에 있어요.', ['directions', 'e_vs_eseo']),
            fb('오른쪽___ 가세요.', 'Allez à droite.', ['으로', '로', '를', '이'], '으로', '오른쪽 finit par ㄱ (consonne) → 으로.', ['direction', 'directions']),
            mc('Que signifie 오른쪽 ?', null, ['à droite', 'à gauche', 'tout droit', 'derrière'], 'à droite', '오른쪽 = droite ; 왼쪽 = gauche ; 똑바로 = tout droit.', ['directions']),
            mc('Que signifie 가세요 (ici, dans une direction) ?', null, ['Allez', 'Il est allé', 'Je vais', 'Ne partez pas'], 'Allez', '-(으)세요 : forme polie pour inviter / ordonner gentiment.', ['directions']),
            tk('Allez tout droit.', '똑바로 가세요 | 쭉 가세요', '똑바로 = tout droit ; 가세요 = allez (poli).', ['directions'], 2),
            ro('Où est la banque ?', ['은행이', '어디에', '있어요'], '은행이 어디에 있어요', 'Sujet → où → il y a / se trouve.', ['directions', 'e_vs_eseo'], 2),
            tf('오른쪽으로 가세요.', 'Allez à droite | Allez vers la droite | Tournez à droite', '오른쪽으로 = vers la droite.', ['directions']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '길 찾기 연습',
          title_fr: 'Entraînement : directions et transports',
          exercises: [
            fb('집에서 학교___ 걸어서 십 분 걸려요.', "De chez moi à l'école, il faut dix minutes à pied.", ['까지', '부터', '에서', '으로'], '까지', '에서 … 까지 = de … à … ; 까지 marque l\'arrivée.', ['directions', 'e_vs_eseo']),
            fb('지하철___ 가요.', "J'y vais en métro.", ['로', '으로', '를', '에게'], '로', '지하철 finit par ㄹ → 로 (moyen de transport).', ['direction', 'directions'], 3),
            fb('버스___ 타요.', 'Je prends le bus.', ['를', '을', '로', '가'], '를', '버스 finit par une voyelle → 를. On « prend » un transport : 버스를 타요.', ['object_particle', 'directions']),
            mc('Quelle phrase est correcte ? (je prends le métro)', null, ['지하철을 타요', '지하철로 타요', '지하철을 가요', '지하철이 타요'], '지하철을 타요', '타다 (prendre un transport) se construit avec 을/를.', ['object_particle', 'directions'], 3),
            tk("Je vais à l'école en bus.", '버스로 학교에 가요 | 학교에 버스로 가요 | 저는 버스로 학교에 가요', '버스로 (moyen) + 학교에 가요 (destination → 에).', ['direction', 'e_vs_eseo'], 3),
            tk("Où est l'hôpital ?", '병원이 어디에 있어요 | 병원은 어디에 있어요 | 병원이 어디예요', '병원이/은 + 어디에 있어요.', ['directions', 'e_vs_eseo']),
            ls('오른쪽으로 가세요', ['오른쪽으로 가세요', '왼쪽으로 가세요', '똑바로 가세요', '오른쪽에 있어요'], '오른쪽으로 가세요', '오른쪽 = droite ; 왼쪽 = gauche.', ['directions']),
            tf('은행은 병원 옆에 있어요.', "La banque est à côté de l'hôpital | La banque se trouve à côté de l'hôpital", '옆에 있어요 = être à côté.', ['location_words', 'e_vs_eseo']),
            ro("Je vais à la poste en taxi.", ['저는', '택시로', '우체국에', '가요'], '저는 택시로 우체국에 가요 | 저는 우체국에 택시로 가요', 'Moyen (로) et destination (에) avant le verbe.', ['direction', 'e_vs_eseo'], 3),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 4 — faire des projets
    {
      unit_number: 4,
      title_ko: '계획',
      title_fr: 'Faire des projets : le futur',
      topic: 'grammar',
      description: '-(으)ㄹ 거예요',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-(으)ㄹ 거예요',
          title_fr: 'Dire ce que tu feras',
          content: {
            intro: "Pour parler de demain, de ce week-end ou de l'année prochaine, une seule forme : radical + (으)ㄹ 거예요. Là encore : voyelle ou consonne.",
            sections: [
              {
                title: 'La forme',
                body: "Radical qui finit par une voyelle (ou ㄹ) → ㄹ 거예요 : 가다 → 갈 거예요. Radical qui finit par une consonne → 을 거예요 : 먹다 → 먹을 거예요. Verbes en ㄹ (살다) : le ㄹ ne se double pas : 살 거예요.",
                examples: [
                  { ko: '내일 친구를 만날 거예요.', rom: 'nae-il chin-gu-reul man-nal geo-ye-yo', fr: 'Demain, je verrai un ami.' },
                  { ko: '저녁에 밥을 먹을 거예요.', rom: 'jeo-nyeo-ge ba-beul meo-geul geo-ye-yo', fr: 'Ce soir, je mangerai.' },
                  { ko: '저는 서울에 살 거예요.', rom: 'jeo-neun seo-u-re sal geo-ye-yo', fr: "J'habiterai à Séoul." },
                ],
              },
              {
                title: 'Les repères de temps',
                body: "내일 (demain), 주말 (le week-end), 다음 주 (la semaine prochaine). Souvenir de l'étage 1 : 에 avec 주말 et 다음 주, mais pas avec 내일.",
                examples: [
                  { ko: '주말에 영화를 볼 거예요.', rom: 'ju-ma-re yeong-hwa-reul bol geo-ye-yo', fr: 'Ce week-end, je verrai un film.' },
                  { ko: '다음 주에 한국에 갈 거예요.', rom: 'da-eum ju-e han-gu-ge gal geo-ye-yo', fr: "La semaine prochaine, j'irai en Corée." },
                ],
              },
            ],
            tip: "Pas de 에 après 내일, 오늘, 어제. Avec 주말, 다음 주, 3시 : oui.",
          },
          exercises: [
            fb('내일 학교에 ___ 거예요.', "Demain, j'irai à l'école.", ['갈', '가을', '가', '가서'], '갈', '가다 : radical 가 (voyelle) → ㄹ 거예요 : 갈 거예요.', ['future']),
            fb('저녁에 밥을 ___ 거예요.', 'Ce soir, je mangerai.', ['먹을', '먹어', '먹으', '먹'], '먹을', '먹다 : radical 먹 (consonne) → 을 거예요.', ['future']),
            mc('Après un radical qui finit par une consonne (먹다), le futur se forme avec :', null, ['을 거예요', 'ㄹ 거예요', '았어요', '세요'], '을 거예요', 'Consonne → 을 거예요 ; voyelle → ㄹ 거예요. 았어요 = passé.', ['future']),
            tk('Demain, je verrai un film.', '내일 영화를 볼 거예요 | 저는 내일 영화를 볼 거예요', '보다 → 볼 거예요 ; pas de 에 après 내일.', ['future', 'time_particle', 'temporal']),
            tk('Ce week-end, je verrai un ami.', '주말에 친구를 만날 거예요 | 이번 주말에 친구를 만날 거예요 | 저는 주말에 친구를 만날 거예요', '만나다 → 만날 거예요 ; 주말에 (avec 에).', ['future', 'time_particle', 'temporal'], 3),
            ro('Demain, je lirai un livre.', ['내일', '책을', '읽을', '거예요'], '내일 책을 읽을 거예요', 'Temps → objet → verbe au futur.', ['future'], 2),
            tf('다음 주에 한국에 갈 거예요.', "La semaine prochaine, j'irai en Corée | J'irai en Corée la semaine prochaine", '다음 주에 = la semaine prochaine ; 갈 거예요 = j\'irai.', ['future', 'time_particle']),
            mc('Que signifie 내일 ?', null, ['demain', 'hier', "aujourd'hui", 'la semaine prochaine'], 'demain', '내일 = demain ; 어제 = hier ; 오늘 = aujourd\'hui.', ['temporal']),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '계획 연습',
          title_fr: 'Entraînement : le futur',
          exercises: [
            fb('주말에 영화를 ___ 거예요.', 'Ce week-end, je verrai un film.', ['볼', '보을', '볼을', '보'], '볼', '보다 : radical 보 (voyelle) → 볼 거예요.', ['future']),
            fb('오늘 저녁에 친구를 ___ 거예요.', 'Ce soir, je verrai un ami.', ['만날', '만나을', '만나서', '만나'], '만날', '만나다 : radical 만나 (voyelle) → 만날 거예요.', ['future']),
            fb('저는 서울에 ___ 거예요.', "J'habiterai à Séoul.", ['살', '사을', '살을', '사'], '살', '살다 (radical en ㄹ) : 살 거예요, le ㄹ ne se double pas.', ['future'], 3),
            fb('내일 뭐 ___ 거예요?', 'Que feras-tu demain ?', ['할', '하을', '해서', '해'], '할', '하다 : radical 하 (voyelle) → 할 거예요.', ['future']),
            fb('다음 주___ 한국에 갈 거예요.', "La semaine prochaine, j'irai en Corée.", ['에', '에서', '를', '가'], '에', '다음 주 est un moment précis → 에.', ['time_particle', 'temporal']),
            tk('Demain, je mangerai du bibimbap.', '내일 비빔밥을 먹을 거예요 | 저는 내일 비빔밥을 먹을 거예요', '먹다 → 먹을 거예요 ; 비빔밥을 (objet).', ['future', 'object_particle']),
            ls('내일 친구를 만날 거예요', ['내일 친구를 만날 거예요', '내일 친구를 먹을 거예요', '내일 친구를 갈 거예요', '내일 친구를 읽을 거예요'], '내일 친구를 만날 거예요', '만나다 (rencontrer) est le seul verbe cohérent avec 친구를.', ['future', 'object_particle']),
            tf('저는 주말에 영화를 볼 거예요.', 'Ce week-end, je verrai un film | Je verrai un film ce week-end | Moi, ce week-end, je verrai un film', '주말에 = ce week-end ; 볼 거예요 = je verrai.', ['future']),
            ro("Ce week-end, j'irai au parc.", ['주말에', '공원에', '갈', '거예요'], '주말에 공원에 갈 거예요', 'Moment → destination (에) → verbe au futur.', ['future', 'e_vs_eseo'], 2),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 5 — parler du passé
    {
      unit_number: 5,
      title_ko: '과거',
      title_fr: 'Parler du passé',
      topic: 'grammar',
      description: '-았/었-, et relier deux noms avec 하고 / (이)랑',
      lessons: [
        {
          lesson_number: 1,
          type: 'teach',
          title_ko: '-았/었어요',
          title_fr: "Dire ce qu'on a fait",
          content: {
            intro: "Le passé, c'est comme le présent poli, mais avec ㅆ : 았어요 / 었어요 / 했어요. Et pour raconter, un petit outil en plus : relier deux noms.",
            sections: [
              {
                title: 'Le passé poli',
                body: "Dernière voyelle ㅏ ou ㅗ → 았어요 ; autres voyelles → 었어요 ; verbes en 하다 → 했어요. À l'oral, la voyelle se contracte : 가+았 → 갔, 보+았 → 봤, 사+았 → 샀. Attention : 사요 est le présent, 샀어요 le passé.",
                examples: [
                  { ko: '어제 친구를 만났어요.', rom: 'eo-je chin-gu-reul man-na-sseo-yo', fr: "Hier, j'ai vu un ami." },
                  { ko: '저는 커피를 샀어요.', rom: 'jeo-neun keo-pi-reul sa-sseo-yo', fr: "J'ai acheté du café." },
                  { ko: '지난 주말에 영화를 봤어요.', rom: 'ji-nan ju-ma-re yeong-hwa-reul bwa-sseo-yo', fr: "Le week-end dernier, j'ai vu un film." },
                  { ko: '어제 한국어를 공부했어요.', rom: 'eo-je han-gu-geo-reul gong-bu-hae-sseo-yo', fr: "Hier, j'ai étudié le coréen." },
                ],
              },
              {
                title: 'Relier deux noms : 하고 / (이)랑',
                body: "Pour dire « et » ou « avec » entre deux NOMS, on colle 하고, ou (이)랑 (이랑 après une consonne, 랑 après une voyelle). 그리고 ne relie pas des noms : il commence une phrase (« et puis »).",
                examples: [
                  { ko: '빵하고 우유를 샀어요.', rom: 'ppang-ha-go u-yu-reul sa-sseo-yo', fr: "J'ai acheté du pain et du lait." },
                  { ko: '친구랑 영화를 봤어요.', rom: 'chin-gu-rang yeong-hwa-reul bwa-sseo-yo', fr: "J'ai vu un film avec un ami." },
                  { ko: '점심에 비빔밥을 먹었어요. 그다음에 커피를 마셨어요.', rom: 'jeom-sim-e bi-bim-ba-beul meo-geo-sseo-yo. geu-da-eu-me keo-pi-reul ma-syeo-sseo-yo', fr: "À midi, j'ai mangé un bibimbap. Ensuite, j'ai bu un café." },
                ],
              },
            ],
            tip: "Deux outils, deux rôles : 하고 / (이)랑 relient des NOMS (빵하고 우유) ; 그리고 / 그다음에 relient des PHRASES.",
          },
          exercises: [
            fb('어제 친구를 ___.', "Hier, j'ai vu un ami.", ['만났어요', '만나았어요', '만나었어요', '만낫어요'], '만났어요', '만나다 : ㅏ → 았어요, contracté : 만났어요.', ['past']),
            fb('저는 커피를 ___.', "J'ai acheté du café.", ['샀어요', '사았어요', '사었어요', '사요'], '샀어요', '사다 → 샀어요 (passé). 사요 est le présent.', ['past']),
            fb('지난 주말에 영화를 ___.', "Le week-end dernier, j'ai vu un film.", ['봤어요', '보요', '봐요', '보었어요'], '봤어요', '보다 : ㅗ → 았어요, contracté : 봤어요. 봐요 est le présent.', ['past'], 2),
            fb('어제 한국어를 ___.', "Hier, j'ai étudié le coréen.", ['공부했어요', '공부하았어요', '공부하었어요', '공부해요'], '공부했어요', '공부하다 → 공부했어요 (passé). 공부해요 est le présent.', ['past']),
            mc('Quelle terminaison pour le passé poli des verbes en -하다 ?', null, ['했어요', '했요', '하었요', '한어요'], '했어요', '하다 → 했어요.', ['past']),
            mc('Que signifie 어제 ?', null, ['hier', 'demain', "aujourd'hui", 'ce soir'], 'hier', '어제 = hier ; 내일 = demain.', ['temporal']),
            tk("J'ai mangé du bibimbap à midi.", '점심에 비빔밥을 먹었어요 | 저는 점심에 비빔밥을 먹었어요', '먹다 : ㅓ → 었어요 ; 점심에 = à midi.', ['past', 'time_particle'], 3),
            ro("Hier, j'ai étudié le coréen.", ['어제', '한국어를', '공부했어요'], '어제 한국어를 공부했어요', 'Temps → objet → verbe au passé.', ['past'], 2),
          ],
        },
        {
          lesson_number: 2,
          type: 'practice',
          title_ko: '과거 연습',
          title_fr: 'Entraînement : passé et liaison de noms',
          exercises: [
            fb('저는 어제 학교에 ___.', "Hier, je suis allé(e) à l'école.", ['갔어요', '가었어요', '가았어요', '갔요'], '갔어요', '가다 → 갔어요.', ['past', 'e_vs_eseo']),
            fb('어제 커피를 ___.', "Hier, j'ai bu un café.", ['마셨어요', '마시어요', '마셔요', '마싰어요'], '마셨어요', '마시다 → 마셨어요 (passé).', ['past'], 3),
            fb('빵___ 우유를 샀어요.', "J'ai acheté du pain et du lait.", ['하고', '그리고', '그래서', '하지만'], '하고', '하고 relie deux noms. 그리고, 그래서, 하지만 relient des phrases.', ['linking', 'past']),
            fb('친구___ 영화를 봤어요.', "J'ai vu un film avec un ami.", ['랑', '이랑', '그리고', '에서'], '랑', '친구 finit par une voyelle → 랑 (이랑 après une consonne).', ['linking', 'past']),
            mc('Pour relier deux NOMS (du pain et du lait), on utilise :', null, ['하고 / (이)랑', '그리고', '그래서', '하지만'], '하고 / (이)랑', '하고 et (이)랑 relient des noms ; 그리고 relie des phrases.', ['linking']),
            mc('Que signifie 그다음에 ?', null, ['ensuite, après ça', 'avant ça', 'pendant ce temps', 'à cause de ça'], 'ensuite, après ça', '그다음에 = ensuite.', ['linking']),
            tk("J'ai acheté du tofu.", '두부를 샀어요 | 저는 두부를 샀어요', '사다 → 샀어요 ; 두부를 (objet).', ['past', 'object_particle']),
            tk("Hier, j'ai vu un film avec un ami.", '어제 친구랑 영화를 봤어요 | 어제 친구하고 영화를 봤어요 | 저는 어제 친구랑 영화를 봤어요 | 저는 어제 친구하고 영화를 봤어요', '친구랑 / 친구하고 = avec un ami ; 봤어요 = j\'ai vu.', ['past', 'linking'], 3),
            ls('어제 친구를 만났어요', ['어제 친구를 만났어요', '내일 친구를 만날 거예요', '어제 친구를 샀어요', '어제 친구를 먹었어요'], '어제 친구를 만났어요', '만났어요 = passé de 만나다 (rencontrer).', ['past']),
            tf('저는 어제 영화를 봤어요.', "Hier, j'ai vu un film | J'ai vu un film hier | Moi, hier, j'ai vu un film", '어제 = hier ; 봤어요 = j\'ai vu.', ['past']),
          ],
        },
      ],
    },

    // ============================================================ UNITÉ 6 — BOSS
    {
      unit_number: 6,
      title_ko: '역할극',
      title_fr: 'Boss : une journée au marché',
      topic: 'grammar',
      description: 'Tout l\'étage 2 dans un jeu de rôle',
      lessons: [
        {
          lesson_number: 1,
          type: 'boss',
          title_ko: '2층 보스',
          title_fr: "Boss de l'étage 2",
          exercises: [
            fb('저는 프랑스 사람___.', 'Je suis français(e).', ['이에요', '예요', '이요', '에요'], '이에요', '사람 finit par une consonne (ㅁ) → 이에요.', ['copula'], 2),
            fb('이 음식은 정말 ___.', 'Ce plat est vraiment délicieux.', ['맛있어요', '맛있아요', '맛있해요', '맛있요'], '맛있어요', '맛있다 → 맛있어요.', ['adjectives'], 2),
            fb('시장에서 사과 세 ___ 샀어요.', "Au marché, j'ai acheté trois pommes.", ['개', '명', '마리', '잔'], '개', '개 : compteur des objets.', ['counters', 'past'], 3),
            fb('지하철___ 학교에 가요.', "Je vais à l'école en métro.", ['로', '으로', '를', '에게'], '로', '지하철 finit par ㄹ → 로.', ['direction', 'directions'], 3),
            fb('내일 친구를 ___ 거예요.', 'Demain, je verrai un ami.', ['만날', '만나을', '만나서', '만나'], '만날', '만나다 → 만날 거예요.', ['future'], 3),
            fb('어제 영화를 ___.', "Hier, j'ai vu un film.", ['봤어요', '보었어요', '보요', '봐요'], '봤어요', '보다 → 봤어요.', ['past'], 3),
            fb('빵___ 우유를 샀어요.', "J'ai acheté du pain et du lait.", ['하고', '그리고', '그래서', '하지만'], '하고', '하고 relie deux noms.', ['linking', 'past'], 3),
            mc("Quelle phrase est correcte ? (deux cafés, s'il vous plaît)", null, ['커피 두 잔 주세요', '두 커피 잔 주세요', '커피 잔 두 주세요', '주세요 커피 두 잔'], '커피 두 잔 주세요', 'Nom → nombre → compteur → 주세요.', ['counters', 'requests'], 3),
            ro("Hier, j'ai acheté du pain et du café.", ['어제', '빵하고', '커피를', '샀어요'], '어제 빵하고 커피를 샀어요', 'Temps → objets reliés par 하고 → verbe au passé.', ['linking', 'past'], 3),
            tk('Combien coûte ce tofu ?', '이 두부 얼마예요 | 이거 얼마예요 | 이 두부는 얼마예요', '이 두부 = ce tofu ; 얼마예요 = combien ?', ['requests'], 3),
            tk('Allez tout droit, puis à droite.', '똑바로 가세요. 그다음에 오른쪽으로 가세요 | 똑바로 가세요 그다음에 오른쪽으로 가세요', '똑바로 = tout droit ; 그다음에 = ensuite ; 오른쪽으로 = vers la droite.', ['directions', 'linking'], 4),
            tk("Ce week-end, j'irai à Séoul en train.", '주말에 기차로 서울에 갈 거예요 | 이번 주말에 기차로 서울에 갈 거예요 | 주말에 서울에 기차로 갈 거예요', '주말에 (moment) + 기차로 (moyen) + 서울에 (destination) + 갈 거예요.', ['future', 'direction', 'e_vs_eseo'], 4),
            tf('어제 시장에서 두부하고 사과를 샀어요.', "Hier, j'ai acheté du tofu et des pommes au marché | J'ai acheté du tofu et des pommes au marché hier | Hier, au marché, j'ai acheté du tofu et des pommes", '시장에서 = au marché (action) ; 두부하고 사과 = du tofu et des pommes.', ['past', 'linking', 'e_vs_eseo'], 4),
          ],
        },
      ],
    },
  ],
};
