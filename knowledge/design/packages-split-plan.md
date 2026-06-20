---
type: decision
title: "5-package split of @chirag127/oriz-ui"
description: "The plan to split oriz-ui v1.1.0 into five independently-publishable packages (firebase-init, auth-ui, contact-form, sidebar, oriz-family) plus a v2.0.0 deprecation shim. Shipped 2026-06-19."
tags: [decision, packages, oriz-kit, architecture]
timestamp: 2026-06-19
format_version: okf-v0.1
status: completed
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# 5-package split — plan

Date: 2026-06-19. Status: PROPOSAL. No code until user approval.

This document plans the split of `@chirag127/oriz-ui` v1.1.0 into five
independently-publishable packages. The goal: make the components reusable
by sites outside the oriz family, lean on well-maintained libraries for
accessibility-critical behaviour, and minimise the code I have to maintain.

## Library decisions (fixed by P2 research)

| Role | Pick | Why |
|---|---|---|
| Firebase init | none — `firebase` peer dep only | The init logic is 20 lines of singleton setup; no library helps. |
| Auth UI (Google / GitHub / email-link) | **hand-rolled** | All viable libraries are abandoned (`firebaseui-react`, `@web3forms/react`, `react-firebaseui`) or pre-1.0 betas (`@firebase-oss/*`, `@invertase/firebaseui-*`). Hand-rolling = ~80 lines, full control, zero dep risk. Revisit when `@firebase-oss/ui-shadcn` hits 1.0. |
| Drawer / sidebar overlay | **`@radix-ui/react-dialog ^1.1.17`** | 60M weekly downloads, active (last release 4 days ago), MIT, React 19, 11 KB gzip. Handles focus-trap, scroll-lock, ARIA, Escape, Portal — every behaviour I was hand-rolling. |
| Form state | **`react-hook-form ^7.79.0`** | 55M weekly downloads, MIT, React 19, 12.6 KB gzip. Real form state machine. |
| Schema validation | **`valibot ^1.4.1`** + **`@hookform/resolvers ^5.4.0`** | ~1.5 KB gzip per typical schema (zod is 12 KB minimum). MIT, active. RHF integration via `@hookform/resolvers/valibot`. |
| Web3Forms client | **hand-rolled fetch** | `@web3forms/react` is 4 years stale. The Web3Forms API is one POST call. Wrapping it adds nothing. |
| Error isolation | **`react-error-boundary ^6.1.2`** | 1 KB gzip, MIT, React 19, perfectly maintained. Drop-in. |
| Class-name util | **`clsx ^2.1.1`** | 0.35 KB gzip. Trivial cost, useful when consumers compose classes. |

Total new dep weight across all packages, sum gzip: ~26 KB. The hand-rolled
equivalents these libraries replace (focus-trap, scroll-lock, RHF-equivalent
state, error-boundary) compress to ~3–4 KB gzip — so we're paying ~22 KB to
gain a11y-correct primitives that are unsafe to hand-roll.

## The five packages

All five live as separate GitHub repos under `chirag127/`, added as git
submodules under `packages/` in the master oriz repo. Each is its own
small TypeScript package with its own `package.json`, `tsconfig.json`,
`biome.json`, `README.md`, `CHANGELOG.md`, and `src/index.ts`. None ship
styles — every component is unstyled and exposes `[data-*]` attribute hooks
for sites to target. No CSS bundles. No theme system. The current
`oriz-ui v1.0.0` "drop the theme system" decision is preserved here.

### 1. `@chirag127/firebase-init`

**Purpose:** Singleton-init for `app / auth / db` from a config object.
Same shape as the current `oriz-ui` `initFirebase`, but the `authDomain`
is now a required prop (not implicitly `auth.oriz.in`).

**Source:** Move `src/lib/firebase.ts` from oriz-ui verbatim.

**Public API:**
```ts
export interface FirebaseEnv {
  apiKey: string
  authDomain: string
  projectId: string
  storageBucket: string
  messagingSenderId: string
  appId: string
}
export function initFirebase(env: FirebaseEnv): {
  app: FirebaseApp
  auth: Auth
  db: Firestore
}
export function getAuth(): Auth        // accessor; throws if init not called
export function getDb(): Firestore     // accessor; throws if init not called
```

