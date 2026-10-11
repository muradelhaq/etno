begin;
insert into auth.users(id,aud,role,is_anonymous) values('ec000000-0000-4000-8000-000000000091','authenticated','authenticated',true);
set local role authenticated;
select set_config('request.jwt.claims','{"sub":"ec000000-0000-4000-8000-000000000091","role":"authenticated","app_metadata":{}}',true);
insert into public.users(id,name,class_name,school,role) values('ec000000-0000-4000-8000-000000000091','Diagnostic rollback','Test','Test','siswa');
update public.users set total_xp=35,current_slide=4 where id='ec000000-0000-4000-8000-000000000091';
insert into public.quiz_results(id,user_id,student_name,student_class,student_school,quiz_type,score,correct_count,total_questions,answers_detail) values('ec000000-0000-4000-8000-000000000092','ec000000-0000-4000-8000-000000000091','Test','Test','Test','Post-test Evaluasi PISA',83.333333,10,12,'{}') on conflict(id) do nothing;
insert into public.quiz_results(id,user_id,student_name,student_class,student_school,quiz_type,score,correct_count,total_questions,answers_detail) values('ec000000-0000-4000-8000-000000000092','ec000000-0000-4000-8000-000000000091','Test','Test','Test','Post-test Evaluasi PISA',83.333333,10,12,'{}') on conflict(id) do nothing;
insert into public.case_study_answers(user_id,student_name,student_class,student_school,module_id,case_title,student_opinion) values('ec000000-0000-4000-8000-000000000091','Test','Test','Test','tempe','Test','Test');
insert into public.lab_records(user_id,student_name,experiment_type,observation_data) values('ec000000-0000-4000-8000-000000000091','Test','tempe','{}');
do $$ begin
 if (select total_xp from public.users where id='ec000000-0000-4000-8000-000000000091') <> 35 then raise exception 'Progress sync failed'; end if;
 if (select count(*) from public.quiz_results where user_id='ec000000-0000-4000-8000-000000000091') <> 1 then raise exception 'Quiz sync failed'; end if;
end $$;
rollback;
