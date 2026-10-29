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
  with organization, status, training domain; call it first to find ids),
  `list_project_templates` (managers; the `templateId` values
  `create_project` accepts). Write: `create_project` (managers only; optional
  `language` as a BCP 47 code and `templateId`).
- **Pipeline context (optional)**: read `get_crm_pipeline_digest` (anonymized
  patterns from the CRM connection bound to the project: objection clusters,
  lost reasons, stall stages, buyer profiles, won patterns; `connected: false`
  when the project has no CRM, `lowSignal: true` when fewer than 15 lost deals
  had notes). Write: none; a CRM is bound from the dashboard.
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
  `set_project_features` (`realtimeFeedbackEnabled`, `hidePersonaDetails`,
  `hideGoalSelection`, `liveAssistEnabled`; expert chat, practice quizzes and
  reminder emails are always on and have no flag).
- **Live personas (ACTIVE project)**: read `list_personas`. Write
  `add_persona` (manual, no AI), `update_persona`, `delete_persona`.
- **Invitations**: write `invite_trainees` (exact list of `trainees` with
  `email`, optional `name` and `phone`; optional `locale`; `channel` app,
  both or phone; a preview with seats before and after until
  `confirm: true`).
- **Reporting**: read `get_project_kpis` (sessions, average AI score 0 to 10,
  trainee counts, first-versus-recent progression), `get_recent_activity`
  (who trained over the last `days`, default 1, with per-trainee scores),
  `list_sessions` (one row per session over the last `days`, default 7, max
  90, optional `traineeEmail`; paged with `limit`, `cursor`, `hasMore`,
  `nextCursor`), `get_session` (one session: analysis summary, strengths,
  improvements, score breakdown, the five skill scores, key moments, the
  trainee's goal; expert sessions return a recap instead),
  `get_session_transcript` (the conversation turns, first 200; manager
  connections only). The session-analyst skill in this plugin builds reports
  on these.

The phases below exist on manager connections only (see the next section).

- **Contacts and groups**: read `list_contacts` (search, status, `groupId`,
  paged max 50; the only source of `contactId`), `get_contact_import_job`
  (poll a background import), `list_contact_groups` (the only source of
  `groupId`). Write `add_contacts` (store people, max 500 per call, no email,
  no seat; over 50 rows returns a `jobId`), `update_contact` (name, phone,
  locale), `deactivate_contacts` (preview, then `confirm: true`),
  `manage_contact_group` (`action` create, update, archive with preview and
  `confirm`, restore), `set_contact_group_members` (`action` add or remove),
  `assign_contacts_to_project` (`contactIds` and/or `groupIds` into an ACTIVE
  project with `channel`; preview with seats, then `confirm: true`).
- **Trainees**: read `list_project_trainees` (status, sessions, score, last
  activity, paged max 50; the source of `membershipId`), `get_trainee` (one
  person's stats and 10 recent sessions). Write `manage_trainee` (`action`
  resend_invitation, deactivate, reactivate, remove, send_reminder; every
  action except reactivate previews first), `set_trainee_personas` (the full
  list of persona ids one trainee may practise with; `[]` lifts the
  restriction).
- **Phone training (Replio Call)**: read `get_phone_training` (on or off,
  calls per month, end date, participants with number, consent and bookings).
  Write `set_phone_training` (`enabled`, `callsPerMonth` 1 to 20, `until`
  YYYY-MM-DD or null; switching off or shortening the end date previews
  first), `send_phone_invitations` (`scope` all, missing_number or
  memberships with `membershipIds`; preview with the recipient count, then
  `confirm: true`).
- **Replio Live (call assist)**: read `get_live_workspace` (enabled, contexts,
  reps, every library document and folder id), `get_live_context` (linked
  documents, brief status, fact cards, withheld cards, objection cards;
  `wait: true` blocks up to about 25 s). Write `manage_live_context`
  (`action` create, update, archive with preview and `confirm`),
  `link_live_documents` (`assetIds` and `folderIds`, the FULL set),
  `build_live_brief` (forced synchronous rebuild), `set_live_brief_published`
  (`briefId`, `published`), `manage_live_card` (`action` update, add, delete
  with preview and `confirm`), `manage_live_objection` (`action` update,
  approve_all, unapprove_all).
- **Knowledge Library**: read `list_knowledge_library` (folders and documents
  with ids, extraction status, `folderId` and `search` filters, max 50),
  `list_replio_library` (documents Replio ships). Write
  `manage_knowledge_folder` (`action` create, rename, move, archive),
  `add_library_document` (`kind` text or url, `folderId`; not linked to any
  project), `delete_library_document` (preview, then `confirm: true`; refused
  while a project links it), `manage_project_documents` (`action` link with
  `assetId` or `folderId` and `syncMode`, unlink with `linkId`),
  `import_replio_document` (`docId`, optional `projectId` to link the copy).
- **Organization and reports**: read `get_project_report` (headline stats,
  per-trainee rows, skill averages; CSV stays on the dashboard),
  `get_organization_usage` (minutes, seats, projects), `list_team_members`
  (managers: owner, admin, viewer). Write `duplicate_project` (`projectId`,
  optional `targetLanguage`; preview, then `confirm: true`), `set_join_link`
  (`enabled`, `rotate` with `confirm`, `allowedDomains`),
  `invite_team_member` (`email`, `role` admin or viewer with `projectIds`;
  preview, then `confirm: true`).

## What each connection can call

- **Manager** (OAuth sign-in, scope `mcp:read mcp:write`): every tool (71),
  across all the manager's organizations. The domain tools (contacts and
  groups, trainees, phone training, Replio Live, Knowledge Library,
  organization and reports) exist on this connection only.
