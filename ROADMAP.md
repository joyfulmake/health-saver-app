# Flourish — Roadmap

Live at [flourish.is-a.dev](https://flourish.is-a.dev)

---

## Current status

| Platform | Status |
|---|---|
| Web (GitHub Pages) | Live |
| Microsoft Store | Live — v4.1 update pending upload |
| Google Play | **Production** — live as of 2026-06-24 |
| Amazon Appstore | Pending submission |
| Huawei AppGallery | Pending submission |
| Samsung Galaxy Store | Blocked — requires business registration |
| Apple App Store | Not started |

---

## v4.1 — Shipped (2026-06-24)

All 14 enhancements shipped in one release:

1. **Sidebar/drawer navigation** — bottom nav (5 items) + left drawer replaces 7-tab horizontal bar
2. **Dashboard hero card** — animated energy ring + week-over-week deltas on all KPIs
3. **Insights → pure data** — removed all prescriptive tips; patterns show data + time window only
4. **90-day calendar heatmap** — already existed; now in drawer under Records
5. **11 Body Systems panel** — new "Body" pane; live scores derived from actual log data, not static
6. **Dark mode** — CSS tokens + toggle in drawer footer; respects system `prefers-color-scheme`
7. **Push Notifications** — Web Push API, daily 9pm reminder; opt-in from drawer
8. **Correlation Intelligence** — auto-derived from 60 days of data: nature→direction, day-of-week, friction→spend, flow state
9. **CSV + Share card** — CSV existed; weekly share card for Pro (visual summary)
10. **Onboarding flow** — 4-step first-run carousel for new users with no entries
11. **Swipe actions CSS** — swipe-reveal CSS in place (JS touch handlers: backlog)
12. **Habit correlation patterns** — `buildCorrelations()` auto-derives statistical insights
13. **Body System weekly report** — Pro share card includes system scores
14. **Integration hooks stub** — "Coming soon" placeholder in drawer for Pro users

---

## Phase 1 — Complete store distribution *(now)*

- [x] Microsoft Store — live; v4.1 MSIX to be uploaded
- [x] Google Play — production live as of 2026-06-24
- [ ] Amazon Appstore — submit APK via developer.amazon.com
- [ ] Huawei AppGallery — submit APK via developer.huawei.com/AppGallery
- [ ] GitHub Releases automation *(done via `store-release.yml`)*

---

## Phase 2 — Retention and growth *(next 30–60 days)*

- [ ] **Swipe-to-edit gesture** — wire JS touch handlers for the existing swipe-reveal CSS
- [ ] **Import data** — restore from CSV export (migration path for free users)
- [ ] **Recurring templates** — one-tap log for common activities (e.g. "Morning run 30m")
- [ ] **Tester recruitment** — simple form linked from app to onboard more Android testers

---

## Phase 3 — Feature depth *(60–120 days)*

### Logging
- [ ] **Batch entry** — log multiple activities for a past day in one session
- [ ] **Photos** — attach a photo to a nature entry (base64 in localStorage)

### Insights
- [ ] **Monthly review** — extend weekly review to monthly roll-ups
- [ ] **Goal tracking** — set targets (e.g. "3 workouts/week") visible in dashboard

### Nature
- [ ] **Location tagging** — optional place name (free text, no GPS required)
- [ ] **Nature streak** — consecutive days with score ≥ 3

---

## Phase 4 — Pro tier expansion *(120–180 days)*

- [ ] **AI weekly summary** — Claude API edge function; plain-English week summary (Pro only)
- [ ] **Custom themes** — 3–4 additional color themes beyond gold Pro theme
- [ ] **Android home-screen widget** — quick-log widget via TWA shortcut

---

## Phase 5 — Platform expansion *(future)*

- [ ] **iOS Safari PWA** — audit Web Speech API fallback, layout fixes
- [ ] **Apple App Store** — WKWebView wrapper via Xcode
- [ ] **Samsung Galaxy Store** — requires business registration; revisit when entity is set up
- [ ] **Desktop PWA** — polish installed desktop experience on Windows / macOS
- [ ] **Offline-first** — service worker caching for full offline use

---

## Backlog / ideas

- Telangana / Telugu language support for suggestions
- Keyboard shortcuts for power users on desktop
- CSV import from other habit trackers (Streaks, Habitica)
- Public API for personal automation (IFTTT, Zapier, n8n)
- Community leaderboard (opt-in, anonymous) for nature scores

---

## How to contribute

1. Open an [issue](https://github.com/joyfulmake/health-saver-app/issues) describing the feature or bug
2. PRs welcome — the entire app is one file (`index.html`), so changes are self-contained
