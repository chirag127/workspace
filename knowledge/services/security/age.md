---
type: service
title: "age — modern file encryption (X25519 + ChaCha20-Poly1305)"
description: "age (by FiloSottile) is the modern, minimal file-encryption tool the family uses as the master-key backend for SOPS. X25519 key exchange + ChaCha20-Poly1305 stream. Single private key file (~/.config/sops/age/keys.txt). No PGP keyring, no key server, no cloud dependency. v1.3.1 (2026). Stored in Bitwarden CLI for recovery."
tags: [service, security, encryption, age, sops-backend]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
resource: https://github.com/FiloSottile/age
related:
  - services/security/sops
  - decisions/security/sops-plus-doppler-hybrid
  - rules/submodule-env-files-three-file-pattern
---

# age — modern file encryption

## What it is

A 2019-era file-encryption tool by Filippo Valsorda (Go-language cryptographer, ex-Google, ex-Cloudflare). Designed as a modern replacement for `gpg --encrypt` with a minimal feature set.

- **Algorithms**: X25519 for key exchange, ChaCha20-Poly1305 for stream encryption, HKDF-SHA-256 for key derivation
- **Key format**: a single `age1...` public key (~62 chars), a single `AGE-SECRET-KEY-1...` private key (~74 chars)
- **No keyring**: keys are just text strings. Save them in a file, password manager, or sticky note.
- **Multiple recipients**: a single ciphertext can be encrypted to N public keys, any one of which can decrypt.
- **Latest**: v1.3.1 (2026)

## Why we use it (instead of PGP/KMS)

| Concern | age | GPG | AWS KMS |
|---|---|---|---|
| Setup time | 30 sec (`age-keygen`) | 30 min (keyring + web of trust) | hours (IAM + KMS policies) |
| Cloud dependency | None | None | AWS account |
| Failure modes | Lose the key file | GPG agent issues, expired subkeys, web-of-trust corruption | IAM misconfig, KMS region outage, billing |
| Cost | $0 | $0 | $0.03 / 10K decrypt requests |
| Multi-recipient | Yes (additive) | Yes (additive) | Yes (KMS grants) |
| Offline decryption | Yes, forever | Yes, forever | Requires AWS reachable |

For a solo dev with no compliance requirement, age wins on simplicity. The cost is real but small: it has no integration with hardware tokens, no revocation list, no formal trust model. Trade-offs we accept.

## Our setup

**Where the keys live:**
- **Private key**: Bitwarden CLI, item `age-key`, retrieved with `bw get item age-key | jq -r .notes`
- **Public key**: in `.sops.yaml` at the umbrella root (committed, public is meant to be public)

**Generate (one-time, only if rotating):**
```bash
age-keygen -o ~/.config/sops/age/keys.txt    # generates new keypair
# Copy the public age1... line into .sops.yaml
# Copy the AGE-SECRET-KEY-1... into Bitwarden CLI
```

**On a fresh machine:**
```bash
bw get item age-key | jq -r .notes > ~/.config/sops/age/keys.txt
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
# Now sops -d works in any submodule
```

**CI (GitHub Actions):**
```yaml
- name: Decrypt secrets
  env:
    SOPS_AGE_KEY: ${{ secrets.SOPS_AGE_KEY }}    # the private key as a single env var
  run: sops decrypt -i .env.enc
```

## Key rotation

Rotation is a Bitwarden CLI update + a re-encrypt of every `.env.enc` family-wide. ~5 min if all submodules are cloned locally. We have not rotated yet (and have no scheduled rotation) — the cost of a real rotation only justifies if the current key is suspected compromised. See [[runbooks/rotate-age-key]] (write when first needed).

## Anti-patterns

- **Storing the age private key in a repo.** Bitwarden only.
- **Sharing the age key with collaborators.** If a second human ever needs decrypt access, they get their OWN keypair, and we add their public key to `.sops.yaml` as a second recipient. SOPS supports multi-recipient.
- **Using age for streaming / large files.** age is fine for files up to a few MB; for large blobs, use [`age-plugin-rage`](https://github.com/str4d/rage) or another tool.
- **Encrypting binary files we don't actually need encrypted.** age adds ~200 bytes of overhead per file; not a big deal but pointless on already-zipped tarballs.

## Related

- [[services/security/sops]] — the wrapper that calls age for the data-key step
- [[decisions/security/sops-plus-doppler-hybrid]] — overall secrets architecture
- [[rules/submodule-env-files-three-file-pattern]] — the three-file pattern that uses age
