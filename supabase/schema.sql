-- ============================================================
-- 한글 with Karina — Schema Supabase (V0)
-- À coller dans Supabase → SQL Editor → Run. Rejouable sans danger.
-- ============================================================

-- ---------- Profil & progression globale ----------
create table if not exists user_profile (
  id UUID primary key default gen_random_uuid(),
  user_id UUID references auth.users(id) on delete cascade unique,
  display_name TEXT default 'Jordan',
  current_level TEXT default 'A2',
  current_floor INT default 1,
  xp INT default 0,
  streak_days INT default 0,
  last_session_date DATE,
  created_at TIMESTAMPTZ default now()
);

-- ---------- Curriculum : étages → unités → leçons ----------
create table if not exists floors (
  id SERIAL primary key,
  floor_number INT unique not null,
  title_ko TEXT not null,
  title_fr TEXT not null,
  cefr_level TEXT not null,
  description TEXT,
  unlock_xp INT default 0
);

create table if not exists units (
  id SERIAL primary key,
  floor_id INT references floors(id) on delete cascade,
  unit_number INT not null,
  title_ko TEXT not null,
  title_fr TEXT not null,
  topic TEXT not null,
  description TEXT,
  unique (floor_id, unit_number)
);

create table if not exists lessons (
  id SERIAL primary key,
  unit_id INT references units(id) on delete cascade,
  lesson_number INT not null,
  title_ko TEXT not null,
  title_fr TEXT not null,
  lesson_type TEXT not null check (lesson_type in ('teach', 'practice', 'review', 'boss')),
  content_json JSONB,
  created_at TIMESTAMPTZ default now(),
  unique (unit_id, lesson_number)
);

-- ---------- Exercices (statiques + cache LLM) ----------
create table if not exists exercises (
  id SERIAL primary key,
  lesson_id INT references lessons(id) on delete cascade,
  exercise_type TEXT not null,
  prompt_ko TEXT,
  prompt_fr TEXT,
  correct_answer TEXT,
  options JSONB,
  hint TEXT,
  explanation_ko TEXT,
  explanation_fr TEXT,
  difficulty INT default 1,
  tags TEXT[],
  is_llm_generated BOOLEAN default false,
  created_at TIMESTAMPTZ default now()
);
create index if not exists exercises_lesson_idx on exercises (lesson_id);
create index if not exists exercises_tags_idx on exercises using gin (tags);

-- ---------- SRS (cartes de révision) ----------
create table if not exists srs_cards (
  id SERIAL primary key,
  user_id UUID references auth.users(id) on delete cascade,
  card_type TEXT not null,
  front_ko TEXT not null,
  back_fr TEXT not null,
  pronunciation TEXT,
  example_sentence_ko TEXT,
  example_sentence_fr TEXT,
  tags TEXT[],
  ease_factor REAL default 2.5,
  interval_days INT default 1,
  repetitions INT default 0,
  next_review DATE default current_date,
  last_review DATE,
  created_at TIMESTAMPTZ default now()
);

-- Révisions espacées J+1 / J+3 / J+7 / J+16 : colonnes ajoutées à srs_cards (rejouable).
--   step = révisions réussies (0..4), status = active | mastered, exercise = copie rejouable de l'exercice,
--   source_key = identité de la carte (texte de l'exercice, stable malgré les seed.sql).
alter table srs_cards add column if not exists step INT default 0;
alter table srs_cards add column if not exists status TEXT default 'active';
alter table srs_cards add column if not exists lapses INT default 0;
alter table srs_cards add column if not exists exercise JSONB;
alter table srs_cards add column if not exists source_key TEXT;
alter table srs_cards alter column next_review drop not null;
create unique index if not exists srs_cards_source_idx on srs_cards (user_id, source_key);
create index if not exists srs_cards_due_idx on srs_cards (user_id, next_review) where status = 'active';

-- ---------- Sessions ----------
create table if not exists sessions (
  id SERIAL primary key,
  user_id UUID references auth.users(id) on delete cascade,
  started_at TIMESTAMPTZ default now(),
  ended_at TIMESTAMPTZ,
  lesson_id INT references lessons(id) on delete set null,
  exercises_attempted INT default 0,
  exercises_correct INT default 0,
  xp_earned INT default 0,
  weak_points JSONB,
  duration_seconds INT,
  summary_text TEXT
);

-- ---------- Progression par leçon (ajout V0) ----------
create table if not exists lesson_progress (
  user_id UUID references auth.users(id) on delete cascade,
  lesson_id INT references lessons(id) on delete cascade,
  completed BOOLEAN default false,
  best_score REAL default 0,
  attempts INT default 0,
  completed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ default now(),
  primary key (user_id, lesson_id)
);

-- ---------- Signalements d'exercices (bouton « Signaler » de l'app) ----------
-- Chaque signalement garde une copie du texte : les exercices sont recréés à chaque seed.sql,
-- leur identifiant n'est donc pas stable. Lecture :
--   select created_at, snapshot->>'prompt_ko' as ko, snapshot->>'prompt_fr' as fr,
--          snapshot->>'correct_answer' as attendu, given_answer as donne, note
--   from exercise_reports where status = 'open' order by created_at desc;
create table if not exists exercise_reports (
  id SERIAL primary key,
  user_id UUID references auth.users(id) on delete cascade,
  exercise_id INT references exercises(id) on delete set null,
  note TEXT,
  given_answer TEXT,
  snapshot JSONB,
  status TEXT default 'open' check (status in ('open', 'fixed', 'dismissed')),
  created_at TIMESTAMPTZ default now()
);

