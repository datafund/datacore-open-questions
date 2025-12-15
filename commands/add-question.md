# /add-question

Capture a new open question.

## Usage

```
/add-question "Your question here"
/add-question "Question" --project verity
/add-question "Question" --project verity --stakeholders gregor,crt --priority high
```

## Arguments

- `"question"` - The question text (required)
- `--project` - Project to bind question to (required, interactive if not provided)
- `--stakeholders` - Comma-separated usernames (optional)
- `--priority` - high, medium, low (default: medium)
- `--context` - Brief context/background (optional)
- `--due` - Deadline if time-sensitive (optional, format: YYYY-MM-DD)
- `--github` - Also create GitHub issue (default: true if github_sync enabled)

## Behavior

### 1. Validate question text
- Must end with `?` or be phrased as question
- If not, confirm: "This doesn't look like a question. Continue anyway?"

### 2. Determine project (CRITICAL)

**If `--project` provided**: Use it

**If not provided, try to detect**:
1. Check current working directory for project context
2. Check `questions.default_project` in settings
3. **If still unknown, ASK INTERACTIVELY**:

```
Which project does this question belong to?

1) verity
2) datacore
3) swarm-connect
4) Other (specify)

Select [1-4]:
```

**NEVER create a question without project binding.**

### 3. Determine space
- Infer from project (e.g., `verity` → `1-datafund`)
- Or ask if ambiguous

### 4. Generate question ID
```
q-YYYYMMDD-NNN
```
Where NNN is sequential for that day.

### 5. Get current user as creator
- Read `identity.name` from settings

### 6. Create org entry

Append to `[space]/org/questions.org`:

```org
* OPEN [Q] Your question here? :question:projectname:@stakeholder1:@stakeholder2:
:PROPERTIES:
:ID: q-20251215-001
:PROJECT: projectname
:STAKEHOLDERS: stakeholder1, stakeholder2
:PRIORITY: medium
:CREATED: [2025-12-15 Mon]
:CREATOR: username
:CONTEXT: Optional context
:DUE: [2025-12-20 Fri]
:END:
Additional details if provided.
```

### 7. Optionally create GitHub issue

If `github_sync: true` in settings:

```bash
gh issue create \
  --repo datafund/projectname \
  --label "question" \
  --title "[Q] Your question here?" \
  --assignee stakeholder1,stakeholder2 \
  --body "Context: ..."
```

Update org entry with `:GITHUB_ISSUE: 123`

### 8. Confirm

```
Question added to verity project.

  ID: q-20251215-001
  Stakeholders: @gregor, @crt
  Priority: medium
  GitHub: datafund/verity#123

Use /my-questions to see all your questions.
```

## Interactive Example

```
User: /add-question "Should we use PostgreSQL or SQLite?"

Claude: Which project does this question belong to?

1) verity
2) datacore
3) swarm-connect
4) Other (specify)

User: 1

Claude: Who should provide input on this? (comma-separated usernames, or Enter to skip)

User: gregor, tadej

Claude: Priority? [high/medium/low, default: medium]

User: high

Claude: Question added to verity project.

  ID: q-20251215-002
  Stakeholders: @gregor, @tadej
  Priority: high
  GitHub: datafund/verity#124
```

## Quick Mode

With all args provided, no interaction needed:

```
/add-question "Rate limiting approach?" --project verity --stakeholders gregor --priority high
```

## Error Handling

- **No project and can't detect**: Ask interactively (never fail silently)
- **Invalid project**: "Project 'x' not found. Available: verity, datacore, ..."
- **No identity configured**: "Please set identity.name in settings"
- **GitHub sync fails**: Log warning, continue with local-only
