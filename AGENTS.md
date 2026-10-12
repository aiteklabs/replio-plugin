# replio-plugin: Agent Guide

Skill and plugin manifests for the Replio MCP server. This repository is public
and is installed directly into end users' agents: every word ships.

## Rules

- **MCP tool names are a contract.** The skill may only reference tools that
  the hosted MCP server exposes (catalog in
  `skills/replio-project-setup/references/mcp/tools.md`). The server lives in
  the Replio monorepo (`apps/api/src/routes/mcp/`); when a tool, its
  description or the server `instructions` change there, this catalog and the
  skill change in the same release, and `version` is raised in every manifest.
- **Skills are MCP-first.** Every workflow ends in an MCP tool call, never in
  "write a file to disk", a REST call, or a reference to internal Replio
  repositories, paths or CLIs.
- **Files never go through chat.** Documents are uploaded on the page returned
  by `get_upload_link` so they get Replio's full parsing pipeline. The skill
  must never instruct the agent to paste extracted file text into
  `add_knowledge_text`.
- **No secrets.** Authentication is OAuth, or an access code pasted on the
  consent page. The shipped MCP configs carry no credentials. Never name a
  token, user id, organization id or project id in this repository.
- **Token discipline in SKILL.md.** Skills load into agent context; keep
  SKILL.md under about 250 lines and push depth into `references/` files the
  agent loads on demand.
- **Public bar.** No internal jargon, no unfinished sections, no features that
  do not exist on the server. Terminology: "Replio" (one word), "AitekLabs"
  (CamelCase), "trainee", "persona", "training project", "Persona Library".
  Language-agnostic: Replio runs in 58 languages, so never assume English
  content.
- **ChatGPT package.** The root `plugin.json` `name` is the OpenAI app id and
  must keep its value or the upload is refused. Bump `version` for every
  upload. Zip: `zip -r replio-plugin.zip plugin.json mcp.json skills assets -x 'skills/*/agents/*'`. The OpenAI uploader refuses a package whose skill folder holds `agents/openai.yaml` ("Onboarding skill must reference a packaged SKILL.md"), so that file stays out of the zip; it is for Codex only. Keep the SKILL.md description on one line.
- **English only** in every file, including comments and commit messages. No
  emojis, no em dashes.

## Structure

- `skills/replio-project-setup/`: the one skill. `SKILL.md` holds the guided
  flow and the hard rules; `references/mcp/tools.md` the tool map and
  confirmations; `references/mcp/clients.md` per-client connection and auth
  errors; `references/failure-modes.md` symptom to fix location;
  `agents/openai.yaml` the ChatGPT interface block.
- `skill-evals/`: one JSON per skill in Anthropic's evaluation format (query +
  expected behaviors). Run every eval against a test organization before a
  release that touches a skill file; a pass needs every expected behavior.
- Manifests: `.claude-plugin/` (Claude Code + Anthropic directory),
  `plugin.json` + `mcp.json` (ChatGPT), `.codex-plugin/`, `.cursor-plugin/`,
  `.agents/plugins/marketplace.json` (Codex marketplace), `server.json` (MCP
  registry).
- A new skill only for a distinct job with its own vocabulary and triggers;
  otherwise add a reference file to `replio-project-setup`. No cross-skill
  file links.

## Release

1. Update the skill and references to match the live `tools/list`.
2. Run the evals in `skill-evals/` against a test organization.
3. `claude plugin validate --strict .` must pass.
4. Raise `version` in `.claude-plugin/plugin.json`, `plugin.json`,
   `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json` and
   `server.json`.
5. Merge to `main`. The Anthropic directory follows `main`; re-upload the zip
   to OpenAI.
