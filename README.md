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

New qadaa entries are stored locally with a prayer type and UTC timestamp. Existing installations that only stored a completed count are migrated into a legacy progress baseline so that their count is not discarded. The estimate still uses a configurable `years × 365 × 5` approximation and must not be presented as a religious ruling.

## Monetization

Planned formats are an adaptive banner first, then an optional clearly labelled native placement and/or a non-essential rewarded placement only after core functionality and privacy checks pass. A paid ad-free option can be evaluated later. Ads must never block prayer logging or be shown on the first-run language selection screen. See the roadmap for the supplied AdMob IDs and acceptance gates.
