create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  emergency_name text,
  emergency_phone text,
  language text not null default 'en' check (language in ('en','ta','hi','te')),
  created_at timestamptz not null default now()
);

create table if not exists public.checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mood smallint not null check (mood between 1 and 5),
  energy smallint not null check (energy between 1 and 5),
  note text not null default '' check (char_length(note) <= 500),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.checkins enable row level security;

create policy "Users read own profile" on public.profiles for select to authenticated using ((select auth.uid()) = id);
create policy "Users create own profile" on public.profiles for insert to authenticated with check ((select auth.uid()) = id);
create policy "Users update own profile" on public.profiles for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
create policy "Users read own checkins" on public.checkins for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users create own checkins" on public.checkins for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Users delete own checkins" on public.checkins for delete to authenticated using ((select auth.uid()) = user_id);
