---
name: replio-project-setup
description: "Guides users end to end through creating, reviewing and managing Replio AI voice-training projects with the Replio MCP tools: naming the project, adding knowledge (pasted text, web pages, file uploads), agreeing training goals (grounded in the CRM pipeline digest when a CRM is connected), generating and reviewing AI personas, building the quiz, activating the project, configuring its features, inviting trainees, and reading training results (KPIs, recent activity); for managers also the contact library and groups, trainee management, phone training (Replio Call), Replio Live knowledge contexts, the Knowledge Library, reports, usage and the manager team. Use whenever the Replio connector is available and the user wants to set up, change or report on a training project or their Replio workspace (\"create a sales training from our product sheet\", \"did my team train yesterday?\", \"make this persona more skeptical about price\", \"enrol the Lisbon group in the project\", \"turn on phone training\")."
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
record: always send the user's ORIGINAL content to knowledge tools, never your
own summary, and never invent knowledge the user did not provide.

## Three kinds of connection

- **Manager** (signed in with a Replio account): every project of their
  organizations; may `create_project`. Only this connection has the workspace
  tools (contacts, trainees, phone training, Replio Live, Knowledge Library,
  organization); see "Manager workspace" below.
- **Setup code** (a client pasted a `REPLIO-XXXX-XXXX-XXXX` code shared by a
  Replio manager): ONE pre-created project, read and write, no
  `create_project`.
- **Read code**: ONE project, reporting only.

`list_projects` shows what the connection can reach. Never ask for a token or
a code in chat; the consent page collects it.

## Known situations

For a sales objection drill, a support escalation, interviewer practice or a
language conversation, open the matching recipe in
[references/recipes/](references/recipes/) first: it lists what to collect,
the goals to propose and the `businessContext` shape, then hands over to the
flow below.

## Setup flow, in order

1. **Name the project.** Ask what to call the training, then
   `set_project_details` (managers may `create_project` first, with the
   training `language` and, for a standard scenario, a `templateId` from
   `list_project_templates`).
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
   If the project is bound to a CRM (`get_crm_pipeline_digest` answers
   `connected: true` with a digest), read it before suggesting: its objection
   clusters, lost reasons and buyer profiles belong in the goals and in the
   `businessContext`. Say so when `lowSignal` is true (small sample; the
   manager can opt in from the project setup page).
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
   to enable (`set_project_features`: realtime feedback, hidden persona
   details, hidden goal selection, Replio Live on the project when the
   organization has it). Expert chat, practice quizzes and reminder emails
   are always on; do not offer a switch for them.
9. **Invite trainees.** Ask whether to invite trainees now from the chat or
   later from the dashboard. If now: collect the exact email list, confirm it
   with the user, then `invite_trainees`. Without `confirm: true` it returns a
   preview (invitations, seats before and after, which emails go out): show
   it, ask, then call again with `confirm: true`. When the project has phone
   training, ask whether they practise in the app, by phone or both
   (`channel`). Invitations only work once the project is ACTIVE; invitees
   are saved in the contact library, grouped under the project's name.

## After activation

