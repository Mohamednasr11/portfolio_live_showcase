# Portfolio UI Redesign & Modern Arabic Font Upgrade

This implementation plan covers the complete UI/UX overhaul of the portfolio hero section (fixing profile picture overlap and phone frame placement) and upgrading the Arabic typography to a modern font (`Cairo` / `Tajawal` / `Readex Pro`), adhering to the `flutter-project-engineer` standards.

## User Review Required

> [!IMPORTANT]
> **Arabic Font Upgrade:** We will replace `Noto Sans Arabic` with a modern, stylish Arabic font family (**`Cairo`** or **`Readex Pro`**), downloading all 5 weights (400, 500, 600, 700, 800) and rewriting their CanvasKit font name tables via `tool/prepare_fonts.py`.
> **Hero Section Redesign:** We will fix the awkward right-column double stacking (avatar circle over phone frame). The profile picture will be integrated into a sleek, modern author badge next to the role tag, leaving the right column dedicated to the live interactive phone preview (`LivePhone`).
> **Typography & Sizing:** Adjust title font size and letter-spacing (`Syne`) so "Mohamed Nasr Eldeen" fits without forced line-wraps or ugly overflows.

## Proposed Changes

### [Component Name] Arabic Font Asset Infrastructure
- Update `tool/prepare_fonts.py` to download and configure **`Cairo`** or **`Readex Pro`** (400, 500, 600, 700, 800) and generate fixed `.ttf` files in `assets/fonts/`.
- Update `tool/check_fonts.py` to allow the new Arabic font family in validation gates.
- Update `pubspec.yaml` font definitions to declare the new Arabic font family.

### [Component Name] Theme & Typography (`lib/showcase/theme.dart`)
- Update `ShowType.arabicFallback` to use the new modern Arabic font family.
- Tweak display title typography and font sizes for optimal header balance.

### [Component Name] Hero Section & Portfolio UI (`lib/portfolio/portfolio_page.dart`)
- Redesign `_Hero` layout:
  - Place profile picture as a sleek author badge in the hero left column alongside the role tag.
  - Keep `LivePhone` standalone in the right column with proper height constraints.
  - Fix title line-breaks and text contrast in dark and light modes.
- Ensure all sections maintain flawless responsiveness across mobile, tablet, and desktop breakpoints.

### [Component Name] Test Suite (`test/portfolio_test.dart`, `test/check_fonts.py`)
- Update font checks and layout tests to pass 100%.

## Verification Plan

### Automated Tests
- Run `python tool/prepare_fonts.py` to generate and verify CanvasKit font name tables.
- Run `python tool/check_fonts.py` to verify font integrity.
- Run `flutter test` to ensure all 87+ widget and layout tests pass cleanly.
- Run `flutter analyze` to verify zero linter or compiler warnings.

### Manual Verification
- Verify the redesigned Hero section layout on web at desktop (1280px+), tablet (820px), and mobile (360px).
- Verify the new Arabic font rendering in Arabic mode.
- Verify Light and Dark mode appearance.