- **Setup code** (scope `mcp:project-write`): the project setup and
  reporting tools except `create_project` (31), pinned to its one project.
  `list_projects` returns only that project. No domain tool is listed, and
  calling one is refused.
- **Read code** (scope `mcp:project`): the read tools only, pinned to one
  project.

`get_session_transcript` is listed for manager connections only. Setup and
read codes do not see it and are refused if they call it: a transcript is a
different disclosure than the scores a code was shared for.

A code is re-checked on every call: removing the manager who minted it,
revoking the code, or deleting the project ends access. Relay such refusals
plainly.

## Confirm before acting

State the exact target and get the user's go-ahead before any of these. The
server's tool annotations flag the same risks (`destructiveHint: true` on
every tool below); confirm even when a client hides them.

### Confirm in code: previews

Every tool that sends email, uses seats, cancels calls or deletes takes a
`confirm` boolean. Called without `confirm: true` it changes nothing and
returns `{preview: true, ...}` with the numbers: people selected, already
enrolled, seats before and after, which emails go out, what is cancelled or
purged. Show that preview to the user, ask, and call the SAME tool again with
`confirm: true` only after they agreed in this conversation. The tools that
work this way:

- `invite_trainees`, `assign_contacts_to_project` (emails and seats)
- `deactivate_contacts`, `manage_contact_group` action `archive`
- `manage_trainee` every action except `reactivate`
- `set_phone_training` when switching off or moving the end date earlier
  (cancels booked calls), `send_phone_invitations`
- `manage_live_context` action `archive`, `manage_live_card` action `delete`
- `delete_library_document`
- `duplicate_project`, `set_join_link` with `rotate: true`,
  `invite_team_member`

### Confirm in conversation

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

`get_session_transcript` is read-only but opens a trainee's conversation:
call it only when the user asked for the conversation itself, never to
decorate a score report.

`add_knowledge_url` and `add_library_document` kind `url` fetch a public web
page (`openWorldHint: true`). `invite_trainees`, `assign_contacts_to_project`,
`manage_trainee` (resend_invitation, send_reminder), `send_phone_invitations`
and `invite_team_member` email people; a manager connection may reach at most
300 email recipients per hour across them.

## Tool notes

- `get_project_setup_status` with `wait: true` returns early when processing
  finishes; chain calls silently while `stillProcessing` is true. Never tell
  the user to wait or check back.