**Note:** I'm renaming `getOrizAuth` → `getAuth` and `getOrizDb` → `getDb`
because this package is now generic. Sites outside the oriz family would
look at `getOrizAuth` and ask why their Firebase accessor has "oriz" in the
name. The rename is part of the "make it generic" decision.

**Conflict:** Firebase JS SDK already has a `getAuth(app)` export. I'll either
namespace as `getInitializedAuth` / `getInitializedDb` to avoid the collision
or keep the `getOrizAuth` name and document that this package is "for sites
that follow oriz's auth.oriz.in pattern even if they aren't oriz themselves".
**Decision needed in approval.**

**Peer deps:** `firebase ^12.0.0`
**Runtime deps:** none
**Bundle:** ~0 (just types + thin wrappers around firebase SDK calls)
**Generic?** Yes — usable on any site.
**License:** MIT

### 2. `@chirag127/auth-ui`

**Purpose:** React components that render the auth flow on top of `firebase/auth`:
- `<AccountPanel>` — sign-in / signed-in / sign-out states with Google +
  GitHub + email-link providers
- `<FinishSignIn>` — completes the email-link flow on the redirect page

**Source:** Reshape from `oriz-ui/src/components/AccountPanel.tsx` and
`FinishSignIn.tsx`. Hand-rolled (per P2 research — no library exists).
Replace direct `getOrizAuth()` import with a required `auth` prop, so the
package doesn't depend on `@chirag127/firebase-init` (decoupling).

**Public API:**
```tsx
export interface AccountPanelProps {
  auth: Auth                          // Firebase Auth instance, passed in
  finishSignInPath?: string           // default '/account/finish-sign-in/'
  siteName?: string                   // default 'this site'
  emailStorageKey?: string            // default 'oriz:emailForSignIn' — OVERRIDABLE
  providers?: ('google' | 'github' | 'email-link' | 'anonymous')[]
                                       // default all four; sites can opt in
}
export interface FinishSignInProps {
  auth: Auth
  successPath?: string
  emailStorageKey?: string
}
```

**Selector hooks:** Same `[data-oriz-account-*]` and
`[data-oriz-finish-sign-in-*]` attribute hooks documented in the current
component. (The `oriz-` prefix on data attributes stays — it's a stable
namespace, not an oriz-only signal. Same way Bootstrap uses `data-bs-*`
even on non-Bootstrap-branded sites.)

**Behaviour preserved:**
- `oriz:emailForSignIn` localStorage contract (now overridable via prop)
- `role="status"` on intermediate states, `role="alert"` on errors
- `aria-label` on email inputs
- `autoComplete="email"` on email field

**Peer deps:** `firebase ^12.0.0`, `react ^18 || ^19`, `react-dom ^18 || ^19`
**Runtime deps:** `react-error-boundary ^6.1.2` (wrap each panel in EB)
**Bundle:** ~3 KB gzip + 1 KB for react-error-boundary
**Generic?** Yes — works on any site that uses Firebase Auth.
**License:** MIT

### 3. `@chirag127/contact-form`

**Purpose:** A `<ContactForm>` that POSTs to Web3Forms with proper field
validation, honeypot, and error handling. No styles — sites style via
`[data-oriz-contact-*]` attribute hooks.

**Source:** Rebuild from `oriz-ui/src/components/ContactForm.tsx`. Replace
the bare `<form action=...>` POST with a controlled form using
`react-hook-form` + `valibot` schema validation + `fetch` to the Web3Forms
API. Hand-rolled fetch (per P2 — `@web3forms/react` is dead).

**Public API:**
```tsx
export interface ContactFormProps {
  web3formsKey: string                // required
  fromName?: string                   // default 'contact form'
  onSuccess?: () => void              // optional callback
  onError?: (e: Error) => void        // optional callback
  fields?: ('name' | 'email' | 'subject' | 'message')[]
                                       // default all four
}
```

