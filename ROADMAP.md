# Flourish — Roadmap

Live at [flourish.is-a.dev](https://flourish.is-a.dev)

---

## Current status

| Platform | Status |
|---|---|
| Web (GitHub Pages) | Live |
| Microsoft Store | Live |
| Google Play | Closed track — needs 12 Android testers × 14 days |
| Amazon Appstore | Pending submission |
| Huawei AppGallery | Pending submission |
| Samsung Galaxy Store | Blocked — requires business registration |
| Apple App Store | Not started |

---

## Phase 1 — Complete store distribution *(now)*

Goal: get the app into every major Android store and unblock Google Play production access.

- [x] Microsoft Store — submitted and live
- [ ] Google Play production access — recruit 12 Android testers, maintain closed track for 14 days
- [ ] Amazon Appstore — submit APK via developer.amazon.com
- [ ] Huawei AppGallery — submit APK via developer.huawei.com/AppGallery
- [ ] GitHub Releases automation — create a tagged release + notify watchers on every store update *(done via `store-release.yml`)*

---

## Phase 2 — User growth & retention *(next 30–60 days)*

Goal: give early users reasons to return daily and invite others.

- [ ] **Daily streak notifications** — PWA push notification at a user-chosen time ("time to log")
- [ ] **Share a day** — generate a shareable image/card from a day's entries (no server needed, canvas API)
- [ ] **Onboarding flow** — 3-step first-run guide so new users understand the 7 tabs immediately
- [ ] **Export data** — one-tap CSV / JSON download of all entries
- [ ] **Import data** — restore from a previous export (migration path between devices for free users)
- [ ] **Tester recruitment page** — a simple landing page / Google Form linked from the app to onboard Android testers for Play production access

---

## Phase 3 — Feature depth *(60–120 days)*

Goal: make the app substantially more useful for daily self-tracking.

### Logging
- [ ] **Recurring templates** — save a common entry as a one-tap template (e.g. "Morning run 30m")
- [ ] **Batch entry** — log multiple activities for a past day in one session
- [ ] **Photos** — attach a photo to a nature or activity entry (stored as base64 in localStorage)

### Insights
- [ ] **Monthly review** — extend the existing weekly review to monthly roll-ups
- [ ] **Goal tracking** — set a target (e.g. "3 workouts/week") and see progress in dashboard
- [ ] **Habit calendar** — GitHub-style contribution grid per activity category
- [ ] **Finance trends** — month-over-month spend graph per category

### Nature
- [ ] **Location tagging** — optional place name attached to nature entries (no GPS required, free text)
- [ ] **Nature streak** — consecutive days with a nature score ≥ 3

---

## Phase 4 — Pro tier expansion *(120–180 days)*

Goal: make Pro genuinely compelling and self-sustaining.

- [ ] **AI weekly summary** — call Claude API server-side (edge function) to generate a plain-English summary of the week's entries; Pro only
- [ ] **Custom themes** — 3–4 additional color themes beyond the gold Pro theme
- [ ] **Multiple Firebase accounts** — let power users switch between their own Firebase projects
- [ ] **Web widgets** — embeddable badge (streak count, today's nature score) for personal sites
- [ ] **Android home-screen widget** — quick-log widget via TWA / shortcut

---

## Phase 5 — Platform expansion *(future)*

- [ ] **iOS Safari PWA** — audit and fix any iOS-specific layout or API issues (Web Speech API absent on iOS; need graceful fallback)
- [ ] **Apple App Store** — WKWebView wrapper via Xcode once iOS PWA issues are resolved
- [ ] **Samsung Galaxy Store** — requires business/commercial registration; revisit when entity is set up
- [ ] **Desktop PWA** — test and polish the installed desktop experience on Windows and macOS (currently functional but not optimised)
- [ ] **Offline-first hardening** — service worker caching for full offline use, not just install

---

## Backlog / ideas

These are not scheduled but worth considering:

- Telangana / regional language support (Telugu) for suggestions and UI strings
- Dark mode
- Keyboard shortcuts for power users on desktop
- CSV import from other habit trackers (Streaks, Habitica)
- Public API for personal automation (IFTTT, Zapier, n8n)
- Community leaderboard (opt-in, anonymous) for nature scores

---

## How to contribute

1. Open an [issue](https://github.com/joyfulmake/health-saver-app/issues) describing the feature or bug
2. For Android tester recruitment (unblocks Google Play): use the Play Console invite link and stay opted in for 14 days
3. PRs welcome — the entire app is one file (`index.html`), so changes are self-contained
