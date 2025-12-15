# /my-questions

Show open questions where you are a stakeholder.

## Usage

```
/my-questions
/my-questions [project]
/my-questions --all
```

## Arguments

- `[project]` - Filter by project (optional)
- `--all` - Show questions from all spaces

## Behavior

1. **Get current user identity**
   - Read `identity.name` from settings
   - If not set, prompt to configure

2. **Find questions files**
   - Scan `[space]/org/questions.org` for all relevant spaces
   - If `[project]` specified, filter by `:project:` tag

3. **Filter by stakeholder**
   - Match questions with `:@{username}:` tag
   - Include questions with no stakeholders (everyone's concern)

4. **Group and display**
   ```markdown
   # Your Open Questions

   ## High Priority

   ### VERITY - API Architecture
   **Question**: Should we implement rate limiting?
   **Context**: API scaling discussion
   **Other stakeholders**: @gregor
   **Created**: 2025-12-15

   ## Medium Priority
   ...

   ---
   Found 5 questions requiring your input across 2 projects.
   ```

5. **If no questions found**
   ```
   No open questions requiring your input.
   ```

## Interactive Mode

If project not specified and multiple projects have questions:

```
You have open questions in multiple projects:
1) verity (3 questions)
2) datacore (1 question)
3) Show all

Which project?
```

## Output Format

Questions displayed with:
- Project name and topic
- The question itself
- Context/background
- Other stakeholders
- Creation date
- Priority indicator
- GitHub issue link (if synced)

## Preparation Suggestions

For each question, suggest preparation:
```markdown
**Suggested prep**:
- Review docs/architecture/api-scaling.md
- Check competitor approaches
```

## Example

```bash
# All my questions
/my-questions

# Just verity project
/my-questions verity

# All spaces (personal + team)
/my-questions --all
```
