# Connect a client

Per-client registration of the hosted `replio` MCP server. Plugin installs do
this automatically; use this file for manual and web setups, and for auth
errors. Tools appear as `replio:<name>` (some clients: `mcp__replio__<name>`).
If they are missing, the server is not registered: fix registration here;
never fall back to invented REST calls.

Server: `https://api.replio.eu/mcp` (Streamable HTTP; no SSE, no local
process). Nothing to install, no API key.

## Contents

- Auth: OAuth, or an access code
- Coding agents (Claude Code, Codex, Cursor, Copilot, Windsurf, Gemini CLI)
- Stdio-only clients (mcp-remote)
- Web agents (claude.ai, Claude Desktop, ChatGPT)
- Troubleshooting

## Auth

- **OAuth 2.1 (default)**: register the URL with no credentials; the client
  opens a browser consent page on first use. Managers sign in with their
  Replio account (password, Google, Microsoft, or their company SSO).
- **Access code**: on the same consent page a client of a Replio manager
  pastes the `REPLIO-XXXX-XXXX-XXXX` code they received instead of signing in.
  No Replio account needed. A setup code gives read and write on one project,
  a read code gives reporting only. Codes expire after 90 days and can be
  revoked by the manager at any time.
- Tokens are short-lived and refreshed by the client. There is no personal
  access token: never ask the user to paste a token or a code into chat.

## Coding agents

<details>
<summary>Claude Code</summary>

Plugin (skill + server in one install):

```text
/plugin marketplace add aiteklabs/replio-plugin
/plugin install replio@replio-plugin
```

Server only:

```bash
claude mcp add --transport http replio https://api.replio.eu/mcp
```

Run `/mcp` in a session and finish the browser sign-in.

</details>

<details>
<summary>Codex</summary>

```bash
codex plugin marketplace add aiteklabs/replio-plugin
codex plugin add replio@replio
```

Server only:

```bash
codex mcp add replio --url https://api.replio.eu/mcp
codex mcp login replio
```

Or in `~/.codex/config.toml`:

```toml
[mcp_servers.replio]
url = "https://api.replio.eu/mcp"
```

</details>

<details>
<summary>Cursor</summary>

Cursor Settings > MCP > Add new global MCP server:

```json
{
  "mcpServers": {
    "replio": { "url": "https://api.replio.eu/mcp" }
  }
}
```

Cursor prompts for OAuth on first use. The skill: Settings > Plugins > Team
Marketplaces > Add Marketplace > Import from Repo, enter
`https://github.com/aiteklabs/replio-plugin`, then install **replio**.

</details>

<details>
<summary>GitHub Copilot (VS Code)</summary>

**MCP: Open User Configuration** (or `.vscode/mcp.json` per workspace):

```json
{
  "servers": {
    "replio": {
      "type": "http",
      "url": "https://api.replio.eu/mcp"
    }
  }
}
```

</details>

<details>
<summary>Windsurf</summary>

```json
{
  "mcpServers": {
    "replio": {
      "serverUrl": "https://api.replio.eu/mcp"
    }
  }
}
```

</details>

<details>
<summary>Gemini CLI</summary>

`~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "replio": {
      "httpUrl": "https://api.replio.eu/mcp"
    }
  }
}
```

</details>

Skills for any coding agent:

```bash
npx skills add aiteklabs/replio-plugin
```

## Stdio-only clients

Clients without remote MCP support bridge through `mcp-remote`, which also runs
the OAuth flow:

```json
{
  "mcpServers": {
    "replio": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://api.replio.eu/mcp"]
    }
  }
}
```

## Web agents

- **claude.ai and Claude Desktop**: Settings > Connectors > Add custom
  connector. Name it `Replio`, paste `https://api.replio.eu/mcp`, approve the
  sign-in.
- **ChatGPT**: Settings > Apps & Connectors > Create (developer mode), name
  `Replio`, URL `https://api.replio.eu/mcp`, authentication OAuth.
- **Shared project page**: a manager can send a client to
  `https://replio.eu/connect/<code>`, which shows the code, the per-assistant
  setup steps, and the file upload section for setup codes.

## Troubleshooting

- **401 on every tool**: OAuth not completed for this client (Claude Code
  `/mcp`, Codex `codex mcp login replio`, Cursor Settings > MCP). Never ask for
  a token in chat.
- **Fewer tools than expected**: a read code shows the reporting tools only;
  a setup code hides `create_project`. Start a new thread, or remove and
  re-add the server after a change of connection.
- **"project not ready" or `knowledgeReady: false`**: documents are still
  processing. Call `get_project_setup_status` with `wait: true` and chain.
- **"code revoked" or "project not found" on a code connection**: the manager
  revoked the code, lost owner or admin access, or deleted the project. The
  manager mints a new code from the dashboard.
- **File upload questions**: files go through the page returned by
  `get_upload_link`, never through chat. Max 20 MB per file; the page shows
  the remaining document slots.
- **Login refused with an SSO message**: the manager's company enforces SSO;
  use the company sign-in button on the login page.
