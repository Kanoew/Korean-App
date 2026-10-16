-- ============================================================
-- 한글 with Karina — Seed : étage 1 (consolidation A2)
-- Fichier GÉNÉRÉ par supabase/seed/build-seed.mjs — ne pas éditer à la main.
-- À exécuter APRÈS schema.sql. Rejouable : remplace le contenu statique de l'étage 1.
-- ============================================================

insert into floors (floor_number, title_ko, title_fr, cefr_level, description, unlock_xp)
values (1, '기초 다지기', 'Les fondations', 'A2', 'Consolider les bases : particules, lieu, temps, nombres.', 0)
on conflict (floor_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr,
  cefr_level = excluded.cefr_level, description = excluded.description;

-- ---------- Unité 1 : Particules : rappel ----------
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
select l.id, 'fill_blank', '물___ 마셔요.', 'Je bois de l''eau.', '을', '["을","를","은","는"]'::jsonb, '물 finit par ㄹ, une consonne → 을.', 1, ARRAY['object_particle', 'particles']::text[], false
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
select l.id, 'translate_ko', NULL, 'Je suis étudiant(e).', '저는 학생이에요 | 학생이에요', NULL, '저(moi) + 는 + 학생(étudiant) + 이에요(être, poli).', 2, ARRAY['topic_particle', 'particles']::text[], false
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
select l.id, 'fill_blank', '비___ 와요.', 'Il pleut.', '가', '["가","이","를","는"]'::jsonb, '비 finit par une voyelle → 가.', 1, ARRAY['subject_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Forme polie de "moi" + particule de sujet :', '제가', '["제가","저가","내가","저이"]'::jsonb, 'Avec 이/가, 저 devient 제 : 제가. (저가 n''existe pas.)', 1, ARRAY['subject_particle', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 1 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Mon ami aime la cuisine coréenne.', '친구가 한국 음식을 좋아해요', '["친구가","한국","음식을","좋아해요"]'::jsonb, 'Sujet (이/가) → objet (을/를) → verbe.', 2, ARRAY['subject_particle', 'object_particle', 'particles', 'word_order']::text[], false
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

-- ---------- Unité 2 : Particules de lieu : 에, 에서, 으로 ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 2, '장소 조사', 'Particules de lieu : 에, 에서, 으로', 'grammar', 'Le point faible n°1 : 에 vs 에서' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '에 vs 에서', '에 contre 에서', 'teach', '{"intro":"LE piège classique. On le démonte ensemble, une bonne fois.","sections":[{"title":"에 — le point sur la carte","body":"Destination (aller, venir), lieu d''existence (être, il y a) et heure précise. Verbes typiques : 가다, 오다, 있다, 없다.","examples":[{"ko":"학교에 가요.","rom":"hak-gyo-e ga-yo","fr":"Je vais à l''école."},{"ko":"집에 있어요.","rom":"ji-be i-sseo-yo","fr":"Je suis à la maison."}]},{"title":"에서 — là où l''action se passe","body":"Lieu d''une action (manger, étudier, travailler…) ou origine (\"de\"). Verbes typiques : 먹다, 공부하다, 일하다.","examples":[{"ko":"도서관에서 공부해요.","rom":"do-seo-gwan-e-seo gong-bu-hae-yo","fr":"J''étudie à la bibliothèque."},{"ko":"프랑스에서 왔어요.","rom":"peu-rang-seu-e-seo wa-sseo-yo","fr":"Je viens de France."}]},{"title":"으로/로 — direction ou moyen","body":"Direction (\"vers\") ou moyen (\"en bus\", \"avec la main\"). Après une voyelle ou ㄹ : 로. Après une autre consonne : 으로.","examples":[{"ko":"버스로 가요.","rom":"beo-seu-ro ga-yo","fr":"J''y vais en bus."},{"ko":"손으로 먹어요.","rom":"son-eu-ro meo-geo-yo","fr":"Je mange avec les mains."}]}],"tip":"Astuce : demande-toi \"le verbe est une ACTION ?\" → 에서. \"Mouvement ou existence ?\" → 에. (Exception : 살다 accepte les deux.)"}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 2
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '학교___ 가요.', 'Je vais à l''école.', '에', '["에","에서","을","가"]'::jsonb, '가다 = mouvement vers une destination → 에.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '도서관___ 공부해요.', 'J''étudie à la bibliothèque.', '에서', '["에","에서","로","를"]'::jsonb, '공부하다 est une action → 에서.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '집___ 있어요.', 'Je suis à la maison.', '에', '["에","에서","으로","를"]'::jsonb, '있다 (exister, être quelque part) → 에.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '카페___ 커피를 마셔요.', 'Je bois un café au café.', '에서', '["에","에서","으로","가"]'::jsonb, '마시다 est une action → 에서.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle particule avec une action (manger, étudier, travailler) ?', '에서', '["에서","에","으로","도"]'::jsonb, 'Action → 에서. Mouvement / existence → 에.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Quelle particule avec 가다 / 오다 (destination) ?', '에', '["에","에서","이","는"]'::jsonb, '가다 / 오다 + lieu d''arrivée → 에.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je vais à l''école.', '학교에 가요 | 저는 학교에 가요', NULL, '학교(école) + 에 + 가요(aller).', 2, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 1;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je travaille au café.', '카페에서 일해요 | 저는 카페에서 일해요', NULL, '일하다 est une action → 에서.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
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
select l.id, 'fill_blank', '친구가 서울___ 있어요.', 'Mon ami est à Séoul.', '에', '["에","에서","를","로"]'::jsonb, '있다 (existence) → 에.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '도서관___ 가요.', 'Je vais à la bibliothèque.', '에', '["에","에서","를","가"]'::jsonb, '가다 est un verbe de déplacement : il prend 에, jamais 에서. 도서관에 가요.', 2, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '식당___ 점심을 먹어요.', 'Je déjeune au restaurant.', '에서', '["에서","에","로","를"]'::jsonb, '먹다 est une action → 에서.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'fill_blank', '우리는 공원___ 운동해요.', 'Nous faisons du sport au parc.', '에서', '["에서","에","으로","가"]'::jsonb, '운동하다 est une action → 에서.', 1, ARRAY['e_vs_eseo', 'particles']::text[], false
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
select l.id, 'listening', '학교에 가요', 'Écoute et choisis la phrase entendue', '학교에 가요', '["학교에 가요","학교에서 가요","학교를 가요","학교가 가요"]'::jsonb, 'Aller à l''école : 가다 → destination → 에.', 2, ARRAY['e_vs_eseo', 'particles', 'listening']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'J''étudie à la bibliothèque.', '저는 도서관에서 공부해요', '["저는","도서관에서","공부해요"]'::jsonb, 'Lieu de l''action (에서) juste avant le verbe.', 2, ARRAY['e_vs_eseo', 'particles', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'translate_ko', NULL, 'Je mange au restaurant.', '식당에서 먹어요 | 저는 식당에서 먹어요', NULL, '먹다 est une action → 에서.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 2 and l.lesson_number = 2;

-- ---------- Unité 3 : Le temps et les connecteurs ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 3, '시간 표현', 'Le temps et les connecteurs', 'grammar', '때, 전에, 후에, 동안' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '때 · 전에 · 후에 · 동안', 'Quand, avant, après, pendant', 'teach', '{"intro":"Les connecteurs temporels, ton deuxième point faible. Quatre mots à retenir, et un piège avec 에.","sections":[{"title":"때 — quand / à l''époque où","body":"Après un nom : 방학 때. Après un verbe : radical + (으)ㄹ 때, ou au passé radical + 았/었을 때.","examples":[{"ko":"방학 때 한국에 갈 거예요.","rom":"bang-hak ttae han-gu-ge gal geo-ye-yo","fr":"Pendant les vacances, j''irai en Corée."},{"ko":"어렸을 때 서울에 살았어요.","rom":"eo-ryeo-sseul ttae seo-u-re sa-ra-sseo-yo","fr":"Quand j''étais petit, j''habitais à Séoul."}]},{"title":"전에 / 후에 — avant / après","body":"Nom + 전에 / 후에. Avec un verbe : radical + 기 전에 (avant de…) et radical + (으)ㄴ 후에 (après avoir…).","examples":[{"ko":"자기 전에 책을 읽어요.","rom":"ja-gi jeon-e chae-geul il-geo-yo","fr":"Avant de dormir, je lis un livre."},{"ko":"식사 후에 커피를 마셔요.","rom":"sik-sa hu-e keo-pi-reul ma-syeo-yo","fr":"Après le repas, je bois un café."}]},{"title":"동안 — pendant (une durée)","body":"Nom de durée + 동안, ou radical + 는 동안 pour \"pendant que\".","examples":[{"ko":"한 시간 동안 기다렸어요.","rom":"han si-gan dong-an gi-da-ryeo-sseo-yo","fr":"J''ai attendu pendant une heure."}]},{"title":"Le piège : 에 avec le temps","body":"On met 에 avec une heure ou un jour précis (3시에, 월요일에, 주말에). Mais PAS avec 어제, 오늘, 내일, 지금.","examples":[{"ko":"3시에 도착해요.","rom":"se-si-e do-chak-hae-yo","fr":"J''arrive à 3 heures."},{"ko":"내일 만나요.","rom":"nae-il man-na-yo","fr":"On se voit demain."}]}],"tip":"Retiens la série : 전 = avant, 후 = après, 동안 = durée, 때 = moment. Et pas de 에 après 어제 / 오늘 / 내일 / 지금."}'::jsonb
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
select l.id, 'translate_ko', NULL, 'Pendant les vacances, je voyage.', '방학 때 여행해요 | 방학 동안 여행해요 | 저는 방학 때 여행해요 | 저는 방학 동안 여행해요', NULL, '방학 때 (au moment des vacances) ou 방학 동안 (durant les vacances).', 3, ARRAY['temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'reorder', NULL, 'Avant de dormir, je prends une douche.', '저는 자기 전에 샤워해요', '["저는","자기","전에","샤워해요"]'::jsonb, 'Radical + 기 전에 se place avant le verbe principal.', 2, ARRAY['temporal', 'word_order']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 3 and l.lesson_number = 2;

-- ---------- Unité 4 : Nombres sino-coréens ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 4, '한자어 숫자', 'Nombres sino-coréens', 'vocabulary', '일, 이, 삼… et leurs compteurs' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '일, 이, 삼', 'Le système sino-coréen', 'teach', '{"intro":"Deux systèmes de nombres, deux usages. Aujourd''hui : le système sino-coréen, celui de l''argent, des dates et des minutes.","sections":[{"title":"Les nombres","body":"1 일 · 2 이 · 3 삼 · 4 사 · 5 오 · 6 육 · 7 칠 · 8 팔 · 9 구 · 10 십 · 100 백 · 1 000 천 · 10 000 만. On les assemble comme en maths : 15 = 십오, 2 000 = 이천.","examples":[{"ko":"삼천 원","rom":"sam-cheon won","fr":"3 000 wons"},{"ko":"이십 분","rom":"i-sip bun","fr":"20 minutes"},{"ko":"이천이십육 년","rom":"i-cheon-i-sip-yuk nyeon","fr":"l''année 2026"}]},{"title":"Quand les utiliser ?","body":"Argent (원), minutes (분), dates (년, 월, 일), étages (층), numéros (번), téléphone. Pour 10 000, on dit 만 (pas 일만) : 만 원.","examples":[{"ko":"오월 십오일","rom":"o-wol si-bo-il","fr":"le 15 mai"},{"ko":"오 층","rom":"o cheung","fr":"5e étage"}]},{"title":"Deux exceptions de mois","body":"6月 se dit 유월 (pas 육월) et 10月 se dit 시월 (pas 십월).","examples":[{"ko":"유월","rom":"yu-wol","fr":"juin"}]}],"tip":"Moyen mnémotechnique : l''argent, le calendrier et les numéros = sino. Les heures, l''âge et le comptage d''objets = natifs (unité suivante)."}'::jsonb
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
select l.id, 'translate_ko', NULL, 'Je suis au 5e étage.', '저는 오 층에 있어요 | 오 층에 있어요 | 오층에 있어요', NULL, '오 + 층 (étage) ; lieu d''existence → 에 있어요.', 3, ARRAY['numbers_sino', 'e_vs_eseo']::text[], false
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

-- ---------- Unité 5 : Nombres coréens natifs ----------
insert into units (floor_id, unit_number, title_ko, title_fr, topic, description)
select id, 5, '고유어 숫자', 'Nombres coréens natifs', 'vocabulary', '하나, 둘, 셋… et les compteurs' from floors where floor_number = 1
on conflict (floor_id, unit_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, topic = excluded.topic, description = excluded.description;
insert into lessons (unit_id, lesson_number, title_ko, title_fr, lesson_type, content_json)
select u.id, 1, '하나, 둘, 셋', 'Le système natif', 'teach', '{"intro":"Le deuxième système : celui du quotidien (heures, âge, comptage). Attention, il se transforme devant un compteur.","sections":[{"title":"Les nombres","body":"1 하나 · 2 둘 · 3 셋 · 4 넷 · 5 다섯 · 6 여섯 · 7 일곱 · 8 여덟 · 9 아홉 · 10 열 · 20 스물 · 30 서른 · 40 마흔.","examples":[{"ko":"스물다섯 살","rom":"seu-mul-da-seot sal","fr":"25 ans"}]},{"title":"Devant un compteur, 4 nombres changent","body":"하나 → 한 · 둘 → 두 · 셋 → 세 · 넷 → 네 · 스물 → 스무. On écrit : nom + nombre + compteur.","examples":[{"ko":"커피 두 잔","rom":"keo-pi du jan","fr":"deux cafés (tasses)"},{"ko":"사과 세 개","rom":"sa-gwa se gae","fr":"trois pommes"}]},{"title":"Les compteurs essentiels","body":"개 = objets · 명 (ou 사람) = personnes · 마리 = animaux · 권 = livres · 잔 = tasses · 병 = bouteilles · 살 = âge · 시 = heures.","examples":[{"ko":"학생 네 명","rom":"hak-saeng ne myeong","fr":"quatre étudiants"},{"ko":"세 시","rom":"se si","fr":"3 heures"}]}],"tip":"Heures = natif (세 시), minutes = sino (십 분) : \"세 시 십 분\" = 3 h 10. Les deux systèmes dans la même phrase, c''est tout le charme du coréen 😏"}'::jsonb
from units u join floors f on f.id = u.floor_id where f.floor_number = 1 and u.unit_number = 5
on conflict (unit_id, lesson_number) do update set
  title_ko = excluded.title_ko, title_fr = excluded.title_fr, lesson_type = excluded.lesson_type, content_json = excluded.content_json;
delete from exercises where is_llm_generated = false and lesson_id in (select l.id from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 5 and l.lesson_number = 1);
insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
select l.id, 'multiple_choice', NULL, 'Comment dit-on 3 en coréen natif ?', '셋', '["셋","삼","세","사"]'::jsonb, '셋 = 3 natif (devant un compteur : 세).', 1, ARRAY['numbers_native']::text[], false
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

-- ---------- Unité 6 : Boss : évaluation mixte ----------
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
select l.id, 'fill_blank', '저는 회사___ 일해요.', 'Je travaille à l''entreprise.', '에서', '["에서","에","로","를"]'::jsonb, '일하다 est une action → 에서.', 3, ARRAY['e_vs_eseo', 'particles']::text[], false
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
select l.id, 'listening', '저는 도서관에서 책을 읽어요', 'Écoute et choisis la phrase entendue', '저는 도서관에서 책을 읽어요', '["저는 도서관에서 책을 읽어요","저는 도서관에 책을 읽어요","저는 도서관에서 책이 읽어요","저는 도서관에서 책을 일해요"]'::jsonb, '읽다 est une action → 에서.', 3, ARRAY['e_vs_eseo', 'listening']::text[], false
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
select l.id, 'translate_ko', NULL, 'Je prends le petit-déjeuner à 7 heures.', '일곱 시에 아침을 먹어요 | 저는 일곱 시에 아침을 먹어요', NULL, 'Heures = natif (일곱 시) + 에 (heure précise).', 4, ARRAY['numbers_native', 'time_particle', 'temporal']::text[], false
from lessons l join units u on u.id = l.unit_id join floors f on f.id = u.floor_id
where f.floor_number = 1 and u.unit_number = 6 and l.lesson_number = 1;

-- 103 exercices au total.
