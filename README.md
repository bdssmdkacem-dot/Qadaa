# قضاء — Qadaa

Android-only Flutter app to help users estimate and track missed obligatory prayers with a calm Arabic-first experience.

## Initial scope
- Arabic RTL home screen matching the approved visual reference
- Missed-prayer estimate and editable daily qadaa plan
- Local persistence; no account required
- Progress statistics and encouraging reminders
- Android launcher icon aligned with the Qadaa brand

## Build
Requires Flutter 3.29+ and Java 17.

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

Religious calculations are estimates and must remain configurable; the app should not present a single jurisprudential opinion as universal.

## Commercial roadmap

The committed implementation plan and release gates live in [docs/COMMERCIAL_ROADMAP.md](docs/COMMERCIAL_ROADMAP.md). Work is intentionally sequenced: first reliable prayer records and home-screen behavior, then planning/statistics, then ads and release compliance.

## Prayer records

New qadaa entries are stored locally with a prayer type and UTC timestamp. Existing installations that only stored a completed count are migrated into a legacy progress baseline so that their count is not discarded. Settings provide a versioned JSON backup that includes the estimate, daily target, legacy baseline, and prayer history; restore validates the entire payload and requires confirmation before replacing local data. The estimate still uses a configurable `years × 365 × 5` approximation and must not be presented as a religious ruling.

## Monetization

Planned formats are an adaptive banner first, then an optional clearly labelled native placement and/or a non-essential rewarded placement only after core functionality and privacy checks pass. A paid ad-free option can be evaluated later. Ads must never block prayer logging or be shown on the first-run language selection screen. See the roadmap for the supplied AdMob IDs and acceptance gates.

## Visual assets specification

The UI is being prepared against the approved Arabic home-screen reference. Do not add placeholder artwork or stretch one image into multiple roles. Add the final assets only after they are supplied at the following dimensions.

| Asset path | Required dimensions | Format | Intended use |
|---|---:|---|---|
| `assets/images/brand/qadaa_app_icon.png` | 1024 × 1024 px | PNG, opaque square master | Source for Android launcher icon generation; keep the emblem centered with safe margins |
| `assets/images/home/qadaa_home_hero.webp` | 1600 × 900 px | WebP, high quality | Wide home header scene; keep mosque, sun and focal details inside the central 80% safe area |
| `assets/images/home/qadaa_header_logo.png` | 900 × 900 px | PNG, transparent background | Standalone Qadaa wordmark/emblem overlay if the hero does not contain the final logo |
| `assets/images/ornaments/islamic_pattern.png` | 1024 × 1024 px | PNG, transparent background | Subtle decorative pattern in header/card edges; must remain low contrast |
| `assets/images/illustrations/empty_prayer_history.webp` | 1200 × 900 px | WebP, transparent/clean background | Empty-state illustration for a new user with no recorded prayers |
| `assets/images/illustrations/encouragement.webp` | 1200 × 900 px | WebP, transparent/clean background | Encouragement screen illustration |

### Image integration rules

- Keep the original source files at the paths above; do not commit screenshots of the full app as production UI assets.
- Preserve aspect ratio with `BoxFit.cover` for the hero and `BoxFit.contain` for standalone illustrations and logos.
- Provide meaningful semantic descriptions for informative images; decorative patterns must be excluded from accessibility semantics.
- Supply a 2×/3× raster variant only when needed for a specific density; do not upscale a small source.
- The home hero must remain readable with RTL and LTR layouts, and must not place important details underneath the status bar, action buttons, or text.
- Until the final assets are supplied, retain the vector-painted fallback and do not add generated or stock images.
- After integration, validate image cropping on 320 px, 360 px, and 412 px logical widths, plus large text scaling.

## Visual and physical-device acceptance

Automated widget coverage includes narrow layouts and enlarged text, but it is not a substitute for a real Android device review. Before merging the release candidate, capture and inspect these screens on the target phone:

- First launch and language selection.
- Home at the top and after scrolling, including zero-data and populated states.
- Daily plan, statistics, encouragement, and settings.
- Prayer logging sheet with all five prayer choices and the keyboard visible where applicable.
- Smallest supported display setting and Android's largest practical font setting.
- RTL Arabic and at least one LTR language.

Check that all five navigation destinations remain visible and tappable, no text or numbers clip, buttons have comfortable touch areas, content respects status/navigation bars, and bottom sheets remain scrollable above the keyboard. Compare the home composition, hierarchy, spacing, and contrast against the approved reference image; record any deviations before release. Do not mark commercial readiness or merge solely because CI is green.