- `generate_personas` is refused while the knowledge base is not ready
  (`knowledgeReady: false`); keep polling first.
- `suggest_training_goals` before `generate_personas`: goals steer the
  scenarios and objections. Send the agreed goals, never only the suggestions.
- `get_crm_pipeline_digest` before `suggest_training_goals` and
  `generate_personas` when it answers `connected: true` with a `digest`: the
  objection clusters, lost reasons and buyer profiles belong in the goals and
  in `businessContext`. With `lowSignal: true`, say the sample is small and
  that the manager can opt in from the project setup page;
  `usedForGeneration` says whether the server already applies the digest.
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
- `list_sessions` pages: keep calling with `nextCursor` while `hasMore` is
  true before stating any count or average. Expert sessions (`mode:
  "expert"`) carry no score and `analyzed` means their recap is ready; keep
  them out of every average.
- `add_contacts` only stores people: no email, no seat, no project. An email
  already in the library is updated, a deactivated contact is reactivated.
  When it answers `processing: true`, poll `get_contact_import_job` until
  `stillProcessing` is false before stating counts. `list_contacts` and
  `list_contact_groups` are the only sources of `contactId` and `groupId`;
  never guess ids.
- `assign_contacts_to_project` is for people already in the library or a
  group; `invite_trainees` is for new addresses. Both need an ACTIVE project
  and use one seat per new person. `channel` phone or both needs the project's
  phone training on.
- Deactivation is soft: `deactivate_contacts` and `manage_trainee` deactivate
  keep the account and history; a deactivated contact is purged 90 days later
  and re-adding the email reactivates the contact but not the memberships.
  `manage_trainee` deactivate also cancels the trainee's booked phone calls;
  reactivate needs a free seat and is refused at the seat limit.
- `manage_trainee` send_reminder goes out at most once per 24 hours and never
  to a trainee who unsubscribed, is deactivated or whose project is not
  active; relay the refusal, do not retry.
- `list_project_trainees` pages (max 50): follow `page` while `hasMore` is
  true before stating any count.
- Phone training and Replio Live answer `{available: false, reason}` when the
  deployment has no phone provider or the organization has no Live: tell the
  user the feature is not activated and how to ask Replio, then stop; do not
  retry the other tools of that domain.
- `link_live_documents` REPLACES the whole linked set: always pass the full
  `assetIds` and `folderIds` lists, an empty list unlinks everything. A folder
  links with its children; an empty folder is refused.
- Every Live rebuild (`link_live_documents`, a language change through
  `manage_live_context`, `build_live_brief`) resets the objection approval:
  say so and offer `manage_live_objection` approve_all again after the user
  reviewed the wording. Hidden cards, edits and manual cards survive rebuilds.
  A card read from a document is hidden, never deleted; only manual cards can
  be deleted.
- `get_live_context` with `wait: true` returns early once documents are read
  and the brief exists; chain calls while `stillProcessing` is true.
- `delete_library_document` is permanent and refused while any project links
  the document; unlink first with `manage_project_documents`.
  `manage_knowledge_folder` archive hides a folder without touching its
  documents or their project links.
- `add_library_document` and `import_replio_document` count as one AI
  operation each; identical content already in the library comes back as a
  duplicate, not a new document.
- Every tool returns `structuredContent` with the keys its `outputSchema`
  documents; read results by those names.
- Edits apply to new sessions only; past sessions keep their transcript and
  score.

## Widgets (MCP Apps)

The read tools `list_projects`, `get_project_kpis`, `get_recent_activity`,
`get_project_setup_status`, `list_contacts` and `get_live_context` carry an
`_meta.ui.resourceUri` pointing at a `ui://replio/*` view. Hosts that support
MCP Apps render the widget; every other host keeps the text and
`structuredContent` result. Never depend on the widget being shown.

## Key files

- [clients.md](clients.md): connect a client, OAuth, access codes,
  troubleshooting
- [../failure-modes.md](../failure-modes.md): symptom to fix location
