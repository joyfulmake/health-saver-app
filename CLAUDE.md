# Flourish — CLAUDE.md

## Project overview

**Flourish** (`flourish.is-a.dev`) is a single-file PWA for honest self-tracking: habits, finance, time, and nature in one place. No build step, no framework, no server — pure HTML/CSS/JS. All data lives in `localStorage` (key `lifeos_v5`) unless the user signs in with Google (Pro), which syncs a copy of their entries to Flourish's own Firestore project under a private per-user path.

**Current version: v4.2** — released 2026-08-29 (onboarding rework, progressive-disclosure UX, faster entry management, gzip backup codes). v4.1 shipped 2026-06-25.

## Live URL & deployment

- **Live**: https://flourish.is-a.dev — **GitHub Pages**, custom domain, build type "GitHub Actions"
- **Repo**: github.com/joyfulmake/health-saver-app
- **Deploy**: push to `main` → `.github/workflows/deploy.yml` runs `build.sh` (secret injection) → publishes the flat directory to Pages. A merge to `main` is a production release — it is the URL the Play Store TWA loads.
- Secrets live in **GitHub repo → Settings → Secrets → Actions** (`RAZORPAY_KEY`, `WEB3FORMS_KEY`, `FLOURISH_PRO_KEY`, `FIREBASE_CONFIG`). The workflow hard-fails if a `__PLACEHOLDER__` survives injection.
- `health-saver-app.pages.dev` (Cloudflare Pages) is a **dead experiment** — not wired for secret injection, not the canonical host. Ignore it or delete the project.

```bash
git add -A && git commit -m "..." && git push   # then: gh run watch
```

## Architecture

