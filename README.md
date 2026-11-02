# Live UX Showcase

A presentation player for four mobile apps I built, running as one Flutter
application. Every screen is real Flutter widgets — layouts, animations, text
input, RTL Arabic — not screenshots or a video. It is the thing I open during a
Flutter interview and drive with the keyboard.

## Run it

```
flutter pub get
flutter run -d chrome
```

Flutter 3.47.2 / Dart 3.13.2.

For a static build:

```
flutter build web --release --output build/web-release
```

## Controls

| Key | Action |
| --- | --- |
| `→` / `D` | next beat |
| `←` / `A` | previous beat |
| `Shift` + `→` / `←` | next / previous project |
| `Space` | play / pause the auto-advance |
| `S` | cycle playback speed |
| `N` | speaker notes |
| `M` | captions |
| `R` | restart the current project |
| `1`–`4` | jump to a project |

## The tour

Four projects, 28 beats total. Each beat is a screen state; the player animates
between them so the flow reads as a session, not a slide deck.

| Project | Beats | What it demonstrates |
| --- | --- | --- |
| Matjarkom | 9 | RTL Arabic e-commerce: OTP entry, cart, checkout, an AI assistant that emits an add-to-cart intent |
| Build-Guard | 7 | Camera viewfinder, crack detection sweep, risk gauge, repair steps |
| Brew & Bloom | 6 | Onboarding, catalogue, product detail, order, live delivery tracking |
| TrustSafe | 6 | Access scan, findings, verdict |

The in-app speaker notes carry the honest split: the screens matching my mockups
are the delivered work, and any screen built afterwards to close the loop says
so on its own beat.

## Layout

```
lib/
  showcase/     player shell, tour engine, theme, device frame, shared kit
  demos/        one file per project, each a self-contained widget tree
assets/
  fonts/        Syne + DM Sans + Noto Sans Arabic, renamed for CanvasKit
  matjarkom/ buildguard/ brewbloom/   artwork cut from the mockups
tool/           font preparation and verification
test/           widget tests: every beat renders, gate self-check
```

`lib/showcase/demos.dart` is the single source of truth for the tour: beat list,
captions, notes, stack chips. Adding a screen means adding a beat there and one
widget in the matching demo file.

## Fonts

CanvasKit resolves a `TextStyle.family` against the font's internal name table
(nameID 1/16), not the family declared in `pubspec.yaml`. The downloaded Syne and
DM Sans files did not match, so nothing rendered in the intended face until the
name tables were rewritten and the missing weights filled in:

```
python tool/prepare_fonts.py
python tool/check_fonts.py
```

## Tests

```
flutter test
```

The suite renders every beat twice: standalone at the 262×518 content box the
phone frame leaves, and again inside the full shell at capture size. It fails on
any uncaught exception — which is how a `RenderFlex` overflow surfaces — and on a
`Text` that has lost its `Material` ancestor, because that one inherits the
engine's underlined fallback style and reads as a rendering bug in every
screenshot. It is what caught the price row that clipped `$19.99` to `$9`. The
`PageController` assertion — `position` read while a beat cross-fade attaches two
scroll views — is the one thing a widget test cannot see, since a controller gets
exactly one position there; that one only shows up in the browser walk.