-- ---------- Couche LLM (Edge Function `llm`) ----------
-- Quotas : 20 appels par session de l'appli, 100 par jour (voir llm_take_quota ci-dessous pour les changer).
create table if not exists llm_usage (
  user_id UUID references auth.users(id) on delete cascade,
  day DATE not null default current_date,
  calls INT not null default 0,
  primary key (user_id, day)
);
create table if not exists llm_usage_session (
  user_id UUID references auth.users(id) on delete cascade,
  session_id TEXT not null,
  calls INT not null default 0,
  created_at TIMESTAMPTZ default now(),
  primary key (user_id, session_id)
);

-- Réserve p_n appels. Renvoie {ok, reason?, day_used, session_used}. Les plafonds sont ICI, pas côté client.
create or replace function public.llm_take_quota(p_session text, p_n int default 1)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  u uuid := auth.uid();
  v_session text := left(coalesce(p_session, 'default'), 64);
  max_day constant int := 100;
  max_session constant int := 20;
  d int;
  s int;
begin
  if u is null then
    raise exception 'not authenticated';
  end if;
  if p_n is null or p_n < 1 or p_n > 10 then
    raise exception 'invalid quota request';
  end if;
  insert into llm_usage (user_id, day, calls) values (u, current_date, 0) on conflict do nothing;
  insert into llm_usage_session (user_id, session_id, calls) values (u, v_session, 0) on conflict do nothing;
  select calls into d from llm_usage where user_id = u and day = current_date for update;
  select calls into s from llm_usage_session where user_id = u and session_id = v_session for update;
  if d + p_n > max_day then
    return jsonb_build_object('ok', false, 'reason', 'day', 'day_used', d, 'session_used', s, 'max_day', max_day, 'max_session', max_session);
  end if;
  if s + p_n > max_session then
    return jsonb_build_object('ok', false, 'reason', 'session', 'day_used', d, 'session_used', s, 'max_day', max_day, 'max_session', max_session);
  end if;
  update llm_usage set calls = calls + p_n where user_id = u and day = current_date;
  update llm_usage_session set calls = calls + p_n where user_id = u and session_id = v_session;
  return jsonb_build_object('ok', true, 'day_used', d + p_n, 'session_used', s + p_n, 'max_day', max_day, 'max_session', max_session);
end;
$$;

-- Enregistre des exercices générés par l'IA (jamais rattachés à une leçon ; marqués is_llm_generated).
create or replace function public.llm_store_exercises(items jsonb)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  n int := 0;
  it jsonb;
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;
  if jsonb_typeof(items) <> 'array' or jsonb_array_length(items) > 20 then
    raise exception 'invalid items';
  end if;
  for it in select * from jsonb_array_elements(items) loop
    if it->>'exercise_type' not in ('multiple_choice', 'fill_blank', 'reorder', 'translate_ko', 'translate_fr', 'listening') then
      continue;
    end if;
    insert into exercises (lesson_id, exercise_type, prompt_ko, prompt_fr, correct_answer, options, explanation_fr, difficulty, tags, is_llm_generated)
    values (
      null,
      it->>'exercise_type',
      nullif(it->>'prompt_ko', ''),
      nullif(it->>'prompt_fr', ''),
      it->>'correct_answer',
      case when jsonb_typeof(it->'options') = 'array' then it->'options' else null end,
      nullif(it->>'explanation_fr', ''),
      least(greatest(coalesce((it->>'difficulty')::int, 2), 1), 5),
      case when jsonb_typeof(it->'tags') = 'array' then array(select jsonb_array_elements_text(it->'tags')) else null end,
      true
    );
    n := n + 1;
  end loop;
  return n;