**Schema (built in):**
```ts
const ContactSchema = v.object({
  name:    v.pipe(v.string(), v.minLength(1, 'Required')),
  email:   v.pipe(v.string(), v.email('Enter a valid email')),
  subject: v.pipe(v.string(), v.minLength(1, 'Required')),
  message: v.pipe(v.string(), v.minLength(10, 'At least 10 characters')),
})
```

**Behaviour preserved:**
- Hidden honeypot field (visual hiding via inline style — that's anti-spam
  behaviour, not styling)
- Submit disabled while pending
- Success / error states surface via `onSuccess` / `onError` props plus
  inline `[data-oriz-contact-status]` attribute updates

**Peer deps:** `react ^18 || ^19`, `react-dom ^18 || ^19`
**Runtime deps:**
- `react-hook-form ^7.79.0`
- `valibot ^1.4.1`
- `@hookform/resolvers ^5.4.0` (use the `/valibot` subpath import)
**Bundle:** ~16 KB gzip (RHF + valibot + resolver)
**Generic?** Yes.
**License:** MIT

### 4. `@chirag127/sidebar`

**Purpose:** A `<Sidebar>` with proper drawer behaviour — focus-trap,
scroll-lock, Escape-to-close, click-outside-to-close, ARIA.

**Source:** Rebuild from `oriz-ui/src/components/Sidebar.tsx`. Replace the
hand-rolled `useEffect` for Escape + scroll-lock + media-query close with
`@radix-ui/react-dialog` (per P2 research — Radix handles all of this
correctly and the lib is actively maintained as of this week).

**Public API:** Same as the current Sidebar but the implementation
delegates the drawer chrome to Radix:

```tsx
export interface SidebarProps {
  siteName: string
  siteSlug?: string
  sections: SidebarSection[]
  footerSlot?: React.ReactNode
  withMobileTrigger?: boolean         // default true
  desktopMediaQuery?: string          // default '(min-width: 1024px)'
}
export interface SidebarSection {
  key?: string
  title?: string
  links: SidebarLink[]
}
export interface SidebarLink {
  label: string
  href: string
  icon?: React.ReactNode
  badge?: string
  active?: boolean
}
```

**Behaviour preserved + improved by Radix:**
- Escape closes (Radix)
- Body scroll lock on open (Radix)
- Click backdrop closes (Radix)
- Focus trap inside drawer when open (Radix — was MISSING from current code)
- `aria-modal="true"` and proper focus restoration on close (Radix)
- `desktopMediaQuery` overrides the breakpoint at which the drawer auto-closes

**Selector hooks:** `[data-oriz-sidebar-*]` attribute hooks unchanged from
the current implementation.

**Peer deps:** `react ^18 || ^19`, `react-dom ^18 || ^19`
**Runtime deps:** `@radix-ui/react-dialog ^1.1.17`
**Bundle:** ~11 KB gzip (Radix Dialog includes its tree of dependencies)
**Generic?** Yes.
**License:** MIT

### 5. `@chirag127/oriz-family`

**Purpose:** The oriz-only family config and site list. Not generic; depends
on nothing; used only by `chirag127/oriz-*` sites.

**Source:** Move `src/lib/siteConfig.ts` from oriz-ui verbatim. Drop the
`OrizSiteConfig` interface (it was per-site config, never used externally;
sites can define their own).

**Public API:**
```ts
export const FAMILY: { /* operator, jurisdiction, brand, etc */ }
export const FAMILY_SITES: FamilySite[]
export interface FamilySite {
  slug: string
  name: string
  url: string
  tagline: string
  emoji: string
  category: 'reading' | 'tools' | 'finance' | 'personal'
}
```

