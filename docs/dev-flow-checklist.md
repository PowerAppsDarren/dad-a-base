# Dev Flow Checklist

Use `/_init_dev_flow` to automate this checklist. Use `/_init_dev_flow check` to audit.

## Repo Bootstrap

- [x] Git repository initialized
- [x] .gitignore created (if missing)
- [x] .ai-chats/ initialized with README.md + INDEX.md
- [ ] Project history copied from ~/.claude/projects/
- [ ] CLAUDE.md created
- [ ] TaskMaster initialized
- [ ] Git remotes configured

## Documentation Scaffold

- [x] README.md created or reviewed
- [x] docs/ directory exists
- [ ] docs/PRD.md — product requirements (refs INTENT.md)
- [ ] docs/INTENT.md — project purpose and boundaries
- [ ] docs/ui.md — UI documentation
- [x] docs/tech-stack.md — technology choices
- [ ] docs/change-log.md — version history
- [ ] docs/non-tech-updates/ — stakeholder update directory

## Optional: Docker Setup

- [x] Docker deployment templates (project already uses Docker Compose)

## Development Loop

- [ ] Plan mode -> identify parallel tasks
- [ ] Determine needs: research, team agents, subagents
- [ ] Execute planned work
- [ ] Monitor context window (wrap up at 50%)
- [ ] Session wrap-up:
  - [ ] .ai-chats/ session documented
  - [ ] docs/change-log.md updated
  - [ ] TaskMaster updated
  - [ ] docs/handoff.md created/updated
  - [ ] Non-tech HTML update generated
  - [ ] Final commit + push to all remotes
