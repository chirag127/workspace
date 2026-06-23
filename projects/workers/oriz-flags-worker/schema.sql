-- oriz-flags-worker / D1 schema
--
-- Source-of-truth for the family's feature flags. CF Worker writes here on
-- every admin change, then mirrors a resolved tree into KV for edge reads.
-- Audit table preserves before/after JSON forever (small, no cleanup needed
-- until row count > 1M which is years away).
--
-- Apply with: wrangler d1 execute oriz-flags --file=schema.sql

CREATE TABLE IF NOT EXISTS flags (
  key TEXT PRIMARY KEY,
  variant_type TEXT NOT NULL CHECK (variant_type IN ('bool','string','number')),
  default_variant TEXT NOT NULL,
  updated_at INTEGER NOT NULL,
  updated_by TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS flag_rules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flag_key TEXT NOT NULL,
  priority INTEGER NOT NULL DEFAULT 100,
  segment_key TEXT NOT NULL,           -- 'tier:pro', 'rollout:5', 'country:IN', 'app:oriz-omni', 'uid:abc', 'all'
  variant TEXT NOT NULL,
  FOREIGN KEY (flag_key) REFERENCES flags(key) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS flag_rules_by_flag ON flag_rules(flag_key, priority);

CREATE TABLE IF NOT EXISTS flag_changes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flag_key TEXT NOT NULL,
  before_json TEXT NOT NULL,
  after_json TEXT NOT NULL,
  changed_by TEXT NOT NULL,
  changed_at INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS flag_changes_recent ON flag_changes(changed_at DESC);

-- Seed: the three concrete flags we have day-one use cases for.
INSERT INTO flags (key, variant_type, default_variant, updated_at, updated_by) VALUES
  ('razorpay-checkout-enabled', 'bool', 'true', strftime('%s','now')*1000, 'seed'),
  ('journal-write-enabled',     'bool', 'true', strftime('%s','now')*1000, 'seed'),
  ('image-tools-tier-required', 'string', 'free', strftime('%s','now')*1000, 'seed')
ON CONFLICT(key) DO NOTHING;
