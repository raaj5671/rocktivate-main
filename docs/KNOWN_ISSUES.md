# Rocktivate — Known Issues

Last updated: 2026-08-11

Status legend: 🔴 Open · 🟡 In progress · ✅ Resolved

## 🔴 Open

### 1. OpenAI API key hardcoded in client source — SECURITY
- **Where**: `lib/backend/api_requests/api_calls.dart`, `ChatGPTCall`, `Authorization: Bearer sk-proj-...`
- **Risk**: The key ships inside every compiled build (web, iOS, Android). Anyone can extract it from the app bundle/JS and use it to make OpenAI calls billed to your account.
- **Fix**:
  1. Rotate/revoke the exposed key in the OpenAI dashboard immediately.
  2. Move the OpenAI call server-side — e.g. a Supabase Edge Function that holds the key as a secret and the Flutter app calls instead of `api.openai.com` directly.
  3. Add rate limiting / auth checks on that Edge Function so only logged-in app users can trigger it.
- **Severity**: High — treat as a live incident, not a backlog item.

### 2. Social sign-in (Google/Apple/Facebook/Microsoft/Github) declared but not implemented
- **Where**: `lib/auth/auth_manager.dart` — mixins exist (`GoogleSignInManager`, `AppleSignInManager`, etc.) but `SupabaseAuthManager` only mixes in `EmailSignInManager`.
- **Impact**: `sign_in_with_apple` is a dependency but unused; no social buttons on the login screen. Either finish wiring these or remove the unused mixins/dependency to reduce confusion and app size.

### 3. Analyzer lint debt (1970 issues, all non-blocking)
- **Breakdown**: 1416 info (mostly `prefer_const_constructors`, a few `sized_box_for_whitespace`), 554 warnings (mostly `unused_import`, 58 `unnecessary_non_null_assertion`).
- **Impact**: None on runtime — purely style/perf lint noise typical of FlutterFlow exports. Not urgent, but worth a cleanup pass (`dart fix --apply` handles a large share of these automatically).
- **Two warnings worth a manual look**:
  - `lib/auth/supabase_auth/supabase_auth_manager.dart:59` — `updatePassword` is marked `@override` but doesn't actually override anything in the base `AuthManager` class (not declared there). Harmless but misleading annotation — remove `@override` or add the method to the base class.
  - `lib/flutter_flow/nav/serialization_util.dart:165` — unreachable `default` clause in a switch, already covered by preceding cases.

### 4. `menu_items` table — unclear if actually used
- Table exists with a full schema (title, image, gradient, order, enabled flag) suggesting a configurable home-screen menu, but no widget was traced back to it in this pass. Confirm whether it's live, legacy, or planned.

## ✅ Resolved (this session, 2026-08-11)

### 5. App failed to compile — `font_awesome_flutter: 10.7.0` incompatible with current Flutter SDK
- **Symptom**: `flutter run` failed with `The class 'IconData' can't be extended outside of its library because it's a final class.`
- **Cause**: Flutter 3.44.9 made `IconData` a `final` class; `font_awesome_flutter` 10.7.0 predates that change and subclasses it.
- **Fix**: Upgraded to `font_awesome_flutter: 11.0.0` in `pubspec.yaml`. The new version wraps icons in a `FaIconData` type instead of subclassing `IconData`, which required updating 3 call sites that extracted a raw `IconData` from an existing `FaIcon` and re-wrapped it:
  - `lib/flutter_flow/flutter_flow_choice_chips.dart`
  - `lib/flutter_flow/flutter_flow_icon_button.dart`
  - `lib/flutter_flow/flutter_flow_widgets.dart`

  Fix pattern: wrap the `IconData` in `FaIconData(...)` before passing to `FaIcon(...)`.

### 6. App failed to compile — `page_transition: 2.1.0` incompatible with current Flutter SDK
- **Symptom**: `Couldn't find constructor 'CupertinoPageTransitionsBuilder'`.
- **Cause**: Constructor signature changed upstream in Flutter; old package version called it with the old signature.
- **Fix**: Upgraded to `page_transition: 2.2.2`.

### 7. iOS/macOS builds failed — CocoaPods not installed
- **Symptom**: `flutter run` on the iOS simulator failed with `CocoaPods not installed or not in valid state.`
- **Cause**: CocoaPods is required to link native code for plugins with iOS-side implementations (`sqflite`, `app_links`, `sign_in_with_apple`, `image_picker`, `webview_flutter`, `video_player`, etc.). It wasn't installed on the dev machine.
- **First attempt failed**: `sudo gem install cocoapods` using macOS's bundled system Ruby (2.6.10) — current CocoaPods requires Ruby ≥ 3.0, and Apple has not updated system Ruby in years.
- **Working fix**: Installed Homebrew, then `brew install cocoapods` (which brings a compatible Ruby). Confirmed working — `pod install` and the Xcode build both completed, app launched on iPhone 17 simulator.
- **Follow-up note**: New terminal shells need `/opt/homebrew/bin` on `PATH` (added to `~/.zprofile` by the Homebrew installer) for `pod` to resolve.

## Verified Working (2026-08-11)

- `flutter analyze` — 0 errors (only lint info/warnings, see #3 above)
- `flutter run -d chrome` — builds and launches, Dart VM Service comes up
- `flutter run` on iOS simulator (iPhone 17) — `pod install` + Xcode build succeed, app launches
