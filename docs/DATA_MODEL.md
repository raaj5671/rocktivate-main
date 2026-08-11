# Rocktivate — Data Model (Supabase)

Last updated: 2026-08-11

Generated from `lib/backend/supabase/database/tables/*.dart`. This reflects the Dart model layer, not a live schema dump — re-verify against Supabase directly before relying on it for migrations.

## Base Tables

| Table | Key fields | Used by |
|---|---|---|
| `people` | uuid, firstName, lastName, preferredName, birthday, email, userUUID, profileImage, country, postCode, gender, hasCompletedOnboarding, bio | Profile, onboarding, auth linkage |
| `communities` | uuid, createdAt, createdBy, title, tileImage, headerImage, isPrivate | Community pages |
| `community_members` | uuid, createdAt, peopleLink, communityLink | Community membership |
| `community_requests` | uuid, createdAt, peopleLink, communityLink | Join requests |
| `posts` | uuid, description, createdBy, createdAt, isGroupPost, groupLink | Public feed, community feed |
| `comments` | uuid, createdAt, createdBy, text, postLink | Feed |
| `likes` | uuid, postLink, commentLink, personLink | Feed reactions |
| `needs` | uuid, createdAt, createdBy, title, description, fulfilled | Needs feature |
| `freebies` | uuid, createdAt, createdBy, title, description, isAvailable | Free Stuff feature |
| `property` | id, title, description, propertyType, address, city, state, postcode, country, price, currency, bedrooms, bathrooms, parkingSpaces, mainImageUrl, status, createdBy, createdAt, updatedAt | Accommodation feature |
| `conversations` | id, createdAt | Chat |
| `conversation_participants` | id, conversationId, userId, joinedAt, lastReadAt | Chat |
| `messages` | uuid, createdAt, body, sentBy, sentTo | Legacy/simple messaging? (see `chat_messages` below) |
| `chat_messages` | id, conversationId, senderId, body, createdAt | Chat thread messages |
| `countries` | uuid, name, countryID | Profile country picker, address forms |
| `menu_items` | uuid, orderIndex, title, image, gradient (x2), gradientDegree, enabled, subtitle | Possibly a configurable home-screen menu — verify it's actually rendered (see FEATURES.md open questions) |

## Views (pre-joined, read-optimized)

| View | Key fields | Purpose |
|---|---|---|
| `postsview` | uuid, description, createdBy, createdAt, isGroupPost, groupLink, fullname, commentscount, reactioncount, profileImage | Feed row with author + counts pre-joined — use this instead of joining `posts` + `people` + `comments` + `likes` client-side |
| `community_members_with_full_name` | communityMemberUUID, createdAt, peopleLink, communityLink, fullName, email, profileImage | Member list rendering |
| `community_requests_with_full_name` | communityMemberUUID, createdAt, peopleLink, communityLink, fullName, email, profileImage | Join-request review UI |
| `conversation_list` | conversationId, viewerId, otherUserId, otherUserName, otherUserImage, lastMessage, lastMessageAt | Chat inbox list |
| `conversation_messages` | messageUUID, sentAt, messageBody, sentBy, senderFullName, sentTo, recipientFullName | Chat thread with names pre-joined |
| `messages_with_sender` | messageUUID, sentAt, messageBody, senderUUID, senderFullName, senderProfileImage, recipientUUID, recipientFullName, recipientProfileImage | Same pattern for `messages` table |

## Notable Relationships (inferred from field names)

- `community_members.peopleLink` → `people`, `community_members.communityLink` → `communities`
- `posts.groupLink` → `communities` (when `isGroupPost` is true)
- `comments.postLink` → `posts`
- `likes.postLink` → `posts`, `likes.commentLink` → `comments`, `likes.personLink` → `people`
- `chat_messages.conversationId` → `conversations`, `chat_messages.senderId` → `people`/auth user
- `property.createdBy`, `needs.createdBy`, `freebies.createdBy`, `posts.createdBy`, `communities.createdBy` → likely all reference `people` or the Supabase auth user id

## External Data Sources (non-Supabase)

| Source | Used for | Notes |
|---|---|---|
| `api.bible` (`rest.api.bible/v1/`) | Bible translations, books, chapters, chapter text | `backend/api_requests/api_calls.dart`: `BiblesCall`, `BooksCall`, `ChapterCall`, `ChapterDataCall` |
| OpenAI (`api.openai.com/v1/chat/completions`, model `gpt-4o-mini`) | AI Bible-assistant Q&A | `ChatGPTCall` — **see `docs/KNOWN_ISSUES.md`: API key is currently hardcoded in the client** |

## To verify against live schema

This doc was built by reading generated Dart model files, which only expose fields FlutterFlow's schema generator picked up. Double-check the actual Supabase schema (Table Editor or `supabase db dump`) for:
- Foreign key constraints (the relationships above are inferred, not confirmed)
- RLS (Row Level Security) policies — especially important since the client talks to Supabase directly
- Any columns not surfaced in the Dart models
