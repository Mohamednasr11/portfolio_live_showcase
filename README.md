# Mohamed Nasr Eldeen — Flutter Developer Portfolio

An interactive Flutter Web showcase built to present mobile product work during technical interviews. It brings four app experiences into one guided player. The screens are rendered with Flutter widgets and animations (not a slideshow of screenshots), including Arabic right-to-left interfaces and interactive states.

**Live portfolio:** https://portfolioliveshowcase.vercel.app/  
**Source:** https://github.com/Mohamednasr11/portfolio_live_showcase

## Featured projects

| Project | Beats | Showcase focus |
| --- | ---: | --- |
| Matjarkom | 9 | Arabic RTL e-commerce, OTP journey, cart and checkout, AI-assistant interaction |
| Build-Guard | 7 | Construction safety experience, scan flow, defect analysis, risk verdict and repair guidance |
| Brew & Bloom | 6 | Coffee ordering, product customisation, order summary, delivery tracking and rewards |
| TrustSafe | 6 | Enterprise document vault, access permissions, biometric unlock and security settings |

The tour contains **28 guided beats** in total. Each beat demonstrates a UI state and includes technical notes for explaining implementation decisions in an interview.

> **Scope note:** This repository is the interactive portfolio/showcase layer. A demonstrated screen or simulated flow should not be interpreted as proof that the corresponding production backend, payment provider, AI service, or external integration is connected in this showcase. Project notes should distinguish implemented product work from showcase-only interactions.

## Run locally

Requirements: Flutter SDK compatible with the Dart constraint in `pubspec.yaml`.

```bash
flutter pub get
flutter run -d chrome
```

Build a production web bundle:

```bash
flutter build web --release --output build/web-release
```

Run static analysis and tests:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --reporter expanded
```

## Presentation controls

| Key | Action |
| --- | --- |
| `→` / `D` | Next beat |
| `←` / `A` | Previous beat |
| `Shift` + `→` / `←` | Next / previous project |
| `Space` | Play / pause auto-advance |
| `S` | Cycle playback speed |
| `N` | Toggle speaker notes |
| `M` | Toggle captions |
| `R` | Restart current project |
| `1`–`4` | Jump to a project |

## Project structure

```
lib/
  showcase/   presentation shell, controller, tour model, theme and device frame
  demos/      self-contained Flutter widget trees for each showcased app
assets/
  fonts/      Syne, DM Sans and Noto Sans Arabic
  matjarkom/  product artwork
  buildguard/ construction/scan artwork
  brewbloom/  coffee and product artwork
test/         widget, tour engine, shell and render-gate tests
tool/         font preparation and verification utilities
web/          Flutter web entry point and PWA metadata
.github/      continuous integration workflow
```

`lib/showcase/demos.dart` is the source of truth for the project list, beat sequence, captions, speaker notes and technology labels. Add a new tour step there and implement its widget in the matching demo file.

## Quality checks

GitHub Actions runs the following on pushes and pull requests:

1. Install Flutter dependencies.
2. Check Dart formatting.
3. Run `flutter analyze`.
4. Run the widget and unit test suite.
5. Build the Flutter Web release bundle and upload it as a workflow artifact.

The CI result is the source of truth for whether a given commit passes these checks; a successful local edit or commit alone does not imply that the workflow has passed.

## Fonts

CanvasKit resolves a `TextStyle.family` against the font's internal name table. The bundled font preparation scripts normalize font family names and verify the bundled faces:

```bash
python tool/prepare_fonts.py
python tool/check_fonts.py
```

## Deployment

The project is configured as a Flutter Web application. The live URL above is the existing showcase address. Production deployment depends on the connected hosting provider's build configuration and permissions; GitHub commits alone do not prove that the hosted site has been redeployed.

Suggested Vercel build configuration:

- **Install command:** `flutter pub get` (after installing/configuring the Flutter SDK in the build environment)
- **Build command:** `flutter build web --release`
- **Output directory:** `build/web`

Use a Flutter-capable Vercel build environment or deploy the generated `build/web` directory from a CI workflow. Do not configure Vercel to serve the repository root as a static site.
