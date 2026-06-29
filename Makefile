# oriz workspace — common operations.
# All targets are thin shims around node scripts. Run from workspace root.

.PHONY: help sync-mcp sync-globals

help: ## Display available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}; {printf "  %-22s %s\n", $$1, $$2}'

sync-mcp: ## Sync .mcp.json to all agent configs (.kilocode, .antigravity, .opencode, .mimo)
	node scripts/sync-mcp-configs.mjs

sync-globals: ## Write ~/.claude/, ~/.opencode/ globals from workspace (with grill-on-drift)
	node scripts/sync-globals.mjs

.DEFAULT_GOAL := help
