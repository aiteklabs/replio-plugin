# Persona fix map

What a manager changes once a scenario review was confirmed by reading the
sessions. Every edit belongs to the `replio-project-setup` skill's tools and
applies to NEW sessions only; past scores never change. Read the live
persona first (`list_personas`), name the one cause the sessions support,
then make the narrowest change.

## Personas

- **"The persona is too easy" or "too hard"**: `update_persona`
  `difficultyLevel` (2 easy, 3 medium, 4 hard) on a live persona, or
  `difficultyLevels` at `activate_project`. Difficulty drives the persona's
  patience, resistance and how fast objections come; do not rewrite the
  personality for this.
- **"The persona never objects" or "always the same objection"**:
  `update_persona` `objections`. Take the real objections from the user's
  context (lost deals, call notes) or, when the project has a CRM bound, from
  `get_crm_pipeline_digest`, and send the COMPLETE list, max 12.
- **"The persona states wrong facts"**: the knowledge, not the persona. Add or
  replace the document through `get_upload_link` (the dashboard knowledge page
  has a Replace button for a live document), then confirm with
  `get_project_setup_status`. Personas only know what the project knowledge
  holds.
- **"The persona speaks the wrong language"**: `language` on
  `generate_personas`, `regenerate_persona`, `generate_more_personas`, or
  `translate` on `import_library_persona`. The persona language follows the
  project language.
- **"Trainees see the persona's role and difficulty, that spoils the
  exercise"**: `set_project_features` `hidePersonaDetails: true`. Trainees
  then see names only.
- **"I want the same character in another project"**: the Persona Library.
  `list_library_personas`, then `import_library_persona` into the other
  project.

## When the numbers were the problem, not the persona

- Many short or low-evidence sessions: trainees stop early. Check with the
  manager whether sessions are being abandoned or disconnected before
  changing anything; `realtimeFeedbackEnabled: true` helps trainees who
  freeze.
- Failure overrides with the same reason sentence on sessions that went
  well otherwise: the condition may be worded too broadly. The manager
  rewrites it in the dashboard as one observable spoken behavior.
