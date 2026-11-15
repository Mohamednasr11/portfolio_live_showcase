# Portfolio Showcase Templates

Use these to keep every project presentation consistent and recruiter-ready. Only include links, screenshots, and claims that exist and were verified. Leave a field as "—" rather than inventing it.

## Per-project record

```markdown
## <Project Name>
<One-sentence pitch: what it does and for whom.>

- **Status:** <Complete / Beta / In progress>
- **Tech & architecture:** <Flutter version, state management, router, backend, patterns>
- **Main features:**
  - <feature>
  - <feature>
- **Screenshots:** <paths or links; e.g. docs/screenshots/home.png>
- **Demo / live URL:** <verified URL or "—">
- **GitHub:** <repo URL>
- **APK download:** <link or "—">
- **Remaining tasks:** <short list>
- **Highlights for interviews:** <1–3 technical decisions worth discussing: e.g., offline caching strategy, clean-architecture layering, performance fix>
```

## Portfolio index

A single overview (e.g., `PORTFOLIO.md` in the user's portfolio repo or workspace root):

| Project | Stack | Status | Demo | APK | Repo |
|---|---|---|---|---|---|
| ... | ... | ... | ... | ... | ... |

## README guidance per project
A good project README has: title and pitch, screenshot/GIF row, feature list, tech stack, architecture summary, setup instructions (prerequisites, `flutter pub get`, config/secrets setup, run command), build instructions (APK), testing instructions, and links to the demo and APK.

## Capturing demos
- Screenshots: use an emulator/device with `flutter screenshot` or the integration-test screenshot facility; capture main flows, light and dark mode if supported.
- Recordings: emulator screen recording or `adb shell screenrecord`; keep them short and focused on one flow.
- APK: `flutter build apk --release`. Never ship a release build signed with a keystore the user hasn't authorized you to use.