- Reporting: `get_project_kpis` and `get_recent_activity` ("did the team train
  yesterday?"); `list_sessions` and `get_session` for one session or one
  trainee. Report the numbers the tools return, never invented ones. For a
  team report, a coaching note or a scenario review, the
  `replio-session-analyst` skill of this plugin has the method.
- Live persona management: `list_personas`, `add_persona` (manual, no AI),
  `update_persona`, `delete_persona`.
- `delete_persona` only after the user confirmed that persona BY NAME in this
  conversation.
- `update_persona` objections REPLACE the list positionally: always send the
  complete list, including objections you are not changing.
- Edits apply to new sessions only; past sessions keep their transcript and
  score.
- A complaint about a persona ("too easy", "wrong facts", "wrong language"):
  [references/failure-modes.md](references/failure-modes.md) maps each
  symptom to the field or feature that fixes it.

## Manager workspace

These tools exist on manager connections only; setup and read codes never see
them. [references/mcp/tools.md](references/mcp/tools.md) has the full map.

- **Contacts and groups.** `add_contacts` stores people in the organization's
  contact library (no email, no seat), only with addresses the user listed.
  `manage_contact_group` and `set_contact_group_members` organise them. To
  enrol people who are already in the library or a group, use
  `assign_contacts_to_project` on an ACTIVE project; `invite_trainees` is for
  new addresses. `list_contacts` and `list_contact_groups` are the only
  sources of ids; never guess one.
- **Trainees.** `list_project_trainees` (page to the end before stating a
  count) and `get_trainee` for one person; `manage_trainee` for
  resend_invitation, deactivate, reactivate, remove and send_reminder;
  `set_trainee_personas` to limit which personas one trainee practises with.
  Deactivation keeps the history; a reminder goes out at most once per 24 h.
- **Phone training (Replio Call).** Call `get_phone_training` first. When it
  answers `available: false`, say phone training is not activated on this
  deployment and stop. Otherwise `set_phone_training` turns it on with the
  monthly call quota and end date, and `send_phone_invitations` emails the
  booking link (`scope` all once participants are in, missing_number for
  people without a number, memberships to resend to specific people).
- **Replio Live (call assist).** Only when `get_live_workspace` answers
  `available: true`. Flow: `manage_live_context` create (one context per
  client, offer or language), `link_live_documents` with the FULL set of
  `assetIds` and `folderIds` (it replaces the whole set), `get_live_context`
  with `wait: true` while `stillProcessing`, present every fact card and
  withheld card and apply hides or corrections with `manage_live_card`,
  `set_live_brief_published`, then review the objection wording and
  `manage_live_objection` approve_all only after the user agreed. Every
  rebuild resets that approval: say so.
- **Knowledge Library.** `list_knowledge_library` for folder and document ids;
  `manage_knowledge_folder`; `add_library_document` for pasted text or a web
  page at organization level (files still go through `get_upload_link`);
  `manage_project_documents` to link or unlink library documents on a
  project; `list_replio_library` and `import_replio_document` for Replio's
  own training documents.
- **Reports and organization.** `get_project_report` for the headline numbers
  and per-trainee rows (CSV stays on the dashboard), `get_organization_usage`
  for minutes and seats, `list_team_members` and `invite_team_member` for the
  manager team, `duplicate_project` to copy a project (optionally into another
  language), `set_join_link` for the self-enrolment link.

## Confirm before acting

State the exact target and get the user's go-ahead before `activate_project`,
`invite_trainees` (exact email list), `delete_persona` (by name),
`set_project_features`, and any RE-run of `generate_personas` or
`generate_quiz` on a code connection (it spends a generation budget). The
server's tool annotations flag the same risks; confirm even when a client
hides them.

Every tool that sends email, uses seats, cancels calls or deletes also
enforces this in code: called without `confirm: true` it returns a preview
(people, seats before and after, which emails go out, what is cancelled or
purged) and changes nothing. Show the preview, ask, and call the same tool
again with `confirm: true` only after the user agreed in this conversation.
This covers `invite_trainees`, `assign_contacts_to_project`,
`deactivate_contacts`, `manage_contact_group` archive, `manage_trainee`
(except reactivate), `set_phone_training` when switching off or shortening,
`send_phone_invitations`, `manage_live_context` archive, `manage_live_card`
delete, `delete_library_document`, `duplicate_project`, `set_join_link` with
rotate, and `invite_team_member`.

## Budgets and limits

- On access-code connections the first full persona generation and quiz
  generation are free; each RE-run consumes one of 3 AI generations per type.
  Say so before spending one. Edits, review, saving and activation are always
  free.
- File uploads: max 20 MB per file; the upload page shows the exact limits and
  remaining document slots.
- Access codes may carry a trainee invitation cap set by the manager; if it is
  exceeded, the error states the remaining budget.
- Manager connections may reach at most 300 email recipients per hour across
  invitations, assignments, resends, reminders and phone invitations. For a
  larger roll-out, split it or point the user at the dashboard.

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
- [references/recipes/](references/recipes/): sales objection drill, support
  escalation, interviewer practice, language conversation.
