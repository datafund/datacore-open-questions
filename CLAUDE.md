# Open Questions Module

Track and manage open questions across projects. Implements DIP-0006.

## Overview

This module provides systematic question management:
- Capture questions with project binding
- Track stakeholders who need to provide input
- Generate meeting agendas from open questions
- Sync to GitHub Issues for team visibility

## Question Notation

### Org-mode Format

Questions are stored in `[space]/org/questions.org`:

```org
* OPEN [Q] Should we implement rate limiting? :question:verity:@gregor:@crt:
:PROPERTIES:
:ID: q-20251215-001
:PROJECT: verity
:STAKEHOLDERS: gregor, crt
:PRIORITY: high
:CREATED: [2025-12-15 Mon]
:CONTEXT: API scaling discussion
:END:
Current API has no throttling. Enterprise customers asking about scalability.

** Notes
- Gregor: Need to check competitor approaches
- Crt: Review current load patterns first
```

### Tag Conventions

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

### Properties

| Property | Required | Description |
|----------|----------|-------------|
| `ID` | Yes | Unique identifier `q-YYYYMMDD-NNN` |
| `PROJECT` | Yes | Project this question belongs to |
| `STAKEHOLDERS` | No | Comma-separated usernames |
| `PRIORITY` | No | high, medium, low |
| `CREATED` | Yes | Creation timestamp |
| `CONTEXT` | No | Brief context/background |
| `RESOLVED_DATE` | No | When resolved (for RESOLVED state) |
| `ANSWER` | No | Brief answer summary (for RESOLVED state) |
| `GITHUB_ISSUE` | No | Linked GitHub issue number |

## Document Detection

The module also scans for questions in documents:

**Section headers** (case-insensitive):
- `## Open Questions`
- `## Unresolved`
- `## TBD`
- `## Questions`

**Code comments**:
- `// QUESTION:` or `# QUESTION:`
- `// TODO:` or `# TODO:` (when phrased as question)

**Checkbox items** under question sections:
```markdown
## Open Questions
- [ ] Should we use PostgreSQL or SQLite?
- [ ] What's the deployment timeline?
```

## GitHub Integration

Questions sync to GitHub Issues with:
- **Label**: `question` (configurable)
- **Title prefix**: `[Q]`
- **Body**: Full context from org entry
- **Assignees**: Stakeholders

Example:
```bash
gh issue create --label "question" --title "[Q] Rate limiting approach?" \
  --assignee gregor,crt --body "Context: API scaling..."
```

## Project Binding

**IMPORTANT**: Every question must be bound to a project.

When project is not specified or cannot be detected:
1. Check current directory for project context
2. Check `questions.default_project` in settings
3. **Ask user interactively**:
   ```
   Which project does this question belong to?
   1) verity
   2) datacore
   3) datafund (general)
   4) Other (specify)
   ```

Never create a question without project binding.

## Commands

| Command | Purpose |
|---------|---------|
| `/my-questions` | Show questions where you're a stakeholder |
| `/add-question` | Capture new question (interactive if no project) |
| `/meeting-agenda` | Generate agenda from open questions |
| `/close-questions` | Mark questions resolved, document answers |

## File Locations

```
[space]/org/questions.org     # Question tracking
[space]/org/questions.org_archive  # Resolved questions (optional)
```

## Settings

Configure in `.datacore/settings.local.yaml`:

```yaml
questions:
  default_project: verity        # Default when not specified
  github_sync: true              # Sync to GitHub Issues
  github_label: question         # Issue label
```
