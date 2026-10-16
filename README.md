# Replio plugin

[Replio](https://replio.eu) is an AI voice-training platform. Trainees practice
real conversations with lifelike AI personas in live voice sessions and receive
scored feedback; managers follow their progress. This plugin lets your AI
assistant set up and run a Replio training project from chat: name the
training, add company knowledge, agree the training goals, review the generated
personas and quiz questions, activate the project, invite trainees, and read
the results afterwards.

The voice sessions themselves take place on replio.eu, in 58 languages. Built
in Europe, GDPR compliant, with EU data hosting.

## How it works

Your assistant (Claude, ChatGPT, Codex, Cursor, or any MCP client) loads the
skill in this repository for the know-how, and calls the hosted Replio MCP
server at `https://api.replio.eu/mcp` to act on your workspace. Nothing runs on
your machine, there is no API key: the first action opens a browser sign-in.

Replio's own pipeline stays the extractor of record. The assistant guides and
collects; documents go through Replio's parsing pipeline, never through pasted
summaries.

## Get started

### 1. Install

**Claude Code**

```text
/plugin marketplace add aiteklabs/replio-plugin
/plugin install replio@replio-plugin
```

**Codex**

```bash
codex plugin marketplace add aiteklabs/replio-plugin
codex plugin add replio@replio
```

**Cursor**

Settings > Plugins > Team Marketplaces > Add Marketplace > Import from Repo,
enter `https://github.com/aiteklabs/replio-plugin`, then install **replio**.

**Any coding agent** (Copilot CLI, VS Code, Windsurf, Gemini CLI)

```bash
npx skills add aiteklabs/replio-plugin
```

Then add a remote (HTTP) MCP server with the URL `https://api.replio.eu/mcp`.
Config snippets per client:
[clients.md](skills/replio-project-setup/references/mcp/clients.md).

**claude.ai and Claude Desktop**

Settings > Connectors > Add custom connector. Name it `Replio`, paste
`https://api.replio.eu/mcp`, and approve the sign-in.

**ChatGPT**

Settings > Apps & Connectors > Create, name `Replio`, URL
`https://api.replio.eu/mcp`, authentication OAuth.

### 2. Sign in

Restart your agent. The first Replio action opens a browser sign-in; approve it
once. Managers sign in with their Replio account. Clients of a Replio manager
paste the access code they received (`REPLIO-XXXX-XXXX-XXXX`) on the same page
instead: no Replio account needed.

### 3. Ask

> Set up a sales training for my team from our product sheet.

Then try:

- _"Did my team train yesterday, and how did it go?"_
- _"Review the personas of my training project with me."_
- _"Make the second persona more skeptical about price."_
- _"Invite anna@example.com and tom@example.com to the project."_

## What you can do

- **Create a training from your documents.** Upload a product sheet, a
  procedure, a pitch deck; Replio extracts the knowledge and the assistant
  agrees the training goals with you before generating personas.
- **Review every persona before going live.** Edit a persona, regenerate one,
  add more, or import a reusable character from your Persona Library.
- **Build a knowledge quiz.** Generate, review and save the questions.
- **Configure the training.** Expert chat, realtime feedback, standalone
  quizzes, hidden persona details, hidden goal selection.
- **Invite trainees and read results.** Session counts, average score,
  per-trainee progression, and who trained yesterday.

## Skill

- [replio-project-setup](skills/replio-project-setup): the guided setup flow,
  the tool catalog, per-client connection steps, and a symptom-to-fix map for
  persona and session complaints.

Your agent picks the skill on its own. In Claude Code you can also call it
directly: `/replio:replio-project-setup`.

## Repository map

- `.claude-plugin/`: Claude Code plugin manifest and marketplace.
- `.mcp.json`: the hosted MCP server, registered by the Claude Code plugin.
- `plugin.json`, `mcp.json`: the ChatGPT app package (Agent Plugins layout).
- `.codex-plugin/`, `.cursor-plugin/`: Codex and Cursor manifests.
- `server.json`: MCP registry entry.
- `skills/`: the skill and its references.
- `skill-evals/`: evaluation queries with expected behaviors.
- `assets/`: the logo.

## Update

**Claude Code**

```bash
claude plugin marketplace update replio-plugin
claude plugin update replio@replio-plugin
```

**Codex**

```bash
codex plugin marketplace update replio
codex plugin update replio@replio
```

**Cursor**: Settings > Plugins > Team Marketplaces > Refresh, then update
**replio**.

**Any coding agent**

```bash
npx skills update
```

A new version is announced only when `version` changes in every manifest
(`scripts/bump-version.sh <version>` edits all five at once).

## Privacy and support

- Privacy policy: https://replio.eu/en/privacy
- Terms: https://replio.eu/en/terms
- Support: https://replio.eu/en/contact

The plugin sends your requests to the Replio MCP server only. It stores no
data on your machine. Tool calls are journaled in your Replio dashboard for 30
days.

## License

MIT, see [LICENSE](LICENSE). The Replio platform itself is a commercial
service by AitekLabs.
