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
| Hosting | Cloudflare Pages (native Git integration — connected directly to this repo) |
| Deploy | GitHub push → Cloudflare builds & deploys automatically, no Actions workflow involved |

---

## Files

```
index.html          ← the entire app (edit this)
manifest.json       ← PWA manifest (standalone, shortcuts to Quick Log)
privacy.html        ← privacy policy (required for store listings)
icon-192.png        ← PWA icon
icon-512.png        ← PWA icon (maskable)
build.sh            ← runs during the Cloudflare Pages build; injects secrets into index.html
```

---

## Secrets (Cloudflare Pages project → Settings → Environment variables)

These are **not** GitHub secrets — Cloudflare's native Git integration builds directly from
its own dashboard, so the values live there instead. `build.sh` reads them as env vars at
build time and substitutes them into `index.html`.

| Variable | Purpose |
|----------|---------|
| `RAZORPAY_KEY` | Payment public key injected at build |
| `WEB3FORMS_KEY` | Contact form submissions |
| `FLOURISH_PRO_KEY` | Pro tier unlock validation |
| `FIREBASE_CONFIG` | JSON blob for Firestore sync (single line, no unescaped newlines) |

Cloudflare Pages project: `health-saver-app` → `health-saver-app.pages.dev`
Build command: `bash build.sh` · Build output directory: `/`

---

## Deploy

```bash
# Normal workflow — just push:
git push origin main  # Cloudflare Pages builds and deploys automatically

# Manual deploy (secrets injected manually first), only if you need to bypass Git:
npx wrangler pages deploy . --project-name health-saver-app
```

---

## Working on this project

```bash
cd /home/kali/dev-workspace/worktrees/health-saver-app
# Edit index.html directly — no build, open in browser to test
# ask Claude: "add a water intake tracker" or "fix the streak calculation"
```
