-- Remove exact duplicate metadata rows and make filename the stable natural key.
-- The oldest row is retained so existing references to its UUID remain valid.

with ranked as (
  select
    id,
    row_number() over (
      partition by filename
      order by created_at asc, id asc
    ) as duplicate_number
  from public.module_assets
)
delete from public.module_assets as asset
using ranked
where asset.id = ranked.id
  and ranked.duplicate_number > 1;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'module_assets_filename_key'
      and conrelid = 'public.module_assets'::regclass
  ) then
    alter table public.module_assets
      add constraint module_assets_filename_key unique (filename);
  end if;
end
$$;
