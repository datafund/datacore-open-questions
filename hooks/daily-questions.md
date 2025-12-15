# Daily Questions Hook

Integration with `/gtd-daily-start` and `/gtd-daily-end` commands.

## Daily Start Integration

When `/gtd-daily-start` runs, include this section in the briefing:

### Behavior

1. **Find user's open questions**
   - Read `identity.name` from settings
   - Scan `[space]/org/questions.org` for all team spaces
   - Filter questions where user is in `:@username:` tags or `:STAKEHOLDERS:`

2. **Group by priority and due date**
   - Overdue (DUE date passed)
   - Due today
   - High priority
   - Others

3. **Generate briefing section**

### Output Format (for daily start)

```markdown
## Open Questions Requiring Your Input

### Overdue
- **[Q] Budget approval for Q1?** (verity) - Due: Dec 10 ⚠️
  Stakeholders: @gregor, @crt

### Due Today
- **[Q] API rate limiting approach?** (verity) - Due: Dec 15
  Stakeholders: @gregor, @tadej

### High Priority
- **[Q] MVP feature set for Verity PoC?** (verity)
  Stakeholders: @gregor, @crt, @tadej

---
*3 questions awaiting your input. Run `/my-questions` for details.*
```

### If No Questions

```markdown
## Open Questions

No open questions requiring your input.
```

---

## Daily End Integration

When `/gtd-daily-end` runs, include this section:

### Behavior

1. **Find questions created today**
   - Check `:CREATED:` property for today's date
   - Show who created them and for which project

2. **Find questions resolved today**
   - Check `:RESOLVED_DATE:` property for today's date

3. **Prompt for new questions**
   - Ask if any questions arose during the day

### Output Format (for daily end)

```markdown
## Questions Activity Today

### New Questions (2)
- **[Q] Database migration strategy?** (verity) by @crt
  Stakeholders: @gregor, @tadej
- **[Q] Demo timeline for investor?** (verity) by @gregor
  Stakeholders: @crt

### Resolved Today (1)
- **[Q] ERC-3643 vs simpler standard?** → Use ERC-3643 for compliance

---
*Any questions that came up today to capture?*
```

### Prompt for Capture

If user responds with a question:
- Run `/add-question` flow interactively
- Ensure project binding

---

## Integration Points

### For /gtd-daily-start

Add to briefing after calendar/tasks section:

```python
# Pseudo-code for integration
def daily_start_hook():
    questions = get_open_questions_for_user(identity.name)
    if questions:
        render_questions_briefing(questions)
```

### For /gtd-daily-end

Add to wrap-up after completed tasks section:

```python
# Pseudo-code for integration
def daily_end_hook():
    new_today = get_questions_created_today()
    resolved_today = get_questions_resolved_today()
    render_questions_summary(new_today, resolved_today)
    prompt_for_new_questions()
```

## Settings

Can be disabled in settings:

```yaml
questions:
  show_in_daily_start: true   # Default: true
  show_in_daily_end: true     # Default: true
```
