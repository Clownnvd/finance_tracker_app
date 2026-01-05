# Finance Tracker (Flutter + Supabase)

A personal finance tracking app built with Flutter, Supabase, Dio, and Bloc/Cubit following a feature-first Clean Architecture approach.

## Tech Stack
- Flutter (UI)
- Bloc/Cubit (state management)
- Dio (HTTP client)
- Supabase (Auth + Postgres + RLS)
- GetIt (dependency injection)
- flutter_dotenv (environment variables)
- shared_preferences / flutter_secure_storage (token storage)

## Setup

### 1) Requirements
- Flutter SDK installed
- A Supabase project
- (Optional desktop) Windows/Linux/macOS supported

### 2) Create `.env`
Create a file named `.env` at project root:

SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=xxxx

go
Copy code

Create `.env.example`:

SUPABASE_URL=
SUPABASE_ANON_KEY=

csharp
Copy code

Make sure `.env` is ignored by Git.

### 3) Install dependencies
flutter pub get

shell
Copy code

### 4) Run app
flutter run

markdown
Copy code

## Supabase Database Setup

1) Open Supabase SQL Editor
2) Run the provided one-shot SQL setup script (tables, RLS, policies, views, functions)
3) Ensure RLS is enabled and policies are created

Expected tables:
- `public.users`
- `public.categories`
- `public.transactions`
- `public.budgets`
- `public.settings`

Optional:
- View `public.v_month_totals`
- Function `public.category_totals(...)`

## Project Structure (Feature-first)

lib/
core/
constants/
di/
error/
network/
router/
theme/
utils/
feature/
users/
auth/
data/
domain/
presentation/
dashboard/
data/
domain/
presentation/
shared/
widgets/

markdown
Copy code

## Scripts / Tips
- If you update generated files:
flutter pub run build_runner build --delete-conflicting-outputs

markdown
Copy code

## Common Issues
- Missing env vars: app shows "App initialization failed"
- `auth.uid()` is NULL in SQL editor when running as `postgres`
- Ensure `DioClient` attaches `apikey` and `Authorization: Bearer <token>`

## License
MIT