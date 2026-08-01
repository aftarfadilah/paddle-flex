# Strion — SPEC.md

## 1. Concept & Vision

**Strion** is a social fitness tracker for padel players — the intersection of a serious performance log and an Instagram-style flex machine. It scratches the itch to share your wins, see where you rank, and feel the FOMO when someone in your club just beat your streak. Think Strava meets BeReal: logging a session should feel as satisfying as posting it.

**Tagline:** *"Every session. Every win. Let them know."*

**Core feeling:** Competitive, addictive, slightly vain. The app rewards consistency and wins — not just participation.

---

## 2. Design Language

### Aesthetic Direction
Dark-first athletic luxury — inspired by Nike Training Club meets Discord. Bold, high-contrast, with electric accent colors that feel fast and competitive.

### Color Palette
```
Background:     #0D0D0F (near black)
Surface:        #1A1A1F (card backgrounds)
Surface Raised: #252530 (elevated cards, inputs)
Primary:        #00D4AA (electric teal — energy, wins)
Accent:        #FF6B35 (orange-red — FOMO, streaks, fire)
Warning:       #FFD60A (gold — achievements)
Text Primary:  #FFFFFF
Text Secondary:#8E8E9A
Border:        #2E2E3A
Error:         #FF453A
```

### Typography
- **Display/Headings:** `Space Grotesk` (bold, geometric, sporty)
- **Body:** `Inter` (clean, readable)
- **Mono/Stats:** `JetBrains Mono` (numbers, leaderboard ranks)

### Spatial System
- Base unit: 8px
- Card border radius: 16px
- Button border radius: 12px
- Standard padding: 16px
- Card gap: 12px

### Motion Philosophy
- Micro-interactions on every tap (scale 0.95 → 1.0, 100ms)
- Page transitions: slide-up on push, fade on pop
- Number counters animate when stats load (count-up)
- Streak "fire" icons pulse subtly when active
- Like button: heart bounce + particle burst

### Visual Assets
- Icons: Lucide (consistent stroke, modern)
- Avatars: Circle, gradient placeholder if no photo
- Stat cards: glassmorphism effect (blur + border)
- Achievement badges: filled icons with glow effect

---

## 3. Layout & Structure

### Navigation
Bottom navigation bar (5 tabs):
1. **Feed** — social activity
2. **Log** — log a new session (center, prominent)
3. **Leaderboard** — rankings
4. **Profile** — your stats + flex
5. **More** — settings, clubs, tips/content

### Screen Flow
```
Splash → Auth (Google) → Home (Feed)
                      ↓
              Bottom Nav
  ┌───────────┬───────────┬───────────┬───────────┐
  │   Feed     │    Log    │  Leader   │  Profile  │
  │            │  Session  │   board   │           │
  │            │           │           │           │
  │            │           │           │           │
  └───────────┴───────────┴───────────┴───────────┘
                      ↓
                  [More] → Clubs, Tips, Settings
```

### Responsive Strategy
Mobile-first. Single column. Cards stack vertically. No desktop breakpoints for MVP.

---

## 4. Features & Interactions

### 4.1 Authentication
- Google Sign-In (primary)
- Auto-create Firestore user document on first sign-in
- Guest mode: can browse feed but can't log sessions
- Profile completion prompt after first sign-in

### 4.2 Log a Session
**Core action — this is the heart of the app.**

Fields:
- **Date** — date picker (default: today)
- **Partner** — search/select from club members (optional, for doubles)
- **Opponents** — multi-select opponents (optional)
- **Result** — Win / Loss / Practice (radio)
- **Score** — e.g. "6-3, 4-6, 7-5" (text field)
- **Duration** — minutes (number input)
- **Notes** — free text (optional)
- **Post to feed** — toggle (default: ON)

On submit:
- Save to Firestore `sessions` collection
- Update user stats (win/loss, total sessions, streak)
- If "post to feed" is ON → create `feedPost` document
- Show success animation + share card preview
- Navigate to the share card (can screenshot/share)

### 4.3 Activity Feed
- Chronological feed of session posts from followed users
- Each post card shows:
  - User avatar + name + timestamp
  - Result badge (WIN/LOSS/PRACTICE with color coding)
  - Score + duration
  - Partner/opponents if logged
  - Like button + count
  - Comment button + count
  - "Flex factor" (computed: win + close score + long rally = high flex)
