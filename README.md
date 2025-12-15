# Open Questions Module

Track open questions across projects so nothing gets lost between meetings. Implements [DIP-0006](https://github.com/datafund/datacore/blob/main/dips/DIP-0006-open-questions-management.md).

## Purpose

Questions are captured with project binding and stakeholder assignments, then surfaced in daily briefings and meeting agendas. No more "what did we need to decide?" at the start of meetings.

## How It Works

- Questions stored in `org/questions.org` with structured notation
- Each question has project, stakeholders, priority, and optional due date
- Syncs to GitHub Issues with `question` label for team visibility
- Integrates with `/gtd-daily-start` and `/gtd-daily-end` to show what needs your input

## Installation

```bash
cd ~/.datacore/modules
git clone https://github.com/datafund/datacore-open-questions open-questions
```

Then initialize for your space:

```bash
cp open-questions/templates/questions.org ~/Data/1-yourspace/org/questions.org
```

## Commands

| Command | Purpose |
|---------|---------|
| `/add-question "Question?"` | Capture new question (asks for project if not specified) |
| `/my-questions` | Show questions where you're a stakeholder |
| `/my-questions verity` | Filter by project |
| `/meeting-agenda verity` | Generate meeting agenda from open questions |
| `/close-questions` | Mark resolved and document answer |

## Question Notation

```org
* OPEN [Q] Should we use PostgreSQL or SQLite? :question:verity:@gregor:@crt:
:PROPERTIES:
:ID: q-20251215-001
:PROJECT: verity
:STAKEHOLDERS: gregor, crt
:PRIORITY: high
:CREATED: [2025-12-15 Mon]
:DUE: [2025-12-20 Fri]
:CONTEXT: Database selection for PoC
:END:
Additional details here.
```

### Tags

| Tag | Meaning |
|-----|---------|
| `:question:` | Marks as question (required) |
| `:projectname:` | Binds to project (e.g., `:verity:`) |
| `:@username:` | Stakeholder who should provide input |

### States

| State | Meaning |
|-------|---------|
| `OPEN` | Awaiting discussion/decision |
| `RESOLVED` | Decided, answer documented |
| `DEFERRED` | Postponed to later date |

## Daily Integration

**Morning** (`/gtd-daily-start`): Shows overdue, due today, and high priority questions awaiting your input.

**Evening** (`/gtd-daily-end`): Shows questions created/resolved today, prompts for any new questions to capture.

## GitHub Sync

Questions can sync to GitHub Issues:

```yaml
# settings.local.yaml
questions:
  github_sync: true
  github_label: question
```

## Configuration

```yaml
# .datacore/settings.local.yaml
questions:
  default_project: verity          # Default when not specified
  github_sync: true                # Sync to GitHub Issues
  github_label: question           # Issue label
  show_in_daily_start: true        # Show in morning briefing
  show_in_daily_end: true          # Show in evening wrap-up
```

## License

MIT