- **Single file**: `index.html` — all CSS, JS, and HTML inline
- **No build step** for local dev — open `index.html` in a browser. The deploy workflow only does secret injection then publishes the flat directory.
- **Local dev**: open `index.html` directly in a browser; secrets will be `undefined` (payment and email features won't work, everything else does)
- `manifest.json` — PWA manifest (standalone, portrait-primary, shortcuts to Quick Log)
- `privacy.html` — standalone privacy policy page (required for store listings)

## Navigation (v4.1)

Replaced 7-tab horizontal bar with:
- **Bottom nav** (5 items): Log · Board · Patterns · Body · More
- **Left drawer**: all panes + tools (Export CSV, Share Week, Daily Reminder) + Settings
- `sw(tab, el)` syncs both bnav buttons and drawer-item highlights

## Secret injection (CI only)

Secrets are placeholder strings in `index.html` replaced by `sed` in the deploy workflow:

| Placeholder | GitHub Secret | Purpose |
|---|---|---|
| `__RAZORPAY_KEY__` | `RAZORPAY_KEY` | UPI/GPay payment gateway |
| `__WEB3FORMS_KEY__` | `WEB3FORMS_KEY` | Feedback + OTP emails to inbox |
| `__FLOURISH_PRO_KEY__` | `FLOURISH_PRO_KEY` | Direct pro unlock passphrase |
| `__FIREBASE_CONFIG__` | `FIREBASE_CONFIG` | Cloud sync — single-line JSON object |

`FIREBASE_CONFIG` uses Python injection (not `sed`) to handle JSON special characters safely. Value format: `{"apiKey":"AIza...","authDomain":"x.firebaseapp.com","projectId":"x","storageBucket":"x.appspot.com","messagingSenderId":"123","appId":"1:123:web:abc"}`

Never commit real keys. They live in GitHub → Settings → Secrets.

## Data model

```js
// entries[] stored in localStorage under key 'lifeos_v5'
{
  id, date, activity, category, duration,
  direction,       // 'directed' | 'distractor'
  mode,            // 'doing' | 'being' | 'social' | 'admin' | ...
  friction,        // 'low' | 'medium' | 'high'
  hasFinance,      // bool
  financeType,     // 'expense' | 'income'
  financeAmount,   // number
  financeCategory, // string
  natureScore,     // 1–5
  note
}
```

## App panes

`quicklog` · `dashboard` · `insights` · `body` · `nature` · `review` · `finance` · `time`

Each maps to a pane with `id="p-{name}"`. `body` is the new Body Systems pane (v4.1).

## Free vs Pro

**Free** (everyone): all logging, dashboard, insights, body systems, weekly review, voice logging, dark mode, push notifications  
**Pro** (₹99 founding / ₹100 one-time via Razorpay): cross-device sync via Firebase (user's own cloud), golden premium theme (`body.is-pro`), Pro badge in header, weekly share card, body system weekly report

## Key features (v4.1)

- **Bottom nav + left drawer** — 5-button bottom nav; drawer has all secondary panes + tools
- **Dashboard hero ring** — animated SVG energy ring with week-over-week delta indicators
- **Insights → pure patterns** — no tips, no gyan; pattern cards show data + time window only
- **11 Body Systems panel** — live scores from real log data; draining vs balancing per system; week delta
- **Dark mode** — full CSS dark theme; toggle in drawer footer; respects `prefers-color-scheme`
- **Correlation Intelligence** — auto-derived: nature→direction, best/worst day-of-week, friction→spend, flow %
- **90-day heatmap** — calendar grid in drawer under Records
- **Onboarding flow** — 4-step first-run carousel for users with no entries
- **Push Notifications** — daily 9pm reminder; opt-in from drawer
- **Weekly share card** — Pro: visual summary card with energy score, KPIs, body system dots
- **Guided wizard** — step-by-step entry flow
- **FAB mic** — voice logging for all users (Web Speech API, capability-detected)
- **Wisdom stories** — 50-story rotating banner (Thirukkural / philosophy)
- **Finance tracking** — attach income/expense to any log entry
- **Nature score** — 1–5 per entry; aggregated in dashboard

## Design tokens

```css
--cb:#1A4A8C  /* blue  */   --cg:#1A6B3C  /* green */
--ca:#B07020  /* amber */   --cr:#B83020  /* red   */
--cp:#5C2A9D  /* purple */  --ct:#0F6B6B  /* teal  */
--co:#C06520  /* orange */
```

Pro mode overrides: `body.is-pro` sets warm gold borders and background tints.
Dark mode overrides: `[data-theme="dark"]` on `<html>` element.

## App Store distribution

Full submission guide: `/home/kali/Coding/flourish-store-assets/STORE-SUBMISSION-GUIDE.md`

### Store Status (as of 2026-06-25)

| Store | Status |
|---|---|
| Google Play | **Live in production** (as of 2026-06-24) |
| Microsoft Store | Live — v4.1 MSIX pending upload |
| Amazon Appstore | Pending submission |
| Huawei AppGallery | Pending submission |
| Samsung Galaxy Store | Blocked — requires commercial/business registration |

### Key assets
- Signed APK: `/home/kali/Coding/flourish-twa/app-release-signed.apk` (1.7MB)
- AAB: `/home/kali/Coding/flourish-twa/app-release-bundle.aab`
- Windows MSIX: `/home/kali/Coding/flourish-windows.msix`
- Store icons + feature graphics: `/home/kali/Coding/flourish-store-assets/`

### Microsoft Store identity (Partner Center)
- Identity Name: `Flourishing.Flourish`
- Publisher: `CN=CF05ACFD-1A2C-4D3B-85CE-80828C73812E`
- Publisher Display Name: `Flourishing`
- App display name: `Flourish: Self Tracker`
- MSIX hand-crafted as ZIP — PWABuilder CLI cannot package for stores
- MSIX version must increment on each upload (e.g. 1.0.4.0 → 1.0.5.0)

### Microsoft Store MSIX build (manual)

Trigger via GitHub Actions → `build-msix.yml` → Run workflow. Download artifact, then upload via Partner Center → Packages.

## Firebase project

Project ID: `flourish-app-a5672` — Authentication (Google), Firestore enabled. Owned by Flourish, not the end user.
The `FIREBASE_CONFIG` GitHub secret carries this project's web config (injected into `index.html` at deploy).
Migrated 2026-08-29 from the old repurposed project `opsmanifest-d363a`; users re-sync on next sign-in (their local
entries push up to the new per-user doc — no server-side data migration needed as long as they still hold local data).
Data path: `users/{uid}/data/entries` (one document per user, holding `entries[]` + `deletedIds` + `updated`).

Firestore rules (per-user isolation — updated 2026-08-29):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Auth → Settings → **Authorized domains** must list every domain the app is served from
(`flourish.is-a.dev`, plus `health-saver-app.pages.dev` / `localhost` as needed) or Google
sign-in fails.

## Privacy policy

`privacy.html` is deployed alongside `index.html`. URL: `https://flourish.is-a.dev/privacy.html`
Required by Google Play, Microsoft Store, and other stores for production listings.
Free users: all data stays on-device (`localStorage`), nothing collected. Pro users who sign in:
a copy of their entries is stored in Flourish's own Firestore project (`flourish-app-a5672`) under
a private per-user path; Firebase Auth holds their Google ID, email, and display name. This must
match the Google Play Data Safety declaration (data collected, stored on our server, transmitted
off device, deletable on request).

## Pitfalls

- **Secret placeholders must be exact** — the `sed` replacements are literal string matches; any whitespace change breaks injection
- **localStorage only** — clearing browser data erases all entries for free users; Pro + Firebase is the backup path
- **Voice API** — requires HTTPS in production; works on `localhost` but not on bare `file://`
- **CDN cache** — after a deploy, force-push an empty commit if the CDN is serving stale HTML
- **Brace counter false positives** — the JS contains braces inside string literals (e.g. `==='{'`); use `node --check` to validate JS syntax, not a naive counter
- **MSIX version** — must be incremented in `AppxManifest.xml` before each Partner Center upload or the submission will be rejected
