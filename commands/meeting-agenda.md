# /meeting-agenda

Generate a meeting agenda from open questions.

## Usage

```
/meeting-agenda [project]
/meeting-agenda verity --attendees gregor,crt,tadej
/meeting-agenda --all
```

## Arguments

- `[project]` - Project to generate agenda for (required, interactive if not provided)
- `--attendees` - Comma-separated attendees (filters to relevant questions)
- `--all` - Include questions from all projects
- `--output` - Output format: `markdown`, `github`, `org` (default: markdown)

## Behavior

### 1. Determine project

**If not provided, ASK**:
```
Generate meeting agenda for which project?

1) verity (5 open questions)
2) datacore (2 open questions)
3) All projects

Select [1-3]:
```

### 2. Collect questions

- Read from `[space]/org/questions.org`
- Filter by project tag
- Filter by attendees (if specified) - include questions where attendee is stakeholder
- Sort by priority (high → medium → low)

### 3. Check preparation status

For each stakeholder, check if they've added notes to the question.

### 4. Generate agenda

```markdown
# Meeting Agenda: Verity
**Date**: 2025-12-15
**Attendees**: @gregor, @crt, @tadej

## Preparation Status
| Person | Prepared | Questions |
|--------|----------|-----------|
| @gregor | Yes (2/3) | API, Database |
| @crt | No | - |
| @tadej | Yes (1/3) | Timeline |

---

## High Priority

### 1. [Q] Should we implement rate limiting?
**ID**: q-20251215-001
**Stakeholders**: @gregor, @crt
**Context**: API scaling discussion, enterprise customers asking

**Pre-meeting input**:
- @gregor: Checked competitors, most use token bucket algorithm

**Decision needed**: Yes/No on rate limiting, approach if yes

---

### 2. [Q] PostgreSQL or SQLite for MVP?
**ID**: q-20251215-002
**Stakeholders**: @gregor, @tadej
**Context**: Database selection for PoC phase

**Pre-meeting input**: None yet

**Decision needed**: Database choice

---

## Medium Priority

### 3. [Q] Deployment timeline for demo?
...

---

## Summary
- 3 questions requiring decisions
- 2 attendees prepared, 1 not yet
- Estimated discussion time: 30-45 min
```

### 5. Optionally create GitHub issue

With `--output github`:
```bash
gh issue create \
  --repo datafund/verity \
  --label "meeting-agenda" \
  --title "Meeting Agenda: Verity (2025-12-15)" \
  --body "$(agenda_markdown)"
```

### 6. Output location

- Default: Display in terminal
- `--output github`: Create GitHub issue
- `--output org`: Append to `[space]/org/meetings.org`

## Interactive Example

```
User: /meeting-agenda

Claude: Generate meeting agenda for which project?

1) verity (5 open questions)
2) datacore (2 open questions)
3) All projects

User: 1

Claude: Who will attend? (comma-separated, or Enter for all stakeholders)

User: gregor, crt

Claude: [Generates agenda markdown]
```

## No Questions Case

```
No open questions for verity project.

Consider:
- /add-question to capture new questions
- Check if questions were already resolved
```
