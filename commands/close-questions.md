# /close-questions

Mark questions as resolved and document answers.

## Usage

```
/close-questions [question-id]
/close-questions q-20251215-001
/close-questions q-20251215-001 --answer "Decided to use PostgreSQL"
/close-questions --meeting 123
```

## Arguments

- `[question-id]` - Question ID to close (interactive if not provided)
- `--answer` - Brief answer/decision summary
- `--meeting` - GitHub issue number of meeting where decided
- `--defer` - Mark as DEFERRED instead of RESOLVED
- `--defer-until` - Date to revisit deferred question

## Behavior

### 1. Find question

**If ID provided**: Look up directly

**If not provided, show open questions**:
```
Which question to close?

VERITY:
1) [q-20251215-001] Should we implement rate limiting?
2) [q-20251215-002] PostgreSQL or SQLite?

DATACORE:
3) [q-20251214-001] Module registry format?

Select [1-3]:
```

### 2. Get resolution details

**If `--answer` not provided, ask**:
```
What was decided?
> Use PostgreSQL for MVP, revisit for scale

Any follow-up actions? (or Enter to skip)
> Create database schema task
```

### 3. Update org entry

Change state from `OPEN` to `RESOLVED`:

```org
* RESOLVED [Q] PostgreSQL or SQLite? :question:verity:@gregor:@tadej:
:PROPERTIES:
:ID: q-20251215-002
:PROJECT: verity
:STAKEHOLDERS: gregor, tadej
:PRIORITY: high
:CREATED: [2025-12-15 Mon]
:RESOLVED_DATE: [2025-12-16 Tue]
:ANSWER: Use PostgreSQL for MVP, revisit for scale
:DECIDED_IN: meeting-2025-12-16 or github#123
:END:
```

### 4. Update GitHub issue (if linked)

```bash
gh issue close 124 --comment "Resolved: Use PostgreSQL for MVP"
```

### 5. Create follow-up tasks (if specified)

Add to `org/inbox.org`:
```org
* TODO Create database schema for Verity :verity:
:PROPERTIES:
:ORIGIN: q-20251215-002
:END:
Follow-up from question resolution.
```

### 6. Confirm

```
Question resolved.

  ID: q-20251215-002
  Answer: Use PostgreSQL for MVP, revisit for scale
  GitHub #124: Closed
  Follow-up task: Created in inbox

1 question resolved. 4 questions remaining for verity.
```

## Batch Mode

After a meeting, close multiple:

```
/close-questions --meeting 123
```

This:
1. Fetches meeting agenda from GitHub issue #123
2. Lists questions discussed
3. Walks through each, asking for resolution

## Defer Mode

For questions not ready to decide:

```
/close-questions q-20251215-001 --defer --defer-until 2026-01-15
```

```org
* DEFERRED [Q] Rate limiting approach? :question:verity:
:PROPERTIES:
:DEFER_UNTIL: [2026-01-15 Wed]
:DEFER_REASON: Need load testing data first
:END:
```

## Archive Option

Optionally move resolved questions to archive:

```
/close-questions q-20251215-001 --archive
```

Moves entry to `questions.org_archive`.
