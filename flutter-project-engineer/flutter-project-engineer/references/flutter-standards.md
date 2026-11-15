# Flutter Development Standards

Read this when making architectural decisions, adding dependencies, or building a new feature. The guiding principle: **match what the project already does.** These are defaults for gaps, not a mandate to refactor.

## Contents
- Core practices
- Architecture
- State management
- Navigation, networking, data
- Dependencies
- UI and theming
- Security

## Core practices
- Follow Dart and Flutter best practices and the lints in `analysis_options.yaml`.
- Apply SOLID principles; keep widgets small and composable; prefer `const` constructors.
- Separate UI, state, and data concerns so each can be tested on its own.

## Architecture
- Use Clean Architecture (presentation / domain / data) when the app's size justifies it. For a small app, a simple feature-first structure is better than empty layers.
- Never add architectural complexity without a reason you can state in one sentence.

## State management
Use whatever the project already uses: BLoC / Cubit, Provider, or Riverpod. Don't mix approaches inside one project. For a new project with no preference, pick one and stay consistent.

## Navigation, networking, data
- **Navigation:** GoRouter (unless the project already uses another router consistently).
- **Networking:** Dio, with interceptors for auth/logging and typed error handling.
- **Dependency injection:** GetIt when the project needs it.
- **Models:** Freezed and JSON Serializable where they reduce boilerplate and bugs.
- **Persistence / backend:** Firebase, Supabase, SQLite, Hive, SharedPreferences as the feature requires. Use secure storage for tokens.

## Dependencies
Avoid unnecessary packages. Before adding one, check that it is maintained, null-safe, and that the Flutter SDK or an existing dependency doesn't already cover the need.

## UI and theming
- Responsive layouts (`LayoutBuilder`, `MediaQuery`, adaptive widgets); test small phones and tablets.
- Reusable components instead of copy-pasted widget trees.
- Centralized theme (colors, typography, spacing) with light/dark support where the project has it.
- Localization via `intl` / ARB files when the project supports multiple languages.
- Every async screen has loading, error (with retry), and empty states.

## Security
- Keep API keys and configuration out of source: use `--dart-define`, `.env` files that are git-ignored, or platform secret storage.
- Never commit keystores, `key.properties`, or service-account files.
- Validate and sanitize user input; use HTTPS only.
