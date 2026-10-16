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

-- ---------- SRS (SM-2) — utilisé à partir de la V1 ----------
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

drop policy if exists "weakness_own" on weakness_log;
create policy "weakness_own" on weakness_log for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
