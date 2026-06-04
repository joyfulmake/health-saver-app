# Flourish — CLAUDE.md

## Project overview

**Flourish** (`flourish.is-a.dev`) is a single-file PWA for honest self-tracking: habits, finance, time, and nature in one place. No build step, no framework, no server — pure HTML/CSS/JS. All data lives in `localStorage` (key `lifeos_v5`) unless the user enables Firebase sync via Pro.

## Live URL & deployment

- **Live**: https://flourish.is-a.dev (custom domain → GitHub Pages)
- **Repo**: github.com/joyfulmake/health-saver-app
- **Auto-deploy**: push to `main` triggers `.github/workflows/deploy.yml` → GitHub Pages
- Secrets are injected by the CI workflow via `sed` — never hardcode them in source

**Deploy command** (manual, from WSL):

```bash
git add -p && git commit -m "..." && git push
# GitHub Actions deploys automatically; no local build needed
```

For Netlify fallback (not currently used):
```bash
export NVM_DIR="$HOME/.config/nvm" && . "$NVM_DIR/nvm.sh"
netlify deploy --prod --dir=. --no-build
```

## Architecture

- **Single file**: `index.html` — all CSS, JS, and HTML inline
- **No build step** — edit and push; the CI only does secret injection then deploys the flat directory
- **Local dev**: open `index.html` directly in a browser; secrets will be `undefined` (payment and email features won't work, everything else does)
- `manifest.json` — PWA manifest (standalone, portrait-primary, shortcuts to Quick Log)

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

## App tabs

`quicklog` · `dashboard` · `insights` · `nature` · `review` · `finance` · `time`

Each maps to a pane with `id="p-{name}"`.

## Free vs Pro

**Free** (everyone): all logging, dashboard, insights, weekly review, voice logging  
**Pro** (₹99 founding / ₹100 one-time via Razorpay): cross-device sync via Firebase (user's own cloud), golden premium theme (`body.is-pro`), Pro badge in header

## Key features (as of latest commit)

- **Guided wizard** — step-by-step entry flow; every field glows and the wizard self-directs the user through all steps
- **FAB mic** — prominent floating action button enters guided listening state; opens explore screen after a log entry
- **Voice logging** — Web Speech API on Activity field, Note field, and wizard Note card; free for all users; capability-detected at boot — FAB and mic buttons are hidden entirely on browsers that don't support it (no browser name restrictions; works on any device where the API is available, stops naturally when support ends)
- **Suggestion chips** — quick-pick activity chips in both the modal and the wizard
- **Wisdom stories** — 50-story rotating banner (15s each, 3-hour no-repeat), Thirukkural / philosophical quotes
- **Ambient particles** — subtle CSS animation on the quick-entry bar
- **Seasonal insights** — Telangana-specific advice per season (summer / monsoon / post-monsoon / winter)
- **Finance tracking** — attach income/expense to any log entry with category breakdown
- **Nature score** — 1–5 scale per entry; aggregated in dashboard

## Design tokens

```css
--cb:#1A4A8C  /* blue  */   --cg:#1A6B3C  /* green */
--ca:#B07020  /* amber */   --cr:#B83020  /* red   */
--cp:#5C2A9D  /* purple */  --ct:#0F6B6B  /* teal  */
--co:#C06520  /* orange */
```

Pro mode overrides: `body.is-pro` sets warm gold borders and background tints.

## App Store distribution

Full submission guide with step-by-step instructions for all stores:
`/home/kali/Coding/flourish-store-assets/STORE-SUBMISSION-GUIDE.md`

### Store Status (as of 2026-06-04)

| Store | Status |
|---|---|
| Google Play | Awaiting production access — need 12 Android testers × 14 days on closed track; ~6 confirmed so far (iOS users don't count) |
| Microsoft Store | Live — screenshots updated and resubmitted for certification (2026-06-04); awaiting screenshot update to propagate |
| Amazon Appstore | Pending — guide in STORE-SUBMISSION-GUIDE.md |
| Huawei AppGallery | Pending — guide in STORE-SUBMISSION-GUIDE.md |
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
- App display name: `Flourish: Self Tracker` (reserved)
- MSIX hand-crafted as ZIP — PWABuilder CLI cannot package for stores

### Google Play — production access checklist
- 12 unique **Android** testers must opt in and stay opted in for 14 consecutive days on closed track (iOS users cannot participate)
- Tester invite link: Play Console → Closed testing → your track → copy invite link
- After 14 days: Play Console → Production → Start rollout → Apply for access

## Firebase project

Project ID: `opsmanifest-d363a` — Authentication (Google), Firestore enabled.
Firestore rule: `allow read, write: if request.auth != null;`
Data path: `users/{uid}/data/entries`

## Pitfalls

- **Secret placeholders must be exact** — the `sed` replacements are literal string matches; any whitespace change breaks injection
- **localStorage only** — clearing browser data erases all entries for free users; Pro + Firebase is the backup path
- **Voice API** — requires HTTPS in production; works on `localhost` but not on bare `file://`
- **CDN cache** — after a deploy, force-push an empty commit if the CDN is serving stale HTML (see commit `cab1e42`)
