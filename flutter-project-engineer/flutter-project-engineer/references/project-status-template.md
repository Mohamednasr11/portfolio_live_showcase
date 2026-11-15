# PROJECT_STATUS.md Template

Create one `PROJECT_STATUS.md` at the root of each Flutter project and keep it current after every session. Use this structure. Write "not run" or "not verified" where something wasn't actually checked.

```markdown
# <Project Name> — Project Status

_Last updated: <YYYY-MM-DD>_

## Overview
<One or two sentences: what the app does, who it is for.>
- **Stack:** <Flutter/Dart versions, state management, router, backend, key packages>
- **Architecture:** <e.g., feature-first + Cubit + Dio repository layer>

## Current Implementation Status
<Overall status: e.g., "Beta: core flows work, payments missing". Give a rough completion estimate only if it is grounded in the feature list below.>

## Completed Features
- [x] <feature> — <short note>

## Missing Features
- [ ] <feature> — <why it matters / what blocks it>

## Bugs and Technical Debt
- <issue> — <severity, location>

## Latest Changes
### <YYYY-MM-DD>
- <what changed and why>

## Testing Results
| Check | Result | Notes |
|---|---|---|
| flutter pub get | passed / failed / not run | |
| dart format | passed / failed / not run | |
| flutter analyze | passed / failed / not run | <issue count> |
| flutter test | passed / failed / not run | <X passed, Y failed> |
| Android build | passed / failed / not run | <debug or release> |
| Manual flow testing | done / not run | <device, flows covered> |

## Live Demo Status
- **Live URL:** <url or "none">
- **Verified reachable:** <yes, date / no / not verified>
- **APK:** <link or "not built">
- **Deployment notes:** <how to deploy; credentials needed>

## Next Development Priorities
1. <highest-impact next task>
2. ...

## Blockers
- <missing credential / permission / decision, or "none">
```
