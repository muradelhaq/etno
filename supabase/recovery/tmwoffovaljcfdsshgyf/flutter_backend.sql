-- Transactional integration proof; fixtures and all writes are rolled back.
begin;
insert into auth.users(id,aud,role,is_anonymous,raw_app_meta_data,raw_user_meta_data)
values
 ('ec000000-0000-4000-8000-000000000001','authenticated','authenticated',true,'{}','{}'),
 ('ec000000-0000-4000-8000-000000000002','authenticated','authenticated',true,'{}','{}');
set local role authenticated;
select set_config('request.jwt.claims','{"sub":"ec000000-0000-4000-8000-000000000001","role":"authenticated","app_metadata":{},"user_metadata":{"role":"admin"}}',true);
insert into public.users(id,name,class_name,school) values ('ec000000-0000-4000-8000-000000000001','Supabase test A','Test','Test');
insert into public.quiz_results(id,user_id,student_name,student_class,student_school,quiz_type,score,correct_count,total_questions,answers_detail)
values ('ec000000-0000-4000-8000-000000000011','ec000000-0000-4000-8000-000000000001','Supabase test A','Test','Test','Post-test Evaluasi PISA',83.333333,10,12,'{}');
insert into public.quiz_results(id,user_id,quiz_type,score) values ('ec000000-0000-4000-8000-000000000011','ec000000-0000-4000-8000-000000000001','Post-test Evaluasi PISA',0) on conflict(id) do nothing;
insert into public.case_study_answers(user_id,student_name,student_class,student_school,module_id,case_title,research_question,student_opinion)
values ('ec000000-0000-4000-8000-000000000001','Test','Test','Test','tempe','Test','Test','Test');
insert into public.lab_records(user_id,student_name,experiment_type) values ('ec000000-0000-4000-8000-000000000001','Test','tempe');
-- Existing CMS quiz payload remains valid.
insert into public.quiz_results(user_id,quiz_type,module_page,score,max_score,answers)
values ('ec000000-0000-4000-8000-000000000001','multiple_choice',1,4,5,'{}');
do $$ begin
 if (select score from public.quiz_results where id='ec000000-0000-4000-8000-000000000011') <> 83.333333 then raise exception 'Fractional score or idempotency broken'; end if;
 begin
  update public.quiz_results set user_id='ec000000-0000-4000-8000-000000000002' where id='ec000000-0000-4000-8000-000000000011';
  raise exception 'Ownership transfer allowed';
 exception when insufficient_privilege then null; end;
end $$;
select set_config('request.jwt.claims','{"sub":"ec000000-0000-4000-8000-000000000002","role":"authenticated","app_metadata":{},"user_metadata":{"role":"admin"}}',true);
do $$ declare n integer; begin
 if exists(select 1 from public.users where id='ec000000-0000-4000-8000-000000000001')
 or exists(select 1 from public.quiz_results where user_id='ec000000-0000-4000-8000-000000000001')
 or exists(select 1 from public.case_study_answers where user_id='ec000000-0000-4000-8000-000000000001')
 or exists(select 1 from public.lab_records where user_id='ec000000-0000-4000-8000-000000000001') then raise exception 'Cross-student read allowed'; end if;
 update public.users set name='Forbidden' where id='ec000000-0000-4000-8000-000000000001';
 get diagnostics n = row_count; if n <> 0 then raise exception 'Cross-student update allowed'; end if;
 delete from public.quiz_results where user_id='ec000000-0000-4000-8000-000000000001';
 get diagnostics n = row_count; if n <> 0 then raise exception 'Cross-student delete allowed'; end if;
 begin
  insert into public.lab_records(user_id,student_name,experiment_type) values ('ec000000-0000-4000-8000-000000000001','Forbidden','Test');
  raise exception 'Cross-student insert allowed';
 exception when insufficient_privilege then null; end;
end $$;
select set_config('request.jwt.claims','{"sub":"ec000000-0000-4000-8000-000000000002","role":"authenticated","app_metadata":{"role":"admin"}}',true);
do $$ begin
 if (select count(*) from public.quiz_results where user_id='ec000000-0000-4000-8000-000000000001') <> 2 then raise exception 'Admin read failed'; end if;
end $$;
select set_config('request.jwt.claims','{"sub":"ec000000-0000-4000-8000-000000000001","role":"authenticated","app_metadata":{}}',true);
delete from public.quiz_results where user_id='ec000000-0000-4000-8000-000000000001';
delete from public.users where id='ec000000-0000-4000-8000-000000000001';
do $$ begin
 if exists(select 1 from public.lab_records where user_id='ec000000-0000-4000-8000-000000000001') or exists(select 1 from public.case_study_answers where user_id='ec000000-0000-4000-8000-000000000001') then raise exception 'Profile deletion left child rows'; end if;
end $$;
set local role anon;
do $$ begin
 begin perform 1 from public.users; raise exception 'Unauthenticated student read allowed'; exception when insufficient_privilege then null; end;
 perform 1 from public.module_assets;
end $$;
rollback;