end;
$$;

-- Enregistre des BROUILLONS de messages de Karina (inactifs : tu les relis et les actives toi-même).
create or replace function public.llm_store_message_drafts(p_category text, p_subcategory text, items jsonb)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  n int := 0;
  t text;
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;
  if p_category = 'flirty' and coalesce(p_subcategory, '') = 'spicy' then
    raise exception 'les messages flirty/spicy s''écrivent à la main';
  end if;
  if jsonb_typeof(items) <> 'array' or jsonb_array_length(items) > 12 then
    raise exception 'invalid items';
  end if;
  for t in select jsonb_array_elements_text(items) loop
    if length(trim(t)) between 3 and 400 then
      insert into karina_messages (category, subcategory, trigger_context, message_text, is_active)
      values (p_category, nullif(p_subcategory, ''), 'brouillon IA — à relire', trim(t), false);
      n := n + 1;
    end if;
  end loop;
  return n;
end;
$$;

revoke all on function public.llm_take_quota(text, int) from public, anon;
revoke all on function public.llm_store_exercises(jsonb) from public, anon;
revoke all on function public.llm_store_message_drafts(text, text, jsonb) from public, anon;
grant execute on function public.llm_take_quota(text, int) to authenticated;
grant execute on function public.llm_store_exercises(jsonb) to authenticated;
grant execute on function public.llm_store_message_drafts(text, text, jsonb) to authenticated;

-- ---------- Récompenses (V1) ----------
create table if not exists rewards (
  id SERIAL primary key,
  reward_type TEXT not null,
  trigger_type TEXT not null,
  trigger_value INT,
  content_text TEXT,
  image_url TEXT,
  badge_name TEXT,
  is_unlocked BOOLEAN default false,
  unlocked_at TIMESTAMPTZ
);

-- ---------- Points faibles ----------
create table if not exists weakness_log (
  id SERIAL primary key,
  user_id UUID references auth.users(id) on delete cascade,
  tag TEXT not null,
  error_count INT default 0,
  streak_correct INT default 0,
  last_error_at TIMESTAMPTZ,
  resolved BOOLEAN default false,
  unique (user_id, tag)
);

