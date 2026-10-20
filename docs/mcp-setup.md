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

A project-scoped server needs a one-time approval per checkout, so the first
listing reports `Pending approval` even when the token is valid:

```bash
claude mcp list
# apify: https://mcp.apify.com/ (HTTP) - ⏸ Pending approval (run `claude` to approve)
```

That is the expected first result, not a broken setup. Start `claude` once in
this directory and approve the server when prompted; after that `claude mcp list`
reports it connected. `claude mcp get apify` shows which scope and header the
entry resolved to, which is the quickest way to tell a config problem from a
missing approval.

If the token is missing, the server reports the endpoint's own auth error rather
than appearing healthy:

```
apify (AUTH_HEADER_REJECTED): HTTP 401 — invalid_token:
Missing or invalid access token.
```

That is intentional: a silent fallback would look connected while every tool
call returned 401.

### Alternative: OAuth instead of a token

Drop the `headers` block from the `apify` entry in `.mcp.json` and Claude Code
falls back to Apify's OAuth flow, which prompts in the browser on first use.
Pick one or the other — an `Authorization` header disables the OAuth fallback.

### Alternative: user scope instead of project scope

To make Apify available in every project rather than just this one, register it
against your user config under a **different server name**, so it does not
collide with the `apify` entry this repo commits:

```bash
claude mcp add apify-global "https://mcp.apify.com/" -t http \
  --scope user \
  --header "Authorization: Bearer $APIFY_API_TOKEN"
```

Reusing the name `apify` instead leaves two definitions competing, and which one
wins depends on the project entry's approval state — measured in this repo, a
user-scoped `apify` shadows the project entry while that entry is still pending
approval, so the project's `${APIFY_API_TOKEN}` header is not what gets used.
A distinct name avoids having to reason about it. If you would rather not have
the project entry at all, remove the `apify` block from `.mcp.json` in your
checkout; `claude mcp add --scope user` does not override a committed file.

Note this writes the resolved token into `~/.claude.json` in plaintext, which
the `.mcp.json` route avoids.

## Reference

- Claude Code MCP docs: <https://docs.claude.com/en/docs/claude-code/mcp>
- Apify MCP docs: <https://docs.apify.com/platform/integrations/mcp>
