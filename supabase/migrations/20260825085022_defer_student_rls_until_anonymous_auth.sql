-- Anonymous Auth is currently disabled in the hosted project. Keep the legacy
-- policies temporarily so existing student flows remain operational. Replace
-- this migration state after Anonymous Auth is enabled and client rollout is complete.

drop policy if exists "Students read own profile" on public.users;
drop policy if exists "Students create own profile" on public.users;
drop policy if exists "Students update own profile" on public.users;
drop policy if exists "Admins delete profiles" on public.users;
drop policy if exists "Allow anon all users" on public.users;
create policy "Allow anon all users" on public.users
for all to anon, authenticated using (true) with check (true);

drop policy if exists "Students read own case studies" on public.case_study_answers;
drop policy if exists "Students submit own case studies" on public.case_study_answers;
drop policy if exists "Admins manage case studies" on public.case_study_answers;
drop policy if exists "Allow anon all case_study" on public.case_study_answers;
create policy "Allow anon all case_study" on public.case_study_answers
for all to anon, authenticated using (true) with check (true);

drop policy if exists "Students read own quiz results" on public.quiz_results;
drop policy if exists "Students submit own quiz results" on public.quiz_results;
drop policy if exists "Admins manage quiz results" on public.quiz_results;
drop policy if exists "Allow anon all quiz_results" on public.quiz_results;
create policy "Allow anon all quiz_results" on public.quiz_results
for all to anon, authenticated using (true) with check (true);

drop policy if exists "Students read own lab records" on public.lab_records;
drop policy if exists "Students submit own lab records" on public.lab_records;
drop policy if exists "Admins manage lab records" on public.lab_records;
drop policy if exists "Allow anon all lab_records" on public.lab_records;
create policy "Allow anon all lab_records" on public.lab_records
for all to anon, authenticated using (true) with check (true);
