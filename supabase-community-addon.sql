-- RTSA52GA Community Hub add-on schema (additive only).
-- This script creates only the new community tables; it does not alter or drop
-- existing community_registrations or vendor_profiles tables.
-- Run in Supabase Dashboard > SQL Editor > New query.

create table if not exists public.community_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 60),
  bio text not null default '' check (char_length(bio) <= 300),
  updated_at timestamptz not null default now()
);

create table if not exists public.community_posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 120),
  body text not null check (char_length(body) between 1 and 3000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.community_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.community_posts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 1500),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists community_posts_created_at_idx on public.community_posts(created_at desc);
create index if not exists community_posts_user_id_idx on public.community_posts(user_id);
create index if not exists community_comments_post_id_idx on public.community_comments(post_id, created_at);
create index if not exists community_comments_user_id_idx on public.community_comments(user_id);

alter table public.community_profiles enable row level security;
alter table public.community_posts enable row level security;
alter table public.community_comments enable row level security;

grant select on public.community_profiles, public.community_posts, public.community_comments to anon, authenticated;
grant insert, update on public.community_profiles to authenticated;
grant insert, delete on public.community_posts to authenticated;
grant insert, delete on public.community_comments to authenticated;

drop policy if exists "Community profiles are publicly readable" on public.community_profiles;
create policy "Community profiles are publicly readable" on public.community_profiles for select to anon, authenticated using (true);
drop policy if exists "Members insert own community profile" on public.community_profiles;
create policy "Members insert own community profile" on public.community_profiles for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Members update own community profile" on public.community_profiles;
create policy "Members update own community profile" on public.community_profiles for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Community posts are publicly readable" on public.community_posts;
create policy "Community posts are publicly readable" on public.community_posts for select to anon, authenticated using (true);
drop policy if exists "Members create own community posts" on public.community_posts;
create policy "Members create own community posts" on public.community_posts for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Members delete own community posts" on public.community_posts;
create policy "Members delete own community posts" on public.community_posts for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "Community comments are publicly readable" on public.community_comments;
create policy "Community comments are publicly readable" on public.community_comments for select to anon, authenticated using (true);
drop policy if exists "Members create own community comments" on public.community_comments;
create policy "Members create own community comments" on public.community_comments for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Members delete own community comments" on public.community_comments;
create policy "Members delete own community comments" on public.community_comments for delete to authenticated using (auth.uid() = user_id);
