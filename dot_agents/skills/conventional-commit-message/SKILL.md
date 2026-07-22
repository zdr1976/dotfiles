---
name: conventional-commit-message
description: Generate conventional commit messages with a subject line capped at 50 characters and body lines wrapped to 72 characters. Use this when the user asks for a commit message, wants a conventional commit, wants a commit message formatted for git best practices, or asks for copy-ready commit text with no extra prose.
---

# Conventional Commit Message

Use this skill when the user wants a commit message that is ready to paste into
Git, especially when they want:

- a conventional commit
- a 50 character subject cap
- body lines wrapped to 72 characters
- output with no extra explanation

## Output Contract

Return only the commit message in a fenced `text` block unless the user
explicitly asks for explanation or alternatives.

Do not add lead-in text like "Here is your commit message".

## Rules

Format the subject as:

```text
type(scope): summary
```

Follow these rules:

- Keep the subject at or under 50 characters.
- Use an imperative summary.
- Prefer lowercase conventional commit types such as `feat`, `fix`, `docs`,
  `refactor`, `chore`, `test`, `build`, and `ci`.
- Include a scope only when it adds clear value.
- Leave exactly one blank line between subject and body when a body is present.
- Wrap every body line to 72 characters or fewer.
- Prefer balanced wrapping that uses the available width naturally.
- Keep non-final body lines close to the 72 character limit when phrasing allows.
- Avoid very short trailing lines when a cleaner reflow is possible.
- Keep body lines plain text with no bullet nesting unless the user asks for a
  list.
- Explain what changed and why, not implementation trivia, unless the user asks
  for technical detail.

## Missing Context

If the user gives only a vague change summary, infer a sensible conventional
type and scope from the request and still produce the final commit message.

If multiple reasonable commit messages exist, provide the best default first.
Only provide alternatives when the user asks for options.

## Examples

```text
fix(chezmoi): symlink macOS app support configs

Manage Ghostty and Lazygit config paths through chezmoi symlinks
so macOS uses the same canonical ~/.config files.
```

```text
docs(readme): clarify chezmoi macOS config paths

Document the macOS App Support symlink setup so config changes
stay centralized under ~/.config.
```

```text
feat(chezmoi): add shared codex commit skill

Add a reusable conventional commit skill under ~/.agents/skills
and expose it through ~/.codex/skills for use by Codex agents.
```
