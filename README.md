# Flourish
### Honest self-tracking for people who want to keep score without being managed

> *Not another productivity system. A single honest file that tracks what you actually care about.*

One HTML file. No build step. No framework. No server. Your habits, finances, time, and nature — in a browser tab that works offline, syncs to the cloud if you pay, and never lectures you.

**Live →** https://flourish.is-a.dev

---

## What it does

Most tracking apps make you feel bad for skipping. Flourish just records. It gives you the view — streaks, patterns, correlations — and gets out of the way.

```
Open browser → data loads from localStorage
     │
     ├─ Free           → full app, all features, data stays local
     └─ Pro (paid)     → Firebase sync across devices
```

Four modules in one file:

| Module | Tracks |
|--------|--------|
| **Habits** | Daily/weekly targets, streaks, skip counts |
| **Finance** | Income, expenses, categories, month-over-month |
| **Time** | Where hours go — deep work, admin, rest |
| **Nature** | Movement, sleep, sunlight, meals |

---

## Stack

| Layer | What |
|-------|------|
| Everything | Single `index.html` — HTML + CSS + JS inline |
| Storage | `localStorage` key `lifeos_v5` (no server needed) |
| Pro sync | Firebase Firestore (optional, Pro tier) |
| Auth | Firebase Auth (Pro tier) |
| Payments | Razorpay (Pro unlock) |
| Hosting | GitHub Pages, custom domain `flourish.is-a.dev` (build type: GitHub Actions) |
| Deploy | Push to `main` → `.github/workflows/deploy.yml` injects secrets via `build.sh`, then publishes |

---

## Files

```
index.html          ← the entire app (edit this)
manifest.json       ← PWA manifest (standalone, shortcuts to Quick Log)
privacy.html        ← privacy policy (required for store listings)
icon-192.png        ← PWA icon
icon-512.png        ← PWA icon (maskable)
build.sh            ← runs in the deploy workflow; injects build-time secrets into index.html
CNAME               ← binds the GitHub Pages site to flourish.is-a.dev (do not delete)
```

---

## Secrets (GitHub repo → Settings → Secrets and variables → Actions)

`build.sh` reads these as env vars during the deploy workflow and substitutes them into
`index.html`. Locally they are unset, so payment / email / cloud-sync features are inert —
everything else works.

| Variable | Purpose |
|----------|---------|
| `RAZORPAY_KEY` | Payment public key injected at build |
| `WEB3FORMS_KEY` | Contact form + Pro-activation notifications |
| `FLOURISH_PRO_KEY` | Pro tier unlock passphrase |
| `FIREBASE_CONFIG` | JSON blob for Firestore sync (single line, no unescaped newlines) |

---

## Deploy

```bash
# Just push — the deploy workflow builds and publishes to flourish.is-a.dev:
git push origin main
```

The workflow fails the build if any `__SECRET__` placeholder survives injection, so a
missing repo secret can never ship a broken page. Watch a run with `gh run watch`.

---

## Working on this project

```bash
cd /home/kali/dev-workspace/worktrees/health-saver-app
# Edit index.html directly — no build, open in browser to test
# ask Claude: "add a water intake tracker" or "fix the streak calculation"
```
