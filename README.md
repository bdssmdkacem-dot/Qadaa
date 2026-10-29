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