- Pull-to-refresh
- Like: heart animation, optimistic UI update
- Comment: tap to open bottom sheet with comments

### 4.4 Profile
- Cover photo (gradient default)
- Avatar, display name, username (@handle)
- Club name
- Stats row: Sessions | Win Rate | Current Streak | Best Streak
- Bio (short text)
- "My Sessions" grid (last 9 session cards)
- Achievement badges (unlocked ones glow)
- Edit profile button (own profile)
- Follower/Following counts (tappable)

### 4.5 Leaderboard
Tabs: **This Week** | **This Month** | **All Time** | **Club**

Columns (toggle):
- Wins
- Win Rate
- Sessions
- Streak

Each row:
- Rank number (#1 has gold, #2 silver, #3 bronze)
- Avatar + name
- Club badge
- Stat value
- Trend arrow (up/down vs last period)

### 4.6 Achievements (Stretch MVP)
Badges unlocked automatically:
- 🏆 First Blood — log your first session
- 🔥 On Fire — 7-day streak
- 💪 Century — 100 sessions logged
- 👑 Champion — win a tournament (manual flag)
- 💎 Double Date — log 10 sessions with the same partner
- 📸 Flex Master — get 50+ likes on a single post

---

## 5. Component Inventory

### SessionCard
- Default: dark surface, result badge (green=W, red=L, gray=P), score, duration, avatar stack
- States: loading (shimmer), error (retry button)
- Tap → session detail page

### FeedPostCard
- Default: full session card + like/comment bar
- States: liked (filled heart, teal), loading (shimmer)
- Long-press → share options

### StatCard
- Glassmorphism: frosted glass with border
- Icon + label + animated number value
- Variants: small (profile row), large (detail page)

### LeaderboardRow
- Rank medal for top 3
- Name + avatar
- Stat value (bold mono font)
- Trend indicator

### BottomNavBar
- 5 icons with labels
- Center "Log" button is elevated/highlighted (primary color)
- Active tab: primary color icon + label
- Inactive: muted gray

### AchievementBadge
- Circular icon with glow
- Locked: grayscale + lock overlay
- Unlocked: full color + subtle pulse animation

---

## 6. Technical Approach

### Framework & Stack
- **Flutter 3.44.8** (Dart 3.5+)
- **Firebase** — Auth, Firestore, Analytics
- **State Management:** Riverpod (cleaner than Provider, better for scale)
- **Routing:** go_router
- **UI Components:** Material 3 with heavy custom theming

### Data Model (Firestore)

```
users/{userId}
  displayName: string
  username: string
  avatarUrl: string
  clubName: string
  bio: string
  sessionCount: int
  winCount: int
  lossCount: int
  currentStreak: int
  bestStreak: int
  followerCount: int
  followingCount: int
  createdAt: timestamp

sessions/{sessionId}
  userId: string
  date: timestamp
  result: "win" | "loss" | "practice"
  score: string
  durationMinutes: int
  partnerId: string? (userId)
  opponentIds: string[] (userIds)
  notes: string
  flexFactor: int (computed 1-100)
  likeCount: int
  commentCount: int
  createdAt: timestamp

feed/{postId}
  userId: string
  sessionId: string
  createdAt: timestamp

likes/{postId_userId} (compound key)
  postId: string
  userId: string
  createdAt: timestamp

follows/{followerId_followedId} (compound key)
  followerId: string
  followedId: string
  createdAt: timestamp
```

### API / Architecture
- All data via Firestore SDK (no custom backend for MVP)
- Cloud Functions for: computing flex factor, streak updates, leaderboard ranking
- Optimistic UI updates for likes/comments
- Firestore security rules enforce: users can only write their own sessions/posts

### Key Packages
```yaml
firebase_core: latest
firebase_auth: latest
cloud_firestore: latest
firebase_analytics: latest
flutter_riverpod: latest
go_router: latest
google_sign_in: latest
intl: latest (date formatting)
shimmer: latest (loading states)
flutter_animate: latest (animations)
```

---

## 7. MVP Scope (What we're building now)

### Phase 1 — Core Loop
1. Google Sign-In
2. Log a session + post to feed
3. Activity feed (see all posts)
4. Like a post
5. Profile with stats

### Phase 2 — Engagement
6. Leaderboard
7. Follow users
8. Comments
9. Achievements

### Phase 3 — Growth
10. Club pages
11. Share cards
12. Push notifications
13. Tournament mode
