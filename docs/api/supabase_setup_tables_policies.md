
# Supabase – Hướng dẫn tạo **Tables** & **RLS Policies** (Template Finance Tracker)

Tài liệu này giúp bạn tạo nhanh các **bảng** và **Row Level Security (RLS) policies** cho ứng dụng Personal Finance Tracker trên Supabase, bám đúng schema bạn yêu cầu:

- **users**: `id, email, name, avatar_url`
- **categories**: `id, name, type, icon`
- **transactions**: `id, user_id, category_id, type, amount, note, date`
- **budgets**: `id, user_id, category_id, amount, month`
- **settings**: `user_id, reminder_on, budget_alert_on, tips_on`

> ✅ Chạy lần lượt từng khối SQL trong **Supabase Dashboard → SQL Editor**.  
> ✅ Sau khi tạo xong, đừng quên kiểm tra trong **Table Editor** và thử gọi API với Postman/ứng dụng Flutter.


---

## 0) Ghi chú quan trọng về Auth & JWT
- Các policy bên dưới dựa trên `auth.uid()` → **bạn phải có JWT của user** (đăng ký/đăng nhập qua Supabase Auth).  
- Khi gọi REST API từ client/Postman, luôn thêm header:
  ```http
  apikey: <ANON_KEY>
  Authorization: Bearer <USER_JWT>
  Content-Type: application/json
  ```
- Nếu cần seed dữ liệu từ server (bỏ qua RLS), dùng **service_role key** (server only).


---

## 1) Tạo **Tables**

> Lưu ý: Bảng `users` ở đây là profile riêng, **không phải** `auth.users`. Cột `id` là `uuid` để khớp với `auth.uid()`.

```sql
-- 1. USERS
create table if not exists public.users (
  id uuid primary key,                   -- phải khớp với auth.uid()
  email text unique not null,
  name text,
  avatar_url text
);

-- 2. CATEGORIES (dùng chung, public read)
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
```

### (Tuỳ chọn) Seed **categories**
```sql
insert into public.categories (name, type, icon) values
  ('Food','EXPENSE','food'),
  ('Shopping','EXPENSE','shopping_cart'),
  ('Housing','EXPENSE','house'),
  ('Salary','INCOME','money'),
  ('Freelance','INCOME','work')
on conflict do nothing;
```


---

## 2) Bật **RLS** & tạo **Policies**

> Mục tiêu: Mỗi user **chỉ xem/sửa/xoá dữ liệu của chính mình**; `categories` public read.

```sql
-- Enable RLS
alter table public.users        enable row level security;
alter table public.transactions enable row level security;
alter table public.budgets      enable row level security;
alter table public.settings     enable row level security;
alter table public.categories   enable row level security;  -- bật để kiểm soát kỹ hơn (vẫn cho phép SELECT công khai bên dưới)
```

### 2.1) Policies cho **users** (profile)
> Yêu cầu khi **INSERT**: body phải gửi `"id": "<auth.uid()>"` (id trong JWT).

```sql
-- Xem hồ sơ của chính mình
create policy "users_select_own"
on public.users for select
using (id = auth.uid());

-- Tạo hồ sơ của chính mình
create policy "users_insert_own"
on public.users for insert
with check (id = auth.uid());

-- Cập nhật hồ sơ của chính mình
create policy "users_update_own"
on public.users for update
using (id = auth.uid());
```

> Nếu muốn **admin** seed/điều chỉnh users từ server, có thể thêm policy cho `service_role` hoặc tạm thời disable RLS khi seed.


### 2.2) Policies cho **transactions**
```sql
-- Xem giao dịch của chính mình
create policy "transactions_select_own"
on public.transactions for select
using (user_id = auth.uid());

-- Thêm giao dịch cho chính mình
create policy "transactions_insert_own"
on public.transactions for insert
with check (user_id = auth.uid());

-- Sửa giao dịch của chính mình
create policy "transactions_update_own"
on public.transactions for update
using (user_id = auth.uid());

-- Xoá giao dịch của chính mình
create policy "transactions_delete_own"
on public.transactions for delete
using (user_id = auth.uid());
```

