# Scenario review

For "which persona needs a look", "is Marta too hard", "why does everyone
fail the refund scenario". The output is a review flag with its sample size,
never a verdict on the persona.

## Steps

1. `list_sessions` over 30 days (or the user's period, up to 90), paged to
   the end.
2. Group analyzed non-expert sessions by `persona_name`. Per persona:
   sessions, distinct trainees, average score, share with
   `scoring_override: "failure"`, share with `is_incomplete: true`, evidence
   distribution (high, medium, low), outcomes.
3. Flag a persona when, with at least 5 analyzed sessions from at least 2
   trainees, one of these holds: average at least 1.5 points below the
   project average; failure overrides on a third or more of its sessions;
   half or more of its sessions incomplete or low evidence.
4. For a flagged persona, open two or three representative sessions with
   `get_session` (one low, one median, one high) and read the summaries and
   the override reasons: do they describe the same obstacle?

## The review

- **Per persona** (all of them, by session count): sessions, trainees,
  average with evidence distribution, failures, incomplete, outcomes.
- **Flags**: the personas that met a threshold, each with the numbers that
  triggered it and the sample size.
- **What the opened sessions say**: the common obstacle in the summaries,
  quoted from `get_session`, or "no common pattern".
- **Ask before acting**: a flag is a reason for the manager to open two or
  three sessions themselves. Suggest that, with the session dates, before
  any change to the persona.
- **If the manager confirms**, point at
  [../persona-fix-map.md](../persona-fix-map.md) for the change that matches
  the obstacle (difficulty, objections, knowledge, language, hidden details).

## Why the numbers alone are not enough

Short sessions and failure overrides also come from disconnects, abandoned
attempts, trainees' first tries, and a condition worded too broadly. A
persona can be exactly as hard as intended. The review says where to look;
the manager decides.
