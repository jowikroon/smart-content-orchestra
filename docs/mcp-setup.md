# MCP servers

This repo ships a project-scoped MCP config in `.mcp.json`. Claude Code picks it
up automatically when a session starts in this directory and asks for approval
the first time.

No tokens live in the repo — `.mcp.json` references environment variables, which
Claude Code expands from the shell that launched it.

## Apify

| | |
|---|---|
| Server name | `apify` |
| Transport | HTTP |
| Endpoint | `https://mcp.apify.com/` |
| Auth | `Authorization: Bearer ${APIFY_API_TOKEN}` |

### Setup

Export the token in your shell profile (`~/.zshrc`, `~/.bashrc`), so every
Claude Code session inherits it:

```bash
export APIFY_API_TOKEN="apify_api_..."
```

Find the token at <https://console.apify.com/settings/integrations> — the
default one is created on sign-up.

Then verify:

```bash
claude mcp list          # apify should report connected
```

If the token is missing, the `apify` server fails to connect with an auth error.
That is intentional: a silent fallback would look connected while every tool
call returned 401.

### Alternative: OAuth instead of a token

Drop the `headers` block from the `apify` entry in `.mcp.json` and Claude Code
falls back to Apify's OAuth flow, which prompts in the browser on first use.
Pick one or the other — an `Authorization` header disables the OAuth fallback.

### Alternative: user scope instead of project scope

To make Apify available in every project rather than just this one, skip
`.mcp.json` and register it against your user config:

```bash
claude mcp add apify "https://mcp.apify.com/" -t http \
  --scope user \
  --header "Authorization: Bearer $APIFY_API_TOKEN"
```

Note this writes the resolved token into `~/.claude.json` in plaintext, which
the `.mcp.json` route avoids.

## Reference

- Claude Code MCP docs: <https://docs.claude.com/en/docs/claude-code/mcp>
- Apify MCP docs: <https://docs.apify.com/platform/integrations/mcp>
