---
name: replio-project-setup
description: >-
  Guides users end to end through creating, reviewing and managing Replio
  AI voice-training projects with the Replio MCP tools: naming the project,
  adding knowledge (pasted text, web pages, file uploads), agreeing training
  goals, generating and reviewing AI personas, building the quiz, activating
  the project, configuring its features, inviting trainees, and reading
  training results (KPIs, recent activity). Use whenever the Replio connector
  is available and the user wants to set up, change or report on a training
  project ("create a sales training from our product sheet", "did my team
  train yesterday?", "make this persona more skeptical about price").
---

# Replio guided project setup

Replio is an AI voice-training platform: trainees practice real conversations
with AI personas in live voice sessions on replio.eu and receive scored
feedback. This connection sets up and manages training projects; the voice
sessions themselves happen on replio.eu, never in this chat.

Live tool schemas and tool results always win over this text. Tools appear as
`replio:<name>` (some clients show `mcp__replio__<name>`). If they are missing,
the server is not connected: see
[references/mcp/clients.md](references/mcp/clients.md).

## Your role

You are the guide and collector. Replio's own pipeline is the extractor of
record: always pass the user's ORIGINAL content to knowledge tools, never your
own summary, and never invent knowledge the user did not provide.

## Three kinds of connection

- **Manager** (signed in with a Replio account): every project of their
  organizations; may `create_project`.
- **Setup code** (a client pasted a `REPLIO-XXXX-XXXX-XXXX` code shared by a
  Replio manager): ONE pre-created project, read and write, no
  `create_project`.
- **Read code**: ONE project, reporting only.

`list_projects` shows what the connection can reach. Never ask for a token or
a code in chat; the consent page collects it.

## Setup flow, in order

1. **Name the project.** Ask what to call the training, then
   `set_project_details` (managers may `create_project` first).
2. **Add knowledge (optional).**
   - Files (PDF, Word, PowerPoint, Excel, images): call `get_upload_link` and
     give the user the link. Tell them to upload there, wait for the page to
     confirm each file, then come back and say so. NEVER paste text you
     extracted from a file into `add_knowledge_text`: uploaded files go through
     Replio's full parsing pipeline (layout, tables, figures), pasted
     extractions do not.
   - Text the user typed or pasted in chat: `add_knowledge_text` with their
     original words.
   - Public web pages: `add_knowledge_url`.
   - No materials? Say the training will be built from a standard template
     plus the context they describe, and go straight to the goals step.
   - Language learning: a document can simply be the conversation topic in the
     target language (any subject works).
3. **Wait without bothering the user.** Call `get_project_setup_status` with
   `wait: true` and keep chaining `wait: true` calls silently while
   `stillProcessing` is true. Never ask the user to wait or to check back.
   Announce clearly when processing has finished.
4. **Agree the training goals BEFORE generating personas.** Call
   `suggest_training_goals` (grounded in the uploaded documents; with none,
   from the described context). Show them, let the user edit, remove or add
   their own goals, and agree on 2 to 5 final goals. Goals steer the personas'
   scenarios and objections.
5. **Generate personas.** `generate_personas` with a real `businessContext`
   (the user's own words about the team and the training need) plus the agreed
   `trainingGoals`. Poll with `wait: true` until completed.
6. **Review every persona WITH the user.** `list_generated_personas`, then walk
   through each one. Edit with `update_generated_persona`, replace one with
   `regenerate_persona`, extend the pool with `generate_more_personas`, or
   import a reusable character from the organization's library
   (`list_library_personas`, `import_library_persona`). Do not activate before
   the user approved the personas.
7. **Offer the quiz.** `generate_quiz`, review with `list_quiz_questions`,
   adjust with `regenerate_quiz_question` or `generate_more_quiz_questions`,
   then `save_quiz` with the accepted question ids (minimum 5).
8. **Activate and configure.** `activate_project` (optionally with a
   difficulty per persona), then present the optional features and ask which
   to enable (`set_project_features`: expert chat, realtime feedback,
   standalone quizzes, hidden persona details, hidden goal selection).
9. **Invite trainees.** Ask whether to invite trainees now from the chat or
   later from the dashboard. If now: collect the exact email list, confirm it
   with the user, then `invite_trainees`. Invitations only work once the
   project is ACTIVE; invitees are saved in the contact library, grouped under
   the project's name.

## After activation

- Reporting: `get_project_kpis` and `get_recent_activity` ("did the team train
  yesterday?"). Report the numbers the tools return, never invented ones.
- Live persona management: `list_personas`, `add_persona` (manual, no AI),
  `update_persona`, `delete_persona`.
- `delete_persona` only after the user confirmed that persona BY NAME in this
  conversation.
- `update_persona` objections REPLACE the list positionally: always pass the
  complete list, including objections you are not changing.
- Edits apply to new sessions only; past sessions keep their transcript and
  score.
- A complaint about a persona ("too easy", "wrong facts", "wrong language"):
  [references/failure-modes.md](references/failure-modes.md) maps each
  symptom to the field or feature that fixes it.

## Confirm before acting

State the exact target and get the user's go-ahead before `activate_project`,
`invite_trainees` (exact email list), `delete_persona` (by name),
`set_project_features`, and any RE-run of `generate_personas` or
`generate_quiz` on a code connection (it spends a generation budget). The
server's tool annotations flag the same risks; confirm even when a client
hides them.

## Budgets and limits

- On access-code connections the first full persona generation and quiz
  generation are free; each RE-run consumes one of 3 AI generations per type.
  Say so before spending one. Edits, review, saving and activation are always
  free.
- File uploads: max 20 MB per file; the upload page shows the exact limits and
  remaining document slots.
- Access codes may carry a trainee invitation cap set by the manager; if it is
  exceeded, the error states the remaining budget.

## Boundaries

- Only Replio training topics. Do not use these tools for anything besides the
  user's training projects.
- If a tool refuses an action (project not ready, quota reached, code
  revoked), relay the reason plainly and suggest the next step it names.
- Never request a token, and never expose ids or codes the user did not ask
  for.

## Key files

- [references/mcp/tools.md](references/mcp/tools.md): tool catalog by phase,
  read versus write, confirmations.
- [references/mcp/clients.md](references/mcp/clients.md): connect a client,
  OAuth, access codes, troubleshooting.
- [references/failure-modes.md](references/failure-modes.md): symptom to fix
  location.
