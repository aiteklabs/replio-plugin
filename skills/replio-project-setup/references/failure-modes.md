# Common complaints and where to fix them

Each symptom lists its owner (which tool or field), then the mechanism. Read
the live persona or project state first (`list_personas`,
`get_project_setup_status`), name one concrete cause the evidence supports,
then make the narrowest change. Edits apply to new sessions only.

## Personas

- **"The persona is too easy" or "too hard"**: `update_persona`
  `difficultyLevel` (2 easy, 3 medium, 4 hard) on a live persona, or
  `difficultyLevels` at `activate_project`. Difficulty drives the persona's
  patience, resistance and how fast objections come; do not rewrite the
  personality for this.
- **"The persona never objects" or "always the same objection"**:
  `update_persona` `objections`. Take the real objections from the user's
  context (lost deals, call notes) or, when the project has a CRM bound, from
  `get_crm_pipeline_digest`, and send the COMPLETE list, max 12.
- **"The persona states wrong facts"**: the knowledge, not the persona. Add or
  replace the document through `get_upload_link` (the dashboard knowledge page
  has a Replace button for a live document), then confirm with
  `get_project_setup_status`. Personas only know what the project knowledge
  holds.
- **"The persona speaks the wrong language"**: `language` on
  `generate_personas`, `regenerate_persona`, `generate_more_personas`, or
  `translate` on `import_library_persona`. The persona language follows the
  project language.
- **"Trainees see the persona's role and difficulty, that spoils the
  exercise"**: `set_project_features` `hidePersonaDetails: true`. Trainees
  then see names only.
- **"I want the same character in another project"**: the Persona Library.
  `list_library_personas`, then `import_library_persona` into the other
  project.

## Sessions

- **"Trainees get no help during the session"**: `set_project_features`
  `realtimeFeedbackEnabled: true`. Live coaching cards appear during the
  session. Coach mode (guided practice) and exercise mode (free practice) are
  chosen by the trainee in the app.
- **"Trainees should just start, no goal to pick"**: `set_project_features`
  `hideGoalSelection: true`.
- **"Trainees want to ask questions about the material"**:
  `set_project_features` `expertChatEnabled: true`. A voice expert grounded
  exclusively in the project knowledge, no scoring.
- **"We need a knowledge check without a voice session"**:
  `set_project_features` `standaloneQuizzesEnabled: true` (the quiz must be
  saved first with `save_quiz`).
- **"The score looks too low for a short session"**: sessions under 60 s are
  capped at 5 out of 10, and one-word sessions at 2, by design. Longer
  sessions score normally.

## Setup

- **`generate_personas` refused, "knowledge not ready"**: documents still
  processing. `get_project_setup_status` with `wait: true`, chain calls, then
  retry.
- **"The goals do not match our documents"**: `suggest_training_goals` with a
  precise `focusHint` and the user's `businessContext`; send only the agreed
  goals to `generate_personas`.
- **"Not enough personas"**: `generate_more_personas` with `count` and
  `instructions` (draft pool) or `add_persona` by hand (active project).
- **"Quiz questions are off-topic"**: `regenerate_quiz_question` for one,
  `generate_more_quiz_questions` for more, then `save_quiz` with only the
  accepted ids.
- **"Upload failed"**: 20 MB per file, document and page caps per project; the
  upload page states the exact limit. Duplicates of an already uploaded file
  are accepted at no cost.

## Access and invitations

- **`invite_trainees` refused, "project not active"**: `activate_project`
  first.
- **"Invitation cap reached" on a setup code**: the manager set a limit when
  minting the code; the error states the remaining budget. Ask the manager for
  a new code.
- **"The code stopped working"**: revoked, expired (90 days), the manager lost
  access, or the project was deleted. A new code comes from the manager's
  dashboard.
- **"A trainee never received the invitation"**: the manager resends it from
  the trainees page of the dashboard; MCP has no resend tool.

## Key files

- [mcp/tools.md](mcp/tools.md): tool catalog and confirmations
- [mcp/clients.md](mcp/clients.md): connection and auth errors
