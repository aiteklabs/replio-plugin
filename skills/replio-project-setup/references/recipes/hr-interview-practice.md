# Recipe: interviewer practice

Hiring managers and HR staff practice conducting interviews. The trainee is
the INTERVIEWER; the persona is the candidate. This is the only direction
Replio's HR training supports: a persona cannot play the interviewer. If the
user wants candidates to rehearse their own interviews, say so plainly and
offer the interviewer drill instead, or a communication training where the
persona is a conversation partner.

## Collect, in this order

1. **The role being hired**: title, seniority, the three skills that decide
   the hire.
2. **The interview format**: screening call, competency interview, final
   round. One format per project.
3. **The question bank** or the competency grid, as text through
   `add_knowledge_text` or as a FILE through `get_upload_link`. The persona
   answers in character; the knowledge gives the interviewer the questions
   and the scoring grid to practice against.
4. **The candidate profiles to meet**: a strong candidate who undersells, a
   polished candidate with a gap, a candidate who dodges specifics. Ask for
   the user's own experience.

## Project description

Name the hiring context with words such as interview, candidate, hiring or
recruitment: the training domain is detected from the text.

## Goals to propose

Run `suggest_training_goals` with `focusHint` set to the format, then agree
2 to 5 goals. Good goals:

- Ask for a specific example after every general answer.
- Probe a gap without leading the candidate.
- Cover every competency of the grid within the time.
- Give the candidate a clear next step at the end.

## businessContext shape

> We are [team] at [company], hiring [role]. The interview to practice is
> [format]. The three skills that decide the hire: [skills]. Candidate
> profiles we meet: "[profile 1]", "[profile 2]", "[profile 3]".

## What to check in the generated personas

- Each persona is a candidate with a consistent background and one concrete
  weakness the interviewer should surface.
- Personas do not volunteer the weakness: the trainee has to probe.
- No persona is a caricature; a believable candidate makes a fair exercise.

## Features to suggest

- `realtimeFeedbackEnabled: true` for new interviewers.
- `hidePersonaDetails: true` from the start: an interviewer should not see
  the candidate's hidden weakness on the card.
- Quiz: skip, unless a legal or compliance document was uploaded (questions
  one may not ask).

Then continue with the standard flow.
