# Repository Guidelines

## Project Structure & Module Organization
- `special_needs_planner/` houses the Flutter application.
- `special_needs_planner/lib/` contains app code: `main.dart`, `app.dart`, feature modules under `features/`, and shared UI in `ui/`.
- `special_needs_planner/lib/data/` holds state management, repositories, storage, and immutable models.
- `special_needs_planner/test/` contains widget and unit tests (e.g., `widget_test.dart`).
- Platform folders (`android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`) contain generated runner/build files.
- Root docs: `MVP.md`, `PRODUCT_SPEC.md`, and `claude.md` explain scope, architecture, and design intent.

## Build, Test, and Development Commands
Run from `special_needs_planner/`:
- `flutter run` runs the app on the default device.
- `flutter run -d chrome` runs the web build locally.
- `flutter build web` or `flutter build apk` creates release builds.
- `flutter test` executes the test suite.
- `flutter analyze` runs static analysis with project lints.

## Coding Style & Naming Conventions
- Dart/Flutter formatting: use `dart format` (or IDE auto-format) before committing.
- Follow `flutter_lints` (see `analysis_options.yaml`). Avoid `print` in production code.
- File names use `snake_case.dart` and widget/class names use `PascalCase` (e.g., `TherapySessionScreen`).
- Keep models immutable and prefer `copyWith` patterns (see `lib/data/models/`).

## Testing Guidelines
- Use Flutter’s built-in `test` framework; place tests in `special_needs_planner/test/` with `*_test.dart` naming.
- No explicit coverage target is defined; add tests for new state mutations in `AppStateStore` and key UI flows.

## Commit & Pull Request Guidelines
- Git history is minimal; no formal convention is established. Use short, imperative commits (e.g., "Add therapy session timer").
- PRs should include: a concise summary, linked issue (if any), and screenshots or screen recordings for UI changes.

## Architecture Overview
- State management uses a Provider-backed `AppStateStore` with `ChangeNotifier`.
- Persistence is local-first via SharedPreferences JSON serialization.
