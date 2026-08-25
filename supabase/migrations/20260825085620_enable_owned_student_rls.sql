-- Final ownership model after Anonymous Sign-In was enabled.
-- Anonymous Supabase users use the authenticated Postgres role and own rows
-- through auth.uid(). Admin authority comes only from app_metadata.

alter table public.users enable row level security;
alter table public.case_study_answers enable row level security;
alter table public.quiz_results enable row level security;
alter table public.lab_records enable row level security;

revoke all on public.users from anon;
revoke all on public.case_study_answers from anon;
revoke all on public.quiz_results from anon;
revoke all on public.lab_records from anon;

grant select, insert, update, delete on public.users to authenticated;
grant select, insert, update, delete on public.case_study_answers to authenticated;
grant select, insert, update, delete on public.quiz_results to authenticated;
grant select, insert, update, delete on public.lab_records to authenticated;

drop policy if exists "Allow anon all users" on public.users;
drop policy if exists "Students read own profile" on public.users;
drop policy if exists "Students create own profile" on public.users;
drop policy if exists "Students update own profile" on public.users;
drop policy if exists "Admins delete profiles" on public.users;

create policy "Read own profile or admin"
on public.users for select to authenticated
using (
  (select auth.uid()) = id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Create own student profile"
on public.users for insert to authenticated
with check (
  (select auth.uid()) = id
  and role = 'siswa'
);

create policy "Update own profile or admin"
on public.users for update to authenticated
using (
  (select auth.uid()) = id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
)
with check (
  ((select auth.uid()) = id and role = 'siswa')
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin deletes profiles"
on public.users for delete to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Allow anon all case_study" on public.case_study_answers;
drop policy if exists "Students read own case studies" on public.case_study_answers;
drop policy if exists "Students submit own case studies" on public.case_study_answers;
drop policy if exists "Admins manage case studies" on public.case_study_answers;

create policy "Read own case studies or admin"
on public.case_study_answers for select to authenticated
using (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Submit own case studies or admin"
on public.case_study_answers for insert to authenticated
with check (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin updates case studies"
on public.case_study_answers for update to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin')
with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin deletes case studies"
on public.case_study_answers for delete to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Allow anon all quiz_results" on public.quiz_results;
drop policy if exists "Students read own quiz results" on public.quiz_results;
drop policy if exists "Students submit own quiz results" on public.quiz_results;
drop policy if exists "Admins manage quiz results" on public.quiz_results;

create policy "Read own quiz results or admin"
on public.quiz_results for select to authenticated
using (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Submit own quiz results or admin"
on public.quiz_results for insert to authenticated
with check (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin updates quiz results"
on public.quiz_results for update to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin')
with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin deletes quiz results"
on public.quiz_results for delete to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Allow anon all lab_records" on public.lab_records;
drop policy if exists "Students read own lab records" on public.lab_records;
drop policy if exists "Students submit own lab records" on public.lab_records;
drop policy if exists "Admins manage lab records" on public.lab_records;

create policy "Read own lab records or admin"
on public.lab_records for select to authenticated
using (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Submit own lab records or admin"
on public.lab_records for insert to authenticated
with check (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin updates lab records"
on public.lab_records for update to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin')
with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

create policy "Admin deletes lab records"
on public.lab_records for delete to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

create index if not exists idx_case_study_answers_user_id
  on public.case_study_answers (user_id);
create index if not exists idx_quiz_results_user_id
  on public.quiz_results (user_id);
create index if not exists idx_lab_records_user_id
  on public.lab_records (user_id);
