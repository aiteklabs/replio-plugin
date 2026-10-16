# Team report over a period

For "how is the training going", "weekly report", "did the team train this
week". Default period: the last 7 days; use the period the user named, up to
90 days.

## Steps

1. `list_projects` if no project is in context; ask which one when several
   match.
2. `get_project_kpis`: the project totals since the start. Keep the average
   score and the progression line for context.
3. `get_recent_activity` with `days` set to the period (max 30; for a longer
   period skip this step): per-trainee counts and averages.
4. `list_sessions` with the same `days`, paged with `nextCursor` until
   `hasMore` is false. This is the source of every number in the report.
5. From the rows, per trainee: sessions, analyzed sessions, average score
   over analyzed non-expert sessions, best and weakest metric from
   `metric_scores` (average each metric across their analyzed sessions),
   capped sessions (`is_incomplete`), overrides, outcomes.
6. Only when a trainee's numbers need explaining (one very low or very high
   session, an override), open that session with `get_session` and use the
   summary. Do not open every session.

## The report

- **Headline**: sessions this period, trainees who trained, average score
  (analyzed non-expert sessions only, say how many), compared with the
  project average from `get_project_kpis`.
- **Per trainee** (alphabetical): sessions, average with evidence levels in
  brackets ("7.2 across 3 sessions, 2 high, 1 medium"), best metric, weakest
  metric, one coaching line that names the weakest metric and one concrete
  thing to try next session. A capped session is named as capped.
- **Participation**: trainees in `get_recent_activity` with zero sessions do
  not exist as rows, so the report says "among trainees who trained" unless
  the user gives the roster; `get_project_kpis` trainee counts give the
  total enrolled.
- **Observations** (at most three): a metric low across the team, a persona
  that concentrates the low scores (hand over to the scenario review),
  outcomes trend.
- **Next step**: one action for the manager.

## Guardrails

- Expert sessions and unanalyzed sessions are listed in the participation
  count but never in an average; say "2 expert sessions not scored".
- One session is not a trend: say so when a trainee has a single session.
- Do not rank trainees unless asked; do not label anyone as "worst".
