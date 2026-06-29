---
type: service
title: "SOPS — Secrets OPerationS (getsops/sops, CNCF Sandbox)"
description: "Git-native secrets encryption — encrypts values in structured files, keeps structure visible, CNCF"
tags: [service, security, secrets, sops, encryption, cncf]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
resource: https://github.com/getsops/sops
related:
  - services/business/security/age
  - security/sops-plus-doppler-hybrid
  - rules/submodule-env-files-three-file-pattern
  - policy/private-repos-excluded-from-mirror-cron
---

# SOPS — Secrets OPerationS

## What it is

CNCF Sandbox project (donated by Mozilla in 2023). Encrypts the VALUES of a structured file while leaving keys + structure visible. The result is a `.env.enc` (or `.yaml.enc`) file that's committable to git with readable diffs (you see "the AWS key changed" not "the whole blob differs").

Latest: **v3.13.1 (May 2026)**. Active. 22.2k stars. The `mozilla/sops` repo redirects to `getsops/sops` — no abandonment.

## How it works

**Envelope encryption:**

1. SOPS generates a random 256-bit data key per file.
2. File contents are encrypted with AES-256-GCM using the data key.
3. The data key is encrypted with one or more master keys (age, KMS, PGP, etc.).
4. Encrypted data key is stored in the file's `sops:` metadata block.

To decrypt: master key unwraps the data key → data key decrypts the values.

## Our backend choice: age

We use [`age`](https://github.com/FiloSottile/age) (`services/business/security/age`) as the master-key backend. Reasons in priority order:

1. **No cloud key-server**: a single `.txt` file holds the private key. Bitwarden CLI stores it. Offline-decryptable forever, even if every cloud provider disappears.
2. **No GPG complexity**: age has 4 lines of config; GPG has 40. Less surface area = fewer failure modes.
3. **Post-quantum hybrid available** through the X25519 + ChaCha20-Poly1305 stack.
4. **Free**: zero recurring cost. Aligns with [[rules/no-card-on-file]].

Not chosen: AWS KMS / GCP KMS / Azure Key Vault (cloud lock-in), PGP (legacy UX), HashiCorp Vault (needs server).

## `.sops.yaml` config

Root config at `c:/D/oriz/.sops.yaml`:

```yaml
creation_rules:
  - path_regex: \.env\.enc$
    age: age1<our_public_key>
```

Every `.env.enc` in the umbrella + submodules encrypts with the same age key. Single-key recovery family-wide — see [[rules/submodule-env-files-three-file-pattern]].

## Daily commands

```bash
# Decrypt for editing:
sops decrypt -i .env.enc           # in-place: .env.enc → .env (still encrypted)
# OR
sops -d .env.enc > .env            # decrypt to plain .env

# Encrypt fresh:
sops -e .env > .env.enc

# Edit interactively (decrypts → opens $EDITOR → re-encrypts on save):
sops .env.enc
```

CI uses `SOPS_AGE_KEY` env var with the private key contents — see [[security/sops-plus-doppler-hybrid]].

## Upgrade path

Pin to the latest stable. Currently v3.13.1. Check `getsops/sops/releases` quarterly. Minor bumps are non-breaking; major would prompt a re-evaluation (none expected in 2026 per project status).

## Related services

- [[services/business/security/age]] — the backend that does the actual key wrapping
- [[security/sops-plus-doppler-hybrid]] — why SOPS+age is source-of-truth and Doppler is runtime-sync only
- [[rules/submodule-env-files-three-file-pattern]] — every submodule that has secrets gets a `.env`, `.env.enc`, `.env.example`
- [[policy/private-repos-excluded-from-mirror-cron]] — protects the encrypted blobs from public mirror cron just in case

## Anti-patterns

- **Encrypting whole files** instead of values (use `git-crypt` if you want that; SOPS deliberately doesn't).
- **Per-submodule different age keys.** Defeats the single-key recovery; see [[rules/submodule-env-files-three-file-pattern]].
- **Storing the age key in any repo.** Bitwarden CLI only.
- **Using SOPS for blob backups.** Use B2 instead — see [[decisions/architecture/backup-channels-alternative]].
