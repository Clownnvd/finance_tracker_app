
-- =============================================================
-- Supabase Finance Tracker - ONE-SHOT SQL SETUP
-- Creates tables, seeds categories, enables RLS, and adds policies
-- Schema: public
-- =============================================================

-- ========== 0) EXTENSIONS (usually enabled by default) ==========
-- enable if needed
-- create extension if not exists "uuid-ossp";
-- create extension if not exists pgcrypto;

-- ========== 1) TABLES ==========================================

-- 1. USERS (profile table; id must match auth.users.id)
create table if not exists public.users (
  id uuid primary key,
  email text unique not null,
  name text,
  avatar_url text
);

-- 2. CATEGORIES (shared list)
create table if not exists public.categories (
  id bigint generated always as identity primary key,
  name text not null,
  type text not null check (type in ('INCOME','EXPENSE')),
  icon text
);

-- 3. TRANSACTIONS
create table if not exists public.transactions (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.users(id) on delete cascade,
  category_id bigint not null references public.categories(id),
  type text not null check (type in ('INCOME','EXPENSE')),
  amount double precision not null,
  note text,
  date date not null
);

-- 4. BUDGETS
create table if not exists public.budgets (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.users(id) on delete cascade,
  category_id bigint not null references public.categories(id),
  amount double precision not null,
  month int not null check (month between 1 and 12)
);

-- 5. SETTINGS
create table if not exists public.settings (
  user_id uuid primary key references public.users(id) on delete cascade,
  reminder_on boolean default true,
  budget_alert_on boolean default false,
  tips_on boolean default false
);

-- ========== 2) SEED CATEGORIES ================================
insert into public.categories (name, type, icon) values
  ('Food','EXPENSE','food'),
  ('Shopping','EXPENSE','shopping_cart'),
  ('Housing','EXPENSE','house'),
  ('Salary','INCOME','money'),
  ('Freelance','INCOME','work')
on conflict do nothing;

-- ========== 3) OPTIONAL: AUTO-CREATE PROFILE AFTER SIGNUP =====
-- This trigger inserts a row into public.users when a new auth.users is created
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email, name, avatar_url)
  values (new.id, new.email, split_part(new.email,'@',1), null)
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users for each row
execute procedure public.handle_new_user();

-- ========== 4) ENABLE RLS =====================================
alter table public.users        enable row level security;
alter table public.transactions enable row level security;
alter table public.budgets      enable row level security;
alter table public.settings     enable row level security;
alter table public.categories   enable row level security;

-- ========== 5) POLICIES =======================================

-- USERS: owner-only access
do $$ begin
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='users' and policyname='users_select_own') then
    create policy "users_select_own" on public.users for select using (id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='users' and policyname='users_insert_own') then
    create policy "users_insert_own" on public.users for insert with check (id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='users' and policyname='users_update_own') then
    create policy "users_update_own" on public.users for update using (id = auth.uid());
  end if;
end $$;

-- TRANSACTIONS: owner-only CRUD
do $$ begin
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='transactions' and policyname='transactions_select_own') then
    create policy "transactions_select_own" on public.transactions for select using (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='transactions' and policyname='transactions_insert_own') then
    create policy "transactions_insert_own" on public.transactions for insert with check (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='transactions' and policyname='transactions_update_own') then
    create policy "transactions_update_own" on public.transactions for update using (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='transactions' and policyname='transactions_delete_own') then
    create policy "transactions_delete_own" on public.transactions for delete using (user_id = auth.uid());
  end if;
end $$;

-- BUDGETS: owner-only CRUD
do $$ begin
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='budgets' and policyname='budgets_select_own') then
    create policy "budgets_select_own" on public.budgets for select using (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='budgets' and policyname='budgets_insert_own') then
    create policy "budgets_insert_own" on public.budgets for insert with check (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='budgets' and policyname='budgets_update_own') then
    create policy "budgets_update_own" on public.budgets for update using (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='budgets' and policyname='budgets_delete_own') then
    create policy "budgets_delete_own" on public.budgets for delete using (user_id = auth.uid());
  end if;
end $$;

-- SETTINGS: owner-only CRUD
do $$ begin
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='settings' and policyname='settings_select_own') then
    create policy "settings_select_own" on public.settings for select using (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='settings' and policyname='settings_insert_own') then
    create policy "settings_insert_own" on public.settings for insert with check (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='settings' and policyname='settings_update_own') then
    create policy "settings_update_own" on public.settings for update using (user_id = auth.uid());
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='settings' and policyname='settings_delete_own') then
    create policy "settings_delete_own" on public.settings for delete using (user_id = auth.uid());
  end if;
end $$;

-- CATEGORIES: public read; server write (optional)
do $$ begin
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='categories' and policyname='categories_public_select') then
    create policy "categories_public_select" on public.categories for select to public using (true);
  end if;
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='categories' and policyname='categories_admin_write') then
    create policy "categories_admin_write" on public.categories for all to service_role using (true) with check (true);
  end if;
end $$;

-- Chạy trên Supabase SQL Editor
create or replace view public.v_month_totals as
select
  user_id,
  type,
  date_trunc('month', date)::date as month,
  sum(amount) as total
from public.transactions
WHERE user_id = auth.uid()
group by user_id, type, date_trunc('month', date)::date;

-- Để view chạy dưới quyền caller (tôn trọng RLS)
alter view public.v_month_totals set (security_invoker = true);


-- Hàm tính tổng và phần trăm cho từng category, fix lỗi round(double precision, integer)
CREATE OR REPLACE FUNCTION public.category_totals(
  uid uuid, 
  start_date date, 
  end_date date, 
  cat_type text
)
RETURNS TABLE (
  category_id bigint,
  name text,
  total numeric,
  percent numeric
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id AS category_id,
    c.name,
    SUM(t.amount)::numeric AS total,
    ROUND(CAST(SUM(t.amount) * 100 / SUM(SUM(t.amount)) OVER () AS numeric), 2) AS percent
  FROM transactions t
  JOIN categories c ON c.id = t.category_id
  WHERE t.user_id = uid
    AND t.type = cat_type
    AND t.date BETWEEN start_date AND end_date
  GROUP BY c.id, c.name
  ORDER BY total DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

ALTER FUNCTION public.category_totals(uuid, date, date, text) OWNER TO postgres;


-- ========== 6) DONE ===========================================
-- Now you can:
-- - Sign up/login to get USER_JWT
-- - POST /rest/v1/users with { "id": "<USER_ID_FROM_JWT>", "email": "...", "name": "...", "avatar_url": "" }
-- - CRUD /transactions, /budgets, /settings with user_id = auth.uid()

-- drop table transactions;
-- drop table budgets;
-- drop table categories;
-- drop table settings;
-- drop table users;
