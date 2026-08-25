-- Keep educational media publicly readable while restricting every mutation
-- to authenticated users whose server-controlled app_metadata role is admin.

drop policy if exists "Public Insert for aset-sed" on storage.objects;
drop policy if exists "Public Update for aset-sed" on storage.objects;
drop policy if exists "Admin Insert for aset-sed" on storage.objects;
drop policy if exists "Admin Update for aset-sed" on storage.objects;
drop policy if exists "Admin Delete for aset-sed" on storage.objects;

create policy "Admin Insert for aset-sed"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'aset-sed'
  and ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin Update for aset-sed"
on storage.objects for update
to authenticated
using (
  bucket_id = 'aset-sed'
  and ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
)
with check (
  bucket_id = 'aset-sed'
  and ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin Delete for aset-sed"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'aset-sed'
  and ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

alter table public.module_assets enable row level security;

revoke insert, update, delete on public.module_assets
from public, anon, authenticated;
grant select on public.module_assets to anon, authenticated;
grant insert, update, delete on public.module_assets to authenticated;

drop policy if exists "Allow public insert on module_assets"
on public.module_assets;
drop policy if exists "Allow public update on module_assets"
on public.module_assets;
drop policy if exists "Admin insert module_assets"
on public.module_assets;
drop policy if exists "Admin update module_assets"
on public.module_assets;
drop policy if exists "Admin delete module_assets"
on public.module_assets;

create policy "Admin insert module_assets"
on public.module_assets for insert
to authenticated
with check (
  ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin update module_assets"
on public.module_assets for update
to authenticated
using (
  ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
)
with check (
  ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);

create policy "Admin delete module_assets"
on public.module_assets for delete
to authenticated
using (
  ((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin'
);
