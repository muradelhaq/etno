-- Allow students (authenticated / anonymous) to delete their own records upon account deletion
-- Complies with Google Play Store Account and Data Deletion Policy

drop policy if exists "Admin deletes profiles" on public.users;
drop policy if exists "Users delete own profile or admin" on public.users;
create policy "Users delete own profile or admin"
on public.users for delete to authenticated
using (
  (select auth.uid()) = id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

drop policy if exists "Admin deletes case studies" on public.case_study_answers;
drop policy if exists "Users delete own case studies or admin" on public.case_study_answers;
create policy "Users delete own case studies or admin"
on public.case_study_answers for delete to authenticated
using (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

drop policy if exists "Admin deletes quiz results" on public.quiz_results;
drop policy if exists "Users delete own quiz results or admin" on public.quiz_results;
create policy "Users delete own quiz results or admin"
on public.quiz_results for delete to authenticated
using (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

drop policy if exists "Admin deletes lab records" on public.lab_records;
drop policy if exists "Users delete own lab records or admin" on public.lab_records;
create policy "Users delete own lab records or admin"
on public.lab_records for delete to authenticated
using (
  (select auth.uid()) = user_id
  or ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);
