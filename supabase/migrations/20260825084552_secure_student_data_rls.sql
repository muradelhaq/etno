-- Student rows are owned by Supabase Auth users. Teacher access is granted
-- only through server-controlled app_metadata.role = 'admin'.

alter table public.users enable row level security;
alter table public.case_study_answers enable row level security;
alter table public.quiz_results enable row level security;
alter table public.lab_records enable row level security;

drop policy if exists "Allow anon all users" on public.users;
drop policy if exists "Allow anon all case_study" on public.case_study_answers;
drop policy if exists "Allow anon all quiz_results" on public.quiz_results;
drop policy if exists "Allow anon all lab_records" on public.lab_records;

create policy "Students read own profile"
on public.users for select
to authenticated
using (
  (select auth.uid()) = id
  or (select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Students create own profile"
on public.users for insert
to authenticated
with check (
  (select auth.uid()) = id
  and role = 'siswa'
);

create policy "Students update own profile"
on public.users for update
to authenticated
using (
  (select auth.uid()) = id
  or (select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
)
with check (
  ((select auth.uid()) = id and role = 'siswa')
  or (select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admins delete profiles"
on public.users for delete
to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Students read own case studies"
on public.case_study_answers for select
to authenticated
using (
  (select auth.uid()) = user_id
  or (select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Students submit own case studies"
on public.case_study_answers for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Admins manage case studies"
on public.case_study_answers for all
to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Students read own quiz results"
on public.quiz_results for select
to authenticated
using (
  (select auth.uid()) = user_id
  or (select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Students submit own quiz results"
on public.quiz_results for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Admins manage quiz results"
on public.quiz_results for all
to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create policy "Students read own lab records"
on public.lab_records for select
to authenticated
using (
  (select auth.uid()) = user_id
  or (select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Students submit own lab records"
on public.lab_records for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Admins manage lab records"
on public.lab_records for all
to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create index if not exists idx_case_study_answers_user_id
  on public.case_study_answers (user_id);
create index if not exists idx_quiz_results_user_id
  on public.quiz_results (user_id);
create index if not exists idx_lab_records_user_id
  on public.lab_records (user_id);
