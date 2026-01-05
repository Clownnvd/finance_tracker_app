# Architecture

This app uses a feature-first Clean Architecture split into:
- Presentation: UI + Cubit/Bloc
- Domain: Entities, Repositories (contracts), Usecases
- Data: Remote/Local datasources, Models, Repository implementations

## Layer Rules
- Presentation depends on Domain
- Domain depends on nothing
- Data depends on Domain (implements repository interfaces)
- Core is shared across features (network, error, DI, constants)

## Flow Example (Auth)
UI (LoginScreen)
→ AuthCubit
→ Usecase (Login)
→ AuthRepository (domain contract)
→ AuthRepositoryImpl (data)
→ AuthRemoteDataSource (Dio/Supabase)
→ Response mapped into domain entity / exceptions

## Error Handling
- Remote layer catches network exceptions
- `ExceptionMapper` converts low-level errors into app-specific exceptions:
  - `AuthException`
  - `NetworkException`
  - `TimeoutRequestException`
  - `ServerException`
  - fallback `AppException`

Presentation only handles `AppException` messages, never Dio errors directly.

## Network
`DioClient` is configured with:
- `baseUrl = SUPABASE_URL`
- headers:
  - `apikey: SUPABASE_ANON_KEY`
  - `Authorization: Bearer <access_token>` when available
- optional refresh-token strategy (if implemented)

## DI
GetIt wires:
- SessionLocalDataSource (token storage)
- Dio (via DioClient)
- Feature datasources
- Feature repositories
- Usecases
- Cubits

## Security Notes
- Avoid committing `.env`
- Prefer secure storage for access tokens on mobile
- Consider adding crash reporting and global error boundary