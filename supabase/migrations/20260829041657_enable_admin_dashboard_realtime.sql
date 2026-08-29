do $$
declare
  target_table text;
begin
  foreach target_table in array array[
    'users',
    'quiz_results',
    'case_study_answers'
  ]
  loop
    if to_regclass(format('public.%I', target_table)) is null then
      raise exception 'Required Realtime table public.% does not exist',
        target_table;
    end if;

    if not exists (
      select 1
      from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = target_table
    ) then
      execute format(
        'alter publication supabase_realtime add table public.%I',
        target_table
      );
    end if;
  end loop;
end
$$;
