# AI Coding Agent Instructions for IntegrationSchedulerProject/ui

## Project overview

This repository is a Flutter application named `ui` that targets mobile and web platforms.
The current implementation is a Google Keep-style note app with a web deployment workflow in `.github/workflows/flutter_web.yml`.

## Key files

- `lib/main.dart` — app entrypoint and `MaterialApp` configuration.
- `lib/keep_main.dart` — main screen implementation; currently the `build` method is unimplemented and there is commented-out UI scaffolding for a Keep-like layout.
- `lib/core/api/api_client.dart` — shared `Dio` client used for API requests.
- `lib/data/models/contents_model.dart`, `lib/data/models/note_model.dart` — domain models for note content.
- `pubspec.yaml` — dependencies include `flutter_staggered_grid_view`, `dio`, and `flutter_lints`.

## Development and build commands

Use Flutter stable commands for local development.

- Install dependencies:
  - `flutter pub get`
- Run on a local device/emulator:
  - `flutter run`
- Build for web:
  - `flutter build web --release --base-href "/<repo-name>/" --dart-define=API_URL=<url>`

The GitHub Actions workflow uses `flutter pub get` and `flutter build web --release` with `API_URL` passed from secrets.

## Important conventions

- Keep changes aligned with Flutter best practices and the existing simple architecture.
- Prefer small, incremental edits in `lib/keep_main.dart` rather than broad refactors, unless implementing a clear UI or API flow.
- The app uses `String.fromEnvironment('API_URL')` in `keep_main.dart`; local runs must pass `--dart-define=API_URL=...` when API calls are required.
- `analysis_options.yaml` and `flutter_lints` are configured for linting; keep code style consistent.

## What to focus on first

1. Implement the `KeepMainScreen.build` method or restore the commented UI scaffolding in `lib/keep_main.dart`.
2. Ensure API integration uses `ApiClient.instance` and handles response parsing safely.
3. Keep the app compatible with the existing web build flow.

## Notes for AI agents

- Do not assume there is a backend schema beyond the existing `/contents` and `/test-contents` endpoints used in `keep_main.dart`.
- Keep changes localized to Flutter UI and API client layers unless the user explicitly asks for additional architecture work.
- This repo currently lacks detailed project documentation beyond the generated README; rely on source code and CI workflow for behavior.
