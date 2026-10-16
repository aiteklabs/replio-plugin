# Coaching note for one trainee

For "how did Anna do", "coaching note for Tom", "why did Lucas get a 4".

## Steps

1. Identify the trainee: `list_sessions` with `traineeEmail` when the user
   gave an email; otherwise list the period (paged) and match the name the
   user gave. Two trainees with the same first name: ask which one.
2. `list_sessions` with `traineeEmail`, `days` 30 (or the period the user
   named, up to 90), paged to the end.
3. `get_session` on the three most recent analyzed non-expert sessions, or
   on the one session the user asked about.
4. Progression: compare scores in time order, with evidence levels. A capped
   session does not count as a drop.
5. Themes: improvements that repeat across the opened sessions are the
   coaching theme; strengths that repeat are what to keep.
6. The trainee's `goal` on each session tells whether they practiced what
   they set out to practice.

## The note

- **Headline**: sessions in the period, average over analyzed non-expert
  sessions (count stated), direction (improving, steady, mixed, one session
  only).
- **Last sessions** (newest first, three at most): date, persona, duration,
  score with evidence level, outcome, one-line summary from `get_session`.
  Name a capped score as capped; name an override with its reason sentence.
- **Keeps**: one or two strengths that repeat.
- **Works on**: one theme, named through the weakest metric and the
  repeated improvement, with one concrete behavior to try next session.
- **Next session goal**: one sentence the trainee can set as their goal.

## Guardrails

- Quote the analysis summary; do not open the transcript unless the user
  asks for the conversation itself, and confirm before opening it.
- A single session is a snapshot, not a trend; say so.
- No comparison with named colleagues unless the user asks for it.
- The note is about training behavior in these sessions only.
