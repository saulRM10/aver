create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text,
  last_name text,
  email text, 
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

-- Policies
create policy "Public profiles are viewable by everyone" 
  on public.profiles for select using (true);

create policy "Users can update own profile" 
  on public.profiles for update using (auth.uid() = id);

-- 3. Define the Function
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, first_name, last_name)
  values (
    new.id, 
    new.raw_user_meta_data ->> 'first_name', 
    new.raw_user_meta_data ->> 'last_name',
    new.email
  );
  return new;
end;
$$;

-- Trigger
--'drop if exists' so the migration is "idempotent" (can be run multiple times without error)
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();