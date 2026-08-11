# Rocktivate — Feature Tracker

Last updated: 2026-08-11

Status legend: ✅ Implemented · 🟡 Partial / needs wiring · ⬜ Not started

This tracks what exists in the codebase today (`lib/`), so it can be updated as work continues. Update the status and "Notes" column as features change — this file reflects code, not intentions.

## Auth & Onboarding

| Feature | Status | Files | Notes |
|---|---|---|---|
| Email/password sign in | ✅ | `sign_up_signin/login/` | |
| Email/password sign up | ✅ | `sign_up_signin/create/` | |
| Forgot password | ✅ | `sign_up_signin/forgot_password/` | |
| Google sign-in | 🟡 | `auth/auth_manager.dart` (`GoogleSignInManager` mixin) | Mixin declared, **not** applied to `SupabaseAuthManager`. No button on login screen. |
| Apple sign-in | 🟡 | `auth/auth_manager.dart` (`AppleSignInManager` mixin), `sign_in_with_apple` dependency | Package installed, mixin declared, but not wired into `SupabaseAuthManager` or the login UI. |
| Facebook / Microsoft / Github sign-in | ⬜ | `auth/auth_manager.dart` | Mixins declared only, no implementation, no UI. |
| Anonymous sign-in | ⬜ | `auth/auth_manager.dart` (`AnonymousSignInManager` mixin) | Declared, unused. |
| Onboarding walkthrough | ✅ | `onboarding/onboarding/`, `onboarding/onboard/` | |
| Post-login routing ("director") | ✅ | `login_director/` | Routes user based on auth/onboarding state. |

## Community

| Feature | Status | Files | Notes |
|---|---|---|---|
| Browse communities | ✅ | `pages/community/` | |
| Community detail page | ✅ | `pages/community_detail/` | |
| Community members list | ✅ | `pages/community_members/` | |
| Community settings (manage/edit) | ✅ | `pages/community_settings/` | |
| My Communities list | ✅ | `pages/my_communities/` | |
| Join requests | ✅ | backed by `community_requests` table | |
| Private communities | ✅ | `communities.isPrivate` field exists | Confirm UI enforces it. |

## Social Feed

| Feature | Status | Files | Notes |
|---|---|---|---|
| Public feed | ✅ | `pages/public_feed/` | |
| Create post (text) | ✅ | `components/new_group_post_widget` | |
| Post with images | ✅ | `components/post_images_widget` | |
| Comments | ✅ | backed by `comments` table | |
| Likes (posts & comments) | ✅ | backed by `likes` table | |
| Group posts | ✅ | `posts.isGroupPost`, `posts.groupLink` | Links a post to a community. |

## Needs (Community Help Requests)

| Feature | Status | Files | Notes |
|---|---|---|---|
| Browse needs | ✅ | `pages/needs/` | |
| Need detail page | ✅ | `need_details/` | |
| Create a need | ✅ | `components/create_new_need_widget` | |
| Mark need fulfilled | ✅ | `needs.fulfilled` field exists | Confirm UI has a toggle/action. |

## Free Stuff (Giveaways)

| Feature | Status | Files | Notes |
|---|---|---|---|
| Browse free items | ✅ | `pages/free_stuff/` | |
| Item detail page | ✅ | `pages/freebie_details/` | |
| My Freebies (manage own listings) | ✅ | `pages/my_freebies/` | |
| Freebie settings (create/edit) | ✅ | `pages/freebie_settings/` | |
| Availability toggle | ✅ | `freebies.isAvailable` field exists | |

## Accommodation

| Feature | Status | Files | Notes |
|---|---|---|---|
| Property listings | ✅ | `pages/accomodation/`, backed by `property` table | Rich schema: type, address, price, bedrooms/bathrooms, parking, status. |
| Accommodation detail page | ✅ | `accomodation_details/` | |

## Chat / Messaging

| Feature | Status | Files | Notes |
|---|---|---|---|
| Conversation list | ✅ | `chat/my_messages/`, `conversation_list` view | |
| 1:1 chat thread | ✅ | `chat/chat/`, `chat/message_bubble/` | |
| Start new chat | ✅ | `chat/new_chat/` | |
| Read receipts | 🟡 | `conversation_participants.lastReadAt` field exists | Confirm UI reflects read state. |

## Bible Reader

| Feature | Status | Files | Notes |
|---|---|---|---|
| List Bible translations | ✅ | `bible/bibles/` | Source: `api.bible` (`rest.api.bible/v1/`). |
| List books | ✅ | `bible/books/` | |
| List chapters | ✅ | `bible/chapters/` | |
| Chapter reading view | ✅ | `bible/chapter_data/` | |

## AI Bible Assistant

| Feature | Status | Files | Notes |
|---|---|---|---|
| Ask-AI Q&A | ✅ | `components/a_i_response_widget`, `backend/api_requests/api_calls.dart` (`ChatGPTCall`) | Calls OpenAI `gpt-4o-mini` directly from the client with a system prompt framing it as a "bible scholar." Markdown-rendered response. |
| Conversation history for AI chat | ⬜ | — | Each question appears to be a single-shot call, no thread persistence found. Verify. |

## Profile

| Feature | Status | Files | Notes |
|---|---|---|---|
| View/edit profile | ✅ | `profile/`, backed by `people` table | Fields: name, birthday, email, country, postcode, gender, bio, profile image. |
| Onboarding completion flag | ✅ | `people.hasCompletedOnboarding` | |

## Search

| Feature | Status | Files | Notes |
|---|---|---|---|
| Global search | ✅ | `search/` | Verify which entities it covers (posts/needs/freebies/people/communities). |

## Home

| Feature | Status | Files | Notes |
|---|---|---|---|
| Home hub screen | ✅ | `home/` | Embeds AI assistant and a webview (`webviewx_plus`) — confirm what the webview loads. |
| Dynamic menu | 🟡 | `menu_items` table (title, image, gradient, orderIndex, enabled) | Table exists for a configurable menu; confirm it's rendered somewhere (not yet traced to a widget in this pass). |

## Platform / Infra

| Item | Status | Notes |
|---|---|---|
| Supabase backend (Postgres + Auth + Realtime + Storage) | ✅ | |
| Routing | ✅ | `go_router` via `flutter_flow/nav/nav.dart` |
| State management | ✅ | `provider` |
| Deep linking | ✅ | `app_links` package present |
| Localization scaffolding | ✅ | `flutter_localizations` dependency present — verify actual translated strings exist |
| Web build | ✅ | Confirmed working (`flutter run -d chrome`) |
| Android build | ✅ (assumed) | Not explicitly re-verified this session |
| iOS build | ✅ | Confirmed working on simulator as of 2026-08-11, after installing CocoaPods |
| macOS build | 🟡 | Should work now that CocoaPods is installed — not explicitly re-verified |

## Open Questions to Resolve

- Which entities does the search screen actually query?
- Does the `menu_items` table drive a real UI, or is it unused/legacy?
- Is the AI assistant single-turn only, or does it maintain conversation context?
- Are Google/Apple sign-in intentionally disabled, or mid-migration?
