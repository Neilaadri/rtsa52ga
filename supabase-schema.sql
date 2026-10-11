-- RTSA52GA™ backend schema for Supabase
-- Run this whole script in Supabase Dashboard > SQL Editor > New query.
-- Row Level Security ensures each signed-in member can access only their own records.

create extension if not exists pgcrypto;

create table if not exists public.community_registrations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 80),
  email text check (email is null or char_length(email) <= 254),
  interest text not null check (char_length(interest) <= 100),
  experience_level text not null default 'I''m just starting' check (char_length(experience_level) <= 100),
  idea text check (idea is null or char_length(idea) <= 500),
  created_at timestamptz not null default now()
);

create table if not exists public.vendor_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  vendor_name text not null check (char_length(vendor_name) between 1 and 80),
  contact_email text not null check (char_length(contact_email) <= 254),
  category text not null check (char_length(category) <= 100),
  availability text not null default 'Available for projects' check (char_length(availability) <= 100),
  description text not null check (char_length(description) between 1 and 500),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists community_registrations_user_id_idx on public.community_registrations(user_id);
create index if not exists vendor_profiles_user_id_idx on public.vendor_profiles(user_id);

alter table public.community_registrations enable row level security;
alter table public.vendor_profiles enable row level security;

drop policy if exists "Members read own registrations" on public.community_registrations;
create policy "Members read own registrations" on public.community_registrations
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Members create own registrations" on public.community_registrations;
create policy "Members create own registrations" on public.community_registrations
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Members delete own registrations" on public.community_registrations;
create policy "Members delete own registrations" on public.community_registrations
  for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "Members read own vendor profiles" on public.vendor_profiles;
create policy "Members read own vendor profiles" on public.vendor_profiles
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Members create own vendor profiles" on public.vendor_profiles;
create policy "Members create own vendor profiles" on public.vendor_profiles
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Members update own vendor profiles" on public.vendor_profiles;
create policy "Members update own vendor profiles" on public.vendor_profiles
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Members delete own vendor profiles" on public.vendor_profiles;
create policy "Members delete own vendor profiles" on public.vendor_profiles
  for delete to authenticated using (auth.uid() = user_id);

grant usage on schema public to authenticated;
grant select, insert, delete on public.community_registrations to authenticated;
grant select, insert, update, delete on public.vendor_profiles to authenticated;
