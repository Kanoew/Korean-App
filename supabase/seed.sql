-- ============================================================
-- 한글 with Karina — Seed : étages 1 à 5
-- Fichier GÉNÉRÉ par supabase/seed/build-seed.mjs — ne pas éditer à la main.
-- À exécuter APRÈS schema.sql. Rejouable : remplace le contenu statique de chaque étage.
-- ============================================================

-- ################ Étage 1 : Les fondations ################
insert into floors (floor_number, title_ko, title_fr, cefr_level, description, unlock_xp)
values (1, '기초 다지기', 'Les fondations', 'A2', 'Consolider les bases : particules, lieu, temps, nombres.', 0)
on conflict (floor_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr,
  cefr_level = excluded.cefr_level, description = excluded.description;

-- ---------- Étage 1 · Unité 1 : Particules : rappel ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 1, '조사 복습', 'Particules : rappel', 'grammar', '은/는, 이/가, 을/를' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '은/는 · 이/가 · 을/를', 'Les trois grandes particules', 'teach', '{"intro":"Trois particules qui reviennent dans presque toutes les phrases. Si elles sont solides, tout le reste devient plus facile, mon chou.","sections":[{"title":"은/는 — le thème","body":"Elle pose le sujet dont on parle (\"quant à…\") ou crée un contraste. Après une consonne : 은. Après une voyelle : 는.","examples":[{"ko":"저는 학생이에요.","rom":"jeo-neun hak-saeng-i-e-yo","fr":"Moi, je suis étudiant(e)."},{"ko":"책은 재미있어요.","rom":"chae-geun jae-mi-i-sseo-yo","fr":"Le livre, il est intéressant."}]},{"title":"이/가 — le sujet","body":"Elle marque le sujet grammatical, surtout pour une information nouvelle (\"c''est X qui…\"). Après une consonne : 이. Après une voyelle : 가.","examples":[{"ko":"친구가 와요.","rom":"chin-gu-ga wa-yo","fr":"Un ami vient."},{"ko":"책이 있어요.","rom":"chae-gi i-sseo-yo","fr":"Il y a un livre."},{"ko":"비가 와요.","rom":"bi-ga wa-yo","fr":"Il pleut."}]},{"title":"을/를 — le complément d''objet","body":"Elle marque ce sur quoi porte l''action (le COD). Après une consonne : 을. Après une voyelle : 를.","examples":[{"ko":"커피를 마셔요.","rom":"keo-pi-reul ma-syeo-yo","fr":"Je bois du café."},{"ko":"물을 마셔요.","rom":"mu-reul ma-syeo-yo","fr":"Je bois de l''eau."}]}],"tip":"Regarde toujours la dernière lettre du mot : consonne → 은 / 이 / 을, voyelle → 는 / 가 / 를. Le choix entre 은/는 et 이/가 dépend de ce que tu veux dire, pas du mot."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저___ 학생이에요.', 'Moi, je suis étudiant(e). (thème)', '는', '["는","가","를","에"]'::jsonb, '저 finit par une voyelle et on pose le thème : 저는.', 1, ARRAY['topic_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '책___ 읽어요.', 'Je lis un livre. (COD)', '을', '["을","를","이","가"]'::jsonb, '책 finit par une consonne (ㄱ) → 을.', 1, ARRAY['object_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '친구___ 왔어요.', 'Un ami est arrivé. (information nouvelle)', '가', '["가","이","을","를"]'::jsonb, '친구 finit par une voyelle → 가.', 1, ARRAY['subject_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '물___ 마셔요.', 'Je bois de l''eau.', '을', '["을","를","이","는"]'::jsonb, '물 finit par ㄹ, une consonne → 을.', 1, ARRAY['object_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이것___ 뭐예요?', 'Qu''est-ce que c''est ?', '은', '["은","는","을","를"]'::jsonb, '이것 finit par ㅅ, une consonne → 은 (thème).', 1, ARRAY['topic_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle particule marque le thème ("quant à moi…") ?', '은/는', '["은/는","이/가","을/를","에"]'::jsonb, '은/는 pose le thème ; 이/가 marque le sujet ; 을/를 l''objet.', 1, ARRAY['topic_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Je bois du café.', '저는 커피를 마셔요', '["저는","커피를","마셔요"]'::jsonb, 'Ordre coréen : thème → objet → verbe (le verbe est toujours à la fin).', 1, ARRAY['object_particle', 'particles', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je suis professeur.', '저는 선생님이에요 | 선생님이에요', NULL, '저(moi) + 는 + 선생님(professeur) + 이에요(être, poli).', 2, ARRAY['topic_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '조사 연습', 'Entraînement : particules', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '학교___ 멀어요.', 'L''école est loin.', '가', '["가","이","을","를"]'::jsonb, '학교 finit par une voyelle → 가.', 1, ARRAY['subject_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '영화___ 봐요.', 'Je regarde un film.', '를', '["를","을","가","이"]'::jsonb, '영화 finit par une voyelle → 를.', 1, ARRAY['object_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '선생님___ 한국 사람이에요.', 'Le professeur, il est coréen. (thème)', '은', '["은","는","를","을"]'::jsonb, '선생님 finit par ㅁ, une consonne → 은.', 1, ARRAY['topic_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '우리___ 영화를 봐요.', 'Nous, on regarde un film.', '는', '["는","를","에서","로"]'::jsonb, '"우리를" est une erreur fréquente : 를 marque l''objet (영화를). Pour dire "nous" en thème, on met 는 : 우리는.', 2, ARRAY['topic_particle', 'object_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '비___ 와요.', 'Il pleut.', '가', '["가","이","를","을"]'::jsonb, '비 finit par une voyelle → 가.', 1, ARRAY['subject_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Forme polie de "moi" + particule de sujet :', '제가', '["제가","저가","내가","저이"]'::jsonb, 'Avec 이/가, 저 devient 제 : 제가. (저가 n''existe pas.)', 1, ARRAY['subject_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Mon ami aime la cuisine coréenne.', '친구가 한국 음식을 좋아해요 | 한국 음식을 친구가 좋아해요', '["친구가","한국","음식을","좋아해요"]'::jsonb, 'Sujet (이/가) → objet (을/를) → verbe.', 2, ARRAY['subject_particle', 'object_particle', 'particles', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 한국어를 공부해요.', NULL, 'J''étudie le coréen | J''apprends le coréen | Moi, j''étudie le coréen', NULL, '한국어(coréen) + 를 + 공부해요(étudier).', 2, ARRAY['object_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je bois de l''eau.', '저는 물을 마셔요 | 물을 마셔요', NULL, '물 finit par une consonne → 을.', 2, ARRAY['object_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis ce que tu regardes ou ce que tu bois, en une phrase.', 'La particule d''objet 을/를', NULL, 'Exemple : 저는 영화를 봐요.', 3, ARRAY['object_particle', 'particles', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;

-- ---------- Étage 1 · Unité 2 : Particules de lieu : 에, 에서, 으로 ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 2, '장소 조사', 'Particules de lieu : 에, 에서, 으로', 'grammar', 'Le point faible n°1 : 에 vs 에서' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '에 vs 에서', '에 ou 에서 : une petite liste', 'teach', '{"intro":"Oublie « action » et « état ». Pour 에 ou 에서, il suffit de connaître une toute petite liste de verbes, et de l''avoir dite à voix haute assez souvent pour qu''elle sonne juste.","sections":[{"title":"La liste des verbes en 에 : cinq verbes","body":"가다 (aller), 오다 (venir), 도착하다 (arriver), 있다 (être là, il y a), 없다 (ne pas être là). Si ton verbe est dans cette liste, le lieu prend 에. Apprends-les comme des mots, pas comme une règle.","examples":[{"ko":"학교에 가요.","rom":"hak-gyo-e ga-yo","fr":"Je vais à l''école."},{"ko":"집에 와요.","rom":"ji-be wa-yo","fr":"Je rentre à la maison."},{"ko":"공항에 도착해요.","rom":"gong-hang-e do-cha-kae-yo","fr":"J''arrive à l''aéroport."},{"ko":"집에 있어요.","rom":"ji-be i-sseo-yo","fr":"Je suis à la maison."},{"ko":"방에 없어요.","rom":"bang-e eop-sseo-yo","fr":"Il n''est pas dans la chambre."}]},{"title":"Tous les autres verbes : 에서","body":"Manger, boire, étudier, travailler, voir quelqu''un, acheter… Si le verbe n''est pas dans la liste, le lieu prend 에서. Pas besoin de réfléchir : liste → 에, sinon → 에서.","examples":[{"ko":"카페에서 커피를 마셔요.","rom":"ka-pe-e-seo keo-pi-reul ma-syeo-yo","fr":"Je bois un café au café."},{"ko":"도서관에서 공부해요.","rom":"do-seo-gwa-ne-seo gong-bu-hae-yo","fr":"J''étudie à la bibliothèque."},{"ko":"사무실에서 일해요.","rom":"sa-mu-si-re-seo il-hae-yo","fr":"Je travaille au bureau."},{"ko":"식당에서 친구를 만나요.","rom":"sik-dang-e-seo chin-gu-reul man-na-yo","fr":"Je retrouve un ami au restaurant."}]},{"title":"Écoute, puis dis-le à voix haute","body":"Touche 🔊 sur chaque phrase ci-dessus et répète-la trois fois à voix haute. Le but n''est pas de comprendre pourquoi, mais que 집에 있어요 et 집에서 먹어요 deviennent des blocs que ta bouche connaît. Les exercices te feront écouter deux versions, et tu choisiras celle qui sonne juste.","examples":[]},{"title":"으로/로 — direction ou moyen","body":"Direction (\"vers\") ou moyen (\"en bus\", \"avec la main\"). Après une voyelle ou ㄹ : 로. Après une autre consonne : 으로.","examples":[{"ko":"버스로 가요.","rom":"beo-seu-ro ga-yo","fr":"J''y vais en bus."},{"ko":"손으로 먹어요.","rom":"so-neu-ro meo-geo-yo","fr":"Je mange avec les mains."}]}],"tip":"Deux détails pour plus tard : 에서 veut aussi dire « de, depuis » (프랑스에서 왔어요 : je viens de France), et 살다 (habiter) accepte les deux, 서울에 살아요 étant le plus courant. Quelques verbes de placement (앉다, 놓다, 넣다) prennent aussi 에 : tu les verras en temps voulu."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'sounds_right', NULL, 'Écoute les phrases : laquelle sonne juste ?', '학교에 가요', '["학교에 가요","학교에서 가요"]'::jsonb, '가다 est dans la liste des verbes en 에 : 학교에 가요.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'sounds_right', NULL, 'Écoute les phrases : laquelle sonne juste ?', '집에서 공부해요', '["집에서 공부해요","집에 공부해요"]'::jsonb, '공부하다 n''est pas dans la liste → 에서 : 집에서 공부해요.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '집___ 있어요.', 'Je suis à la maison.', '에', '["에","에서","으로","를"]'::jsonb, '있다 est dans la liste des verbes en 에.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '카페___ 커피를 마셔요.', 'Je bois un café dans un café.', '에서', '["에","에서","으로","가"]'::jsonb, '마시다 n''est pas dans la liste → 에서.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Lequel de ces verbes est dans la liste des verbes en 에 ?', '도착하다 (arriver)', '["도착하다 (arriver)","먹다 (manger)","일하다 (travailler)","마시다 (boire)"]'::jsonb, 'La liste : 가다, 오다, 도착하다, 있다, 없다.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '도서관에서 공부해요', 'Écoute et choisis la phrase entendue', '도서관에서 공부해요', '["도서관에서 공부해요","도서관에 가요","도서관에서 일해요","도서관에 있어요"]'::jsonb, '공부해요 n''est pas dans la liste → 에서. Écoute bien le verbe.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je vais à la bibliothèque.', '도서관에 가요 | 저는 도서관에 가요', NULL, '가다 est dans la liste → 에.', 2, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je travaille au café.', '카페에서 일해요 | 저는 카페에서 일해요', NULL, '일하다 n''est pas dans la liste → 에서.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '장소 조사 연습', 'Entraînement : 에 / 에서 / 으로', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '친구가 서울___ 있어요.', 'Mon ami est à Séoul.', '에', '["에","에서","를","로"]'::jsonb, '있다 est dans la liste des verbes en 에.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '도서관___ 가요.', 'Je vais à la bibliothèque.', '에', '["에","에서","를","가"]'::jsonb, '가다 est dans la liste des verbes en 에 : jamais 에서. 도서관에 가요.', 2, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '식당___ 점심을 먹어요.', 'Je déjeune au restaurant.', '에서', '["에서","에","로","를"]'::jsonb, '먹다 n''est pas dans la liste des verbes en 에 → 에서.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '우리는 공원___ 운동해요.', 'Nous faisons du sport au parc.', '에서', '["에서","에","으로","가"]'::jsonb, '운동하다 n''est pas dans la liste des verbes en 에 → 에서.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 프랑스___ 왔어요.', 'Je viens de France. (origine)', '에서', '["에서","에","로","를"]'::jsonb, 'Origine ("de") → 에서.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '버스___ 가요.', 'J''y vais en bus.', '로', '["로","으로","에","에서"]'::jsonb, '버스 finit par une voyelle → 로 (moyen de transport).', 1, ARRAY['direction', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지하철___ 가요.', 'J''y vais en métro.', '로', '["로","으로","에서","에"]'::jsonb, '지하철 finit par ㄹ → 로 (comme après une voyelle).', 3, ARRAY['direction', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '손___ 먹어요.', 'Je mange avec les mains.', '으로', '["으로","로","에","에서"]'::jsonb, '손 finit par ㄴ (consonne ≠ ㄹ) → 으로.', 3, ARRAY['direction', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'sounds_right', NULL, 'Écoute les phrases : laquelle sonne juste ?', '식당에서 점심을 먹어요', '["식당에서 점심을 먹어요","식당에 점심을 먹어요"]'::jsonb, '먹다 n''est pas dans la liste → 에서.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'sounds_right', NULL, 'Écoute les phrases : laquelle sonne juste ?', '친구가 서울에 있어요', '["친구가 서울에 있어요","친구가 서울에서 있어요"]'::jsonb, '있다 est dans la liste des verbes en 에.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'sounds_right', NULL, 'Écoute les phrases : laquelle sonne juste ?', '공원에서 운동해요', '["공원에서 운동해요","공원에 운동해요"]'::jsonb, '운동하다 n''est pas dans la liste → 에서.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '학교에 가요', 'Écoute et choisis la phrase entendue', '학교에 가요', '["학교에 가요","학교에서 가요","학교를 가요","학교가 가요"]'::jsonb, '가다 est dans la liste des verbes en 에.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'J''étudie à la bibliothèque.', '저는 도서관에서 공부해요', '["저는","도서관에서","공부해요"]'::jsonb, 'Lieu de l''action (에서) juste avant le verbe.', 2, ARRAY['e_vs_eseo', 'particles', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je mange au restaurant.', '식당에서 먹어요 | 저는 식당에서 먹어요', NULL, '먹다 n''est pas dans la liste des verbes en 에 → 에서.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;

-- ---------- Étage 1 · Unité 3 : Le temps et les connecteurs ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 3, '시간 표현', 'Le temps et les connecteurs', 'grammar', '때, 전에, 후에, 동안' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '때 · 전에 · 후에 · 동안', 'Quand, avant, après, pendant', 'teach', '{"intro":"Les connecteurs temporels, ton deuxième point faible. Quatre mots à retenir, et un piège avec 에.","sections":[{"title":"때 — quand / à l''époque où","body":"Après un nom : 방학 때. Après un verbe : radical + (으)ㄹ 때, ou au passé radical + 았/었을 때.","examples":[{"ko":"방학 때 한국에 갈 거예요.","rom":"bang-hak ttae han-gu-ge gal geo-ye-yo","fr":"Pendant les vacances, j''irai en Corée."},{"ko":"어렸을 때 서울에 살았어요.","rom":"eo-ryeo-sseul ttae seo-u-re sa-ra-sseo-yo","fr":"Quand j''étais petit, j''habitais à Séoul."}]},{"title":"전에 / 후에 — avant / après","body":"Nom + 전에 / 후에. Avec un verbe : radical + 기 전에 (avant de…) et radical + (으)ㄴ 후에 (après avoir…).","examples":[{"ko":"자기 전에 책을 읽어요.","rom":"ja-gi jeo-ne chae-geul il-geo-yo","fr":"Avant de dormir, je lis un livre."},{"ko":"식사 후에 커피를 마셔요.","rom":"sik-sa hu-e keo-pi-reul ma-syeo-yo","fr":"Après le repas, je bois un café."}]},{"title":"동안 — pendant (une durée)","body":"Nom de durée + 동안, ou radical + 는 동안 pour \"pendant que\".","examples":[{"ko":"한 시간 동안 기다렸어요.","rom":"han si-gan dong-an gi-da-ryeo-sseo-yo","fr":"J''ai attendu pendant une heure."}]},{"title":"Le piège : 에 avec le temps","body":"On met 에 avec une heure ou un jour précis (3시에, 월요일에, 주말에). Mais PAS avec 어제, 오늘, 내일, 지금.","examples":[{"ko":"3시에 도착해요.","rom":"se-si-e do-cha-kae-yo","fr":"J''arrive à 3 heures."},{"ko":"내일 만나요.","rom":"nae-il man-na-yo","fr":"On se voit demain."}]}],"tip":"Retiens la série : 전 = avant, 후 = après, 동안 = durée, 때 = moment. Et pas de 에 après 어제 / 오늘 / 내일 / 지금."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '밥을 먹기 ___ 손을 씻어요.', 'Je me lave les mains avant de manger.', '전에', '["전에","후에","동안","때"]'::jsonb, '"Avant de" = radical + 기 전에.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '수업 ___ 커피를 마셔요.', 'Je bois un café après le cours.', '후에', '["후에","전에","동안","에서"]'::jsonb, '"Après" = 후에.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '방학 ___ 한국에 갈 거예요.', 'Pendant les vacances, j''irai en Corée.', '때', '["때","전에","후에","으로"]'::jsonb, '방학 때 = au moment des vacances.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 3시___ 도착해요.', 'J''arrive à 3 heures.', '에', '["에","에서","를","은"]'::jsonb, 'Heure précise → 에.', 1, ARRAY['time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quel mot signifie "pendant" (une durée) ?', '동안', '["동안","전에","후에","때"]'::jsonb, '동안 exprime la durée : 한 시간 동안 = pendant une heure.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Avec lequel de ces mots n''utilise-t-on PAS la particule 에 ?', '내일', '["내일","3시","월요일","주말"]'::jsonb, 'Pas de 에 avec 어제, 오늘, 내일, 지금.', 3, ARRAY['time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Avant de dormir, je lis un livre.', '자기 전에 책을 읽어요 | 저는 자기 전에 책을 읽어요', NULL, '자다 → 자기 전에 (radical + 기 전에).', 3, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Après le repas, je bois un café.', '식사 후에 커피를 마셔요', '["식사","후에","커피를","마셔요"]'::jsonb, 'Nom + 후에 en tête de phrase, verbe à la fin.', 2, ARRAY['temporal', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '시간 표현 연습', 'Entraînement : le temps', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국에 가기 ___ 한국어를 공부했어요.', 'J''ai étudié le coréen avant d''aller en Corée.', '전에', '["전에","후에","동안","때"]'::jsonb, 'Radical + 기 전에 = avant de.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '일이 끝난 ___ 운동해요.', 'Je fais du sport après le travail.', '후에', '["후에","전에","동안","때"]'::jsonb, '끝나다 → 끝난 후에 (après avoir fini).', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '1시간 ___ 기다렸어요.', 'J''ai attendu pendant une heure.', '동안', '["동안","전에","후에","때"]'::jsonb, 'Durée → 동안.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어렸을 ___ 서울에 살았어요.', 'Quand j''étais petit, j''habitais à Séoul.', '때', '["때","전에","후에","동안"]'::jsonb, '어렸을 때 = quand j''étais petit.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '주말___ 뭐 해요?', 'Que fais-tu le week-end ?', '에', '["에","에서","을","가"]'::jsonb, 'Un moment précis (주말) prend 에.', 1, ARRAY['time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ? (aujourd''hui, on se voit)', '오늘 만나요', '["오늘 만나요","오늘에 만나요","오늘에서 만나요","오늘으로 만나요"]'::jsonb, 'Pas de 에 après 오늘.', 3, ARRAY['time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '식사 후에 커피를 마셔요', 'Écoute et choisis la phrase entendue', '식사 후에 커피를 마셔요', '["식사 후에 커피를 마셔요","식사 전에 커피를 마셔요","식사 동안 커피를 마셔요","식사 때 커피를 마셔요"]'::jsonb, '후에 = après. Écoute bien la différence avec 전에 !', 2, ARRAY['temporal', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 수업 후에 도서관에 가요.', NULL, 'Après le cours, je vais à la bibliothèque | Je vais à la bibliothèque après le cours | Après le cours je vais à la bibliothèque | Après les cours, je vais à la bibliothèque | Je vais à la bibliothèque après les cours | Après les cours je vais à la bibliothèque', NULL, '수업 후에 = après le cours ; 도서관에 가요 = je vais à la bibliothèque.', 3, ARRAY['temporal', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Pendant les vacances, je voyage.', '방학 때 여행해요 | 방학 동안 여행해요 | 저는 방학 때 여행해요 | 저는 방학 동안 여행해요 | 방학에 여행해요 | 저는 방학에 여행해요', NULL, '방학 때 (au moment des vacances) ou 방학 동안 (durant les vacances).', 3, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Avant de dormir, je prends une douche.', '저는 자기 전에 샤워해요', '["저는","자기","전에","샤워해요"]'::jsonb, 'Radical + 기 전에 se place avant le verbe principal.', 2, ARRAY['temporal', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;

-- ---------- Étage 1 · Unité 4 : Nombres sino-coréens ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 4, '한자어 숫자', 'Nombres sino-coréens', 'vocabulary', '일, 이, 삼… et leurs compteurs' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '일, 이, 삼', 'Le système sino-coréen', 'teach', '{"intro":"Deux systèmes de nombres, deux usages. Aujourd''hui : le système sino-coréen, celui de l''argent, des dates et des minutes.","sections":[{"title":"Les nombres","body":"1 일 · 2 이 · 3 삼 · 4 사 · 5 오 · 6 육 · 7 칠 · 8 팔 · 9 구 · 10 십 · 100 백 · 1 000 천 · 10 000 만. On les assemble comme en maths : 15 = 십오, 2 000 = 이천.","examples":[{"ko":"삼천 원","rom":"sam-cheon won","fr":"3 000 wons"},{"ko":"이십 분","rom":"i-sip bun","fr":"20 minutes"},{"ko":"이천이십육 년","rom":"i-cheo-ni-sim-nyung nyeon","fr":"l''année 2026"}]},{"title":"Quand les utiliser ?","body":"Argent (원), minutes (분), dates (년, 월, 일), étages (층), numéros (번), téléphone. Pour 10 000, on dit 만 (pas 일만) : 만 원.","examples":[{"ko":"오월 십오일","rom":"o-wol si-bo-il","fr":"le 15 mai"},{"ko":"오 층","rom":"o cheung","fr":"5e étage"}]},{"title":"Deux exceptions de mois","body":"6月 se dit 유월 (pas 육월) et 10月 se dit 시월 (pas 십월).","examples":[{"ko":"유월","rom":"yu-wol","fr":"juin"}]}],"tip":"Moyen mnémotechnique : l''argent, le calendrier et les numéros = sino. Les heures, l''âge et le comptage d''objets = natifs (unité suivante)."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on 5 en sino-coréen ?', '오', '["오","다섯","사","육"]'::jsonb, '5 = 오 (sino) ; 다섯 est la version native.', 1, ARRAY['numbers_sino']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 3 000원 ?', '삼천 원', '["삼천 원","세천 원","삼십 원","셋천 원"]'::jsonb, '3 = 삼 et 1 000 = 천 → 삼천.', 1, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Pour les minutes (분), quel système de nombres utilise-t-on ?', 'Sino-coréen', '["Sino-coréen","Coréen natif","Les deux au choix","Aucun"]'::jsonb, 'Minutes = sino (십 분). Heures = natif (열 시).', 1, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 10분 ?', '십 분', '["십 분","열 분","십 시","열 시"]'::jsonb, '10 minutes = 십 분 (sino + 분).', 1, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 6월 (juin) ?', '유월', '["유월","육월","여섯월","륙월"]'::jsonb, 'Exception : 6月 = 유월, 10月 = 시월.', 3, ARRAY['numbers_sino']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quel nombre signifie 100 ?', '백', '["백","십","천","만"]'::jsonb, '백 = 100 ; 천 = 1 000 ; 만 = 10 000.', 1, ARRAY['numbers_sino']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Dix mille wons.', '만 원', NULL, 'On dit simplement 만 원 (pas 일만 원).', 3, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Le 15 mai.', '오월 십오일 | 오월 십오 일 | 5월 15일', NULL, '5月 = 오월 ; 15日 = 십오일.', 3, ARRAY['numbers_sino']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '한자어 숫자 연습', 'Entraînement : nombres sino-coréens', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 1 500원 ?', '천오백 원', '["천오백 원","십오백 원","백오십 원","천오십 원"]'::jsonb, '1 000 + 500 → 천 + 오백.', 1, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 2024년 ?', '이천이십사 년', '["이천이십사 년","이천이십사 월","두천스물네 년","이천사십이 년"]'::jsonb, 'Année = nombres sino + 년.', 1, ARRAY['numbers_sino']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 20분 ?', '이십 분', '["이십 분","스무 분","이 분십","열 분"]'::jsonb, 'Minutes = sino : 이십 분.', 1, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on "2번 버스" ?', '이 번 버스', '["이 번 버스","두 번 버스","둘 번 버스","이 개 버스"]'::jsonb, 'Un numéro (번호) se dit en sino : 이 번.', 3, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Trouve l''intrus (nombres sino-coréens) :', '하나', '["하나","일","이","삼"]'::jsonb, '하나 est un nombre natif, pas sino-coréen.', 1, ARRAY['numbers_sino']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '삼십 분', 'Écoute et choisis la phrase entendue', '삼십 분', '["삼십 분","십삼 분","삼 분","삼백 분"]'::jsonb, '삼십 = 30 ; 십삼 = 13 ; 삼 = 3 ; 삼백 = 300.', 2, ARRAY['numbers_sino', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je suis au 5e étage.', '저는 오 층에 있어요 | 오 층에 있어요 | 오층에 있어요 | 5층에 있어요 | 저는 5층에 있어요', NULL, '오 + 층 (étage) ; lieu d''existence → 에 있어요.', 3, ARRAY['numbers_sino', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '삼만 원이에요.', NULL, 'Ça fait 30000 wons | C''est 30000 wons | Ça fait trente mille wons | C''est trente mille wons | Ça coûte 30000 wons', NULL, '삼만 = 3 × 10 000 = 30 000.', 3, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Ce livre coûte 10 000 wons.', '이 책은 만 원이에요', '["이","책은","만","원이에요"]'::jsonb, '만 원 : pas besoin de 일.', 3, ARRAY['numbers_sino', 'topic_particle', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 4 and l.lesson_number = 2;

-- ---------- Étage 1 · Unité 5 : Nombres coréens natifs ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 5, '고유어 숫자', 'Nombres coréens natifs', 'vocabulary', '하나, 둘, 셋… et les compteurs' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '하나, 둘, 셋', 'Le système natif', 'teach', '{"intro":"Le deuxième système : celui du quotidien (heures, âge, comptage). Attention, il se transforme devant un compteur.","sections":[{"title":"Les nombres","body":"1 하나 · 2 둘 · 3 셋 · 4 넷 · 5 다섯 · 6 여섯 · 7 일곱 · 8 여덟 · 9 아홉 · 10 열 · 20 스물 · 30 서른 · 40 마흔.","examples":[{"ko":"스물다섯 살","rom":"seu-mul-da-seot sal","fr":"25 ans"}]},{"title":"Devant un compteur, 4 nombres changent","body":"하나 → 한 · 둘 → 두 · 셋 → 세 · 넷 → 네 · 스물 → 스무. On écrit : nom + nombre + compteur.","examples":[{"ko":"커피 두 잔","rom":"keo-pi du jan","fr":"deux cafés (tasses)"},{"ko":"사과 세 개","rom":"sa-gwa se gae","fr":"trois pommes"}]},{"title":"Les compteurs essentiels","body":"개 = objets · 명 (ou 사람) = personnes · 마리 = animaux · 권 = livres · 잔 = tasses · 병 = bouteilles · 살 = âge · 시 = heures.","examples":[{"ko":"학생 네 명","rom":"hak-saeng ne myeong","fr":"quatre étudiants"},{"ko":"세 시","rom":"se si","fr":"3 heures"}]}],"tip":"Heures = natif (세 시), minutes = sino (십 분) : \"세 시 십 분\" = 3 h 10. Les deux systèmes dans la même phrase, c''est tout le charme du coréen 😏 Et pour la demie, on dit souvent 반 : 두 시 반 = 2 h 30."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on 3 en coréen natif ?', '셋', '["셋","삼","넷","사"]'::jsonb, '셋 = 3 natif (devant un compteur : 세).', 1, ARRAY['numbers_native']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Devant un compteur, "un" (하나) devient :', '한', '["한","하나","일","첫"]'::jsonb, '하나 → 한 devant un compteur : 한 명, 한 잔.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '커피 ___ 잔 주세요.', 'Deux cafés, s''il vous plaît.', '두', '["두","둘","이","둘이"]'::jsonb, '둘 → 두 devant un compteur.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quel compteur pour les personnes ?', '명', '["명","개","마리","권"]'::jsonb, '명 (ou 사람) pour les personnes.', 1, ARRAY['counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quel compteur pour les livres ?', '권', '["권","개","병","명"]'::jsonb, '권 pour les livres, cahiers, magazines.', 1, ARRAY['counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 3시 (3 heures) ?', '세 시', '["세 시","삼 시","셋 시","사 시"]'::jsonb, 'Heures = natif : 셋 → 세 devant 시.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Deux personnes.', '두 명 | 두 사람', NULL, '둘 → 두 + 명.', 2, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Trois cafés, s''il vous plaît.', '커피 세 잔 주세요', NULL, '커피 + 세 + 잔 + 주세요 (s''il vous plaît, donnez-moi).', 3, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '고유어 숫자 연습', 'Entraînement : nombres natifs', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 ___ 살이에요. (25 ans)', 'J''ai 25 ans.', '스물다섯', '["스물다섯","이십오","스무다섯","이십다섯"]'::jsonb, 'L''âge (살) se dit en natif : 스물다섯 살.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '물 ___ 병 주세요.', 'Une bouteille d''eau, s''il vous plaît.', '한', '["한","하나","일","첫"]'::jsonb, '하나 → 한 devant 병.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '고양이 ___ 마리가 있어요.', 'J''ai quatre chats.', '네', '["네","넷","사","너"]'::jsonb, '넷 → 네 devant 마리.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '사과가 ___ 개 있어요.', 'Il y a trois pommes.', '세', '["세","셋","삼","사"]'::jsonb, '셋 → 세 devant 개.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quel système utilise-t-on pour l''âge (살) ?', 'Coréen natif', '["Coréen natif","Sino-coréen","Les deux au choix","Aucun"]'::jsonb, 'Âge = natif (스물다섯 살).', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 2시 30분 ?', '두 시 삼십 분', '["두 시 삼십 분","이 시 삼십 분","두 시 서른 분","이 시 서른 분"]'::jsonb, 'Heures = natif (두 시), minutes = sino (삼십 분).', 3, ARRAY['numbers_native', 'numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '커피 두 잔 주세요', 'Écoute et choisis la phrase entendue', '커피 두 잔 주세요', '["커피 두 잔 주세요","커피 세 잔 주세요","커피 한 잔 주세요","커피 네 잔 주세요"]'::jsonb, '두 = deux. Écoute bien 두 / 세 / 한 / 네.', 2, ARRAY['numbers_native', 'counters', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 책 두 권을 샀어요.', NULL, 'J''ai acheté deux livres | J''ai acheté 2 livres | Moi, j''ai acheté deux livres', NULL, '책 두 권 = deux livres ; 샀어요 = j''ai acheté.', 2, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ? (trois pommes)', '사과 세 개', '["사과 세 개","세 사과 개","세 개 사과","사과 개 세"]'::jsonb, 'Ordre : nom + nombre + compteur (사과 + 세 + 개).', 2, ARRAY['counters', 'numbers_native']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ? (deux cafés)', '커피 두 잔', '["커피 두 잔","두 커피 잔","두 잔 커피","잔 두 커피"]'::jsonb, 'Même ordre : nom + nombre + compteur ; et 둘 devient 두 devant le compteur.', 2, ARRAY['counters', 'numbers_native']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'J''ai mangé trois pommes.', '저는 사과 세 개를 먹었어요', '["저는","사과","세","개를","먹었어요"]'::jsonb, 'Nom + nombre + compteur + particule + verbe.', 3, ARRAY['numbers_native', 'counters', 'object_particle', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 2;

-- ---------- Étage 1 · Unité 6 : Boss : évaluation mixte ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 6, '종합 평가', 'Boss : évaluation mixte', 'grammar', 'Tout l''étage 1 en un seul combat' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '1층 보스', 'Boss de l''étage 1', 'boss', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 6
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 회사___ 일해요.', 'Je travaille au bureau.', '에서', '["에서","에","로","를"]'::jsonb, '일하다 n''est pas dans la liste des verbes en 에 → 에서.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일 부산___ 가요.', 'Demain, je vais à Busan.', '에', '["에","에서","로","를"]'::jsonb, '가다 + destination → 에.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저___ 프랑스 사람이에요.', 'Moi, je suis français(e).', '는', '["는","가","를","에"]'::jsonb, 'Thème "quant à moi" → 저는.', 2, ARRAY['topic_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 커피___ 마셔요.', 'Je bois du café.', '를', '["를","을","가","이"]'::jsonb, '커피 finit par une voyelle → 를.', 2, ARRAY['object_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '자기 ___ 샤워해요.', 'Je prends une douche avant de dormir.', '전에', '["전에","후에","동안","때"]'::jsonb, '"Avant de" = 기 전에.', 3, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '택시___ 가요.', 'J''y vais en taxi.', '로', '["로","으로","에","에서"]'::jsonb, '택시 finit par une voyelle → 로.', 3, ARRAY['direction', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment lit-on 10분 ?', '십 분', '["십 분","열 분","십 시","열 시"]'::jsonb, 'Minutes = sino.', 2, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '저는 식당에서 밥을 먹어요', 'Écoute et choisis la phrase entendue', '저는 식당에서 밥을 먹어요', '["저는 식당에서 밥을 먹어요","저는 식당에 밥을 먹어요","저는 식당에서 밥이 먹어요","저는 식당에서 밥을 마셔요"]'::jsonb, '먹다 n''est pas dans la liste des verbes en 에 → 에서.', 3, ARRAY['e_vs_eseo', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Je lis un livre à la bibliothèque.', '저는 도서관에서 책을 읽어요', '["저는","도서관에서","책을","읽어요"]'::jsonb, 'Thème → lieu de l''action → objet → verbe.', 3, ARRAY['e_vs_eseo', 'object_particle', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 학교에서 한국어를 공부해요.', NULL, 'J''étudie le coréen à l''école | J''apprends le coréen à l''école | Moi, j''étudie le coréen à l''école', NULL, '학교에서 = à l''école (action) ; 한국어를 = le coréen (COD).', 3, ARRAY['e_vs_eseo', 'object_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Trois mille wons.', '삼천 원', NULL, 'Argent = sino : 삼천 원.', 3, ARRAY['numbers_sino', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Quatre personnes.', '네 명 | 네 사람', NULL, '넷 → 네 devant 명.', 3, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je prends le petit-déjeuner à 7 heures.', '일곱 시에 아침을 먹어요 | 저는 일곱 시에 아침을 먹어요 | 7시에 아침을 먹어요 | 저는 7시에 아침을 먹어요', NULL, 'Heures = natif (일곱 시) + 에 (heure précise).', 4, ARRAY['numbers_native', 'time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;

-- ################ Étage 2 : Conversations du quotidien ################
insert into floors (floor_number, title_ko, title_fr, cefr_level, description, unlock_xp)
values (2, '일상 대화', 'Conversations du quotidien', 'A2+', 'Se présenter, faire ses courses, demander son chemin, parler de demain et d''hier.', 0)
on conflict (floor_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr,
  cefr_level = excluded.cefr_level, description = excluded.description;

-- ---------- Étage 2 · Unité 1 : Se présenter et décrire ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 1, '자기소개', 'Se présenter et décrire', 'grammar', '이에요/예요 et les adjectifs en -아요/어요' from floors where floor_number = 2
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '이에요 / 예요 · 형용사', 'Être, et décrire avec les adjectifs', 'teach', '{"intro":"Deux outils pour parler de toi et de ce qui t''entoure : le verbe « être » et les adjectifs. Rien de nouveau dans la logique : voyelle ou consonne, et c''est réglé.","sections":[{"title":"이에요 / 예요 — « être » (poli)","body":"Après un nom qui finit par une consonne : 이에요. Après une voyelle : 예요. C''est la même logique que 은/는.","examples":[{"ko":"저는 프랑스 사람이에요.","rom":"jeo-neun peu-rang-seu sa-ra-mi-e-yo","fr":"Je suis français(e)."},{"ko":"제 이름은 조던이에요.","rom":"je i-reu-meun jo-deo-ni-e-yo","fr":"Mon nom est Jordan."},{"ko":"저는 의사예요.","rom":"jeo-neun ui-sa-ye-yo","fr":"Je suis médecin."}]},{"title":"Les adjectifs : radical + 아요 / 어요","body":"En coréen, l''adjectif se conjugue comme un verbe. Dernière voyelle du radical ㅏ ou ㅗ → 아요 ; sinon → 어요 ; les adjectifs en 하다 → 해요. Si le radical finit par ㅡ, il tombe. Radical d''une syllabe → 어요 (크다 → 커요). Plusieurs syllabes → on regarde la voyelle de la syllabe d''avant : ㅏ/ㅗ → 아요 (바쁘다 → 바빠요), sinon → 어요 (예쁘다 → 예뻐요).","examples":[{"ko":"날씨가 좋아요.","rom":"nal-ssi-ga jo-a-yo","fr":"Il fait beau."},{"ko":"방이 커요.","rom":"bang-i keo-yo","fr":"La chambre est grande."},{"ko":"저는 바빠요.","rom":"jeo-neun ba-ppa-yo","fr":"Je suis occupé(e)."},{"ko":"이 음식은 맛있어요.","rom":"i eum-si-geun ma-si-sseo-yo","fr":"Ce plat est délicieux."},{"ko":"오늘은 피곤해요.","rom":"o-neu-reun pi-gon-hae-yo","fr":"Aujourd''hui, je suis fatigué(e)."}]}],"tip":"Pas de verbe « être » devant un adjectif : on dit « La chambre grande-est » → 방이 커요, jamais 방이 이에요 커요."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 학생___.', 'Je suis étudiant(e).', '이에요', '["이에요","예요","이요","에요"]'::jsonb, '학생 finit par une consonne (ㅇ) → 이에요.', 1, ARRAY['copula', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 의사___.', 'Je suis médecin.', '예요', '["예요","이에요","이요","에요"]'::jsonb, '의사 finit par une voyelle → 예요.', 1, ARRAY['copula', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '제 이름은 조던___.', 'Mon nom est Jordan.', '이에요', '["이에요","예요","이요","에요"]'::jsonb, '조던 finit par ㄴ, une consonne → 이에요.', 1, ARRAY['copula', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Après un nom qui finit par une voyelle, « être » (poli) se dit :', '예요', '["예요","이에요","아요","어요"]'::jsonb, '예요 après une voyelle, 이에요 après une consonne. 아요/어요 servent aux verbes et adjectifs.', 1, ARRAY['copula']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '날씨가 ___.', 'Il fait beau.', '좋아요', '["좋아요","좋어요","좋해요","좋요"]'::jsonb, '좋다 : dernière voyelle ㅗ → 아요 : 좋아요.', 1, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '방이 ___.', 'La chambre est grande.', '커요', '["커요","크어요","큰요","크아요"]'::jsonb, '크다 : le ㅡ tombe → 커요.', 2, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je suis français(e).', '저는 프랑스 사람이에요 | 프랑스 사람이에요', NULL, '사람 finit par une consonne (ㅁ) → 이에요.', 2, ARRAY['copula']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Ma chambre est grande.', '제 방이 커요', '["제","방이","커요"]'::jsonb, 'Possesseur → sujet → adjectif à la fin.', 2, ARRAY['adjectives', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '자기소개 연습', 'Entraînement : être et adjectifs', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 음식은 ___.', 'Ce plat est délicieux.', '맛있어요', '["맛있어요","맛있아요","맛있해요","맛있요"]'::jsonb, '맛있다 : dernière voyelle ㅣ → 어요.', 1, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 오늘 ___.', 'Aujourd''hui, je suis occupé(e).', '바빠요', '["바빠요","바쁘어요","바빠어요","바쁘요"]'::jsonb, '바쁘다 : ㅡ tombe, la voyelle précédente est ㅏ → 아요 : 바빠요.', 3, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 옷은 ___.', 'Ce vêtement est joli.', '예뻐요', '["예뻐요","예쁘어요","예뻐어요","예쁘요"]'::jsonb, '예쁘다 : ㅡ tombe, la voyelle précédente est ㅖ → 어요 : 예뻐요.', 3, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '오늘은 정말 ___.', 'Aujourd''hui, je suis vraiment fatigué(e).', '피곤해요', '["피곤해요","피곤아요","피곤어요","피곤요"]'::jsonb, '피곤하다 : les adjectifs en 하다 font 해요.', 1, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle est la forme polie de 작다 (petit) ?', '작아요', '["작아요","작어요","작해요","작요"]'::jsonb, '작다 : dernière voyelle ㅏ → 아요.', 1, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle est la forme polie de 많다 (être nombreux, il y a beaucoup) ?', '많아요', '["많아요","많어요","많해요","만아요"]'::jsonb, '많다 : dernière voyelle ㅏ → 아요.', 1, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '저는 의사예요', 'Écoute et choisis la phrase entendue', '저는 의사예요', '["저는 의사예요","저는 학생이에요","저는 의사가 아니에요","저는 의사이에요"]'::jsonb, '의사 + 예요 (voyelle).', 2, ARRAY['copula', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '날씨가 좋아요.', NULL, 'Il fait beau | Le temps est bon | La météo est bonne | Il fait bon', NULL, '좋아요 : « c''est bien / agréable ».', 2, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Mon nom est Jordan.', '제 이름은 조던이에요 | 이름은 조던이에요', NULL, '조던 + 이에요 (consonne finale ㄴ).', 2, ARRAY['copula']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Présente-toi en une ou deux phrases : ton nom et ta nationalité.', '이에요 / 예요 avec un nom (nom, nationalité)', NULL, 'Exemple : 저는 조던이에요. 저는 프랑스 사람이에요.', 3, ARRAY['copula', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 1 and l.lesson_number = 2;

-- ---------- Étage 2 · Unité 2 : Acheter et commander ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 2, '쇼핑과 주문', 'Acheter et commander', 'vocabulary', '주세요, les compteurs et les prix' from floors where floor_number = 2
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '주세요', '« S''il vous plaît » : demander quelque chose', 'teach', '{"intro":"Au marché, au café, au restaurant : une seule structure te suffit pour presque tout demander. Et elle réutilise ce que tu sais déjà sur les compteurs.","sections":[{"title":"N + 주세요 — « donnez-moi… »","body":"On dit l''objet puis 주세요, en général sans particule (커피를 주세요 se dit aussi). Pour la quantité : nom + nombre natif + compteur + 주세요. L''ordre est toujours nom → nombre → compteur.","examples":[{"ko":"커피 한 잔 주세요.","rom":"keo-pi han jan ju-se-yo","fr":"Un café, s''il vous plaît."},{"ko":"물 한 병 주세요.","rom":"mul han byeong ju-se-yo","fr":"Une bouteille d''eau, s''il vous plaît."},{"ko":"사과 세 개 주세요.","rom":"sa-gwa se gae ju-se-yo","fr":"Trois pommes, s''il vous plaît."},{"ko":"두부 한 모 주세요.","rom":"du-bu han mo ju-se-yo","fr":"Un bloc de tofu, s''il vous plaît."}]},{"title":"얼마예요 ? — le prix","body":"얼마예요 ? = « combien ça coûte ? ». La réponse utilise les nombres sino-coréens + 원, avec 이에요 / 예요.","examples":[{"ko":"이거 얼마예요?","rom":"i-geo eol-ma-ye-yo","fr":"Combien ça coûte ?"},{"ko":"삼천 원이에요.","rom":"sam-cheon wo-ni-e-yo","fr":"C''est 3 000 wons."}]}],"tip":"Compteurs utiles : 잔 (tasses, verres), 병 (bouteilles), 개 (objets), 명 (personnes), 모 (blocs de tofu). Le tofu a son propre compteur !"}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Un café, s''il vous plaît.', '커피 한 잔 주세요', NULL, '커피 + 한 (하나 devant un compteur) + 잔 + 주세요.', 2, ARRAY['requests', 'counters', 'numbers_native']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Deux bouteilles d''eau, s''il vous plaît.', '물 두 병 주세요', NULL, '물 + 두 (둘 devant un compteur) + 병 + 주세요.', 2, ARRAY['requests', 'counters', 'numbers_native']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '사과 ___ 개 주세요.', 'Une pomme, s''il vous plaît.', '한', '["한","하나","일","첫"]'::jsonb, '하나 → 한 devant le compteur 개.', 1, ARRAY['numbers_native', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quel compteur pour un bloc de tofu ?', '모', '["모","마리","권","명"]'::jsonb, '모 est le compteur des blocs de tofu : 두부 한 모.', 1, ARRAY['counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment demande-t-on le prix ?', '얼마예요?', '["얼마예요?","뭐예요?","어디예요?","누구예요?"]'::jsonb, '얼마 = combien. 뭐 = quoi, 어디 = où, 누구 = qui.', 1, ARRAY['requests']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ? (deux cafés, s''il vous plaît)', '커피 두 잔 주세요', '["커피 두 잔 주세요","두 커피 잔 주세요","커피 잔 두 주세요","주세요 커피 두 잔"]'::jsonb, 'Ordre : nom + nombre + compteur, puis 주세요.', 2, ARRAY['counters', 'requests']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Une bouteille d''eau, s''il vous plaît.', '물 한 병 주세요', '["물","한","병","주세요"]'::jsonb, 'Nom → nombre → compteur → 주세요.', 2, ARRAY['counters', 'requests', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '이거 얼마예요?', NULL, 'Combien ça coûte | Ça coûte combien | C''est combien | Combien ça fait', NULL, '이거 = ceci ; 얼마예요 = combien ça coûte.', 2, ARRAY['requests']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '쇼핑 연습', 'Entraînement : commander et payer', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '삼천 원___.', 'C''est 3 000 wons.', '이에요', '["이에요","예요","이요","에요"]'::jsonb, '원 finit par ㄴ, une consonne → 이에요.', 1, ARRAY['copula', 'numbers_sino']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '사과 세 ___ 주세요.', 'Trois pommes, s''il vous plaît.', '개', '["개","명","마리","권"]'::jsonb, '개 : compteur des objets (et des fruits).', 1, ARRAY['counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '친구가 두 ___ 있어요.', 'J''ai deux amis.', '명', '["명","개","마리","잔"]'::jsonb, '명 : compteur des personnes.', 1, ARRAY['counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Deux cafés, s''il vous plaît.', '커피 두 잔 주세요', NULL, '커피 + 두 (둘 devant un compteur) + 잔 + 주세요.', 2, ARRAY['requests', 'counters', 'numbers_native']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Un bloc de tofu, s''il vous plaît.', '두부 한 모 주세요', NULL, '두부 + 한 + 모 (compteur du tofu) + 주세요.', 2, ARRAY['requests', 'counters', 'numbers_native']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Combien coûte ceci ?', '이거 얼마예요 | 이것 얼마예요 | 이건 얼마예요', NULL, '이거 + 얼마예요.', 2, ARRAY['requests']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '물 한 병 주세요', 'Écoute et choisis la phrase entendue', '물 한 병 주세요', '["물 한 병 주세요","물 두 병 주세요","물 세 병 주세요","물 네 병 주세요"]'::jsonb, '한 = un. Écoute bien 한 / 두 / 세 / 네.', 2, ARRAY['numbers_native', 'counters', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '두부 한 모 주세요.', NULL, 'Un bloc de tofu, s''il vous plaît | Un tofu, s''il vous plaît | Donnez-moi un bloc de tofu | Je voudrais un bloc de tofu', NULL, '모 = bloc de tofu.', 2, ARRAY['requests', 'counters']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Deux pommes, s''il vous plaît.', '사과 두 개 주세요', '["사과","두","개","주세요"]'::jsonb, 'Nom → nombre → compteur → 주세요.', 2, ARRAY['counters', 'requests', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 2 and l.lesson_number = 2;

-- ---------- Étage 2 · Unité 3 : Demander son chemin et se déplacer ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 3, '길 찾기와 교통', 'Demander son chemin et se déplacer', 'grammar', '어디, 옆에, 가세요, 에서…까지' from floors where floor_number = 2
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '어디에 있어요?', 'Où est… ? Directions', 'teach', '{"intro":"Demander son chemin, c''est surtout 에 (où ça se trouve) et (으)로 (dans quelle direction / avec quoi). Tu connais déjà les deux : on les assemble.","sections":[{"title":"Où est… ? → 어디에 있어요 ?","body":"N이/가 + 어디에 있어요 ? Pour répondre : lieu + 에 + 있어요. Mots de position : 옆 (à côté), 앞 (devant), 뒤 (derrière), 위 (dessus).","examples":[{"ko":"은행이 어디에 있어요?","rom":"eun-haeng-i eo-di-e i-sseo-yo","fr":"Où est la banque ?"},{"ko":"병원은 시장 옆에 있어요.","rom":"byeong-wo-neun si-jang yeo-pe i-sseo-yo","fr":"L''hôpital est à côté du marché."}]},{"title":"Donner une direction : -(으)로 + 가세요","body":"오른쪽 (droite), 왼쪽 (gauche) + 으로 ; 똑바로 = tout droit. 가세요 est la forme polie pour dire « allez ». Avec un transport : 지하철로 (en métro), 버스로 (en bus), 택시로 (en taxi).","examples":[{"ko":"오른쪽으로 가세요.","rom":"o-reun-jjo-geu-ro ga-se-yo","fr":"Allez à droite."},{"ko":"똑바로 가세요.","rom":"ttok-ba-ro ga-se-yo","fr":"Allez tout droit."},{"ko":"지하철로 가요.","rom":"ji-ha-cheol-lo ga-yo","fr":"J''y vais en métro."}]},{"title":"De… à… : 에서 … 까지","body":"에서 donne le point de départ, 까지 l''arrivée. Pour la durée : 걸려요 (« ça prend »).","examples":[{"ko":"집에서 학교까지 걸어서 십 분 걸려요.","rom":"ji-be-seo hak-gyo-kka-ji geo-reo-seo sip bun geol-lyeo-yo","fr":"De chez moi à l''école, il faut dix minutes à pied."}]}],"tip":"Piège classique : 가다 (aller) prend 에 pour la destination, jamais 에서 : 도서관에 가요. Et on « prend » un transport avec 를/을 : 버스를 타요."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '은행은 시장 ___ 있어요.', 'La banque est à côté du marché.', '옆에', '["옆에","앞에","뒤에","위에"]'::jsonb, '옆 = à côté.', 1, ARRAY['location_words', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '화장실이 ___ 있어요?', 'Où sont les toilettes ?', '어디에', '["어디에","누구에","무엇을","어디를"]'::jsonb, '어디 = où ; lieu où l''on se trouve → 에 있어요.', 1, ARRAY['directions', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '오른쪽___ 가세요.', 'Allez à droite.', '으로', '["으로","로","를","이"]'::jsonb, '오른쪽 finit par ㄱ (consonne) → 으로.', 1, ARRAY['direction', 'directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie 오른쪽 ?', 'à droite', '["à droite","à gauche","tout droit","derrière"]'::jsonb, '오른쪽 = droite ; 왼쪽 = gauche ; 똑바로 = tout droit.', 1, ARRAY['directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie 가세요 (ici, dans une direction) ?', 'Allez', '["Allez","Il est allé","Je vais","Ne partez pas"]'::jsonb, '-(으)세요 : forme polie pour inviter / ordonner gentiment.', 1, ARRAY['directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Allez tout droit.', '똑바로 가세요 | 쭉 가세요', NULL, '똑바로 = tout droit ; 가세요 = allez (poli).', 2, ARRAY['directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Où est la banque ?', '은행이 어디에 있어요', '["은행이","어디에","있어요"]'::jsonb, 'Sujet → où → il y a / se trouve.', 2, ARRAY['directions', 'e_vs_eseo', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '오른쪽으로 가세요.', NULL, 'Allez à droite | Allez vers la droite | Tournez à droite', NULL, '오른쪽으로 = vers la droite.', 2, ARRAY['directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '길 찾기 연습', 'Entraînement : directions et transports', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '집에서 학교___ 걸어서 십 분 걸려요.', 'De chez moi à l''école, il faut dix minutes à pied.', '까지', '["까지","부터","에서","으로"]'::jsonb, '에서 … 까지 = de … à … ; 까지 marque l''arrivée.', 1, ARRAY['directions', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지하철___ 가요.', 'J''y vais en métro.', '로', '["로","으로","를","에게"]'::jsonb, '지하철 finit par ㄹ → 로 (moyen de transport).', 3, ARRAY['direction', 'directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '버스___ 타요.', 'Je prends le bus.', '를', '["를","을","로","가"]'::jsonb, '버스 finit par une voyelle → 를. On « prend » un transport : 버스를 타요.', 1, ARRAY['object_particle', 'directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ? (je prends le métro)', '지하철을 타요', '["지하철을 타요","지하철로 타요","지하철을 가요","지하철이 타요"]'::jsonb, '타다 (prendre un transport) se construit avec 을/를.', 3, ARRAY['object_particle', 'directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je vais à l''école en bus.', '버스로 학교에 가요 | 학교에 버스로 가요 | 저는 버스로 학교에 가요', NULL, '버스로 (moyen) + 학교에 가요 (destination → 에).', 3, ARRAY['direction', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Où est l''hôpital ?', '병원이 어디에 있어요 | 병원은 어디에 있어요 | 병원이 어디예요', NULL, '병원이/은 + 어디에 있어요.', 2, ARRAY['directions', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '오른쪽으로 가세요', 'Écoute et choisis la phrase entendue', '오른쪽으로 가세요', '["오른쪽으로 가세요","왼쪽으로 가세요","똑바로 가세요","오른쪽에 있어요"]'::jsonb, '오른쪽 = droite ; 왼쪽 = gauche.', 2, ARRAY['directions', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '은행은 병원 옆에 있어요.', NULL, 'La banque est à côté de l''hôpital | La banque se trouve à côté de l''hôpital', NULL, '옆에 있어요 = être à côté.', 2, ARRAY['location_words', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Je vais à la poste en taxi.', '저는 택시로 우체국에 가요 | 저는 우체국에 택시로 가요', '["저는","택시로","우체국에","가요"]'::jsonb, 'Moyen (로) et destination (에) avant le verbe.', 3, ARRAY['direction', 'e_vs_eseo', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 3 and l.lesson_number = 2;

-- ---------- Étage 2 · Unité 4 : Faire des projets : le futur ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 4, '계획', 'Faire des projets : le futur', 'grammar', '-(으)ㄹ 거예요' from floors where floor_number = 2
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-(으)ㄹ 거예요', 'Dire ce que tu feras', 'teach', '{"intro":"Pour parler de demain, de ce week-end ou de l''année prochaine, une seule forme : radical + (으)ㄹ 거예요. Là encore : voyelle ou consonne.","sections":[{"title":"La forme","body":"Radical qui finit par une voyelle (ou ㄹ) → ㄹ 거예요 : 가다 → 갈 거예요. Radical qui finit par une consonne → 을 거예요 : 먹다 → 먹을 거예요. Verbes en ㄹ (살다) : le ㄹ ne se double pas : 살 거예요. Prononciation : 거예요 se dit [꺼예요].","examples":[{"ko":"내일 친구를 만날 거예요.","rom":"nae-il chin-gu-reul man-nal geo-ye-yo","fr":"Demain, je verrai un ami."},{"ko":"저녁에 밥을 먹을 거예요.","rom":"jeo-nyeo-ge ba-beul meo-geul geo-ye-yo","fr":"Ce soir, je mangerai."},{"ko":"저는 서울에 살 거예요.","rom":"jeo-neun seo-u-re sal geo-ye-yo","fr":"J''habiterai à Séoul."}]},{"title":"Les repères de temps","body":"내일 (demain), 주말 (le week-end), 다음 주 (la semaine prochaine). Souvenir de l''étage 1 : 에 avec 주말 et 다음 주, mais pas avec 내일.","examples":[{"ko":"주말에 영화를 볼 거예요.","rom":"ju-ma-re yeong-hwa-reul bol geo-ye-yo","fr":"Ce week-end, je verrai un film."},{"ko":"다음 주에 한국에 갈 거예요.","rom":"da-eum ju-e han-gu-ge gal geo-ye-yo","fr":"La semaine prochaine, j''irai en Corée."}]}],"tip":"Pas de 에 après 내일, 오늘, 어제. Avec 주말, 다음 주, 3시 : oui."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일 학교에 ___ 거예요.', 'Demain, j''irai à l''école.', '갈', '["갈","가을","가","가서"]'::jsonb, '가다 : radical 가 (voyelle) → ㄹ 거예요 : 갈 거예요.', 1, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저녁에 밥을 ___ 거예요.', 'Ce soir, je mangerai.', '먹을', '["먹을","먹어","먹으","먹"]'::jsonb, '먹다 : radical 먹 (consonne) → 을 거예요.', 1, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Après un radical qui finit par une consonne (먹다), le futur se forme avec :', '을 거예요', '["을 거예요","ㄹ 거예요","았어요","세요"]'::jsonb, 'Consonne → 을 거예요 ; voyelle → ㄹ 거예요. 았어요 = passé.', 1, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Demain, je verrai un film.', '내일 영화를 볼 거예요 | 저는 내일 영화를 볼 거예요', NULL, '보다 → 볼 거예요 ; pas de 에 après 내일.', 2, ARRAY['future', 'time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Ce week-end, je verrai un ami.', '주말에 친구를 만날 거예요 | 이번 주말에 친구를 만날 거예요 | 저는 주말에 친구를 만날 거예요', NULL, '만나다 → 만날 거예요 ; 주말에 (avec 에).', 3, ARRAY['future', 'time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Demain, je lirai un livre.', '내일 책을 읽을 거예요', '["내일","책을","읽을","거예요"]'::jsonb, 'Temps → objet → verbe au futur.', 2, ARRAY['future', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '다음 주에 한국에 갈 거예요.', NULL, 'La semaine prochaine, j''irai en Corée | J''irai en Corée la semaine prochaine', NULL, '다음 주에 = la semaine prochaine ; 갈 거예요 = j''irai.', 2, ARRAY['future', 'time_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie 내일 ?', 'demain', '["demain","hier","aujourd''hui","la semaine prochaine"]'::jsonb, '내일 = demain ; 어제 = hier ; 오늘 = aujourd''hui.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '계획 연습', 'Entraînement : le futur', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '주말에 영화를 ___ 거예요.', 'Ce week-end, je verrai un film.', '볼', '["볼","보을","볼을","보"]'::jsonb, '보다 : radical 보 (voyelle) → 볼 거예요.', 1, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '오늘 저녁에 친구를 ___ 거예요.', 'Ce soir, je verrai un ami.', '만날', '["만날","만나을","만나서","만나"]'::jsonb, '만나다 : radical 만나 (voyelle) → 만날 거예요.', 1, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 서울에 ___ 거예요.', 'J''habiterai à Séoul.', '살', '["살","사을","살을","사"]'::jsonb, '살다 (radical en ㄹ) : 살 거예요, le ㄹ ne se double pas.', 3, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일 뭐 ___ 거예요?', 'Que feras-tu demain ?', '할', '["할","하을","해서","해"]'::jsonb, '하다 : radical 하 (voyelle) → 할 거예요.', 1, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '다음 주___ 한국에 갈 거예요.', 'La semaine prochaine, j''irai en Corée.', '에', '["에","에서","를","가"]'::jsonb, '다음 주 est un moment précis → 에.', 1, ARRAY['time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Demain, je mangerai du bibimbap.', '내일 비빔밥을 먹을 거예요 | 저는 내일 비빔밥을 먹을 거예요', NULL, '먹다 → 먹을 거예요 ; 비빔밥을 (objet).', 2, ARRAY['future', 'object_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '내일 친구를 만날 거예요', 'Écoute et choisis la phrase entendue', '내일 친구를 만날 거예요', '["내일 친구를 만날 거예요","내일 친구를 만났어요","내일 친구를 만나요","주말에 친구를 만날 거예요"]'::jsonb, '만날 거예요 = futur ; 내일 = demain. Écoute bien le temps du verbe et le mot de temps.', 2, ARRAY['future', 'object_particle', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 주말에 영화를 볼 거예요.', NULL, 'Ce week-end, je verrai un film | Je verrai un film ce week-end | Moi, ce week-end, je verrai un film', NULL, '주말에 = ce week-end ; 볼 거예요 = je verrai.', 2, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Ce week-end, j''irai au parc.', '주말에 공원에 갈 거예요', '["주말에","공원에","갈","거예요"]'::jsonb, 'Moment → destination (에) → verbe au futur.', 2, ARRAY['future', 'e_vs_eseo', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 4 and l.lesson_number = 2;

-- ---------- Étage 2 · Unité 5 : Parler du passé ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 5, '과거', 'Parler du passé', 'grammar', '-았/었-, et relier deux noms avec 하고 / (이)랑' from floors where floor_number = 2
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-았/었어요', 'Dire ce qu''on a fait', 'teach', '{"intro":"Le passé, c''est comme le présent poli, mais avec ㅆ : 았어요 / 었어요 / 했어요. Et pour raconter, un petit outil en plus : relier deux noms.","sections":[{"title":"Le passé poli","body":"Dernière voyelle ㅏ ou ㅗ → 았어요 ; autres voyelles → 었어요 ; verbes en 하다 → 했어요. La voyelle fusionne : 가+았 → 갔, 사+았 → 샀 (obligatoire, même à l''écrit : 가았어요 n''existe pas). 보+았 → 봤 (보았어요 existe aussi à l''écrit soutenu, mais 봤어요 est la forme courante). Attention : 사요 est le présent, 샀어요 le passé.","examples":[{"ko":"어제 친구를 만났어요.","rom":"eo-je chin-gu-reul man-na-sseo-yo","fr":"Hier, j''ai vu un ami."},{"ko":"저는 커피를 샀어요.","rom":"jeo-neun keo-pi-reul sa-sseo-yo","fr":"J''ai acheté du café."},{"ko":"지난 주말에 영화를 봤어요.","rom":"ji-nan ju-ma-re yeong-hwa-reul bwa-sseo-yo","fr":"Le week-end dernier, j''ai vu un film."},{"ko":"어제 한국어를 공부했어요.","rom":"eo-je han-gu-geo-reul gong-bu-hae-sseo-yo","fr":"Hier, j''ai étudié le coréen."}]},{"title":"Relier deux noms : 하고 / (이)랑","body":"Pour dire « et » ou « avec » entre deux NOMS, on colle 하고, ou (이)랑 (이랑 après une consonne, 랑 après une voyelle). 그리고 ne relie pas des noms : il commence une phrase (« et puis »).","examples":[{"ko":"빵하고 우유를 샀어요.","rom":"ppang-ha-go u-yu-reul sa-sseo-yo","fr":"J''ai acheté du pain et du lait."},{"ko":"친구랑 영화를 봤어요.","rom":"chin-gu-rang yeong-hwa-reul bwa-sseo-yo","fr":"J''ai vu un film avec un ami."},{"ko":"점심에 비빔밥을 먹었어요. 그다음에 커피를 마셨어요.","rom":"jeom-si-me bi-bim-ba-beul meo-geo-sseo-yo. geu-da-eu-me keo-pi-reul ma-syeo-sseo-yo","fr":"À midi, j''ai mangé un bibimbap. Ensuite, j''ai bu un café."}]}],"tip":"Deux outils, deux rôles : 하고 / (이)랑 relient des NOMS (빵하고 우유) ; 그리고 / 그다음에 relient des PHRASES."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어제 친구를 ___.', 'Hier, j''ai vu un ami.', '만났어요', '["만났어요","만나았어요","만나었어요","만낫어요"]'::jsonb, '만나다 : ㅏ → 았어요, contracté : 만났어요.', 1, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어제 커피를 ___.', 'Hier, j''ai acheté du café.', '샀어요', '["샀어요","사았어요","사었어요","사요"]'::jsonb, '사다 → 샀어요 (passé). 사요 est le présent.', 1, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지난 주말에 영화를 ___.', 'Le week-end dernier, j''ai vu un film.', '봤어요', '["봤어요","보요","봐요","보었어요"]'::jsonb, '보다 : ㅗ → 았어요, contracté : 봤어요. 봐요 est le présent.', 2, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어제 한국어를 ___.', 'Hier, j''ai étudié le coréen.', '공부했어요', '["공부했어요","공부하았어요","공부하었어요","공부해요"]'::jsonb, '공부하다 → 공부했어요 (passé). 공부해요 est le présent.', 1, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle terminaison pour le passé poli des verbes en -하다 ?', '했어요', '["했어요","했요","하었요","한어요"]'::jsonb, '하다 → 했어요.', 1, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie 어제 ?', 'hier', '["hier","demain","aujourd''hui","ce soir"]'::jsonb, '어제 = hier ; 내일 = demain.', 1, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'J''ai mangé du bibimbap à midi.', '점심에 비빔밥을 먹었어요 | 저는 점심에 비빔밥을 먹었어요', NULL, '먹다 : ㅓ → 었어요 ; 점심에 = à midi.', 3, ARRAY['past', 'time_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Hier, j''ai lu un livre.', '어제 책을 읽었어요', '["어제","책을","읽었어요"]'::jsonb, 'Temps → objet → verbe au passé.', 2, ARRAY['past', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '과거 연습', 'Entraînement : passé et liaison de noms', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 어제 학교에 ___.', 'Hier, je suis allé(e) à l''école.', '갔어요', '["갔어요","가었어요","가았어요","갔요"]'::jsonb, '가다 → 갔어요.', 1, ARRAY['past', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어제 커피를 ___.', 'Hier, j''ai bu un café.', '마셨어요', '["마셨어요","마시어요","마셔요","마싰어요"]'::jsonb, '마시다 → 마셨어요 (passé).', 3, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '빵___ 우유를 샀어요.', 'J''ai acheté du pain et du lait.', '하고', '["하고","그리고","그래서","하지만"]'::jsonb, '하고 relie deux noms. 그리고, 그래서, 하지만 relient des phrases.', 1, ARRAY['linking', 'past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '친구___ 영화를 봤어요.', 'J''ai vu un film avec un ami.', '랑', '["랑","이랑","그리고","에서"]'::jsonb, '친구 finit par une voyelle → 랑 (이랑 après une consonne).', 1, ARRAY['linking', 'past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Pour relier deux NOMS (du pain et du lait), on utilise :', '하고 / (이)랑', '["하고 / (이)랑","그리고","그래서","하지만"]'::jsonb, '하고 et (이)랑 relient des noms ; 그리고 relie des phrases.', 1, ARRAY['linking']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie 그다음에 ?', 'ensuite, après ça', '["ensuite, après ça","avant ça","pendant ce temps","à cause de ça"]'::jsonb, '그다음에 = ensuite.', 1, ARRAY['linking']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'J''ai acheté du tofu.', '두부를 샀어요 | 저는 두부를 샀어요', NULL, '사다 → 샀어요 ; 두부를 (objet).', 2, ARRAY['past', 'object_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis ce que tu as fait hier, en une phrase.', 'Le passé poli (-았어요 / -었어요)', NULL, 'Exemple : 어제 친구를 만났어요.', 3, ARRAY['past', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Hier, j''ai vu un film avec un ami.', '어제 친구랑 영화를 봤어요 | 어제 친구하고 영화를 봤어요 | 저는 어제 친구랑 영화를 봤어요 | 저는 어제 친구하고 영화를 봤어요', NULL, '친구랑 / 친구하고 = avec un ami ; 봤어요 = j''ai vu.', 3, ARRAY['past', 'linking']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '어제 친구를 만났어요', 'Écoute et choisis la phrase entendue', '어제 친구를 만났어요', '["어제 친구를 만났어요","어제 친구를 만나요","오늘 친구를 만났어요","어제 친구랑 만났어요"]'::jsonb, '만났어요 = passé ; 어제 = hier. Écoute bien le temps du verbe et le mot de temps.', 2, ARRAY['past', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 어제 영화를 봤어요.', NULL, 'Hier, j''ai vu un film | J''ai vu un film hier | Moi, hier, j''ai vu un film', NULL, '어제 = hier ; 봤어요 = j''ai vu.', 2, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 5 and l.lesson_number = 2;

-- ---------- Étage 2 · Unité 6 : Boss : une journée au marché ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 6, '역할극', 'Boss : une journée au marché', 'grammar', 'Tout l''étage 2 dans un jeu de rôle' from floors where floor_number = 2
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '2층 보스', 'Boss de l''étage 2', 'boss', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 2 and u.unit_number = 6
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 프랑스 사람___.', 'Je suis français(e).', '이에요', '["이에요","예요","이요","에요"]'::jsonb, '사람 finit par une consonne (ㅁ) → 이에요.', 2, ARRAY['copula']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 음식은 정말 ___.', 'Ce plat est vraiment délicieux.', '맛있어요', '["맛있어요","맛있아요","맛있해요","맛있요"]'::jsonb, '맛있다 → 맛있어요.', 2, ARRAY['adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '시장에서 사과 세 ___ 샀어요.', 'Au marché, j''ai acheté trois pommes.', '개', '["개","명","마리","잔"]'::jsonb, '개 : compteur des objets.', 3, ARRAY['counters', 'past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지하철___ 학교에 가요.', 'Je vais à l''école en métro.', '로', '["로","으로","를","에게"]'::jsonb, '지하철 finit par ㄹ → 로.', 3, ARRAY['direction', 'directions']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일 친구를 ___ 거예요.', 'Demain, je verrai un ami.', '만날', '["만날","만나을","만나서","만나"]'::jsonb, '만나다 → 만날 거예요.', 3, ARRAY['future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어제 영화를 ___.', 'Hier, j''ai vu un film.', '봤어요', '["봤어요","보었어요","보요","봐요"]'::jsonb, '보다 → 봤어요.', 3, ARRAY['past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '사과___ 두부를 샀어요.', 'J''ai acheté des pommes et du tofu.', '하고', '["하고","그리고","그래서","하지만"]'::jsonb, '하고 relie deux noms.', 3, ARRAY['linking', 'past']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ? (trois bouteilles d''eau, s''il vous plaît)', '물 세 병 주세요', '["물 세 병 주세요","세 물 병 주세요","물 병 세 주세요","주세요 물 세 병"]'::jsonb, 'Nom → nombre → compteur → 주세요.', 3, ARRAY['counters', 'requests']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Hier, j''ai acheté du pain et du café.', '어제 빵하고 커피를 샀어요', '["어제","빵하고","커피를","샀어요"]'::jsonb, 'Temps → objets reliés par 하고 → verbe au passé.', 3, ARRAY['linking', 'past', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Combien coûte ce tofu ?', '이 두부 얼마예요 | 이거 얼마예요 | 이 두부는 얼마예요', NULL, '이 두부 = ce tofu ; 얼마예요 = combien ?', 3, ARRAY['requests']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Allez tout droit, puis à droite.', '똑바로 가세요. 그다음에 오른쪽으로 가세요 | 쭉 가세요. 그다음에 오른쪽으로 가세요 | 똑바로 가세요. 그리고 오른쪽으로 가세요 | 쭉 가세요. 그리고 오른쪽으로 가세요', NULL, '똑바로 = tout droit ; 그다음에 = ensuite ; 오른쪽으로 = vers la droite.', 4, ARRAY['directions', 'linking']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Ce week-end, j''irai à Séoul en train.', '주말에 기차로 서울에 갈 거예요 | 이번 주말에 기차로 서울에 갈 거예요 | 주말에 서울에 기차로 갈 거예요', NULL, '주말에 (moment) + 기차로 (moyen) + 서울에 (destination) + 갈 거예요.', 4, ARRAY['future', 'direction', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis ce que tu feras demain, avec un lieu.', 'Le futur (-(으)ㄹ 거예요) et la particule de lieu 에', NULL, 'Exemple : 내일 시장에 갈 거예요.', 4, ARRAY['future', 'e_vs_eseo', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '어제 시장에서 두부하고 사과를 샀어요.', NULL, 'Hier, j''ai acheté du tofu et des pommes au marché | J''ai acheté du tofu et des pommes au marché hier | Hier, au marché, j''ai acheté du tofu et des pommes', NULL, '시장에서 = au marché (action) ; 두부하고 사과 = du tofu et des pommes.', 4, ARRAY['past', 'linking', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 2 and u.unit_number = 6 and l.lesson_number = 1;

-- ################ Étage 3 : Vouloir, pouvoir, demander ################
insert into floors (floor_number, title_ko, title_fr, cefr_level, description, unlock_xp)
values (3, '하고 싶은 것', 'Vouloir, pouvoir, demander', 'A2+', 'Dire ce que tu veux et ce que tu peux, demander poliment, donner une consigne et faire une proposition.', 0)
on conflict (floor_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr,
  cefr_level = excluded.cefr_level, description = excluded.description;

-- ---------- Étage 3 · Unité 1 : Dire ce que tu veux ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 1, '-고 싶어요', 'Dire ce que tu veux', 'grammar', '-고 싶어요 : vouloir faire quelque chose' from floors where floor_number = 3
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-고 싶어요', 'Vouloir faire quelque chose', 'teach', '{"intro":"Jusqu''ici tu décris, tu achètes, tu racontes. Maintenant tu exprimes une envie. Bonne nouvelle : c''est l''une des formes les plus faciles du coréen, car le verbe ne change presque pas.","sections":[{"title":"Verbe + 고 싶어요 — « vouloir »","body":"On prend le radical du verbe et on ajoute 고 싶어요. Rien à surveiller : pas de voyelle, pas de consonne, pas de 으. Le radical reste intact (먹다 → 먹고 싶어요, 가다 → 가고 싶어요). Les verbes en 하다 suivent la même règle (공부하다 → 공부하고 싶어요). Seul 싶어요 se conjugue.","examples":[{"ko":"저는 커피를 마시고 싶어요.","rom":"jeo-neun keo-pi-reul ma-si-go si-peo-yo","fr":"Je veux boire un café."},{"ko":"한국에 가고 싶어요.","rom":"han-gu-ge ga-go si-peo-yo","fr":"Je veux aller en Corée."},{"ko":"영화를 보고 싶어요.","rom":"yeong-hwa-reul bo-go si-peo-yo","fr":"Je veux voir un film."},{"ko":"한국어를 배우고 싶어요.","rom":"han-gu-geo-reul bae-u-go si-peo-yo","fr":"Je veux apprendre le coréen."}]},{"title":"Poser la question, refuser","body":"Pour demander l''envie de quelqu''un, on garde la même forme : 뭐 먹고 싶어요 ? (Que veux-tu manger ?). Pour dire qu''on ne veut pas : radical + 고 싶지 않아요.","examples":[{"ko":"뭐 먹고 싶어요?","rom":"mwo meok-go si-peo-yo","fr":"Que veux-tu manger ?"},{"ko":"지금은 먹고 싶지 않아요.","rom":"ji-geu-meun meok-go sip-ji a-na-yo","fr":"Je ne veux pas manger maintenant."}]}],"tip":"Les radicaux en ㄹ ne perdent pas leur ㄹ devant 고 : 만들다 → 만들고 싶어요 (et non 만드고). Cette forme sert pour « je » ou « tu » ; pour parler de ce que veut quelqu''un d''autre, on utilise une forme voisine qu''on verra plus tard."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 커피를 마시___ 싶어요.', 'Je veux boire un café.', '고', '["고","아","서","는"]'::jsonb, '-고 싶어요 : radical + 고. Ici 마시 + 고 싶어요.', 1, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국에 가___ 싶어요.', 'Je veux aller en Corée.', '고', '["고","아서","면","러"]'::jsonb, 'Radical 가 + 고 싶어요.', 1, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle est la forme correcte pour « je veux manger » ?', '먹고 싶어요', '["먹고 싶어요","먹으고 싶어요","먹어 싶어요","먹고 싶요"]'::jsonb, 'Le radical ne change pas : 먹 + 고 싶어요. Pas de 으 devant 고.', 1, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 한국어를 배우고 싶어요 » ?', 'Je veux apprendre le coréen', '["Je veux apprendre le coréen","J''apprends le coréen","J''ai appris le coréen","Je voudrais enseigner le coréen"]'::jsonb, '배우다 = apprendre ; -고 싶어요 = vouloir. (Enseigner se dit 가르치다.)', 1, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 한국어를 공부하___.', 'Je veux étudier le coréen.', '고 싶어요', '["고 싶어요","고 싶요","어 싶어요","고 시퍼요"]'::jsonb, 'Radical 공부하 + 고 싶어요.', 1, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je veux aller en Corée.', '한국에 가고 싶어요 | 저는 한국에 가고 싶어요', NULL, '가다 + 고 싶어요 ; 한국에 (destination).', 2, ARRAY['want_to', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Je veux voir un film.', '영화를 보고 싶어요', '["영화를","보고","싶어요"]'::jsonb, 'Objet → radical + 고 → 싶어요, toujours à la fin.', 2, ARRAY['want_to', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 커피를 마시고 싶어요.', NULL, 'Je veux boire un café | Moi, je veux boire un café | Je voudrais boire un café', NULL, '마시고 싶어요 = je veux boire.', 2, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '-고 싶어요 연습', 'Entraînement : vouloir', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일은 집에서 ___.', 'Demain, je veux me reposer à la maison.', '쉬고 싶어요', '["쉬고 싶어요","쉬어 싶어요","쉬고 싶요","쉬으고 싶어요"]'::jsonb, '쉬다 + 고 싶어요, le radical ne change pas.', 1, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 한국 음식을 ___.', 'Je veux faire de la cuisine coréenne.', '만들고 싶어요', '["만들고 싶어요","만드고 싶어요","만들어 싶어요","만들으고 싶어요"]'::jsonb, 'Le radical en ㄹ garde son ㄹ devant 고 : 만들고.', 3, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on « Je ne veux pas manger » ?', '먹고 싶지 않아요', '["먹고 싶지 않아요","먹고 싶지 않요","먹고 싶 않아요","먹고지 싶어요"]'::jsonb, 'Radical + 고 싶지 않아요.', 2, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 뭐 하고 싶어요? » ?', 'Que veux-tu faire ?', '["Que veux-tu faire ?","Que fais-tu ?","Qu''as-tu fait ?","Que feras-tu ?"]'::jsonb, '뭐 = quoi ; 하고 싶어요 = vouloir faire.', 1, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '저는 한국에 가고 싶어요', 'Écoute et choisis la phrase entendue', '저는 한국에 가고 싶어요', '["저는 한국에 가고 싶어요","저는 한국에 갈 거예요","저는 한국에 갔어요","저는 한국에서 살고 싶어요"]'::jsonb, '가고 싶어요 = je veux aller. Écoute bien la fin du verbe.', 2, ARRAY['want_to', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je veux apprendre le coréen.', '한국어를 배우고 싶어요 | 저는 한국어를 배우고 싶어요', NULL, '배우다 + 고 싶어요.', 2, ARRAY['want_to', 'object_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je ne veux pas manger maintenant.', '지금은 먹고 싶지 않아요 | 지금 먹고 싶지 않아요 | 저는 지금 먹고 싶지 않아요', NULL, '지금 = maintenant ; 먹고 싶지 않아요 = je ne veux pas manger.', 3, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '주말에 친구를 만나고 싶어요.', NULL, 'Ce week-end, je veux voir un ami | Je veux voir un ami ce week-end | Je veux rencontrer un ami ce week-end', NULL, '만나다 = rencontrer / voir (quelqu''un).', 2, ARRAY['want_to', 'time_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Que veux-tu manger ?', '뭐 먹고 싶어요', '["뭐","먹고","싶어요"]'::jsonb, 'Question : pronom → verbe → 싶어요.', 2, ARRAY['want_to', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis ce que tu veux faire ce week-end.', '-고 싶어요 : vouloir faire quelque chose', NULL, 'Exemple : 주말에 영화를 보고 싶어요.', 3, ARRAY['want_to', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 1 and l.lesson_number = 2;

-- ---------- Étage 3 · Unité 2 : Pouvoir, ne pas pouvoir, ne pas faire ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 2, '-(으)ㄹ 수 있어요 · 안 · 못', 'Pouvoir, ne pas pouvoir, ne pas faire', 'grammar', '-(으)ㄹ 수 있어요 / 없어요, et les négations 안 et 못' from floors where floor_number = 3
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-(으)ㄹ 수 있어요', 'Pouvoir, savoir, et les deux négations', 'teach', '{"intro":"En français, « je ne mange pas » et « je ne peux pas manger » sont deux idées différentes. En coréen aussi, avec deux petits mots distincts : 안 et 못. Et pour dire « pouvoir » à l''affirmatif, une structure à retenir.","sections":[{"title":"-(으)ㄹ 수 있어요 / 없어요 — « pouvoir, savoir »","body":"Radical qui finit par une voyelle : + ㄹ 수 있어요 (가다 → 갈 수 있어요). Par une consonne : + 을 수 있어요 (읽다 → 읽을 수 있어요). Radical en ㄹ : on ne rajoute rien (만들다 → 만들 수 있어요). Verbes en 하다 : 할 수 있어요. Le contraire est 수 없어요. Cette forme dit à la fois la capacité (« je sais nager ») et la possibilité (« je peux venir »).","examples":[{"ko":"저는 수영할 수 있어요.","rom":"jeo-neun su-yeong-hal su i-sseo-yo","fr":"Je sais nager."},{"ko":"한국어를 읽을 수 있어요.","rom":"han-gu-geo-reul il-geul su i-sseo-yo","fr":"Je peux lire le coréen."},{"ko":"오늘은 갈 수 없어요.","rom":"o-neu-reun gal su eop-sseo-yo","fr":"Aujourd''hui, je ne peux pas y aller."}]},{"title":"안 et 못 — deux négations","body":"안 + verbe = « ne pas » : un choix ou une simple négation (안 가요 : je ne vais pas). 못 + verbe = « ne pas pouvoir » : incapacité ou empêchement (못 가요 : je ne peux pas y aller). Ils se placent juste avant le verbe. Avec un verbe en 하다, on les met entre le nom et 하다 : 운동 안 해요, 수영 못 해요. Pour un verbe qui n''est pas un nom + 하다 (좋아하다), 안 et 못 se placent devant le verbe entier : 안 좋아해요 (et non 좋아 안 해요).","examples":[{"ko":"저는 고기를 안 먹어요.","rom":"jeo-neun go-gi-reul an meo-geo-yo","fr":"Je ne mange pas de viande."},{"ko":"오늘은 못 가요.","rom":"o-neu-reun mot ga-yo","fr":"Aujourd''hui, je ne peux pas y aller."},{"ko":"운동 안 해요.","rom":"un-dong an hae-yo","fr":"Je ne fais pas de sport."},{"ko":"수영 못 해요.","rom":"su-yeong mot hae-yo","fr":"Je ne sais pas nager."}]}],"tip":"안 = « je ne fais pas » (j''ai choisi, ou c''est un fait). 못 = « je n''y arrive pas » (je n''ai pas la capacité, ou quelque chose m''en empêche). Avec un adjectif, seul 안 existe : 안 커요 (ce n''est pas grand)."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 수영할 ___ 있어요.', 'Je sais nager.', '수', '["수","것","거","때"]'::jsonb, '-(으)ㄹ 수 있어요 : le mot 수 est la clé.', 1, ARRAY['can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 김치를 먹을 수 ___.', 'Je peux manger du kimchi.', '있어요', '["있어요","없어요","있었요","있예요"]'::jsonb, '수 있어요 = je peux ; 수 없어요 = je ne peux pas.', 1, ARRAY['can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국어를 ___ 수 있어요.', 'Je peux lire le coréen.', '읽을', '["읽을","읽","읽는","읽은"]'::jsonb, '읽다 : consonne finale → 을 수 있어요.', 2, ARRAY['can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle négation signifie « je n''y arrive pas / je ne peux pas » ?', '못', '["못","안","아니","말"]'::jsonb, '못 = incapacité ou empêchement ; 안 = négation simple.', 1, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on « Je ne fais pas de sport » ?', '운동 안 해요', '["운동 안 해요","안 운동해요","운동해 안요","운동하 안요"]'::jsonb, 'Avec un verbe en 하다 : nom + 안 + 해요.', 1, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je ne mange pas de viande.', '고기를 안 먹어요 | 저는 고기를 안 먹어요', NULL, '안 + verbe ; 고기를 (objet).', 2, ARRAY['negation', 'object_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Je sais nager.', '저는 수영할 수 있어요', '["저는","수영할","수","있어요"]'::jsonb, 'Sujet → verbe + ㄹ → 수 있어요.', 2, ARRAY['can', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '오늘은 못 가요.', NULL, 'Aujourd''hui, je ne peux pas y aller | Je ne peux pas y aller aujourd''hui', NULL, '못 가요 = je ne peux pas y aller.', 2, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '수 · 안 · 못 연습', 'Entraînement : pouvoir et négations', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 한국어를 말할 ___ 있어요.', 'Je peux parler coréen.', '수', '["수","지","도","만"]'::jsonb, '-(으)ㄹ 수 있어요 : 말하다 → 말할 수 있어요.', 1, ARRAY['can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 고기를 못 ___.', 'Je ne peux pas manger de viande.', '먹어요', '["먹어요","먹으요","먹아요","먹요"]'::jsonb, '못 + verbe au présent poli : 먹어요.', 1, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 운전을 할 수 ___.', 'Je ne sais pas conduire.', '없어요', '["없어요","않아요","못이에요","아니에요"]'::jsonb, '수 없어요 = je ne peux / ne sais pas.', 2, ARRAY['can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase dit « Je ne mange pas de poisson » (je ne mange simplement pas de poisson) ?', '저는 생선을 안 먹어요', '["저는 생선을 안 먹어요","저는 생선을 못 먹어요","저는 생선을 먹어 안요","저는 생선을 안요 먹어요"]'::jsonb, '안 = négation simple ; 못 dirait « je ne peux pas en manger ».', 2, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 수영 못 해요 » ?', 'Je ne sais pas nager', '["Je ne sais pas nager","Je ne nage pas (par choix)","Je vais nager","J''ai nagé"]'::jsonb, '못 = incapacité.', 1, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '저는 수영할 수 있어요', 'Écoute et choisis la phrase entendue', '저는 수영할 수 있어요', '["저는 수영할 수 있어요","저는 수영할 수 없어요","저는 수영 못 해요","저는 수영하고 싶어요"]'::jsonb, '할 수 있어요 = je sais. Écoute bien 있어요 / 없어요.', 2, ARRAY['can', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je ne peux pas aller à l''école aujourd''hui.', '오늘은 학교에 갈 수 없어요 | 오늘 학교에 갈 수 없어요 | 오늘은 학교에 못 가요 | 오늘 학교에 못 가요 | 저는 오늘 학교에 갈 수 없어요 | 저는 오늘 학교에 못 가요', NULL, '갈 수 없어요 ou 못 가요 : les deux disent « je ne peux pas ».', 3, ARRAY['can', 'negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je sais lire le coréen.', '한국어를 읽을 수 있어요 | 저는 한국어를 읽을 수 있어요', NULL, '읽다 → 읽을 수 있어요.', 3, ARRAY['can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '저는 운동을 안 해요.', NULL, 'Je ne fais pas de sport | Moi, je ne fais pas de sport | Je ne fais pas d''exercice', NULL, '안 해요 = je ne fais pas.', 2, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis une chose que tu sais faire et une chose que tu ne sais pas faire.', '-(으)ㄹ 수 있어요 / 없어요, ou 못', NULL, 'Exemple : 저는 요리할 수 있어요. 수영은 못 해요.', 3, ARRAY['can', 'negation', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 2 and l.lesson_number = 2;

-- ---------- Étage 3 · Unité 3 : Demander et donner des consignes ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 3, '-아/어 주세요 · -(으)세요', 'Demander et donner des consignes', 'grammar', '-아/어 주세요, -(으)세요 et -지 마세요' from floors where floor_number = 3
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-아/어 주세요', 'Demander un service et donner une consigne', 'teach', '{"intro":"Tu sais déjà dire 주세요 pour demander un objet. Voici comment demander une action, donner une consigne polie, ou interdire quelque chose. Tu les entendras partout en Corée.","sections":[{"title":"-아/어 주세요 — « fais-le pour moi, s''il te plaît »","body":"On conjugue le verbe comme au présent poli, sans le 요 (먹다 → 먹어, 말하다 → 말해, 열다 → 열어), puis on ajoute 주세요. C''est la manière polie de demander une action à quelqu''un.","examples":[{"ko":"사진을 찍어 주세요.","rom":"sa-ji-neul jji-geo ju-se-yo","fr":"Prenez une photo, s''il vous plaît."},{"ko":"문을 열어 주세요.","rom":"mu-neul yeo-reo ju-se-yo","fr":"Ouvrez la porte, s''il vous plaît."},{"ko":"천천히 말해 주세요.","rom":"cheon-cheon-hi mal-hae ju-se-yo","fr":"Parlez lentement, s''il vous plaît."},{"ko":"다시 한번 말해 주세요.","rom":"da-si han-beon mal-hae ju-se-yo","fr":"Répétez encore une fois, s''il vous plaît."}]},{"title":"-(으)세요 et -지 마세요 — consigne et interdiction","body":"Radical qui finit par une voyelle : + 세요 (오다 → 오세요). Par une consonne : + 으세요 (앉다 → 앉으세요). Radical en ㄹ : le ㄹ tombe (만들다 → 만드세요). Pour interdire : radical + 지 마세요 (가다 → 가지 마세요).","examples":[{"ko":"여기 앉으세요.","rom":"yeo-gi an-jeu-se-yo","fr":"Asseyez-vous ici."},{"ko":"이쪽으로 오세요.","rom":"i-jjo-geu-ro o-se-yo","fr":"Venez par ici."},{"ko":"책을 읽으세요.","rom":"chae-geul il-geu-se-yo","fr":"Lisez le livre."},{"ko":"걱정하지 마세요.","rom":"geok-jeong-ha-ji ma-se-yo","fr":"Ne vous inquiétez pas."},{"ko":"여기에서 사진을 찍지 마세요.","rom":"yeo-gi-e-seo sa-ji-neul jjik-ji ma-se-yo","fr":"Ne prenez pas de photo ici."}]}],"tip":"-(으)세요 est aussi la forme respectueuse d''une question ou d''une phrase : 어디 가세요 ? (Où allez-vous ?). Ici on l''apprend comme une consigne polie, mais ouvre l''oreille : tu l''entendras tout le temps, y compris dans les magasins."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '문을 열어 ___.', 'Ouvrez la porte, s''il vous plaît.', '주세요', '["주세요","세요","줘세요","해요"]'::jsonb, '-아/어 주세요 : 열어 + 주세요.', 1, ARRAY['request_verb']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '여기에 ___.', 'Asseyez-vous ici.', '앉으세요', '["앉으세요","앉세요","앉아세요","앉으요"]'::jsonb, '앉다 finit par une consonne → 으세요.', 1, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이쪽으로 ___.', 'Venez par ici.', '오세요', '["오세요","오으세요","와세요","오세"]'::jsonb, '오다 finit par une voyelle → 세요.', 1, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 천천히 말해 주세요 » ?', 'Parlez lentement, s''il vous plaît', '["Parlez lentement, s''il vous plaît","Parlez fort, s''il vous plaît","Ne parlez pas","J''ai parlé lentement"]'::jsonb, '천천히 = lentement ; 말해 주세요 = dites-le pour moi.', 1, ARRAY['request_verb']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on « Ne vous inquiétez pas » ?', '걱정하지 마세요', '["걱정하지 마세요","걱정 마지세요","걱정하지 말세요","걱정하세요 안"]'::jsonb, 'Interdiction : radical + 지 마세요.', 1, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Prenez une photo, s''il vous plaît.', '사진을 찍어 주세요 | 사진 찍어 주세요', NULL, '찍다 → 찍어 + 주세요.', 2, ARRAY['request_verb', 'object_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Lisez le livre ici.', '여기에서 책을 읽으세요', '["여기에서","책을","읽으세요"]'::jsonb, 'Lieu → objet → verbe en -(으)세요.', 2, ARRAY['honorific', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '다시 한번 말해 주세요.', NULL, 'Répétez encore une fois, s''il vous plaît | Dites-le encore une fois, s''il vous plaît | Pouvez-vous le redire encore une fois ?', NULL, '다시 한번 = encore une fois.', 2, ARRAY['request_verb']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '부탁과 지시 연습', 'Entraînement : demander et consigner', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '사진을 ___ 주세요.', 'Prenez une photo, s''il vous plaît.', '찍어', '["찍어","찍아","찍으","찍해"]'::jsonb, '찍다 : dernière voyelle ㅣ → 어 : 찍어 주세요.', 1, ARRAY['request_verb']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '천천히 ___ 주세요.', 'Parlez lentement, s''il vous plaît.', '말해', '["말해","말아","말하","말어"]'::jsonb, '말하다 → 말해 주세요.', 1, ARRAY['request_verb']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '책을 ___.', 'Lisez le livre.', '읽으세요', '["읽으세요","읽세요","읽어세요","읽으니세요"]'::jsonb, '읽다 : consonne finale → 으세요.', 1, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '여기에서 담배를 피우지 ___.', 'Ne fumez pas ici.', '마세요', '["마세요","않세요","말세요","안 세요"]'::jsonb, 'Interdiction : radical + 지 마세요.', 1, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '여기에 이름을 ___.', 'Écrivez votre nom ici.', '쓰세요', '["쓰세요","쓰으세요","써세요","쓰요"]'::jsonb, '쓰다 finit par une voyelle (ㅡ) → 세요.', 2, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle terminaison exprime une interdiction polie (« ne… pas ») ?', '-지 마세요', '["-지 마세요","-지 않아요","-고 싶어요","-아/어 주세요"]'::jsonb, '-지 마세요 = ne faites pas.', 1, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '이쪽으로 오세요', 'Écoute et choisis la phrase entendue', '이쪽으로 오세요', '["이쪽으로 오세요","이쪽으로 가세요","이쪽으로 왔어요","저쪽으로 오세요"]'::jsonb, '오세요 = venez ; 이쪽 = par ici.', 2, ARRAY['honorific', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Ouvrez la porte, s''il vous plaît.', '문을 열어 주세요 | 문 열어 주세요', NULL, '열다 → 열어 + 주세요.', 2, ARRAY['request_verb']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Ne vous inquiétez pas.', '걱정하지 마세요 | 걱정 마세요', NULL, '걱정하지 마세요 : interdiction polie.', 2, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '여기 앉으세요.', NULL, 'Asseyez-vous ici | Veuillez vous asseoir ici | Asseyez-vous là', NULL, '앉으세요 = asseyez-vous.', 2, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Demande poliment à quelqu''un de parler plus lentement.', '-아/어 주세요', NULL, 'Exemple : 천천히 말해 주세요.', 3, ARRAY['request_verb', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 3 and l.lesson_number = 2;

-- ---------- Étage 3 · Unité 4 : Faire une proposition ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 4, '-(으)ㄹ까요?', 'Faire une proposition', 'grammar', '-(으)ㄹ까요 ? et répondre à une proposition' from floors where floor_number = 3
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-(으)ㄹ까요?', 'Proposer et répondre', 'teach', '{"intro":"Pour inviter quelqu''un ou offrir ton aide, rien de plus naturel : -(으)ㄹ까요 ?. C''est un doux « et si… ? ». Tu apprends aussi à accepter ou à refuser avec élégance.","sections":[{"title":"-(으)ㄹ까요 ? — « on… ? / je… ? »","body":"Radical qui finit par une voyelle : + ㄹ까요 (보다 → 볼까요). Par une consonne : + 을까요 (먹다 → 먹을까요). Radical en ㄹ : + 까요 (열다 → 열까요, 만들다 → 만들까요). Avec 같이 (ensemble), c''est une proposition à deux : « On… ensemble ? ». Avec 제가 (moi), c''est une offre : « Je… pour vous ? ».","examples":[{"ko":"같이 점심 먹을까요?","rom":"ga-chi jeom-sim meo-geul-kka-yo","fr":"On déjeune ensemble ?"},{"ko":"내일 영화 볼까요?","rom":"nae-il yeong-hwa bol-kka-yo","fr":"On va voir un film demain ?"},{"ko":"제가 문을 열까요?","rom":"je-ga mu-neul yeol-kka-yo","fr":"J''ouvre la porte ?"}]},{"title":"Accepter, refuser, proposer sans question","body":"Accepter : 네, 좋아요 ! Refuser poliment : 미안해요, suivi d''une raison. 좀 (« un peu ») adoucit la phrase et revient souvent. Et pour proposer sans question : 같이 + présent poli (같이 가요 : allons-y ensemble).","examples":[{"ko":"네, 좋아요.","rom":"ne, jo-a-yo","fr":"Oui, avec plaisir."},{"ko":"미안해요. 오늘은 좀 바빠요.","rom":"mi-an-hae-yo. o-neu-reun jom ba-ppa-yo","fr":"Désolé(e). Aujourd''hui, je suis un peu occupé(e)."},{"ko":"같이 가요!","rom":"ga-chi ga-yo","fr":"Allons-y ensemble !"}]}],"tip":"같이 가요 (affirmation) = « allons-y ensemble » ; 같이 갈까요 ? (question) = « et si on y allait ensemble ? » — plus doux, on laisse l''autre choisir."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '같이 점심 먹___?', 'On déjeune ensemble ?', '을까요', '["을까요","를까요","으까요","는까요"]'::jsonb, '먹다 finit par une consonne → 을까요.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일 영화 ___?', 'On va voir un film demain ?', '볼까요', '["볼까요","보을까요","보까요","봐요까요"]'::jsonb, '보다 finit par une voyelle → ㄹ까요 : 볼까요.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '제가 문을 ___?', 'J''ouvre la porte ?', '열까요', '["열까요","열을까요","여을까요","열어까요"]'::jsonb, '열다 : radical en ㄹ → on ajoute seulement 까요.', 3, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 같이 갈까요? » ?', 'Et si on y allait ensemble ?', '["Et si on y allait ensemble ?","Je suis allé(e) ensemble","Allez-y tout seul","Où allons-nous ?"]'::jsonb, '같이 = ensemble ; -(으)ㄹ까요 = proposition.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase refuse poliment une invitation ?', '미안해요. 오늘은 좀 바빠요', '["미안해요. 오늘은 좀 바빠요","네, 좋아요! 같이 가요","같이 갈까요","언제 만날까요"]'::jsonb, 'Un refus poli : excuse + raison.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'On mange ensemble ?', '같이 먹을까요 | 우리 같이 먹을까요', NULL, '먹다 → 먹을까요.', 2, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'On va voir un film ensemble ?', '같이 영화 볼까요', '["같이","영화","볼까요"]'::jsonb, 'Ensemble → objet → verbe en -(으)ㄹ까요.', 2, ARRAY['suggest', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '내일 커피 마실까요?', NULL, 'On prend un café demain ? | Et si on buvait un café demain ? | On boit un café demain ?', NULL, '마시다 → 마실까요.', 2, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '제안 연습', 'Entraînement : proposer et répondre', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '주말에 같이 ___?', 'On fait du sport ce week-end ?', '운동할까요', '["운동할까요","운동하을까요","운동해까요","운동하까요"]'::jsonb, '운동하다 → 운동할까요.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어디에서 ___?', 'Où se retrouve-t-on ?', '만날까요', '["만날까요","만나을까요","만나까요","만날거까요"]'::jsonb, '만나다 → 만날까요.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저녁에 뭐 ___?', 'Que mange-t-on ce soir ?', '먹을까요', '["먹을까요","먹를까요","먹까요","먹는까요"]'::jsonb, '먹다 : consonne finale → 을까요.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '제가 창문을 ___?', 'Je ferme la fenêtre ?', '닫을까요', '["닫을까요","닫를까요","닫까요","닫아까요"]'::jsonb, '닫다 : consonne finale → 을까요.', 2, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle réponse accepte la proposition « 같이 먹을까요? » ?', '네, 좋아요', '["네, 좋아요","네, 먹었어요","아니요, 먹을까요","네, 먹고 싶지 않아요"]'::jsonb, '네, 좋아요 = oui, avec plaisir.', 1, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '같이 영화 볼까요', 'Écoute et choisis la phrase entendue', '같이 영화 볼까요', '["같이 영화 볼까요","같이 영화 봤어요","같이 영화 보고 싶어요","같이 영화 볼 거예요"]'::jsonb, '볼까요 = proposition. Écoute la fin du verbe.', 2, ARRAY['suggest', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'On va à la bibliothèque ensemble ?', '같이 도서관에 갈까요 | 우리 같이 도서관에 갈까요', NULL, '도서관에 = à la bibliothèque ; 갈까요 = on y va ?', 2, ARRAY['suggest', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Désolé(e). Aujourd''hui, je suis un peu occupé(e).', '미안해요. 오늘은 좀 바빠요 | 죄송해요. 오늘은 좀 바빠요 | 미안해요. 오늘 좀 바빠요 | 죄송해요. 오늘 좀 바빠요', NULL, '미안해요 / 죄송해요 = désolé(e) ; 좀 = un peu.', 3, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '같이 가요!', NULL, 'Allons-y ensemble ! | On y va ensemble ! | Allons ensemble !', NULL, '같이 + présent poli = allons-y.', 2, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Propose à un ami une activité pour ce week-end.', '-(으)ㄹ까요 ? (proposer)', NULL, 'Exemple : 주말에 같이 영화 볼까요?', 3, ARRAY['suggest', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 4 and l.lesson_number = 2;

-- ---------- Étage 3 · Unité 5 : Boss : préparer un voyage ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 5, '여행 준비', 'Boss : préparer un voyage', 'grammar', 'Tout l''étage 3 dans la préparation d''un voyage en Corée' from floors where floor_number = 3
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '3층 보스', 'Boss de l''étage 3', 'boss', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 3 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 한국에 여행 가___ 싶어요.', 'Je veux voyager en Corée.', '고', '["고","어","면","서"]'::jsonb, '가다 + 고 싶어요.', 2, ARRAY['want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 한국어를 조금 할 ___ 있어요.', 'Je peux parler un peu coréen.', '수', '["수","번","데","곳"]'::jsonb, '할 수 있어요 = je peux / je sais.', 2, ARRAY['can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 운전을 ___ 해요.', 'Je ne sais pas conduire.', '못', '["못","않","아니","말"]'::jsonb, '못 + verbe = ne pas pouvoir. Avec 하다 : 운전 못 해요.', 3, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '수업 시간에 전화하지 ___.', 'Ne téléphonez pas pendant le cours.', '마세요', '["마세요","않세요","말세요","안 세요"]'::jsonb, '-지 마세요 = interdiction polie.', 3, ARRAY['honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '같이 공항에 ___?', 'On va à l''aéroport ensemble ?', '갈까요', '["갈까요","가을까요","가까요","가ㄹ까요"]'::jsonb, '가다 + ㄹ까요 : 갈까요.', 3, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '호텔 이름을 ___ 주세요.', 'Écrivez le nom de l''hôtel, s''il vous plaît.', '써', '["써","쓰어","쓰","쓰아"]'::jsonb, '쓰다 : ㅡ tombe → 써 주세요.', 4, ARRAY['request_verb']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase veut dire « Je ne peux pas y aller (je suis empêché(e)) » ?', '못 가요', '["못 가요","안 가요","가고 싶어요","갈까요"]'::jsonb, '못 = empêchement.', 3, ARRAY['negation']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 어디에서 만날까요? » ?', 'Où est-ce qu''on se retrouve ?', '["Où est-ce qu''on se retrouve ?","Où nous sommes-nous retrouvés ?","Je ne veux pas te retrouver","Je ne peux pas te retrouver"]'::jsonb, '-(으)ㄹ까요 = proposition / question sur le plan.', 3, ARRAY['suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Je veux apprendre le coréen en Corée.', '한국에서 한국어를 배우고 싶어요', '["한국에서","한국어를","배우고","싶어요"]'::jsonb, 'Lieu (에서) → objet → verbe + 고 싶어요.', 3, ARRAY['want_to', 'e_vs_eseo', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je veux acheter un billet de train.', '기차표를 사고 싶어요 | 저는 기차표를 사고 싶어요', NULL, '기차표 = billet de train ; 사다 + 고 싶어요.', 3, ARRAY['want_to', 'object_particle']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je ne sais pas nager. Je veux apprendre.', '수영을 못 해요. 배우고 싶어요 | 저는 수영을 못 해요. 배우고 싶어요 | 수영 못 해요. 배우고 싶어요 | 저는 수영 못 해요. 배우고 싶어요', NULL, '못 해요 = je ne sais pas ; 배우고 싶어요 = je veux apprendre.', 4, ARRAY['negation', 'want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '내일 같이 시장에 갈까요? 저는 오늘은 갈 수 없어요.', NULL, 'On va au marché ensemble demain ? Aujourd''hui, je ne peux pas y aller | Et si on allait ensemble au marché demain ? Aujourd''hui, je ne peux pas y aller', NULL, '갈까요 = proposition ; 갈 수 없어요 = je ne peux pas y aller.', 4, ARRAY['suggest', 'can']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '한국에서 한국 음식을 먹고 싶어요', 'Écoute et choisis la phrase entendue', '한국에서 한국 음식을 먹고 싶어요', '["한국에서 한국 음식을 먹고 싶어요","한국에서 한국 음식을 먹었어요","한국에서 한국 음식을 먹을까요","한국에서 한국 음식을 먹을 수 있어요"]'::jsonb, '먹고 싶어요 = je veux manger.', 3, ARRAY['want_to', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Imagine ton voyage en Corée : dis ce que tu veux faire là-bas.', '-고 싶어요 : vouloir faire quelque chose', NULL, 'Exemple : 한국에서 김치를 먹고 싶어요.', 4, ARRAY['want_to', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 3 and u.unit_number = 5 and l.lesson_number = 1;

-- ################ Étage 4 : Raisons et liens ################
insert into floors (floor_number, title_ko, title_fr, cefr_level, description, unlock_xp)
values (4, '이유와 연결', 'Raisons et liens', 'B1', 'Expliquer pourquoi, opposer deux idées, parler de conditions et de moments : relier tes phrases pour de vrai.', 0)
on conflict (floor_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr,
  cefr_level = excluded.cefr_level, description = excluded.description;

-- ---------- Étage 4 · Unité 1 : Dire pourquoi : -아/어서 ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 1, '-아/어서', 'Dire pourquoi : -아/어서', 'grammar', '-아/어서 (cause), 그래서 et 왜' from floors where floor_number = 4
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-아/어서', 'Donner une cause', 'teach', '{"intro":"Jusqu''ici tes phrases étaient courtes et indépendantes. À partir d''ici, tu les relies : d''abord pour dire pourquoi quelque chose arrive.","sections":[{"title":"Radical + 아/어서 — « parce que, donc »","body":"On forme -아/어서 comme le présent poli, mais on remplace 요 par 서 : dernière voyelle ㅏ ou ㅗ → 아서 (좋다 → 좋아서) ; autres voyelles → 어서 (늦다 → 늦어서) ; 하다 → 해서. Si le radical finit par ㅡ, il tombe et on regarde la syllabe d''avant, comme au présent : 고프다 → 고파서, 예쁘다 → 예뻐서. Le sens : la première partie est la cause, la seconde la conséquence. Règle importante : on ne met jamais de temps avant 서 (비가 와서, pas 비가 왔어서), et la fin de phrase ne peut être ni un ordre ni une proposition.","examples":[{"ko":"비가 와서 집에 있어요.","rom":"bi-ga wa-seo ji-be i-sseo-yo","fr":"Il pleut, donc je reste à la maison."},{"ko":"피곤해서 일찍 잤어요.","rom":"pi-gon-hae-seo il-jjik ja-sseo-yo","fr":"J''étais fatigué(e), alors j''ai dormi tôt."},{"ko":"배가 고파서 빵을 샀어요.","rom":"bae-ga go-pa-seo ppang-eul sa-sseo-yo","fr":"J''avais faim, alors j''ai acheté du pain."},{"ko":"늦어서 미안해요.","rom":"neu-jeo-seo mi-an-hae-yo","fr":"Désolé(e) d''être en retard."}]},{"title":"그래서 et 왜 — « donc » et « pourquoi »","body":"그래서 relie deux phrases : on le met au début de la seconde. 왜 ? signifie « pourquoi ? » ; on répond souvent avec -아/어서요.","examples":[{"ko":"비가 와요. 그래서 집에 있어요.","rom":"bi-ga wa-yo. geu-rae-seo ji-be i-sseo-yo","fr":"Il pleut. Donc je reste à la maison."},{"ko":"왜 한국어를 배워요?","rom":"wae han-gu-geo-reul bae-wo-yo","fr":"Pourquoi apprends-tu le coréen ?"},{"ko":"한국 드라마를 좋아해서요.","rom":"han-guk deu-ra-ma-reul jo-a-hae-seo-yo","fr":"Parce que j''aime les dramas coréens."}]}],"tip":"S''excuser ou remercier passe toujours par -아/어서 : 늦어서 미안해요. Et retiens le piège : jamais de passé avant 서, le temps se met à la fin de la phrase."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '비가 와___ 집에 있어요.', 'Il pleut, donc je reste à la maison.', '서', '["서","면","러","까"]'::jsonb, '오다 : 오 + 아 → 와, puis 서 : 와서.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '피곤___ 일찍 잤어요.', 'J''étais fatigué(e), alors j''ai dormi tôt.', '해서', '["해서","하서","했서","해어서"]'::jsonb, '하다 → 해서.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '늦___ 미안해요.', 'Désolé(e) d''être en retard.', '어서', '["어서","아서","해서","여서"]'::jsonb, '늦다 : dernière voyelle ㅡ → 어서 : 늦어서.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '배가 ___ 빵을 샀어요.', 'J''avais faim, alors j''ai acheté du pain.', '고파서', '["고파서","고프어서","고프서","고픈서"]'::jsonb, '고프다 : ㅡ tombe, voyelle précédente ㅗ → 아서 : 고파서.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Avec -아/어서, la fin de la phrase ne peut PAS être :', 'un ordre (-(으)세요)', '["un ordre (-(으)세요)","un verbe au passé","un verbe au présent","une négation"]'::jsonb, 'Après -아/어서, ni ordre ni proposition (on utilisera -(으)니까, voir l''unité suivante).', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 왜 » ?', 'Pourquoi', '["Pourquoi","Quand","Où","Qui"]'::jsonb, '왜 = pourquoi.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Il pleut, donc je reste à la maison.', '비가 와서 집에 있어요 | 비가 와요. 그래서 집에 있어요', NULL, '와서 = parce qu''il pleut ; 그래서 = donc.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'J''étais fatigué(e), alors j''ai dormi tôt.', '피곤해서 일찍 잤어요', '["피곤해서","일찍","잤어요"]'::jsonb, 'Cause avec 서 → complément → verbe au passé.', 2, ARRAY['reason', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '-아/어서 연습', 'Entraînement : donner une cause', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '날씨가 좋___ 공원에 갔어요.', 'Il faisait beau, alors je suis allé(e) au parc.', '아서', '["아서","어서","해서","와서"]'::jsonb, '좋다 : dernière voyelle ㅗ → 아서.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '음식이 맛있___ 많이 먹었어요.', 'C''était délicieux, alors j''ai beaucoup mangé.', '어서', '["어서","아서","해서","있서"]'::jsonb, '맛있다 : dernière voyelle ㅣ → 어서.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '시간이 없___ 택시를 탔어요.', 'Je n''avais pas le temps, alors j''ai pris un taxi.', '어서', '["어서","아서","해서","없서"]'::jsonb, '없다 : dernière voyelle ㅓ → 어서.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '일이 많___ 바빠요.', 'J''ai beaucoup de travail, donc je suis occupé(e).', '아서', '["아서","어서","해서","많서"]'::jsonb, '많다 : dernière voyelle ㅏ → 아서.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '비가 와요. ___ 집에 있어요.', 'Il pleut. Donc je reste à la maison.', '그래서', '["그래서","하지만","그런데","그러면"]'::jsonb, '그래서 = donc, c''est pourquoi.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '피곤해서 일찍 잤어요', '["피곤해서 일찍 잤어요","피곤했어서 일찍 잤어요","피곤해서 일찍 자세요","피곤해서 일찍 잘까요"]'::jsonb, 'Pas de passé avant 서 ; après 서, ni ordre ni proposition.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment demande-t-on « Pourquoi ? » ?', '왜요?', '["왜요?","뭐요?","어디요?","언제요?"]'::jsonb, '왜 = pourquoi.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '비가 와서 집에 있어요', 'Écoute et choisis la phrase entendue', '비가 와서 집에 있어요', '["비가 와서 집에 있어요","비가 와요. 그래서 집에 갔어요","비가 와서 집에 없어요","비가 오면 집에 있어요"]'::jsonb, '와서 = parce qu''il pleut. Écoute bien la forme du verbe.', 2, ARRAY['reason', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Désolé(e) d''être en retard.', '늦어서 미안해요 | 늦어서 죄송해요', NULL, '늦어서 = parce que je suis en retard.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Il faisait beau, alors j''ai fait du sport au parc.', '날씨가 좋아서 공원에서 운동했어요 | 날씨가 좋아서 공원에서 운동을 했어요', NULL, '좋아서 + 공원에서 (lieu d''une action) + 운동했어요.', 3, ARRAY['reason', 'e_vs_eseo']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis pourquoi tu apprends le coréen (une phrase avec -아/어서).', '-아/어서 : donner une raison', NULL, 'Exemple : 한국 드라마를 좋아해서 한국어를 배워요.', 3, ARRAY['reason', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 1 and l.lesson_number = 2;

-- ---------- Étage 4 · Unité 2 : Une raison pour proposer ou ordonner : -(으)니까 ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 2, '-(으)니까', 'Une raison pour proposer ou ordonner : -(으)니까', 'grammar', '-(으)니까, et quand le choisir à la place de -아/어서' from floors where floor_number = 4
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-(으)니까', 'Donner une raison avant un ordre ou une proposition', 'teach', '{"intro":"-아/어서 a une limite : après lui, impossible d''ordonner ou de proposer. Pour dire « Il pleut, prenez un parapluie » ou « Je suis occupé(e), voyons-nous demain ? », il faut un autre outil.","sections":[{"title":"Radical + (으)니까 — « comme, puisque »","body":"Radical qui finit par une voyelle : + 니까 (바쁘다 → 바쁘니까). Par une consonne : + 으니까 (없다 → 없으니까). Radical en ㄹ : le ㄹ tombe (살다 → 사니까, 멀다 → 머니까). Contrairement à 서, on peut mettre le passé (늦었으니까), et la fin de la phrase peut être un ordre ou une proposition. On rencontre aussi -(으)니, sans 까 : même sens, registre plus écrit (늦었으니 빨리 가요).","examples":[{"ko":"비가 오니까 우산을 가져가세요.","rom":"bi-ga o-ni-kka u-sa-neul ga-jyeo-ga-se-yo","fr":"Il pleut, prenez un parapluie."},{"ko":"오늘은 바쁘니까 내일 만날까요?","rom":"o-neu-reun ba-ppeu-ni-kka nae-il man-nal-kka-yo","fr":"Aujourd''hui, je suis occupé(e) : on se voit demain ?"},{"ko":"늦었으니까 빨리 가요.","rom":"neu-jeo-sseu-ni-kka ppal-li ga-yo","fr":"Il est tard, partons vite."},{"ko":"서울에 사니까 서울을 잘 알아요.","rom":"seo-u-re sa-ni-kka seo-u-reul jal a-ra-yo","fr":"J''habite à Séoul, donc je connais bien Séoul."}]},{"title":"-아/어서 ou -(으)니까 ?","body":"Si la fin de ta phrase est un ordre (-(으)세요) ou une proposition (-(으)ㄹ까요, -아/어요 « allons-y »), choisis -(으)니까. Pour un simple lien de cause, -아/어서 est plus courant et plus neutre. Pour s''excuser ou remercier, toujours -아/어서.","examples":[{"ko":"시간이 없으니까 택시를 타세요.","rom":"si-ga-ni eop-sseu-ni-kka taek-si-reul ta-se-yo","fr":"Vous n''avez pas le temps, prenez un taxi."}]}],"tip":"Test rapide : ta phrase finit par un ordre ou une proposition ? → -(으)니까. Ta phrase finit par une information, une excuse ou un remerciement ? → -아/어서."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '비가 오___ 우산을 가져가세요.', 'Il pleut, prenez un parapluie.', '니까', '["니까","러","아서","서"]'::jsonb, '오다 finit par une voyelle → 니까.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '시간이 없___ 빨리 가요.', 'On n''a pas le temps, partons vite.', '으니까', '["으니까","니까","어서","으러"]'::jsonb, '없다 finit par une consonne → 으니까.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '오늘은 바쁘___ 내일 만날까요?', 'Aujourd''hui, je suis occupé(e) : on se voit demain ?', '니까', '["니까","으니까","아서","어서"]'::jsonb, '바쁘다 finit par une voyelle (ㅡ) → 니까 ; 서 est impossible avant une proposition.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 서울에 ___ 서울을 잘 알아요.', 'J''habite à Séoul, donc je connais bien Séoul.', '사니까', '["사니까","살니까","살으니까","사으니까"]'::jsonb, '살다 (radical en ㄹ) : le ㄹ tombe devant 니까.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Avec -(으)니까, la fin de la phrase peut être :', 'un ordre ou une proposition', '["un ordre ou une proposition","seulement un verbe au passé","seulement une question","jamais un ordre"]'::jsonb, 'C''est justement la différence avec -아/어서.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '늦었으니까 빨리 가요', '["늦었으니까 빨리 가요","늦었어서 빨리 가요","늦으니까니 빨리 가요","늦었니까니 빨리 가요"]'::jsonb, 'Le passé est possible avec -(으)니까, jamais avec 서.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Il pleut, prenez un parapluie.', '비가 오니까 우산을 가져가세요 | 비가 오니까 우산 가져가세요', NULL, '오니까 + ordre en -(으)세요.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '바쁘니까 내일 만날까요?', NULL, 'Comme je suis occupé(e), on se voit demain ? | Je suis occupé(e), alors on se voit demain ? | Je suis occupé(e), alors et si on se voyait demain ?', NULL, '바쁘니까 = comme je suis occupé(e) ; 만날까요 = proposition.', 2, ARRAY['reason', 'suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '-(으)니까 연습', 'Entraînement : raison avant un ordre', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '너무 많이 먹었___ 좀 쉬어요.', 'On a trop mangé, reposons-nous un peu.', '으니까', '["으니까","니까","어서","서"]'::jsonb, '먹었다 finit par une consonne (ㅆ) → 으니까.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '길이 ___ 택시를 타세요.', 'C''est loin, prenez un taxi.', '머니까', '["머니까","멀으니까","멀니까","머서"]'::jsonb, '멀다 (radical en ㄹ) : le ㄹ tombe devant 니까.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '피곤하니까 일찍 ___.', 'Vous êtes fatigué(e), reposez-vous tôt.', '쉬세요', '["쉬세요","쉬으세요","쉬어세요","쉬요세요"]'::jsonb, '쉬다 finit par une voyelle → 세요.', 1, ARRAY['reason', 'honorific']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '시간이 없으니까 택시를 타세요', '["시간이 없으니까 택시를 타세요","시간이 없어서 택시를 타세요","시간이 없었어서 택시를 타세요","시간이 없으니 택시까를 타세요"]'::jsonb, 'Ordre à la fin → -(으)니까, pas 서.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Pour donner une raison avant un ordre (« Dépêchez-vous, il est tard ! »), on utilise :', '-(으)니까', '["-(으)니까","-아/어서","-고","-지만"]'::jsonb, '-(으)니까 accepte les ordres et les propositions.', 1, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '비가 오니까 우산을 가져가세요', 'Écoute et choisis la phrase entendue', '비가 오니까 우산을 가져가세요', '["비가 오니까 우산을 가져가세요","비가 와서 우산을 가져갔어요","비가 오니까 우산을 샀어요","비가 오면 우산을 가져가세요"]'::jsonb, '오니까 + -(으)세요. Écoute bien la fin.', 2, ARRAY['reason', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Il est tard, partons vite.', '늦었으니까 빨리 가요 | 시간이 늦었으니까 빨리 가요 | 늦었으니 빨리 가요', NULL, '늦었으니까 : passé + 으니까.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Il fait beau, allons au parc ensemble.', '날씨가 좋으니까 같이 공원에 가요 | 날씨가 좋으니까 같이 공원에 갈까요 | 날씨가 좋으니까 공원에 같이 가요', NULL, '좋으니까 + proposition.', 3, ARRAY['reason', 'suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '피곤하니까 일찍 쉬세요.', NULL, 'Vous êtes fatigué(e), reposez-vous tôt | Comme vous êtes fatigué(e), reposez-vous tôt', NULL, '피곤하니까 = comme tu es fatigué(e) ; 쉬세요 = repose-toi.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Propose à un ami de faire quelque chose en donnant une raison avec -(으)니까.', '-(으)니까 : raison + proposition', NULL, 'Exemple : 날씨가 좋으니까 같이 산책할까요?', 4, ARRAY['reason', 'suggest', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 2 and l.lesson_number = 2;

-- ---------- Étage 4 · Unité 3 : Opposer deux idées : -지만 ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 3, '-지만', 'Opposer deux idées : -지만', 'grammar', '-지만, 하지만, 그런데' from floors where floor_number = 4
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-지만', 'Dire « mais »', 'teach', '{"intro":"Les raisons, c''est fait. Maintenant, les contrastes : « c''est bon mais cher », « je suis fatigué mais je viens ». Bonne surprise : -지만 est la forme la plus régulière du coréen.","sections":[{"title":"Radical + 지만 — « mais »","body":"On colle 지만 directement au radical, sans rien changer : 먹다 → 먹지만, 좋다 → 좋지만, 하다 → 하지만. Pas de voyelle ou de consonne à surveiller, pas de ㅡ qui tombe. Pour le passé, on met 았/었 avant : 왔지만, 먹었지만.","examples":[{"ko":"이 음식은 맛있지만 비싸요.","rom":"i eum-si-geun ma-sit-ji-man bi-ssa-yo","fr":"Ce plat est délicieux mais cher."},{"ko":"한국어는 어렵지만 재미있어요.","rom":"han-gu-geo-neun eo-ryeop-ji-man jae-mi-i-sseo-yo","fr":"Le coréen est difficile mais amusant."},{"ko":"저는 수영은 못 하지만 운동은 좋아해요.","rom":"jeo-neun su-yeong-eun mot ha-ji-man un-dong-eun jo-a-hae-yo","fr":"Je ne sais pas nager, mais j''aime le sport."},{"ko":"비가 왔지만 갔어요.","rom":"bi-ga wat-ji-man ga-sseo-yo","fr":"Il pleuvait, mais j''y suis allé(e)."}]},{"title":"Au début d''une phrase : 하지만 et 그런데","body":"Pour commencer une nouvelle phrase, 하지만 veut dire « mais, cependant » (opposition nette). 그런데 est plus souple : « mais », « or », ou « au fait » pour changer de sujet.","examples":[{"ko":"저는 커피를 좋아해요. 하지만 오늘은 마시고 싶지 않아요.","rom":"jeo-neun keo-pi-reul jo-a-hae-yo. ha-ji-man o-neu-reun ma-si-go sip-ji a-na-yo","fr":"J''aime le café. Mais aujourd''hui, je ne veux pas en boire."},{"ko":"오늘 날씨가 좋아요. 그런데 너무 바빠요.","rom":"o-neul nal-ssi-ga jo-a-yo. geu-reon-de neo-mu ba-ppa-yo","fr":"Il fait beau aujourd''hui. Mais je suis très occupé(e)."}]}],"tip":"-지만 se colle au radical, sans condition. Il relie DEUX PARTIES d''une phrase ; 하지만 et 그런데 relient DEUX PHRASES."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 음식은 맛있___ 비싸요.', 'Ce plat est délicieux mais cher.', '지만', '["지만","아서","니까","면서"]'::jsonb, '-지만 se colle au radical : 맛있 + 지만.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국어는 어렵___ 재미있어요.', 'Le coréen est difficile mais amusant.', '지만', '["지만","어서","으니까","고서"]'::jsonb, '어렵 + 지만, sans autre changement.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 커피를 좋아해요. ___ 오늘은 마시고 싶지 않아요.', 'J''aime le café. Mais aujourd''hui, je ne veux pas en boire.', '하지만', '["하지만","그래서","그리고","그러면"]'::jsonb, '하지만 = mais (début de phrase).', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '오늘 날씨가 좋아요. ___ 너무 바빠요.', 'Il fait beau aujourd''hui. Mais je suis très occupé(e).', '그런데', '["그런데","그래서","그리고","그러니까"]'::jsonb, '그런데 = mais / or (début de phrase).', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « -지만 » ?', 'mais', '["mais","parce que","si","quand"]'::jsonb, '-지만 oppose deux idées.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on « Il pleuvait, mais j''y suis allé(e) » ?', '비가 왔지만 갔어요', '["비가 왔지만 갔어요","비가 왔서 갔어요","비가 와지만 갔어요","비가 왔지만이 갔어요"]'::jsonb, 'Passé : 왔 + 지만.', 2, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Ce plat est délicieux mais cher.', '이 음식은 맛있지만 비싸요 | 음식이 맛있지만 비싸요', NULL, '맛있다 + 지만 ; 비싸요 = c''est cher.', 2, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Le coréen est difficile mais amusant.', '한국어는 어렵지만 재미있어요', '["한국어는","어렵지만","재미있어요"]'::jsonb, 'Thème → adjectif + 지만 → second adjectif.', 2, ARRAY['contrast', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '-지만 연습', 'Entraînement : opposer deux idées', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 고기를 좋아하___ 생선은 안 먹어요.', 'J''aime la viande, mais je ne mange pas de poisson.', '지만', '["지만","아서","어서","러"]'::jsonb, '좋아하다 + 지만.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 수영은 못 하___ 운동은 좋아해요.', 'Je ne sais pas nager, mais j''aime le sport.', '지만', '["지만","아서","어서","러"]'::jsonb, '하다 + 지만.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '집은 작___ 깨끗해요.', 'La maison est petite mais propre.', '지만', '["지만","면서","고서","니서"]'::jsonb, '작다 + 지만, sans changement.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '주말에 쉬고 싶어요. ___ 일이 많아요.', 'Je veux me reposer ce week-end. Mais j''ai beaucoup de travail.', '하지만', '["하지만","그래서","그리고","그러니까"]'::jsonb, '하지만 = mais.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '비싸지만 맛있어요', '["비싸지만 맛있어요","비싸지만이 맛있어요","비싸지마 맛있어요","비싸자만 맛있어요"]'::jsonb, '비싸다 + 지만.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quel mot signifie « mais » et se place au début d''une phrase ?', '하지만', '["하지만","-지만","-아서","-고"]'::jsonb, '하지만 commence une phrase ; -지만 se colle au radical.', 1, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '이 음식은 맛있지만 비싸요', 'Écoute et choisis la phrase entendue', '이 음식은 맛있지만 비싸요', '["이 음식은 맛있지만 비싸요","이 음식은 맛없지만 비싸요","이 음식은 맛있지만 싸요","이 음식은 맛있어서 비싸요"]'::jsonb, '맛있다 (bon) ≠ 맛없다 (pas bon) ; 비싸다 (cher) ≠ 싸다 (bon marché).', 3, ARRAY['contrast', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'J''aime le café, mais aujourd''hui je ne veux pas en boire.', '커피를 좋아하지만 오늘은 마시고 싶지 않아요 | 저는 커피를 좋아하지만 오늘은 마시고 싶지 않아요 | 커피는 좋아하지만 오늘은 마시고 싶지 않아요 | 저는 커피는 좋아하지만 오늘은 마시고 싶지 않아요', NULL, '좋아하다 + 지만 ; 마시고 싶지 않아요 = je ne veux pas boire.', 4, ARRAY['contrast', 'want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Il fait beau, mais je suis très occupé(e).', '날씨가 좋지만 너무 바빠요 | 날씨는 좋지만 너무 바빠요 | 날씨가 좋지만 아주 바빠요 | 날씨는 좋지만 아주 바빠요 | 날씨가 좋지만 정말 바빠요', NULL, '좋다 + 지만 ; 너무 / 아주 / 정말 = très.', 3, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Décris quelque chose (un plat, une ville…) avec un bon et un mauvais côté, en utilisant -지만.', '-지만 : relier deux idées opposées', NULL, 'Exemple : 서울은 복잡하지만 재미있어요.', 4, ARRAY['contrast', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 3 and l.lesson_number = 2;

-- ---------- Étage 4 · Unité 4 : Conditions et moments ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 4, '-(으)면 · -(으)ㄹ 때', 'Conditions et moments', 'grammar', '-(으)면 (si) et -(으)ㄹ 때 (quand)' from floors where floor_number = 4
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-(으)면 · -(으)ㄹ 때', 'Si… et quand…', 'teach', '{"intro":"Deux petits mots pour parler de conditions (« s''il pleut, je reste ») et de moments (« quand je suis fatigué(e), je bois un café »). Ils servent partout, du plan de week-end à la conversation de tous les jours.","sections":[{"title":"Radical + (으)면 — « si »","body":"Radical qui finit par une voyelle : + 면 (오다 → 오면, 하다 → 하면). Par une consonne : + 으면 (있다 → 있으면, 좋다 → 좋으면). Radical en ㄹ : + 면 (살다 → 살면). La fin de la phrase peut être un futur, un ordre ou une proposition.","examples":[{"ko":"시간이 있으면 같이 가요.","rom":"si-ga-ni i-sseu-myeon ga-chi ga-yo","fr":"Si tu as le temps, allons-y ensemble."},{"ko":"비가 오면 집에 있을 거예요.","rom":"bi-ga o-myeon ji-be i-sseul geo-ye-yo","fr":"S''il pleut, je resterai à la maison."},{"ko":"피곤하면 쉬세요.","rom":"pi-gon-ha-myeon swi-se-yo","fr":"Si vous êtes fatigué(e), reposez-vous."},{"ko":"한국에 가면 김치를 먹고 싶어요.","rom":"han-gu-ge ga-myeon gim-chi-reul meok-go si-peo-yo","fr":"Si je vais en Corée, je veux manger du kimchi."}]},{"title":"Radical + (으)ㄹ 때 — « quand, au moment où »","body":"Radical qui finit par une voyelle ou par ㄹ : + ㄹ 때 (심심하다 → 심심할 때). Par une consonne : + 을 때 (있다 → 있을 때). 때 est un nom qui veut dire « moment » : on décrit le moment avec le verbe qui précède. C''est la fin de la phrase qui donne le temps.","examples":[{"ko":"심심할 때 영화를 봐요.","rom":"sim-sim-hal ttae yeong-hwa-reul bwa-yo","fr":"Quand je m''ennuie, je regarde un film."},{"ko":"시간이 있을 때 책을 읽어요.","rom":"si-ga-ni i-sseul ttae chae-geul il-geo-yo","fr":"Quand j''ai le temps, je lis."},{"ko":"한국에 갈 때 비행기를 타요.","rom":"han-gu-ge gal ttae bi-haeng-gi-reul ta-yo","fr":"Quand je vais en Corée, je prends l''avion."},{"ko":"피곤할 때 커피를 마셔요.","rom":"pi-gon-hal ttae keo-pi-reul ma-syeo-yo","fr":"Quand je suis fatigué(e), je bois un café."}]}],"tip":"-(으)면 pose une condition (« si »), -(으)ㄹ 때 un moment (« quand »). Pour un moment passé, on ajoute 았/었 avant : 갔을 때 (quand j''y suis allé(e)). Attention : 갈 때 = au moment d''y aller (le trajet) ; 갔을 때 = une fois là-bas. Pour « quand je serai en Corée », dis 한국에 가면."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '시간이 있___ 같이 가요.', 'Si tu as le temps, allons-y ensemble.', '으면', '["으면","면","어면","으며"]'::jsonb, '있다 finit par une consonne → 으면.', 1, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '비가 ___ 집에 있을 거예요.', 'S''il pleut, je resterai à la maison.', '오면', '["오면","오으면","와면","오서"]'::jsonb, '오다 finit par une voyelle → 면.', 1, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '피곤___ 쉬세요.', 'Si vous êtes fatigué(e), reposez-vous.', '하면', '["하면","해면","하으면","하서"]'::jsonb, '하다 + 면.', 1, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '___ 때 영화를 봐요.', 'Quand je m''ennuie, je regarde un film.', '심심할', '["심심할","심심하을","심심해","심심하"]'::jsonb, '심심하다 finit par une voyelle → ㄹ 때 : 심심할 때.', 2, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '시간이 있___ 때 책을 읽어요.', 'Quand j''ai le temps, je lis.', '을', '["을","으","아","어"]'::jsonb, '있다 finit par une consonne → 을 때.', 2, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « -(으)면 » ?', 'si (condition)', '["si (condition)","parce que","mais","pour"]'::jsonb, '-(으)면 pose une condition.', 1, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 때 » dans « 피곤할 때 » ?', 'au moment où, quand', '["au moment où, quand","si","parce que","mais"]'::jsonb, '때 = moment.', 1, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Si je vais en Corée, je veux manger du kimchi.', '한국에 가면 김치를 먹고 싶어요 | 저는 한국에 가면 김치를 먹고 싶어요', NULL, '가면 = si je vais ; 먹고 싶어요 = je veux manger.', 3, ARRAY['conditional', 'want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Si tu as le temps, allons-y ensemble.', '시간이 있으면 같이 가요', '["시간이","있으면","같이","가요"]'::jsonb, 'Condition en -(으)면 → conséquence.', 2, ARRAY['conditional', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '-(으)면 · -(으)ㄹ 때 연습', 'Entraînement : si et quand', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일 비가 ___ 뭐 할 거예요?', 'S''il pleut demain, que feras-tu ?', '오면', '["오면","오으면","와면","오는면"]'::jsonb, '오다 + 면.', 1, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '주말에 시간이 ___ 뭐 하고 싶어요?', 'Si tu as du temps ce week-end, que veux-tu faire ?', '있으면', '["있으면","있면","있어면","있으며"]'::jsonb, '있다 + 으면.', 1, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국에 ___ 때 비행기를 타요.', 'Quand je vais en Corée, je prends l''avion.', '갈', '["갈","가","가을","갔"]'::jsonb, '가다 + ㄹ 때 : 갈 때.', 2, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '배가 고플 ___ 빵을 먹어요.', 'Quand j''ai faim, je mange du pain.', '때', '["때","면","서","까"]'::jsonb, '고플 때 = quand j''ai faim.', 1, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '시간이 있을 때 전화하세요', '["시간이 있을 때 전화하세요","시간이 있어 때 전화하세요","시간이 있을면 전화하세요","시간이 있으 때 전화하세요"]'::jsonb, '있다 + 을 때.', 2, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on « S''il fait beau, allons au parc » ?', '날씨가 좋으면 공원에 가요', '["날씨가 좋으면 공원에 가요","날씨가 좋때 공원에 가요","날씨가 좋으니면 공원에 가요","날씨가 좋아면 공원에 가요"]'::jsonb, '좋다 : consonne finale → 으면.', 2, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '비가 오면 집에 있어요', 'Écoute et choisis la phrase entendue', '비가 오면 집에 있어요', '["비가 오면 집에 있어요","비가 와서 집에 있어요","비가 올 때 집에 있어요","비가 오면 집에 없어요"]'::jsonb, '오면 = si il pleut. Écoute la terminaison du verbe.', 2, ARRAY['conditional', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'S''il pleut demain, je resterai à la maison.', '내일 비가 오면 집에 있을 거예요 | 비가 오면 내일 집에 있을 거예요', NULL, '오면 + 있을 거예요 (futur).', 3, ARRAY['conditional', 'future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Quand j''ai faim, je mange du pain.', '배가 고플 때 빵을 먹어요 | 배고플 때 빵을 먹어요', NULL, '고프다 + ㄹ 때.', 3, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis ce que tu fais quand tu es fatigué(e), ou quand tu as du temps.', '-(으)ㄹ 때 ou -(으)면', NULL, 'Exemple : 시간이 있을 때 영화를 봐요.', 4, ARRAY['when', 'conditional', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 4 and l.lesson_number = 2;

-- ---------- Étage 4 · Unité 5 : Boss : le rendez-vous sous la pluie ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 5, '약속', 'Boss : le rendez-vous sous la pluie', 'grammar', 'Tout l''étage 4 : raisons, contrastes et conditions autour d''un rendez-vous' from floors where floor_number = 4
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '4층 보스', 'Boss de l''étage 4', 'boss', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 4 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '비가 와___ 집에 있었어요.', 'Il pleuvait, alors je suis resté(e) à la maison.', '서', '["서","면","러","까"]'::jsonb, '와서 : cause ; le passé se met à la fin.', 2, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '길이 막히___ 택시를 타지 마세요.', 'Il y a des bouchons, ne prenez pas de taxi.', '니까', '["니까","서","아서","으니까"]'::jsonb, '막히다 finit par une voyelle → 니까 ; ordre à la fin → pas de 서.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 가방은 예쁘___ 비싸요.', 'Ce sac est joli mais cher.', '지만', '["지만","아서","고서","니서"]'::jsonb, '예쁘다 + 지만.', 2, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '시간이 있___ 같이 영화 볼까요?', 'Si tu as le temps, on va voir un film ?', '으면', '["으면","면","어면","으니면"]'::jsonb, '있다 + 으면.', 3, ARRAY['conditional']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '___ 때는 전화하지 마세요.', 'Quand je suis occupé(e), ne m''appelez pas.', '바쁠', '["바쁠","바쁘","바빠","바쁘을"]'::jsonb, '바쁘다 + ㄹ 때 : 바쁠 때.', 3, ARRAY['when']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '늦어서 미안해요', '["늦어서 미안해요","늦었어서 미안해요","늦으니서 미안해요","늦고서서 미안해요"]'::jsonb, 'Pas de passé avant 서.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 그런데 » au début d''une phrase ?', 'mais, or (ou « au fait »)', '["mais, or (ou « au fait »)","parce que","donc","si"]'::jsonb, '그런데 oppose ou change de sujet.', 2, ARRAY['contrast']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'S''il pleut demain, je resterai à la maison.', '내일 비가 오면 집에 있을 거예요', '["내일","비가","오면","집에","있을","거예요"]'::jsonb, 'Moment → condition en -(으)면 → conséquence au futur.', 3, ARRAY['conditional', 'future', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je suis fatigué(e), alors je vais me coucher tôt.', '피곤해서 일찍 잘 거예요 | 저는 피곤해서 일찍 잘 거예요', NULL, '피곤해서 + 일찍 잘 거예요 (futur de 자다).', 3, ARRAY['reason', 'future']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Le coréen est difficile, mais je veux l''apprendre.', '한국어는 어렵지만 배우고 싶어요 | 한국어는 어렵지만 저는 배우고 싶어요 | 한국어가 어렵지만 배우고 싶어요', NULL, '어렵지만 + 배우고 싶어요.', 3, ARRAY['contrast', 'want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'S''il fait beau demain, allons au parc ensemble.', '내일 날씨가 좋으면 같이 공원에 가요 | 내일 날씨가 좋으면 같이 공원에 갈까요 | 내일 날씨가 좋으면 공원에 같이 가요', NULL, '좋으면 + 같이 가요 / 갈까요.', 4, ARRAY['conditional', 'suggest']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '시간이 없으니까 택시를 타세요.', NULL, 'Vous n''avez pas le temps, prenez un taxi | Comme vous n''avez pas le temps, prenez un taxi | Il n''y a pas le temps, alors prenez un taxi', NULL, '없으니까 + 타세요.', 3, ARRAY['reason']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '피곤하지만 오늘은 운동하고 싶어요', 'Écoute et choisis la phrase entendue', '피곤하지만 오늘은 운동하고 싶어요', '["피곤하지만 오늘은 운동하고 싶어요","피곤해서 오늘은 운동하고 싶지 않아요","피곤하면 오늘은 운동하고 싶어요","피곤하니까 오늘은 운동하세요"]'::jsonb, '피곤하지만 = fatigué(e) mais… Écoute la liaison au début.', 4, ARRAY['contrast', 'want_to', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Raconte une journée : une raison (-아/어서) et un contraste (-지만) dans la même réponse.', '-아/어서 et -지만', NULL, 'Exemple : 비가 와서 집에 있었지만 재미있었어요.', 4, ARRAY['reason', 'contrast', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 4 and u.unit_number = 5 and l.lesson_number = 1;

-- ################ Étage 5 : Expériences et comparaisons ################
insert into floors (floor_number, title_ko, title_fr, cefr_level, description, unlock_xp)
values (5, '경험과 비교', 'Expériences et comparaisons', 'B1', 'Raconter ce que tu as déjà essayé, dire ce que tu fais en ce moment, comparer, et décrire un nom avec un verbe ou un adjectif.', 0)
on conflict (floor_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr,
  cefr_level = excluded.cefr_level, description = excluded.description;

-- ---------- Étage 5 · Unité 1 : Parler d'expériences ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 1, '-아/어 보다', 'Parler d''expériences', 'grammar', '-아/어 보다 (essayer) et -(으)ㄴ 적이 있어요 (avoir déjà fait)' from floors where floor_number = 5
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-아/어 봤어요 · -(으)ㄴ 적이 있어요', 'Essayer et avoir déjà fait', 'teach', '{"intro":"« Tu as déjà goûté le kimchi ? » « Tu es déjà allé(e) en Corée ? » : ce sont les questions de base pour apprendre à connaître quelqu''un. Deux structures te donnent la réponse.","sections":[{"title":"-아/어 보다 — « essayer de, goûter à »","body":"On conjugue le verbe comme au présent poli, sans le 요 (먹다 → 먹어, 가다 → 가, 입다 → 입어), puis on ajoute 보다. 먹어 보세요 : goûtez-le. 먹어 봤어요 : j''ai déjà goûté. 가 보고 싶어요 : j''aimerais aller voir.","examples":[{"ko":"김치를 먹어 봤어요.","rom":"gim-chi-reul meo-geo bwa-sseo-yo","fr":"J''ai déjà goûté le kimchi."},{"ko":"이거 한번 먹어 보세요.","rom":"i-geo han-beon meo-geo bo-se-yo","fr":"Goûtez ça une fois."},{"ko":"한국에 가 보고 싶어요.","rom":"han-gu-ge ga bo-go si-peo-yo","fr":"J''aimerais aller voir la Corée."},{"ko":"한국에 가 봤어요?","rom":"han-gu-ge ga bwa-sseo-yo","fr":"Es-tu déjà allé(e) en Corée ?"}]},{"title":"-(으)ㄴ 적이 있어요 / 없어요 — « ça m''est déjà arrivé »","body":"Radical qui finit par une voyelle : + ㄴ 적이 있어요 (가다 → 간 적이 있어요). Par une consonne : + 은 적이 있어요 (먹다 → 먹은 적이 있어요). Radical en ㄹ : le ㄹ tombe (만들다 → 만든 적이 있어요). Le contraire : 적이 없어요 (« jamais »). On l''associe souvent à -아/어 보다 : 가 본 적이 있어요.","examples":[{"ko":"한국에 가 본 적이 있어요.","rom":"han-gu-ge ga bon jeo-gi i-sseo-yo","fr":"Je suis déjà allé(e) en Corée."},{"ko":"한국 영화를 본 적이 없어요.","rom":"han-guk yeong-hwa-reul bon jeo-gi eop-sseo-yo","fr":"Je n''ai jamais vu de film coréen."}]}],"tip":"-아/어 봤어요 = « j''ai déjà essayé ». -(으)ㄴ 적이 있어요 = « ça m''est déjà arrivé / je l''ai déjà fait ». Les deux répondent à « Tu as déjà… ? »."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이거 한번 먹어 ___.', 'Goûtez ça une fois.', '보세요', '["보세요","봐세요","보어요","보세"]'::jsonb, '먹어 + 보세요 : essayez de manger.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '김치를 먹어 ___.', 'J''ai déjà goûté le kimchi.', '봤어요', '["봤어요","보았요","봤요","보세요"]'::jsonb, '보다 → 봤어요 (passé).', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국에 가 본 ___ 있어요.', 'Je suis déjà allé(e) en Corée.', '적이', '["적이","수가","거가","번이"]'::jsonb, '-(으)ㄴ 적이 있어요 : avoir déjà fait.', 2, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국 영화를 본 적이 ___.', 'Je n''ai jamais vu de film coréen.', '없어요', '["없어요","않아요","아니에요","안 있어요"]'::jsonb, '적이 없어요 = je ne l''ai jamais fait.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 한국에 가 봤어요? » ?', 'Es-tu déjà allé(e) en Corée ?', '["Es-tu déjà allé(e) en Corée ?","Veux-tu aller en Corée ?","Iras-tu en Corée ?","Pourquoi vas-tu en Corée ?"]'::jsonb, '가 봤어요 = as-tu déjà fait l''expérience d''y aller.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on « Je n''ai jamais goûté de kimchi » ?', '김치를 먹어 본 적이 없어요', '["김치를 먹어 본 적이 없어요","김치를 먹어 본 적이 안 있어요","김치를 먹은 적이 안요","김치를 먹어 봐요 없어요"]'::jsonb, '적이 없어요 = jamais.', 3, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'J''ai déjà vu un film coréen.', '한국 영화를 본 적이 있어요 | 한국 영화를 봐 본 적이 있어요', NULL, '보다 → 본 적이 있어요.', 3, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Goûtez ça !', '이거 먹어 보세요 | 이거 한번 먹어 보세요 | 한번 먹어 보세요', NULL, '먹어 + 보세요.', 2, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'J''ai déjà goûté du bibimbap.', '비빔밥을 먹어 봤어요', '["비빔밥을","먹어","봤어요"]'::jsonb, 'Objet → verbe conjugué → 봤어요.', 2, ARRAY['experience', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '경험 연습', 'Entraînement : expériences', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 1
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한복을 입어 ___.', 'J''ai déjà essayé un hanbok.', '봤어요', '["봤어요","보았요","봄어요","보세요"]'::jsonb, '입다 → 입어 + 봤어요.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '제주도에 가 본 적이 ___?', 'Es-tu déjà allé(e) à Jeju ?', '있어요', '["있어요","있서요","있으요","있에요"]'::jsonb, '적이 있어요 = oui, déjà.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 한국에 가 본 적이 ___.', 'Je ne suis jamais allé(e) en Corée.', '없어요', '["없어요","않아요","못해요","안이에요"]'::jsonb, '적이 없어요 = jamais.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 옷 한번 입어 ___.', 'Essayez ce vêtement.', '보세요', '["보세요","보어요","보으세요","보요"]'::jsonb, '입어 + 보세요.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 먹어 봤어요 » ?', 'J''ai déjà goûté / mangé (par expérience)', '["J''ai déjà goûté / mangé (par expérience)","Je veux manger","Je ne peux pas manger","Mangeons"]'::jsonb, '-아/어 봤어요 = avoir déjà essayé.', 1, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '한국에 간 적이 있어요', '["한국에 간 적이 있어요","한국에 가은 적이 있어요","한국에 가ㄴ 적이 있어요","한국에 갈 적이 있어요"]'::jsonb, '가다 finit par une voyelle → ㄴ 적이 있어요 : 간 적이.', 3, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '한국 음식을 먹어 봤어요', 'Écoute et choisis la phrase entendue', '한국 음식을 먹어 봤어요', '["한국 음식을 먹어 봤어요","한국 음식을 먹고 싶어요","한국 음식을 먹어 보세요","한국 음식을 먹을 수 있어요"]'::jsonb, '먹어 봤어요 = j''ai déjà goûté. Écoute bien la fin.', 2, ARRAY['experience', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je suis déjà allé(e) en Corée.', '한국에 가 본 적이 있어요 | 한국에 간 적이 있어요 | 저는 한국에 간 적이 있어요 | 저는 한국에 가 본 적이 있어요 | 한국에 가 봤어요 | 저는 한국에 가 봤어요', NULL, '가 본 적이 있어요 ou 가 봤어요 : les deux disent « j''y suis déjà allé(e) ».', 3, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je n''ai jamais mangé de tteokbokki.', '떡볶이를 먹어 본 적이 없어요 | 떡볶이를 먹은 적이 없어요 | 저는 떡볶이를 먹어 본 적이 없어요 | 저는 떡볶이를 먹은 적이 없어요', NULL, '먹어 본 적이 없어요 = jamais goûté.', 3, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis une chose en lien avec la Corée que tu as déjà essayée, ou que tu n''as jamais essayée.', '-아/어 봤어요 ou -(으)ㄴ 적이 있어요 / 없어요', NULL, 'Exemple : 김치를 먹어 봤어요. 한국에 간 적은 없어요.', 4, ARRAY['experience', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 1 and l.lesson_number = 2;

-- ---------- Étage 5 · Unité 2 : Ce que tu fais en ce moment, et pourquoi tu y vas ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 2, '-고 있어요 · -(으)러', 'Ce que tu fais en ce moment, et pourquoi tu y vas', 'grammar', '-고 있어요 (en train de) et -(으)러 가요 (aller pour)' from floors where floor_number = 5
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-고 있어요 · -(으)러 가요', 'En train de… et aller pour…', 'teach', '{"intro":"Dans une conversation, on dit souvent ce qu''on fait là, tout de suite, ou pourquoi on va quelque part. Deux structures qui reviennent sans cesse, avec des formes très proches de ce que tu connais déjà.","sections":[{"title":"Radical + 고 있어요 — « être en train de »","body":"Même construction que -고 싶어요, avec 있어요 à la place de 싶어요. 지금 + -고 있어요 : ce que je fais en ce moment. Attention à ne pas confondre : 먹고 싶어요 (je veux manger) et 먹고 있어요 (je suis en train de manger). Avec certains verbes de situation comme 살다 (habiter) ou 다니다 (fréquenter), -고 있어요 décrit une situation durable : 한국에 살고 있어요 (j''habite en Corée).","examples":[{"ko":"지금 공부하고 있어요.","rom":"ji-geum gong-bu-ha-go i-sseo-yo","fr":"En ce moment, je suis en train d''étudier."},{"ko":"친구를 기다리고 있어요.","rom":"chin-gu-reul gi-da-ri-go i-sseo-yo","fr":"J''attends un ami."},{"ko":"한국에 살고 있어요.","rom":"han-gu-ge sal-go i-sseo-yo","fr":"J''habite en Corée."}]},{"title":"Radical + (으)러 가다 / 오다 — « aller / venir pour… »","body":"Radical qui finit par une voyelle ou par ㄹ : + 러 (보다 → 보러, 놀다 → 놀러). Par une consonne : + 으러 (먹다 → 먹으러). Puis 가요 (aller) ou 와요 (venir). On dit où on va, et pourquoi.","examples":[{"ko":"점심을 먹으러 가요.","rom":"jeom-si-meul meo-geu-reo ga-yo","fr":"Je vais déjeuner."},{"ko":"영화를 보러 극장에 가요.","rom":"yeong-hwa-reul bo-reo geuk-jang-e ga-yo","fr":"Je vais au cinéma voir un film."},{"ko":"친구를 만나러 왔어요.","rom":"chin-gu-reul man-na-reo wa-sseo-yo","fr":"Je suis venu(e) voir un ami."},{"ko":"주말에 놀러 가요.","rom":"ju-ma-re nol-leo ga-yo","fr":"Ce week-end, je vais m''amuser."}]}],"tip":"싶 = je veux (désir), 있 = je suis en train de (action). Une seule lettre change, mais le sens aussi ! Et avec -(으)러, le verbe qui suit est toujours un verbe de déplacement : 가다, 오다."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지금 공부하___ 있어요.', 'En ce moment, je suis en train d''étudier.', '고', '["고","러","면","서"]'::jsonb, '-고 있어요 : radical + 고 + 있어요.', 1, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '친구를 기다리___ 있어요.', 'J''attends un ami.', '고', '["고","러","으러","면"]'::jsonb, '기다리다 + 고 있어요.', 1, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '점심을 먹___ 가요.', 'Je vais déjeuner.', '으러', '["으러","러","을러","으고"]'::jsonb, '먹다 finit par une consonne → 으러.', 1, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '영화를 ___ 극장에 가요.', 'Je vais au cinéma voir un film.', '보러', '["보러","보으러","봐러","볼러"]'::jsonb, '보다 finit par une voyelle → 러 : 보러.', 1, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle est la différence entre « 먹고 싶어요 » et « 먹고 있어요 » ?', 'Je veux manger / Je suis en train de manger', '["Je veux manger / Je suis en train de manger","Je suis en train de manger / Je veux manger","J''ai mangé / Je mangerai","Je ne mange pas / Je mange"]'::jsonb, '싶어요 = vouloir ; 있어요 (avec -고) = être en train de.', 2, ARRAY['progressive', 'want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase veut dire « Je vais voir un ami » ?', '친구를 만나러 가요', '["친구를 만나러 가요","친구를 만나고 가요","친구를 만나면 가요","친구를 만나서 가요"]'::jsonb, '-(으)러 가요 = aller pour faire. Les autres expriment une suite, une condition ou une cause.', 3, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je suis en train de manger.', '밥을 먹고 있어요 | 지금 밥을 먹고 있어요 | 저는 지금 밥을 먹고 있어요 | 먹고 있어요', NULL, '먹다 + 고 있어요.', 2, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Je vais au marché pour acheter du pain.', '빵을 사러 시장에 가요 | 시장에 빵을 사러 가요', '["빵을","사러","시장에","가요"]'::jsonb, 'But (-(으)러) → destination → verbe de déplacement.', 3, ARRAY['purpose', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '-고 있어요 · -(으)러 연습', 'Entraînement : en train de, aller pour', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 지금 커피를 마시___ 있어요.', 'Je suis en train de boire un café.', '고', '["고","러","으러","면"]'::jsonb, '마시다 + 고 있어요.', 1, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 한국에 ___ 있어요.', 'J''habite en Corée.', '살고', '["살고","살으고","살러","살면"]'::jsonb, '살다 + 고 있어요 : le radical garde son ㄹ.', 3, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '친구를 ___ 학교에 가요.', 'Je vais à l''école voir un ami.', '만나러', '["만나러","만나으러","만날러","만나라"]'::jsonb, '만나다 finit par une voyelle → 러.', 1, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '책을 ___ 도서관에 가요.', 'Je vais à la bibliothèque lire un livre.', '읽으러', '["읽으러","읽러","읽어러","읽을러"]'::jsonb, '읽다 finit par une consonne → 으러.', 1, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '주말에 친구하고 ___ 가요.', 'Ce week-end, je vais m''amuser avec un ami.', '놀러', '["놀러","노러","놀으러","놀아러"]'::jsonb, '놀다 (radical en ㄹ) + 러 : 놀러.', 3, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 뭐 하고 있어요? » ?', 'Que fais-tu en ce moment ?', '["Que fais-tu en ce moment ?","Que veux-tu faire ?","Que feras-tu ?","Qu''as-tu fait ?"]'::jsonb, '하고 있어요 = être en train de faire.', 1, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '밥을 먹으러 가요', '["밥을 먹으러 가요","밥을 먹러 가요","밥을 먹고러 가요","밥을 먹으러서 가요"]'::jsonb, '먹다 → 먹으러 가요.', 2, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '친구를 만나러 가고 있어요', 'Écoute et choisis la phrase entendue', '친구를 만나러 가고 있어요', '["친구를 만나러 가고 있어요","친구를 만나고 싶어요","친구를 만나러 갔어요","친구를 기다리고 있어요"]'::jsonb, '만나러 = pour voir ; 가고 있어요 = je suis en route.', 3, ARRAY['progressive', 'purpose', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je vais déjeuner avec un ami.', '친구하고 점심을 먹으러 가요 | 친구랑 점심을 먹으러 가요 | 점심을 먹으러 친구랑 가요', NULL, '먹으러 가요 = aller manger ; 하고 / 랑 = avec.', 3, ARRAY['purpose', 'linking']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Que fais-tu en ce moment ?', '지금 뭐 하고 있어요 | 뭐 하고 있어요', NULL, '하고 있어요 = tu es en train de faire.', 2, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Dis ce que tu es en train de faire, puis ce que tu vas faire ensuite.', '-고 있어요 et -(으)러 가요', NULL, 'Exemple : 지금 한국어를 공부하고 있어요. 그다음에 점심을 먹으러 가요.', 4, ARRAY['progressive', 'purpose', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 2 and l.lesson_number = 2;

-- ---------- Étage 5 · Unité 3 : Comparer ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 3, '비교', 'Comparer', 'grammar', '보다, 더, 제일 / 가장, 중에서' from floors where floor_number = 5
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '보다 · 더 · 제일', 'Plus que, le plus', 'teach', '{"intro":"Quel est le plus grand, le plus cher, le meilleur ? Comparer est un réflexe de la conversation. Trois mots suffisent : 보다, 더 et 제일.","sections":[{"title":"A는 B보다 더 + adjectif — « A est plus… que B »","body":"보다 se colle au nom qui sert de comparaison (celui qui vient après « que » en français) : B보다. Le mot 더 (« plus ») renforce la comparaison : il est facultatif mais très courant. On peut aussi inverser : B보다 A가 더…","examples":[{"ko":"서울이 부산보다 더 커요.","rom":"seo-u-ri bu-san-bo-da deo keo-yo","fr":"Séoul est plus grande que Busan."},{"ko":"지하철이 버스보다 더 편해요.","rom":"ji-ha-cheo-ri beo-seu-bo-da deo pyeon-hae-yo","fr":"Le métro est plus pratique que le bus."}]},{"title":"제일 / 가장 et 중에서 — « le plus », « parmi »","body":"제일 et 가장 veulent tous deux dire « le plus » (superlatif). 중에서 signifie « parmi, entre » et indique l''ensemble dans lequel on compare. Pour demander laquelle de deux choses est la meilleure : A하고 B 중에서 뭐가 더 좋아요 ?","examples":[{"ko":"커피하고 차 중에서 뭐가 더 좋아요?","rom":"keo-pi-ha-go cha jung-e-seo mwo-ga deo jo-a-yo","fr":"Entre le café et le thé, lequel préfères-tu ?"},{"ko":"한국 음식 중에서 김치찌개를 제일 좋아해요.","rom":"han-guk eum-sik jung-e-seo gim-chi-jji-gae-reul je-il jo-a-hae-yo","fr":"Parmi les plats coréens, c''est le kimchi-jjigae que j''aime le plus."}]}],"tip":"Ne confonds pas 보다 « que » (qui se colle à un nom) avec le verbe 보다 « voir » : 서울보다 (que Séoul) ≠ 영화를 보다 (voir un film). Le contexte tranche toujours."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '서울이 부산___ 더 커요.', 'Séoul est plus grande que Busan.', '보다', '["보다","에서","하고","처럼"]'::jsonb, '부산보다 = que Busan.', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 가방이 저 가방보다 ___ 비싸요.', 'Ce sac est plus cher que celui-là.', '더', '["더","제일","가장","같이"]'::jsonb, '보다 va avec 더 (plus) ; 제일 / 가장 expriment le superlatif.', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국 음식 중에서 김치찌개를 ___ 좋아해요.', 'Parmi les plats coréens, c''est le kimchi-jjigae que j''aime le plus.', '제일', '["제일","보다","부터","밖에"]'::jsonb, '제일 = le plus.', 2, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지하철이 버스보다 더 ___.', 'Le métro est plus pratique que le bus.', '편해요', '["편해요","편하요","편아요","편어요"]'::jsonb, '편하다 → 편해요.', 1, ARRAY['comparison', 'adjectives']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Où place-t-on 보다 dans « Séoul est plus grande que Busan » ?', 'Juste après Busan : 부산보다', '["Juste après Busan : 부산보다","Juste après Séoul","Avant Busan","À la fin de la phrase"]'::jsonb, '보다 se colle au nom de comparaison.', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase veut dire « Le café est plus cher que le thé » ?', '커피가 차보다 더 비싸요', '["커피가 차보다 더 비싸요","차가 커피보다 더 비싸요","커피가 차보다 더 싸요","차보다 커피가 제일 싸요"]'::jsonb, 'A가 B보다 더 비싸요 = A est plus cher que B.', 3, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Le métro est plus pratique que le bus.', '지하철이 버스보다 더 편해요 | 지하철이 버스보다 편해요', NULL, 'B보다 + adjectif ; 더 est facultatif.', 3, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Séoul est plus grande que Busan.', '서울이 부산보다 더 커요', '["서울이","부산보다","더","커요"]'::jsonb, 'A → B보다 → 더 → adjectif.', 2, ARRAY['comparison', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '비교 연습', 'Entraînement : comparer', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 3
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 커피___ 차를 더 좋아해요.', 'Je préfère le thé au café.', '보다', '["보다","에서","까지","부터"]'::jsonb, '커피보다 = plus que le café.', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 옷이 저 옷보다 ___ 싸요.', 'Ce vêtement est moins cher que celui-là.', '더', '["더","제일","가장","같이"]'::jsonb, '보다 va avec 더.', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '서울에서 이 식당이 ___ 맛있어요.', 'C''est ce restaurant qui est le meilleur de Séoul.', '제일', '["제일","보다","도","밖에"]'::jsonb, '제일 = le plus.', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '우리 집은 친구 집___ 커요.', 'Ma maison est plus grande que celle de mon ami.', '보다', '["보다","하고","를","가"]'::jsonb, '친구 집보다 = que la maison de mon ami.', 2, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 제일 » ?', 'le plus', '["le plus","plus que","un peu","jamais"]'::jsonb, '제일 = le plus (comme 가장).', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 뭐가 더 좋아요? » ?', 'Lequel est le mieux (que tu préfères) ?', '["Lequel est le mieux (que tu préfères) ?","Que veux-tu ?","Quand aimes-tu ?","Qu''as-tu acheté ?"]'::jsonb, '뭐가 더 좋아요 = lequel est le mieux.', 1, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '커피보다 차를 더 좋아해요', 'Écoute et choisis la phrase entendue', '커피보다 차를 더 좋아해요', '["커피보다 차를 더 좋아해요","차보다 커피를 더 좋아해요","커피하고 차를 좋아해요","커피를 제일 좋아해요"]'::jsonb, 'Écoute bien qui est « plus que » qui : 커피보다 → on préfère le thé.', 3, ARRAY['comparison', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je préfère le thé au café.', '커피보다 차를 더 좋아해요 | 저는 커피보다 차를 더 좋아해요 | 차를 커피보다 더 좋아해요 | 저는 차를 커피보다 더 좋아해요', NULL, '커피보다 + 차를 더 좋아해요.', 3, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Parmi les plats coréens, lequel préfères-tu ?', '한국 음식 중에서 뭐를 제일 좋아해요 | 한국 음식 중에서 뭐가 제일 좋아요 | 한국 음식 중에서 뭘 제일 좋아해요', NULL, '중에서 = parmi ; 제일 = le plus.', 4, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Compare deux choses de ton choix (deux villes, deux plats…).', 'A는 B보다 더 + adjectif', NULL, 'Exemple : 서울이 부산보다 더 커요.', 4, ARRAY['comparison', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 3 and l.lesson_number = 2;

-- ---------- Étage 5 · Unité 4 : Décrire un nom avec un verbe ou un adjectif ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 4, '명사 꾸미기', 'Décrire un nom avec un verbe ou un adjectif', 'grammar', 'Adjectif + nom (-(으)ㄴ, -는) et verbe + nom (-는, -(으)ㄴ)' from floors where floor_number = 5
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '-는 · -(으)ㄴ + 명사', 'Le plat que j''aime, le film que j''ai vu', 'teach', '{"intro":"En coréen, il n''y a pas de pronom relatif (« que », « qui »). Pour dire « le plat que j''aime » ou « un joli vêtement », on place le verbe ou l''adjectif DEVANT le nom, sous une forme spéciale. C''est la dernière grande pièce du puzzle de ton étage 5.","sections":[{"title":"Adjectif + nom : -(으)ㄴ","body":"Radical qui finit par une voyelle : + ㄴ (예쁘다 → 예쁜 옷, 크다 → 큰 가방). Par une consonne : + 은 (좋다 → 좋은 사람, 작다 → 작은 방). Radical en ㄹ : le ㄹ tombe (달다 → 단 음식). Exception à retenir : 있다 et 없다 se comportent comme des verbes : 맛있는 음식, 재미없는 영화.","examples":[{"ko":"예쁜 옷을 샀어요.","rom":"ye-ppeun o-seul sa-sseo-yo","fr":"J''ai acheté un joli vêtement."},{"ko":"맛있는 음식을 먹고 싶어요.","rom":"ma-sin-neun eum-si-geul meok-go si-peo-yo","fr":"Je veux manger un plat délicieux."}]},{"title":"Verbe + nom : -는 (présent), -(으)ㄴ (passé)","body":"Présent : radical + 는 (좋아하다 → 좋아하는, 먹다 → 먹는, 마시다 → 마시는). Radical en ㄹ : le ㄹ tombe (만들다 → 만드는). Passé : radical + ㄴ après une voyelle (보다 → 본), + 은 après une consonne (읽다 → 읽은). La phrase qui suit dit ce qu''on dit du nom.","examples":[{"ko":"제가 좋아하는 음식은 김치찌개예요.","rom":"je-ga jo-a-ha-neun eum-si-geun gim-chi-jji-gae-ye-yo","fr":"Le plat que j''aime est le kimchi-jjigae."},{"ko":"어제 읽은 책이 재미있었어요.","rom":"eo-je il-geun chae-gi jae-mi-i-sseo-sseo-yo","fr":"Le livre que j''ai lu hier était intéressant."}]}],"tip":"Pour le futur, on utilise -(으)ㄹ + nom (먹을 음식 : le plat que je mangerai). Et rappelle-toi : le verbe ou l''adjectif descriptif vient TOUJOURS avant le nom, jamais après."}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '___ 옷을 샀어요.', 'J''ai acheté un joli vêtement.', '예쁜', '["예쁜","예쁘","예쁜는","예쁠는"]'::jsonb, '예쁘다 finit par une voyelle → ㄴ : 예쁜.', 1, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 ___ 음식을 좋아해요.', 'J''aime les plats délicieux.', '맛있는', '["맛있는","맛있은","맛있어","맛있게"]'::jsonb, '맛있다 se comporte comme un verbe : 맛있는.', 2, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '제가 좋아하___ 음식은 김치찌개예요.', 'Le plat que j''aime est le kimchi-jjigae.', '는', '["는","은","을","게"]'::jsonb, '좋아하다 + 는 + nom.', 1, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어제 ___ 책이 재미있었어요.', 'Le livre que j''ai lu hier était intéressant.', '읽은', '["읽은","읽어","읽으","읽고"]'::jsonb, '읽다 finit par une consonne → 은 (passé).', 3, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Devant un nom, 크다 devient :', '큰', '["큰","크은","크는","킨"]'::jsonb, '크다 finit par une voyelle → ㄴ : 큰.', 1, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 어제 먹은 음식 » ?', 'la nourriture que j''ai mangée hier', '["la nourriture que j''ai mangée hier","la nourriture que je mange","la nourriture que je mangerai","la nourriture que je veux manger"]'::jsonb, '-(으)ㄴ + nom = passé.', 3, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'J''ai acheté un joli vêtement.', '예쁜 옷을 샀어요 | 저는 예쁜 옷을 샀어요', NULL, '예쁜 + 옷 (adjectif devant le nom).', 2, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '제가 좋아하는 음식은 김치찌개예요.', NULL, 'Le plat que j''aime est le kimchi-jjigae | Mon plat préféré est le kimchi-jjigae | La nourriture que j''aime, c''est le kimchi-jjigae', NULL, '좋아하는 음식 = le plat que j''aime.', 2, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 1;

insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 2, '명사 꾸미기 연습', 'Entraînement : décrire un nom', 'practice', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 4
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 ___ 가방을 샀어요.', 'J''ai acheté un grand sac.', '큰', '["큰","크","크은","크는"]'::jsonb, '크다 + ㄴ : 큰.', 1, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '이 식당에는 ___ 음식이 많아요.', 'Il y a beaucoup de plats délicieux dans ce restaurant.', '맛있는', '["맛있는","맛있은","맛있","맛있게"]'::jsonb, '맛있다 → 맛있는.', 2, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지금 마시___ 커피가 맛있어요.', 'Le café que je bois en ce moment est bon.', '는', '["는","은","을","게"]'::jsonb, '마시다 + 는 (présent).', 1, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '어제 ___ 영화는 정말 재미있었어요.', 'Le film que j''ai vu hier était vraiment amusant.', '본', '["본","보은","봐","보고"]'::jsonb, '보다 finit par une voyelle → ㄴ : 본.', 3, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 ___ 음식을 좋아해요.', 'J''aime les plats sucrés.', '단', '["단","달은","다는","달는"]'::jsonb, '달다 : radical en ㄹ → le ㄹ tombe devant ㄴ : 단.', 4, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase est correcte ?', '제가 읽는 책은 재미있어요', '["제가 읽는 책은 재미있어요","제가 읽은는 책은 재미있어요","제가 읽ㄴ 책은 재미있어요","제가 읽으 책은 재미있어요"]'::jsonb, '읽다 + 는 + nom (présent).', 3, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 좋은 사람 » ?', 'une bonne personne', '["une bonne personne","une grande personne","une personne qui part","une personne en retard"]'::jsonb, '좋다 + 은 + 사람.', 1, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'listening', '어제 읽은 책이 재미있었어요', 'Écoute et choisis la phrase entendue', '어제 읽은 책이 재미있었어요', '["어제 읽은 책이 재미있었어요","어제 읽는 책이 재미있어요","어제 읽은 책이 재미없었어요","내일 읽을 책이 재미있어요"]'::jsonb, '읽은 = passé ; 재미있었어요 / 재미없었어요 : écoute bien 있 / 없.', 3, ARRAY['modifier', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Le plat que j''aime est le bibimbap.', '제가 좋아하는 음식은 비빔밥이에요 | 좋아하는 음식은 비빔밥이에요', NULL, '좋아하는 음식 + 비빔밥이에요.', 3, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'J''ai mangé un plat délicieux.', '맛있는 음식을 먹었어요 | 저는 맛있는 음식을 먹었어요', NULL, '맛있는 + 음식 (adjectif devant le nom).', 2, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Le film que j''ai vu hier était amusant.', '어제 본 영화가 재미있었어요', '["어제","본","영화가","재미있었어요"]'::jsonb, 'Temps → verbe qui décrit le nom → nom → verbe principal.', 3, ARRAY['modifier', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Décris ton plat ou ton film préféré avec -는 ou -(으)ㄴ.', 'Verbe ou adjectif + nom (-는 / -(으)ㄴ)', NULL, 'Exemple : 제가 좋아하는 영화는 재미있는 영화예요.', 4, ARRAY['modifier', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 4 and l.lesson_number = 2;

-- ---------- Étage 5 · Unité 5 : Boss : un week-end à Séoul ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 5, '서울 여행', 'Boss : un week-end à Séoul', 'grammar', 'Tout l''étage 5 dans un week-end de visite' from floors where floor_number = 5
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '5층 보스', 'Boss de l''étage 5', 'boss', NULL
from units u join floors f on f.id = u.floor_id where f.floor_number = 5 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 불고기를 먹어 ___.', 'J''ai déjà goûté du bulgogi.', '봤어요', '["봤어요","보았요","봤요","보세요"]'::jsonb, '먹어 + 봤어요.', 2, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '제주도에 간 ___ 없어요.', 'Je ne suis jamais allé(e) à Jeju.', '적이', '["적이","수가","번이","거가"]'::jsonb, '간 적이 없어요 = jamais allé.', 3, ARRAY['experience']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '지금 친구를 기다리___ 있어요.', 'En ce moment, j''attends un ami.', '고', '["고","러","면","서"]'::jsonb, '-고 있어요 = être en train de.', 2, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '내일 친구를 만나___ 시내에 가요.', 'Demain, je vais en ville voir un ami.', '러', '["러","으러","는","어서"]'::jsonb, '만나다 finit par une voyelle → 러 + 가요.', 3, ARRAY['purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '버스가 택시___ 더 싸요.', 'Le bus est moins cher que le taxi.', '보다', '["보다","하고","까지","부터"]'::jsonb, '택시보다 = que le taxi.', 2, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '한국 가수 중에서 누구를 ___ 좋아해요?', 'Parmi les chanteurs coréens, qui préfères-tu ?', '제일', '["제일","보다","도","밖에"]'::jsonb, '중에서 + 제일 : superlatif.', 3, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '저는 ___ 집에 살아요.', 'J''habite dans une petite maison.', '작은', '["작은","작","작는","작어"]'::jsonb, '작다 finit par une consonne → 은 : 작은 집.', 3, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle phrase veut dire « Je veux goûter ça ! » ?', '이거 먹어 보고 싶어요', '["이거 먹어 보고 싶어요","이거 먹고 있어요","이거 먹어 본 적이 없어요","이거 먹으러 가요"]'::jsonb, '먹어 보다 + 고 싶어요.', 3, ARRAY['experience', 'want_to']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Que signifie « 점심을 먹으러 가고 있어요 » ?', 'Je suis en route pour déjeuner', '["Je suis en route pour déjeuner","Je veux déjeuner","J''ai déjà déjeuné","Je déjeunerai si j''y vais"]'::jsonb, '먹으러 = pour manger ; 가고 있어요 = je suis en train d''aller.', 4, ARRAY['progressive', 'purpose']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'J''ai déjà vu un film coréen.', '한국 영화를 본 적이 있어요', '["한국","영화를","본","적이","있어요"]'::jsonb, 'Objet → verbe en -(으)ㄴ → 적이 있어요.', 3, ARRAY['experience', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je suis en train de manger du bibimbap.', '비빔밥을 먹고 있어요 | 저는 비빔밥을 먹고 있어요 | 지금 비빔밥을 먹고 있어요', NULL, '먹다 + 고 있어요.', 3, ARRAY['progressive']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je préfère le métro au bus.', '버스보다 지하철을 더 좋아해요 | 저는 버스보다 지하철을 더 좋아해요 | 지하철을 버스보다 더 좋아해요 | 저는 지하철을 버스보다 더 좋아해요', NULL, '버스보다 + 지하철을 더 좋아해요.', 3, ARRAY['comparison']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_fr', '제가 어제 본 영화는 정말 재미있었어요.', NULL, 'Le film que j''ai vu hier était vraiment amusant | Le film que j''ai vu hier était très intéressant | Le film que j''ai regardé hier était vraiment amusant', NULL, '제가 어제 본 영화 = le film que j''ai vu hier.', 4, ARRAY['modifier']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'free_production', NULL, 'Parle d''une expérience en Corée (réelle ou imaginée) : ce que tu as déjà essayé, ou ce que tu es en train de faire.', '-아/어 봤어요, -(으)ㄴ 적이 있어요 ou -고 있어요', NULL, 'Exemple : 서울에 가 본 적이 있어요. 지금 한국어를 공부하고 있어요.', 4, ARRAY['experience', 'progressive', 'production']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 5 and u.unit_number = 5 and l.lesson_number = 1;

-- 474 exercices au total.
