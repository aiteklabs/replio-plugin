# Recipe: support escalation

A support or customer-service team practices the calls that go wrong: an
angry customer, a request the policy cannot grant, a complaint that must be
de-escalated. The persona is the customer; the trainee handles the case.

## Collect, in this order

1. **The policies and limits that apply**: refund rules, warranty terms,
   what the agent may and may not promise. These are FILES through
   `get_upload_link` (the policy document, the FAQ) or pasted text through
   `add_knowledge_text`. Personas only know what the project knowledge holds,
   so without the policy the persona cannot test it.
2. **The two or three case types to practice**: pick from the user's real
   tickets ("delivery three weeks late", "wants a refund outside the window",
   "threatens to post a review"). Ask for the user's words.
3. **The channel**: phone or chat-like voice; the tone differs.
4. **What a good outcome looks like** for each case (customer accepts the
   alternative, agrees to a call-back, stays a customer).

## Project description

Name the support context in the description with words such as support,
customer service, complaint, issue or escalation: the training domain is
detected from the text.

## Goals to propose

Run `suggest_training_goals` with `focusHint` set to the case types, then
agree 2 to 5 goals. Good goals for this drill:

- Acknowledge the frustration before explaining anything.
- State what can be done, not only what cannot.
- Keep the policy without reading it out.
- Close with a concrete next step and a time.

## businessContext shape

> We are the [support team] of [company]; customers contact us about
> [products or services]. The cases we want to practice: "[case 1]",
> "[case 2]", "[case 3]". The policy limits that matter: [limits]. A good
> outcome is [outcome].

## What to check in the generated personas

- Every persona has a reason to be upset that the knowledge can confirm (a
  real delay, a real rule), so the exercise stays fair.
- Success and failure conditions, when present, are written as ONE spoken
  behavior the trainee either does or does not do ("the trainee offers an
  alternative before the customer asks twice"), never a time limit or a
  ratio.
- One persona stays calm but firm: not every case is shouting.

## Features to suggest

- `realtimeFeedbackEnabled: true`: de-escalation benefits most from live
  cues.
- `expertChatEnabled: true` when a policy document was uploaded, so agents
  can ask the knowledge directly between sessions.
- Quiz: yes, on the policy facts.

Then continue with the standard flow.
