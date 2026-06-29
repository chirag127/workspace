# oriz workspace — common operations.
# All targets are thin shims around node scripts. Run from workspace root.

.PHONY: help sync-mcp sync-globals sync-showcases sync-showcases-dry

help: ## Display available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}; {printf "  %-22s %s\n", $$1, $$2}'

sync-mcp: ## Sync .mcp.json to all 4 agent configs (.kilocode, .antigravity, .opencode)
	node scripts/sync-mcp-configs.mjs

sync-globals: ## Write ~/.claude/, ~/.opencode/ globals from workspace (with grill-on-drift)
	node scripts/sync-globals.mjs

sync-showcases: ## Sync 4 public mirror repos (claude-code-config, opencode-config, etc.)
	node scripts/sync-config-showcases.mjs

sync-showcases-dry: ## Dry-run mirror sync
	node scripts/sync-config-showcases.mjs --dry-run

.DEFAULT_GOAL := help
