---
description: Stage and commit changes as a conventional commit using cog.
---

Commit the current changes following this repo's Conventional Commits rules
(enforced by cocogitto). `$ARGUMENTS` is an optional hint from the user about
what the commit is for — treat it as context, not as the literal message.

Steps:

1. Run `git status` and `git diff` (staged and unstaged) to understand exactly
   what changed. Read the AGENTS.md "Conventions" section for the allowed
   commit types and the repo's formatting rules.

2. Run `./format_code.sh` to apply `nixpkgs-fmt` + `shfmt -i=4`, then re-stage
   anything the formatter touched so the working tree and index match before
   the pre-commit hook runs.

3. Stage the files that belong in this commit with `git add` (avoid `git add .`
   unless every change is intended). Do not stage unrelated changes.

4. Choose a conventional commit:
   - **type**: one of `feat`, `fix`, `chore`, `docs`, `style`, `refactor`,
     `perf`, `test`, `build`, `ci`, `revert`. Default to `feat` for new config,
     `fix` for correcting breakage, `chore` for lockfile/dependency bumps.
   - **scope** (optional, rarely used here): a host or area, e.g. `laptop`,
     `desktop`, `home`, `t14gen1i`.
   - **subject**: imperative mood, lowercase start, no trailing period,
     ≤72 characters, summarizing the *why/what*.

5. Commit with cocogitto so the message is valid by construction and the git
   hooks run:

   ```bash
   cog commit <type> "<subject>" [scope]
   ```

   Only fall back to `git commit -m "<type>: <subject>"` if `cog` is not
   installed. Never use `--no-verify`.

6. Show the result with `git log -1 --stat` and run `cog check` to confirm the
   history still validates. If the hook rejects the message, fix the message
   and create a fresh commit — do not amend through a failed hook.

**Never push.** This command only creates a local commit. Do not run
`git push`, `cog bump`, or any remote-updating command — stop after the commit
is created and verified. Leave pushing to the user.

Never commit secrets, keys, or tokens. If anything looks machine-specific or
sensitive, stop and ask before committing.
