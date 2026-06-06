# Flourish — Architecture

## Overview

Flourish is a single-file progressive web app (PWA). There is no framework, no bundler, and no server. Everything — HTML, CSS, and JavaScript — lives in one file (`index.html`). All user data stays on-device in `localStorage` unless the user enables optional Firebase cloud sync via Pro.

---

## Tech stack

| Layer | Technology |
|---|---|
| App | Vanilla HTML / CSS / JS — single file |
| Storage (free) | `localStorage` — key `lifeos_v5` |
| Storage (Pro) | Firebase Firestore v10 (lazy-loaded) |
| Auth (Pro) | Firebase Authentication — Google sign-in |
| Payments | Razorpay (UPI / GPay / cards) |
| Email / OTP | Web3Forms |
| Voice input | Web Speech API (capability-detected at boot) |
| Hosting | GitHub Pages — `flourish.is-a.dev` |
| CI / CD | GitHub Actions |
| Windows package | MSIX (hand-crafted, `makeappx.exe`) |
| Android package | TWA — signed APK + AAB |

---

## Functional architecture

What the app does from the user's perspective:

```
┌─────────────────────────────────────────────────────────────┐
│                     Flourish PWA                            │
│                                                             │
│  ┌──────────┐  ┌───────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Quick Log│  │ Dashboard │  │ Insights │  │  Nature  │  │
│  │          │  │           │  │          │  │          │  │
│  │ • Wizard │  │ • Scores  │  │ • Radar  │  │ • 1-5    │  │
│  │ • Voice  │  │ • Streaks │  │ • Trends │  │  score   │  │
│  │ • Chips  │  │ • Finance │  │ • Season │  │ • Daily  │  │
│  └──────────┘  └───────────┘  └──────────┘  └──────────┘  │
│                                                             │
│  ┌──────────┐  ┌───────────┐  ┌──────────┐                 │
│  │  Review  │  │  Finance  │  │   Time   │                 │
│  │          │  │           │  │          │                 │
│  │ • Weekly │  │ • Income  │  │ • Mode   │                 │
│  │   digest │  │ • Expense │  │   split  │                 │
│  │ • Habits │  │ • Balance │  │ • Focus  │                 │
│  └──────────┘  └───────────┘  └──────────┘                 │
│                                                             │
│  Every tab reads from the same local entry store            │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical architecture

### Component diagram

```mermaid
graph TD
    subgraph Client["Browser / WebView"]
        UI["index.html\n(all CSS + JS inline)"]

        subgraph Tabs["7 Tabs"]
            QL[Quick Log]
            DB[Dashboard]
            IN[Insights]
            NT[Nature]
            RV[Review]
            FI[Finance]
            TI[Time]
        end

        subgraph Input["Input layer"]
            WZ[Guided Wizard]
            FAB[FAB Mic]
            VC[Voice — Web Speech API]
            CH[Suggestion chips]
        end

        LS[(localStorage\nlifeos_v5)]
    end

    subgraph External["External services"]
        FB[Firebase Firestore\nPro cloud sync]
        FBA[Firebase Auth\nGoogle sign-in]
        RZ[Razorpay\nPayment gateway]
        WF[Web3Forms\nEmail / OTP]
    end

    UI --> Tabs
    UI --> Input
    Input --> LS
    LS -->|Pro users only| FB
    FB --- FBA
    UI -->|Pro upgrade flow| RZ
    UI -->|Feedback + OTP| WF
```

### Data flow — logging an entry

```mermaid
flowchart TD
    A([User]) -->|tap FAB mic or Quick Log| B{Input method}
    B -->|voice| C[Web Speech API\ncaptures activity]
    B -->|manual| D[Suggestion chips\nor free text]
    C --> E[Guided Wizard\nstep-by-step fields]
    D --> E
    E --> F[saveEntry\nassign id + timestamp]
    F --> G[(localStorage\nlifeos_v5)]
    G -->|if Pro + Firebase ready| H[Firebase Firestore\nuser uid/data/entries]
    G --> I[Dashboard\nInsights\nFinance\nNature\nReview\nTime]
```

### Deployment pipeline

```mermaid
flowchart LR
    Dev[Developer\nWSL] -->|git push main| GH[(GitHub\nmain branch)]

    GH -->|deploy.yml\nauto on push| INJ[Secret injection\nsed + python3]
    INJ --> Pages[GitHub Pages\nflourish.is-a.dev]

    GH -->|build-msix.yml\nmanual dispatch| MSIX[MSIX artifact\nflourise-windows.msix]
    MSIX -->|manual upload\nPartner Center| MS[Microsoft Store\nlive]

    GH -->|TWA repo\nmanual| APK[Signed APK / AAB]
    APK -->|Play Console\nmanual upload| GP[Google Play\nclosed track]

    GH -->|store-release.yml\nmanual dispatch| REL[GitHub Release\n+ email to watchers]
```

---

## Data model

Each entry stored as a JSON object in the `lifeos_v5` array:

```js
{
  id,               // timestamp string
  date,             // "YYYY-MM-DD"
  activity,         // free text
  category,         // inferred or chosen
  duration,         // minutes
  direction,        // "directed" | "distractor"
  mode,             // "doing" | "being" | "social" | "admin" | ...
  friction,         // "low" | "medium" | "high"
  hasFinance,       // bool
  financeType,      // "expense" | "income"
  financeAmount,    // number
  financeCategory,  // string
  natureScore,      // 1–5
  note              // free text
}
```

Firebase path (Pro): `users/{uid}/data/entries` — full array written on each sync.

---

## Secret injection (CI only)

Secrets never touch the source file. The deploy workflow replaces placeholder strings at build time:

```
index.html (source)          GitHub Actions                  index.html (deployed)
─────────────────────────────────────────────────────────────────────────────────
__RAZORPAY_KEY__        →    sed replacement             →   AIza...
__WEB3FORMS_KEY__       →    sed replacement             →   abc123...
__FLOURISH_PRO_KEY__    →    sed replacement             →   passphrase
__FIREBASE_CONFIG__     →    python3 (JSON-safe)         →   {"apiKey":...}
```

---

## Free vs Pro

```
Free (everyone)                     Pro (₹99 founding / ₹100 one-time)
────────────────────────────────    ────────────────────────────────────
All 7 tabs                          Everything in Free
Voice logging                       Cross-device sync — Firebase Firestore
Guided wizard                       Golden premium theme (body.is-pro)
Wisdom stories                      Pro badge in header
Seasonal insights
Finance tracking
Nature score
```

---

## Design tokens

```css
--cb: #1A4A8C   /* brand blue  */    --cg: #1A6B3C   /* green  */
--ca: #B07020   /* amber       */    --cr: #B83020   /* red    */
--cp: #5C2A9D   /* purple      */    --ct: #0F6B6B   /* teal   */
--co: #C06520   /* orange      */
```

Pro mode: `body.is-pro` overrides to warm gold borders and background tints.
