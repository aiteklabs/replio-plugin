# MCP tools

The `replio` MCP server (`https://api.replio.eu/mcp`, Streamable HTTP) is the
action surface. Tools appear as `replio:<name>` (some clients show
`mcp__replio__<name>`). The connected `tools/list` and each tool's input schema
are authoritative; this file is the map.

## Contents

- Catalog by phase
- What each connection can call
- Confirm before acting
- Tool notes
- Widgets (MCP Apps)

## Catalog by phase

Read tools first, then write tools; "none" means MCP has no tool of that kind.

- **Orientation**: read `list_projects` (projects the connection can reach,
  with organization, status, training domain; call it first to find ids).
  Write: `create_project` (managers only).
- **Project identity**: read none. Write `set_project_details` (name,
  description).
- **Knowledge**: read `get_upload_link` (the web page where the user uploads
  FILES), `get_project_setup_status` (ingestion state, `knowledgeReady`,
  persona and quiz progress, feature toggles, linked library assets, next
  step; `wait: true` blocks up to about 25 s server-side). Write
  `add_knowledge_text` (title + the user's original text),
  `add_knowledge_url` (public web page).
- **Goals**: read `suggest_training_goals` (AI suggestions grounded in the
  project knowledge; send `businessContext`, `existingGoals`, optional
  `focusHint`). Write: none (goals go to `generate_personas`).
- **Draft personas (project in setup)**: read `list_generated_personas`.
  Write `generate_personas` (`businessContext` + `trainingGoals`, optional
  `language`), `update_generated_persona`, `regenerate_persona`,
  `generate_more_personas`.
- **Persona Library (organization-wide reusable characters)**: read
  `list_library_personas`. Write `import_library_persona` (copy into the
  project: draft pool in setup, live persona once active; `translate` adapts
  the sheet to the project language).
- **Quiz**: read `list_quiz_questions`. Write `generate_quiz`,
  `generate_more_quiz_questions`, `regenerate_quiz_question`, `save_quiz`
  (accepted question ids, minimum 5).
- **Activation and features**: write `activate_project` (`acceptedPersonaIds`,
  optional `difficultyLevels` map of draft persona id to 2, 3 or 4),
  `set_project_features` (`expertChatEnabled`, `realtimeFeedbackEnabled`,
  `standaloneQuizzesEnabled`, `hidePersonaDetails`, `hideGoalSelection`).
- **Live personas (ACTIVE project)**: read `list_personas`. Write
  `add_persona` (manual, no AI), `update_persona`, `delete_persona`.
- **Trainees**: write `invite_trainees` (exact list of `trainees`, optional
  `locale` for the invitation email).
- **Reporting**: read `get_project_kpis` (sessions, average AI score 0 to 10,
  trainee counts, first-versus-recent progression), `get_recent_activity`
  (who trained over the last `days`, default 1, with per-trainee scores).

## What each connection can call

- **Manager** (OAuth sign-in, scope `mcp:read mcp:write`): every tool, across
  all the manager's organizations.
- **Setup code** (scope `mcp:project-write`): every tool except
  `create_project`, pinned to its one project. `list_projects` returns only
  that project.
- **Read code** (scope `mcp:project`): the read tools only, pinned to one
  project.

A code is re-checked on every call: removing the manager who minted it,
revoking the code, or deleting the project ends access. Relay such refusals
plainly.

## Confirm before acting

State the exact target and get the user's go-ahead before any of these. The
server's tool annotations flag the same risks (`destructiveHint: true` on
every tool below); confirm even when a client hides them.

- `activate_project`: makes the project live for trainees; the draft personas
  not in `acceptedPersonaIds` are discarded.
- `invite_trainees`: sends real emails; confirm the exact address list, never
  guess addresses.
- `delete_persona`: destructive; confirm the persona by name.
- `set_project_details`, `set_project_features`, `update_persona`,
  `update_generated_persona`, `save_quiz`: overwrite the fields you send.
- `generate_personas`, `generate_quiz`, `regenerate_persona`,
  `regenerate_quiz_question`: replace generated content; on code connections a
  re-run spends one of 3 AI generations per type.

`add_knowledge_url` and `invite_trainees` reach outside Replio
(`openWorldHint: true`): the first fetches a public web page, the second emails
people.

## Tool notes

- `get_project_setup_status` with `wait: true` returns early when processing
  finishes; chain calls silently while `stillProcessing` is true. Never tell
  the user to wait or check back.
- `generate_personas` is refused while the knowledge base is not ready
  (`knowledgeReady: false`); keep polling first.
- `suggest_training_goals` before `generate_personas`: goals steer the
  scenarios and objections. Send the agreed goals, never only the suggestions.
- `update_persona` `objections` replace the list positionally: send the
  COMPLETE list (max 12), including objections you are not changing.
  `background`, `goals`, `communicationStyle` accept an empty string to clear.
  `difficultyLevel` is 2 (easy), 3 (medium) or 4 (hard).
- `add_persona` creates a live persona by hand on an ACTIVE project. Draft
  projects are refused: use the draft tools instead.
- `import_library_persona` copies the character; later library edits never
  touch the imported persona.
- `get_upload_link` returns the `/connect/<code>` page for setup-code
  connections and the project's dashboard knowledge page for managers. Files
  are never pasted into `add_knowledge_text`.
- `invite_trainees` only works on an ACTIVE project; invitees are saved in the
  organization's contact library in a group named after the project. Setup
  codes may carry an invitation cap.
- Every tool returns `structuredContent` with the keys its `outputSchema`
  documents; read results by those names.
- Edits apply to new sessions only; past sessions keep their transcript and
  score.

## Widgets (MCP Apps)

The four read tools `list_projects`, `get_project_kpis`,
`get_recent_activity` and `get_project_setup_status` carry an
`_meta.ui.resourceUri` pointing at a `ui://replio/*` view. Hosts that support
MCP Apps render the widget; every other host keeps the text and
`structuredContent` result. Never depend on the widget being shown.

## Key files

- [clients.md](clients.md): connect a client, OAuth, access codes,
  troubleshooting
- [../failure-modes.md](../failure-modes.md): symptom to fix location