-- ---------- Messages de Karina (saisis à la main dans le Table Editor) ----------
-- Catégories / sous-catégories lues par l'app :
--   greeting        morning, afternoon, evening, comeback_after_absence, streak_active
--   correct_answer  standard, streak_3, streak_5, perfect_lesson
--   wrong_answer    standard, repeated_mistake, encouragement
--   floor_clear     standard, milestone_floor_5, milestone_floor_10  (ou milestone_floor_<n>)
--   review_prompt   gentle_reminder, overdue                          (actif avec le SRS, V1)
--   idle_tease      standard, playful                                 (30 s d'inactivité)
--   session_end     short_session, good_session, long_session
--   flirty          light, medium, spicy                              (15 % entre deux exercices ; spicy jamais avant l'étage 3)
--   milestone       xp_500, xp_1000, streak_7, streak_30
-- Variables dans message_text : {name} {streak} {xp} {floor} {level} {gap} {floor_title}
create table if not exists karina_messages (
  id SERIAL primary key,
  category TEXT not null,         -- catégorie du message (voir ci-dessus)
  subcategory TEXT,               -- affinement facultatif
  trigger_context TEXT,           -- note libre : quand ce message apparaît
  message_text TEXT not null,     -- le message
  min_floor INT default 1,        -- n'apparaît pas avant cet étage
  is_active BOOLEAN default true,
  created_at TIMESTAMPTZ default now()
);
create index if not exists karina_messages_lookup_idx on karina_messages (category, subcategory) where is_active;

-- Combien de messages actifs par emplacement ? (objectif : au moins 5 pour éviter les répétitions)
-- Utilisation : select * from karina_messages_coverage where statut <> 'ok';
create or replace view karina_messages_coverage with (security_invoker = true) as
with slots (category, subcategory) as (
  values
    ('greeting', 'morning'), ('greeting', 'afternoon'), ('greeting', 'evening'),
    ('greeting', 'comeback_after_absence'), ('greeting', 'streak_active'),
    ('correct_answer', 'standard'), ('correct_answer', 'streak_3'), ('correct_answer', 'streak_5'), ('correct_answer', 'perfect_lesson'),
    ('wrong_answer', 'standard'), ('wrong_answer', 'repeated_mistake'), ('wrong_answer', 'encouragement'),
    ('floor_clear', 'standard'), ('floor_clear', 'milestone_floor_5'), ('floor_clear', 'milestone_floor_10'),
    ('review_prompt', 'gentle_reminder'), ('review_prompt', 'overdue'),
    ('idle_tease', 'standard'), ('idle_tease', 'playful'),
    ('session_end', 'short_session'), ('session_end', 'good_session'), ('session_end', 'long_session'),
    ('flirty', 'light'), ('flirty', 'medium'), ('flirty', 'spicy'),
    ('milestone', 'xp_500'), ('milestone', 'xp_1000'), ('milestone', 'streak_7'), ('milestone', 'streak_30')
)
select s.category,
       s.subcategory,
       count(m.id) filter (where m.is_active) as actifs,
       5 as objectif,
       case when count(m.id) filter (where m.is_active) >= 5 then 'ok'
            else 'manque ' || (5 - count(m.id) filter (where m.is_active)) end as statut
from slots s
left join karina_messages m on m.category = s.category and m.subcategory = s.subcategory
group by s.category, s.subcategory;

-- ---------- Bucket public pour les sprites de Karina ----------
-- (ignoré si le schéma storage n'existe pas, ex. Postgres de test)
do $$
begin
  if to_regclass('storage.buckets') is not null then
    insert into storage.buckets (id, name, public)
    values ('karina-sprites', 'karina-sprites', true)
    on conflict (id) do update set public = true;
  end if;
end $$;

-- ============================================================
-- Création automatique du profil à l'inscription
-- ============================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.user_profile (user_id)
  values (new.id)
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
-- Row Level Security
-- ============================================================
alter table user_profile    enable row level security;
alter table floors          enable row level security;
alter table units           enable row level security;
alter table lessons         enable row level security;
alter table exercises       enable row level security;
alter table srs_cards       enable row level security;
alter table sessions        enable row level security;
alter table lesson_progress enable row level security;
alter table rewards         enable row level security;
alter table weakness_log    enable row level security;
alter table karina_messages enable row level security;
alter table exercise_reports enable row level security;
alter table llm_usage enable row level security;
alter table llm_usage_session enable row level security;

-- Curriculum : lecture seule pour tout utilisateur connecté
drop policy if exists "floors_read" on floors;
create policy "floors_read" on floors for select to authenticated using (true);
drop policy if exists "units_read" on units;
create policy "units_read" on units for select to authenticated using (true);
drop policy if exists "lessons_read" on lessons;
create policy "lessons_read" on lessons for select to authenticated using (true);
drop policy if exists "exercises_read" on exercises;
create policy "exercises_read" on exercises for select to authenticated using (true);
drop policy if exists "karina_messages_read" on karina_messages;
create policy "karina_messages_read" on karina_messages for select to authenticated using (true);
drop policy if exists "rewards_read" on rewards;
create policy "rewards_read" on rewards for select to authenticated using (true);

-- Données personnelles : uniquement les lignes de l'utilisateur
drop policy if exists "profile_own" on user_profile;
create policy "profile_own" on user_profile for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "srs_own" on srs_cards;
create policy "srs_own" on srs_cards for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "sessions_own" on sessions;
create policy "sessions_own" on sessions for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "progress_own" on lesson_progress;
create policy "progress_own" on lesson_progress for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "llm_usage_own" on llm_usage;
create policy "llm_usage_own" on llm_usage for select to authenticated using (user_id = auth.uid());
drop policy if exists "llm_usage_session_own" on llm_usage_session;
create policy "llm_usage_session_own" on llm_usage_session for select to authenticated using (user_id = auth.uid());

drop policy if exists "reports_own" on exercise_reports;
create policy "reports_own" on exercise_reports for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "weakness_own" on weakness_log;
create policy "weakness_own" on weakness_log for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