**Peer deps:** none
**Runtime deps:** none
**Bundle:** ~1 KB gzip (it's just JSON-shaped data + types)
**Generic?** No — oriz-specific by design.
**License:** MIT

## Migration shim — `@chirag127/oriz-ui v2.0.0`

The current `oriz-ui` doesn't get deleted. It bumps to `v2.0.0` and becomes
a thin re-export shim that consumes the 5 new packages:

```ts
// @chirag127/oriz-ui/src/index.ts (v2.0.0)
export {
  initFirebase,
  // Renamed exports kept under old names for backward compat:
  getAuth as getOrizAuth,
  getDb as getOrizDb,
  type FirebaseEnv,
} from '@chirag127/firebase-init'
export { AccountPanel, FinishSignIn } from '@chirag127/auth-ui'
export type { AccountPanelProps, FinishSignInProps } from '@chirag127/auth-ui'
export { ContactForm } from '@chirag127/contact-form'
export type { ContactFormProps } from '@chirag127/contact-form'
export { Sidebar } from '@chirag127/sidebar'
export type { SidebarProps, SidebarLink, SidebarSection } from '@chirag127/sidebar'
export { FAMILY, FAMILY_SITES } from '@chirag127/oriz-family'
export type { FamilySite } from '@chirag127/oriz-family'
```

**With one breaking change:** consumers must now pass `auth` to
`<AccountPanel>` and `<FinishSignIn>` rather than relying on the implicit
singleton. This is the price of decoupling auth-ui from firebase-init.

`oriz-ui v2` console.warn's once on import for ~3 months, then in `v3` the
shim is deleted and the 11 oriz sites import directly from the 5 new
packages.

## Repo layout (master `chirag127/oriz`)

```
oriz/
├── packages/
│   ├── firebase-init/      ← new submodule, github.com/chirag127/firebase-init
│   ├── auth-ui/            ← new submodule, github.com/chirag127/auth-ui
│   ├── contact-form/       ← new submodule, github.com/chirag127/contact-form
│   ├── sidebar/            ← new submodule, github.com/chirag127/sidebar
│   ├── oriz-family/        ← new submodule, github.com/chirag127/oriz-family
│   └── oriz-ui/            ← existing, becomes deprecation shim
├── sites/
│   └── … (11 site submodules unchanged)
└── …
```

## Branching, commits, no-push

Per the locked rule, every new package repo is committed straight on
`main`. No feature branches anywhere. No pushes to GitHub until explicit
say-so. No `pnpm publish` until explicit say-so.

## Order of execution

If approved, work order is:

1. **Create 5 new GitHub repos** — `gh repo create chirag127/firebase-init` ×5,
   each empty + MIT-licensed + main branch.
2. **Add 5 submodules** to `oriz/packages/` — one commit on master oriz main
   per submodule add.
3. **Bootstrap each package** in parallel — `package.json`, `tsconfig`,
   `biome.json`, `README`, `CHANGELOG`, empty `src/index.ts` — one commit
   per package on its own main.
4. **Move + rewrite each component** — five separate commits per package
   on its own main. Verify each typechecks + lints clean.
5. **Convert `oriz-ui v1.1.0 → v2.0.0`** as the deprecation shim — one
   commit on `oriz-ui` main.
6. **Bump master submodule pointers** for all six packages — one commit on
   master oriz main.

## Open questions for approval

1. **`getAuth` rename.** The current `getOrizAuth` / `getOrizDb` is awkward
   for non-oriz consumers but renaming to plain `getAuth` collides with
   `firebase/auth`'s own `getAuth(app)`. Three options:
   - (a) Rename to `getInitializedAuth` / `getInitializedDb` — verbose but
     unambiguous
   - (b) Keep `getOrizAuth` / `getOrizDb` and document that "oriz" is just
     a stable namespace, like `data-bs-*` for non-Bootstrap sites
   - (c) Drop the accessors entirely and have `initFirebase` return them as
     a destructured object every time (`const { auth, db } = initFirebase(env)`)

2. **`@hookform/resolvers/valibot` vs zod.** I picked valibot for the ~10×
   smaller bundle. Sites that want zod can build their own form. Confirm valibot.

3. **One repo per package or `chirag127/ui` monorepo with five packages?**
   Decision said "5 separate npm packages" — assuming that means 5 separate
   GitHub repos (one per submodule). A monorepo (single repo, pnpm workspaces,
   five packages inside) is also possible but contradicts the "separate
   submodules" mental model.

4. **AdSlot and NewsletterCta were already deleted in v1.0.0.** They are
   not part of the split. Confirm we don't add them back as separate packages.

## What I will NOT do without explicit approval

- Create any GitHub repos
- Add any submodules
- Push anything
- Publish anything to npm
- Modify the 11 consuming sites yet (that's D4)
