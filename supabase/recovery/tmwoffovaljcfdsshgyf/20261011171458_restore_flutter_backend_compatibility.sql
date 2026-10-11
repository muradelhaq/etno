-- Compatibility expansion for the CMS-backed project tmwoffovaljcfdsshgyf.
-- Existing CMS tables and rows are retained. Run as a single transaction.
create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  class_name text not null,
  school text not null,
  role text not null default 'siswa' check (role = 'siswa'),
  total_xp integer not null default 0,
  current_slide integer not null default 1,
  is_completed boolean not null default false,
  last_active timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table public.case_study_answers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  student_name text not null,
  student_class text not null,
  student_school text not null,
  module_id text not null,
  case_title text not null,
  research_question text not null,
  student_opinion text not null,
  student_variables text not null default '',
  submitted_at timestamptz not null default now()
);

create table public.lab_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  student_name text not null,
  experiment_type text not null,
  observation_data jsonb not null default '{}',
  conclusion text not null default '',
  created_at timestamptz not null default now()
);

-- Keep the CMS quiz columns and accepted types. Flutter sends percentage
-- scores (including fractions), student labels, and a descriptive quiz type.
alter table public.quiz_results
  add column student_name text,
  add column student_class text,
  add column student_school text,
  add column correct_count integer,
  add column total_questions integer,
  add column answers_detail jsonb,
  alter column score type numeric using score::numeric,
  alter column module_page set default 12,
  alter column max_score set default 100,
  drop constraint quiz_results_quiz_type_check,
  drop constraint quiz_results_type_check;
alter table public.quiz_results add constraint quiz_results_type_check check (
  quiz_type in ('multiple_choice', 'true_false', 'drag_drop', 'image_quiz',
    'final_evaluation', 'Pre-test', 'Post-test Evaluasi PISA')
);

create index if not exists idx_case_study_answers_user_id on public.case_study_answers(user_id);
create index if not exists idx_lab_records_user_id on public.lab_records(user_id);
create index if not exists idx_quiz_results_user_id on public.quiz_results(user_id);

-- Replace the recursive profile lookup with the existing bounded helper.
alter policy "Teachers can view all profiles" on public.user_profiles
  to authenticated using ((select public.is_teacher_or_admin()));

-- Remove the CMS quiz policies that recurse through profiles or accept writes
-- for arbitrary user IDs. Authorization uses server-controlled JWT metadata.
drop policy "Users can view own quiz_results" on public.quiz_results;
drop policy "Users can update own quiz_results" on public.quiz_results;
drop policy "Authenticated users can insert quiz_results" on public.quiz_results;
drop policy "Teachers can view all quiz_results" on public.quiz_results;
drop policy "Quiz results select" on public.quiz_results;
create policy "CMS staff read quiz results" on public.quiz_results for select to authenticated
  using ((select public.is_teacher_or_admin()));

do $migration$
declare
  table_name text;
  owner_column text;
  owner_or_admin text;
begin
  foreach table_name in array array['users','case_study_answers','quiz_results','lab_records'] loop
    owner_column := case when table_name = 'users' then 'id' else 'user_id' end;
    owner_or_admin := format(
      '(select auth.uid()) = %I or ((select auth.jwt()) -> ''app_metadata'' ->> ''role'') = ''admin''',
      owner_column
    );
    execute format('alter table public.%I enable row level security', table_name);
    execute format('revoke all on public.%I from anon', table_name);
    execute format('grant select,insert,update,delete on public.%I to authenticated', table_name);
    execute format('create policy "Flutter read own or admin" on public.%I for select to authenticated using (%s)', table_name, owner_or_admin);
    execute format('create policy "Flutter insert own or admin" on public.%I for insert to authenticated with check (%s)', table_name, owner_or_admin);
    execute format('create policy "Flutter update own or admin" on public.%I for update to authenticated using (%s) with check (%s)', table_name, owner_or_admin, owner_or_admin);
    execute format('create policy "Flutter delete own or admin" on public.%I for delete to authenticated using (%s)', table_name, owner_or_admin);
    if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename=table_name) then
      execute format('alter publication supabase_realtime add table public.%I', table_name);
    end if;
  end loop;
end;
$migration$;

create table public.module_assets (
  id uuid primary key default gen_random_uuid(),
  module_id text not null,
  category text not null default 'process_step',
  step_number integer,
  title text not null,
  filename text not null unique,
  storage_path text not null,
  public_url text not null,
  description text,
  biological_context text,
  metadata jsonb default '{}',
  created_at timestamptz not null default now()
);
create index idx_module_assets_module_step on public.module_assets(module_id,step_number);
alter table public.module_assets enable row level security;
revoke all on public.module_assets from anon,authenticated;
grant select on public.module_assets to anon,authenticated;
grant insert,update,delete on public.module_assets to authenticated;
create policy "Public reads module assets" on public.module_assets for select to anon,authenticated using (true);
create policy "Admin manages module assets" on public.module_assets for all to authenticated
  using (((select auth.jwt())->'app_metadata'->>'role')='admin')
  with check (((select auth.jwt())->'app_metadata'->>'role')='admin');

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values
  ('aset-sed','aset-sed',true,52428800,array['image/jpeg','image/png','image/webp','image/svg+xml']),
  ('media-assets','media-assets',true,52428800,array['image/jpeg','image/png','image/webp','image/svg+xml','video/mp4']);
create policy "Flutter public media read" on storage.objects for select to anon,authenticated
  using (bucket_id in ('aset-sed','media-assets'));
create policy "Flutter admin media insert" on storage.objects for insert to authenticated
  with check (bucket_id in ('aset-sed','media-assets') and ((select auth.jwt())->'app_metadata'->>'role')='admin');
create policy "Flutter admin media update" on storage.objects for update to authenticated
  using (bucket_id in ('aset-sed','media-assets') and ((select auth.jwt())->'app_metadata'->>'role')='admin')
  with check (bucket_id in ('aset-sed','media-assets') and ((select auth.jwt())->'app_metadata'->>'role')='admin');
create policy "Flutter admin media delete" on storage.objects for delete to authenticated
  using (bucket_id in ('aset-sed','media-assets') and ((select auth.jwt())->'app_metadata'->>'role')='admin');
notify pgrst, 'reload schema';
