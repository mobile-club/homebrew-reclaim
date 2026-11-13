---
description: The conventions of the organisation for language, commit subjects and pull request titles
alwaysApply: true
---

# Conventions of the organisation

This file gives the 2 rules that each repository of mobile-club, Next-Mobiles
and cleaq follows. It is complete: you can apply it with no other file. The
other rules are in [mobile-club/metarepo](https://github.com/mobile-club/metarepo),
in its `CONTRIBUTING.md`.

The workflow `.github/workflows/org-conventions.yml` checks the 2 rules on each
pull request. A red check does not stop the merge. Correct the line that it
names.

## Rule 1: write in English

Write in English:

- each commit message;
- each pull request title;
- each pull request body;
- the code: names, log messages and error messages;
- each code comment;
- each doc, for example a README;
- each agent skill and each agent instruction file.

You can keep a real-world string in its own language when it must stay exact.
Examples are a database status, an email subject, a phrase that a customer
writes and a proper name, for example "La Poste". Put it in backticks or in
quotes. The check looks for French words only
outside backticks, double quotes (`"` and `“ ”`), single quotes (`'`) and
`« »`. A single quote directly after a letter is an apostrophe, so the check
still finds a French elision such as `l'erreur`.

## Rule 2: write each commit subject as `type(scope): summary`

The format of a commit subject is:

```text
type(scope): English imperative summary
```

The pull request title follows the same format, because a squash merge makes
the title the commit subject.

- `type` is one of `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`,
  `build`, `perf`, `style` and `revert`.
- The scope is mandatory. It names the package, the module or the area that the
  change touches, for example `api-v2` or `checkout`. A change to more than one
  package gives a list in one pair of parentheses: `(api-v2, admin)`.
- A `!` after the scope marks a change that breaks a contract:
  `refactor(api)!: remove the v1 routes`.
- The summary is English and imperative: `add`, `fix`, `remove`, not `added`
  or `fixes`.
- A ticket suffix is free. Each of these is correct:
  - `feat(cart): accept promo codes #MBC-123`
  - `fix(api-v2): stop the double charge (NMC-123)`
  - `chore(submodules): update the pins (#1655)`

The check skips a bot author, a merge commit and a revert commit
(`Revert "..."`). It also skips the revert of a revert, which git writes as
`Reapply "..."`.
