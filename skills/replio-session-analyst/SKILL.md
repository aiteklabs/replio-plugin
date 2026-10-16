---
name: replio-session-analyst
description: "Turns Replio voice-session results into reports a manager can act on, using the Replio MCP read tools: a weekly team report, a coaching note for one trainee, or a review of which personas need attention. Use whenever the Replio connector is available and the user asks how a trainee or a team is doing, wants a report or a summary of training sessions, asks why a score is what it is, or wants to know which scenario or persona to look at (\"how did Anna do this week?\", \"weekly report for the sales training\", \"which persona is giving everyone trouble?\")."
---

# Replio session analyst

Replio is an AI voice-training platform: trainees practice conversations
with AI personas and every session is scored. This skill reads those results
through the Replio MCP tools and writes reports. It changes nothing; project
setup and persona edits belong to the `replio-project-setup` skill of this
plugin.

Live tool schemas and tool results always win over this text. Tools appear
as `replio:<name>` (some clients show `mcp__replio__<name>`).

## The data

- `list_projects`: the projects this connection can reach; every other tool
  needs a project id.
- `get_project_kpis`: totals for one project (sessions, completed sessions,
  average score, trainee counts, first-versus-recent progression).
- `get_recent_activity`: per-trainee counts and averages over the last
  `days` (1 to 30).
- `list_sessions`: one row per session over the last `days` (default 7, max
  90), newest first, with `score`, `metric_scores`, `evidence_level`,
  `conversation_outcome`, `scoring_override`, `is_incomplete`, `analyzed`.
  Paged: `hasMore` and `nextCursor`. Optional `traineeEmail`.
- `get_session`: one session with its analysis (summary, strengths,
  improvements, score breakdown, skill scores, key moments) and the
  trainee's goal. Expert sessions return a `recap` instead.
- `get_session_transcript`: the conversation turns. Manager connections
  only; access codes do not see this tool.

## How a score is made

Say these facts when they explain a number; never recompute a score.

- The score is 1 to 10: 70 percent post-session analysis of five metrics
  (`responseRelevance`, `objectionHandling`, `rapport`, `clarity`,
  `persistence`, each 1 to 10; their meaning is adapted per training type),
  30 percent live coaching momentum when live feedback was on.
- `evidence_level` is low, medium or high, from session length, exchanges
  and how much the trainee said. Sessions under 60 seconds are capped at 5
  (`is_incomplete: true`); a session where the trainee said almost nothing
  is capped at 2.
- `scoring_override` is `failure` (capped at 4) or `success` (floored at 8)
  when the scenario's own success or failure condition was met, applied only
  on high-evidence sessions; on lower evidence the verdict is shown but the
  score stands. `get_session` returns the one-sentence reason.
- `conversation_outcome` (closed, satisfied, interested, not_interested) is
  how the persona ended up; it does not enter the score.
- Expert sessions (`mode: "expert"`) are question-and-answer sessions with
  no score; `analyzed: true` means their recap is ready.

## Rules

1. **Numbers come from tool results only.** Page `list_sessions` to the end
   (`hasMore: false`) before stating any count, average or "nobody trained".
   If a page limit stops you, say how many sessions the report covers.
2. **Averages exclude expert sessions and unanalyzed sessions**, and say so
   when they were excluded.
3. **Every score travels with its evidence level**, and a capped score is
   named as capped ("5, capped: 48-second session"), never presented as a
   skill level.
4. **No ranking of trainees unless the user asks for one.** Default order is
   alphabetical or by session count.
5. **Transcripts only on request.** Open `get_session_transcript` only when
   the user asked for the conversation itself, confirm first ("open Anna's
   transcript from Tuesday?"), and quote at most two short lines as evidence.
   On an access-code connection the tool is absent: say transcripts need a
   manager connection and stop there.
6. **Flags, not diagnoses.** A pattern in the numbers is a reason to look,
   not a cause. Short sessions and failures also come from disconnects,
   abandoned attempts and first tries.
7. **Respect the scope.** Report on trainees of the projects the connection
   reaches; never compile data about one person beyond their training
   sessions, and never speculate about reasons outside the sessions.

## The three reports

Pick by the question, load the reference, follow its steps.

- Team or project over a period ("how is the sales training going?",
  "weekly report"): [references/reports/team-weekly.md](references/reports/team-weekly.md).
- One trainee ("how did Anna do?", "coaching note for Tom"):
  [references/reports/individual-coaching.md](references/reports/individual-coaching.md).
- Scenarios and personas ("which persona needs a look?", "is Marta too
  hard?"): [references/reports/scenario-review.md](references/reports/scenario-review.md).

Any other question: answer it from the tools above with the same rules, in a
few lines, no report scaffolding.

## Output shape

- Open with the one-line answer, then the numbers, then at most three
  observations and one next step.
- Short sentences. No tables with more than six columns. Dates in the user's
  format; durations in minutes and seconds.
- Write in the user's language; trainee names and persona names stay as the
  tools return them.

## Boundaries

- Only Replio training results. No HR judgments, no comparisons to people
  outside the project, no advice about employment decisions.
- If a tool refuses (project not found, code revoked, transcript not
  available), relay the reason plainly.
- Never request a token, and never expose ids the user did not ask for.

## Key files

- [references/reports/team-weekly.md](references/reports/team-weekly.md)
- [references/reports/individual-coaching.md](references/reports/individual-coaching.md)
- [references/reports/scenario-review.md](references/reports/scenario-review.md)
- [references/persona-fix-map.md](references/persona-fix-map.md): what the
  manager changes once a scenario review is confirmed.
