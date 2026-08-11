# Rocktivate — Architecture Overview

Last updated: 2026-08-11

## Origin

This app was scaffolded/exported by **FlutterFlow** and is now maintained as a hand-editable Flutter codebase. That explains the file-naming convention (`*_widget.dart` + `*_model.dart` pairs per screen) and the volume of boilerplate lint warnings (unused imports, missing `const`) — normal for FlutterFlow exports, not a sign of hand-written sloppiness.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.44.9 / Dart 3.12.2 |
| Backend | Supabase (Postgres, Auth, Realtime, Storage) |
| Navigation | `go_router`, wrapped by FlutterFlow's `flutter_flow/nav/nav.dart` |
| State management | `provider` |
| AI | OpenAI `gpt-4o-mini` via direct REST call (no server-side proxy) |
| Bible content | `api.bible` public REST API |
| Deep linking | `app_links` |
| Local storage | `hive`, `sqflite`, `shared_preferences` |
| Auth | `supabase_flutter` (email/password wired; social providers scaffolded but unused) |

## Project Structure

```
lib/
├── auth/                  Auth abstraction (AuthManager) + Supabase implementation
├── backend/
│   ├── api_requests/      Raw REST calls (OpenAI, api.Bible) — api_calls.dart
│   └── supabase/
│       ├── database/tables/   One Dart model per Supabase table/view
│       └── storage/           Supabase Storage helpers
├── components/            Shared, reusable widgets used across screens
├── flutter_flow/          FlutterFlow runtime support code (theme, nav, utils, custom widgets)
├── pages/                 Most feature screens (community, feed, needs, freebies, accommodation)
├── home/, profile/, search/, chat/, bible/, onboarding/,
│   sign_up_signin/, login_director/, need_details/,
│   accomodation_details/   Additional top-level screens
└── main.dart               App entry point
```

Each screen typically has:
- `*_widget.dart` — the UI (StatefulWidget wrapping a Model)
- `*_model.dart` — form controllers, animation controllers, disposal logic

## Navigation

All routes are registered in `lib/flutter_flow/router.dart` / `lib/flutter_flow/nav/nav.dart` using `go_router`. Route names/paths are static members on each screen's widget class (`SomeWidget.routeName`, `SomeWidget.routePath`). To find every screen in the app, grep that file rather than walking directories — some widgets (e.g. dialogs, bottom sheets) live outside `pages/` and don't have routes.

## Data Flow

- Supabase tables are wrapped in typed Dart classes under `backend/supabase/database/tables/`, generated from the Supabase schema. Several **views** exist alongside base tables to pre-join data for the UI (e.g. `postsview`, `messages_with_sender`, `community_members_with_full_name`) — prefer reading from these views over re-joining client-side.
- The OpenAI and api.Bible calls in `backend/api_requests/api_calls.dart` are called directly from the client with the API key/config inline — there is no backend proxy for these two integrations. See `docs/DATA_MODEL.md` for the full table list.

## Known Environment Setup Requirements

- **CocoaPods** is required for iOS/macOS builds (native plugin linking for `sqflite`, `app_links`, `sign_in_with_apple`, `image_picker`, `webview_flutter`, `video_player`, etc.). macOS's bundled system Ruby (2.6.10) is too old for modern CocoaPods — install via Homebrew (`brew install cocoapods`), not `sudo gem install cocoapods`.
- Supabase URL and anon key are hardcoded in `lib/backend/supabase/supabase.dart` (this is normal for the anon key, which is designed to be public — RLS policies enforce real security server-side).
- **⚠️ Security issue, not just a TODO**: `ChatGPTCall` in `backend/api_requests/api_calls.dart` has a **live OpenAI secret key hardcoded in plaintext** (`Authorization: Bearer sk-proj-...`) and calls the OpenAI API directly from the client. This key ships inside every build of the app and can be extracted by anyone who downloads it. See `docs/KNOWN_ISSUES.md` for the recommended fix (rotate the key, move the call behind a Supabase Edge Function).

See `docs/KNOWN_ISSUES.md` for build issues encountered and fixed, and `docs/FEATURES.md` for what's implemented.