### 2.3) Policies cho **budgets**
```sql
create policy "budgets_select_own"
on public.budgets for select
using (user_id = auth.uid());

create policy "budgets_insert_own"
on public.budgets for insert
with check (user_id = auth.uid());

create policy "budgets_update_own"
on public.budgets for update
using (user_id = auth.uid());

create policy "budgets_delete_own"
on public.budgets for delete
using (user_id = auth.uid());
```

### 2.4) Policies cho **settings**
```sql
create policy "settings_select_own"
on public.settings for select
using (user_id = auth.uid());

create policy "settings_insert_own"
on public.settings for insert
with check (user_id = auth.uid());

create policy "settings_update_own"
on public.settings for update
using (user_id = auth.uid());

create policy "settings_delete_own"
on public.settings for delete
using (user_id = auth.uid());
```

### 2.5) Policies cho **categories**
**Công khai SELECT** (mọi người đều xem được), chỉ **service_role** mới được viết/xoá:
```sql
-- Cho phép ai cũng xem danh mục
create policy "categories_public_select"
on public.categories for select
to public
using (true);

-- Chỉ server (service_role) được sửa/xoá/thêm danh mục (tuỳ chọn)
create policy "categories_admin_write"
on public.categories for all
to service_role
using (true)
with check (true);
```


---

## 3) Test nhanh bằng REST (Postman)

### 3.1) Signup & Login để lấy **USER_JWT**
- `POST {{PROJECT_URL}}/auth/v1/signup`
```json
{ "email": "you@example.com", "password": "yourStrongPass" }
```
- Hoặc login: `POST {{PROJECT_URL}}/auth/v1/token?grant_type=password`  
  Body: `{ "email":"...", "password":"..." }`

> Lưu `access_token` (JWT) trong response.


### 3.2) Tạo hồ sơ user khớp `auth.uid()`
`POST {{PROJECT_URL}}/rest/v1/users`  
Headers:
```
apikey: {{ANON_KEY}}
Authorization: Bearer {{USER_JWT}}
Content-Type: application/json
Prefer: return=representation
```
Body **phải** có `id` đúng với `sub` trong JWT:
```json
{
  "id": "<USER_ID_FROM_JWT>",
  "email": "you@example.com",
  "name": "Your Name",
  "avatar_url": ""
}
```

### 3.3) Thêm giao dịch
`POST {{PROJECT_URL}}/rest/v1/transactions`
```json
{
  "user_id": "<USER_ID_FROM_JWT>",
  "category_id": 1,
  "type": "EXPENSE",
  "amount": 120000,
  "note": "Lunch",
  "date": "2025-08-13"
}
```

> Nếu bị lỗi `401 new row violates row-level security policy`, hãy kiểm tra:  
> - Header đã có **Bearer USER_JWT** chưa?  
> - Body có `id`/`user_id` khớp `auth.uid()` chưa?  
> - Policy đã tạo đúng và RLS đã bật chưa?


---

## 4) Tuỳ chọn: Gắn `users.id` tự động khi user đăng ký
Nếu muốn tự tạo hồ sơ sau khi signup (không cần client gọi POST /users), dùng **trigger** trên `auth.users`:

```sql
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
```

> Khi đó, sau khi signup, bản ghi trong `public.users` sẽ được tạo tự động.


---

## 5) Gỡ lỗi nhanh (FAQ)
- **400 `email_address_invalid` khi signup**: kiểm tra **Email domain allow list** (Auth → Providers → Email). Thêm domain hoặc tắt allowlist khi test.  
- **401 RLS**: thiếu JWT/headers, hoặc `id/user_id` không trùng `auth.uid()`.  
- **Không đọc được categories**: quên tạo policy `categories_public_select`.


---

**Hoàn tất!** Bạn có thể import file này vào repo dự án như `docs/supabase_setup_tables_policies.md` để Fresher làm theo.
