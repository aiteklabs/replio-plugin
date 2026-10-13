# Recipe: sales objection drill

A sales team rehearses the objections that lose deals. The persona is the
buyer; the trainee sells. Everything below feeds the standard flow in
SKILL.md; the recipe only decides what to collect and what to send.

## Collect, in this order

1. **What is sold**: product or service, in one or two sentences, with the
   price position (premium, mid-market, cheapest). Ask for the product sheet
   or pitch deck as a FILE through `get_upload_link`; pasted paragraphs go to
   `add_knowledge_text`.
2. **Who buys**: the buyer's role and company type (a purchasing manager in a
   mid-size manufacturer, a clinic owner, a retail store manager).
3. **The three objections that hurt most**: ask for the user's own words from
   lost deals or call notes ("too expensive compared to X", "we already have a
   supplier", "send me a brochure"). Do not invent objections.
4. **The stage to practice**: discovery call, demo follow-up, price
   negotiation, renewal. One stage per project keeps the personas focused.

## Project description

Give `create_project` or `set_project_details` a description that names
the sales context explicitly, with words such as sales, prospect, objection,
deal or client: the training domain is detected from the text.

## Goals to propose

Run `suggest_training_goals` with `focusHint` set to the stage, then agree 2
to 5 goals. Good goals for this drill:

- Uncover the real need before presenting the offer.
- Answer the price objection with value, not discounts.
- Turn "send me a brochure" into a next meeting.
- Ask for the next step at the end of every call.

## businessContext shape

The user's own words, assembled into one paragraph: who the team is, what
they sell and to whom, the price position, the three objections verbatim, and
the stage to practice. Example skeleton (fill with the user's content, never
leave placeholders):

> We are the [team] of [company]. We sell [offer] to [buyer role] at
> [company type]; we are [price position]. The objections we lose on are:
> "[objection 1]", "[objection 2]", "[objection 3]". We want to practice
> [stage].

## What to check in the generated personas

- Each persona carries objections written as ONE observable spoken behavior
  ("says the current supplier is cheaper and asks for a discount"), not a
  list joined with "or" and not a physical action.
- The three real objections appear across the pool; add the missing one with
  `update_generated_persona`.
- Difficulty spread: one easy (2), most medium (3), one hard (4) through
  `difficultyLevels` at `activate_project`.

## Features to suggest

- `realtimeFeedbackEnabled: true` for the first weeks (live coaching cards).
- `hidePersonaDetails: false` at first; turn it on once the team knows the
  personas, to simulate unknown buyers.
- Quiz: yes if a product sheet was uploaded (facts to check), skip otherwise.

Then continue with the standard flow: review every persona, offer the quiz,
confirm activation, offer invitations.
