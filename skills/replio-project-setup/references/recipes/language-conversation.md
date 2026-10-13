# Recipe: language conversation

Learners practice speaking a target language with a persona who holds the
conversation in that language. Any subject works: the persona is a
conversation partner, the topic is only the pretext.

## Collect, in this order

1. **Target language** with its variant when it matters (Portuguese from
   Portugal or Brazil, Spanish from Spain or Latin America, English UK or US).
2. **Level**, as a CEFR band (A2, B1, B2, C1). Without it the training
   defaults to B1.
3. **The learners' native language**: needed for the coach mode, which
   explains in the native language; immersion mode stays in the target
   language throughout.
4. **A topic or a document**: a news article, a menu, a job description, a
   chapter of a course. A FILE goes through `get_upload_link`; a pasted text
   through `add_knowledge_text`; a public page through `add_knowledge_url`.
   The document is the conversation subject, not knowledge to be tested.
5. **The situations to practice**: ordering in a restaurant, a job interview,
   a phone call to a landlord, small talk at work.

## Project description

Name the language context with words such as language, speak, fluency,
conversation practice or vocabulary: the training domain is detected from
the text. Name the target language and the level in the description too.

## Goals to propose

Run `suggest_training_goals` with `focusHint` set to the situations, then
agree 2 to 5 goals. Good goals:

- Keep the conversation going for five minutes without switching language.
- Use the vocabulary of the uploaded text in context.
- Ask follow-up questions instead of only answering.
- Handle a misunderstanding by rephrasing.

## businessContext shape

> Learners of [target language, variant] at level [CEFR], native speakers of
> [native language]. They want to practice [situations]. The conversation
> topic comes from [document or topic]. Modes: immersion (persona stays in
> [target language]) and coach (explanations in [native language]).

## generate_personas arguments

Set `language` to the TARGET language as a BCP-47 tag (`pt-PT`, `es-MX`,
`en-GB`), so the personas speak it with the right variant. The
`businessContext` carries the level and the native language.

## What to check in the generated personas

- Each persona has a situation the learner would plausibly meet and speaks
  at the requested level: an A2 persona uses short sentences and common words,
  a C1 persona speaks naturally.
- Personas are patient at lower levels: difficulty 2 for A2 and B1, 3 for
  B2, 4 only for C1.
- No persona corrects grammar in immersion mode; corrections belong to the
  coach mode the learner picks in the app.

## Features to suggest

- `realtimeFeedbackEnabled: true`: live cues help learners who freeze.
- `hideGoalSelection: true` for beginners, so they start speaking at once.
- Quiz: only when the uploaded text is course material with facts to check.

Then continue with the standard flow.
