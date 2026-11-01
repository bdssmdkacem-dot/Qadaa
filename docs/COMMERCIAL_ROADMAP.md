# Qadaa — Commercial Product Roadmap

## Product principle
Stabilize the core prayer-tracking experience and its data before monetization. Advertising must never block prayer logging, obscure navigation, or imply religious authority. All prayer estimates are personal planning estimates, not a fatwa.

## Phase 1 — Stabilize home and real data (current priority)
- Replace count-only logging with individual, timestamped qadaa prayer records (Fajr, Dhuhr, Asr, Maghrib, Isha).
- Persist records locally, load them on restart, and migrate the existing completed-count value without losing progress.
- Derive completed and remaining totals from the estimate and stored records; clamp totals safely when an estimate is changed.
- Make estimate, plan, statistics, and settings screens genuinely useful; keep all five languages (Arabic, Spanish, English, French, German) and correct RTL/LTR direction.
- Add regression tests for record persistence, legacy migration, calculations, and the five-language onboarding.
- Verify the approved mosque/mountain reference and launcher artwork are present before claiming visual-reference completion.

Acceptance gate: analyze and tests pass; release APK builds; manual install/reopen and UI checks on a physical Android phone are still required before commercial readiness.

## Phase 2 — Complete planning and progress
- Add daily and weekly summaries based on actual records.
- Add an editable per-day target and a practical backlog plan.
- Add optional reminders with clear permission handling and no duplicate notifications.
- Add versioned JSON export/restore for the estimate, daily target, legacy baseline, and timestamped prayer records; validate the complete backup before replacing local data.
- Provide clear local-storage disclosure and explicit confirmation before a restore overwrites existing progress.
- Add optional reminders only after selecting and testing a maintained notification implementation, timezone behavior, Android 13+ notification permission flow, and duplicate-schedule prevention.

## Phase 3 — Google Mobile Ads and revenue
Use the supplied AdMob IDs only after confirming they belong to the Qadaa app and banner unit:
- App ID: `ca-app-pub-1377346158677931~1657702105`
- Banner unit ID: `ca-app-pub-1377346158677931/7219139649`

Monetization rollout:
1. Integrate the official Google Mobile Ads Flutter SDK and configure the Android manifest App ID.
2. Build a reusable `QadaaBanner` widget; start with Google test ad units during development.
3. Add an adaptive banner at the bottom of eligible content, separated from the primary action and bottom navigation. Never put ads on first-run language selection or over prayer controls.
4. After banner stability, consider (a) native ads in clearly separated content lists, (b) an optional rewarded ad only for a non-essential benefit, and (c) a paid ad-free upgrade. Do not add interstitials during prayer logging, on launch, or during routine navigation.
5. Treat any ad format as optional and remote-configurable; failure to load ads must not affect core app use.
6. Implement consent/privacy handling appropriate to served regions and the current Google Play / AdMob policies; provide an accurate privacy policy and required store disclosures. Check `app-ads.txt` requirements where applicable.

Acceptance gate: test ad IDs in development; verify loading, no-fill, offline, disposal, and layout behavior; only then test the production unit and review policy readiness. Never click live ads during testing.

## Phase 4 — Privacy, reliability, and accessibility
- Minimize data collection; explain local storage and any advertising/analytics SDK behavior.
- Check large text, screen readers, contrast, tap targets, Arabic shaping, and small-screen overflow.
- Add crash diagnostics only with an explicit privacy review and necessary disclosure.
- Test clean install, upgrade, data retention, offline use, and low-memory behavior.

## Phase 5 — Release readiness
- Run `flutter analyze`, unit/widget tests, and release APK build in CI.
- Install and test on a real Android phone; capture screenshots for the onboarding, home, plan, stats, settings, and ad states.
- Verify app signing, versioning, privacy policy, Play Console declarations, and store listing.
- Keep work on the feature branch until all gates are evidenced; do not merge to `main` based only on a green CI build.

## Additional revenue options — staged, not all at once
1. Adaptive banner: lowest implementation complexity; monitor retention and user experience.
2. Native ads: only in non-critical feed/content areas and clearly labelled as ads.
3. Rewarded ads: optional and never required to log prayers, access core progress, or protect existing data.
4. Paid ad-free option: a clear one-time purchase or subscription only if ongoing premium value exists; restore purchases and billing compliance must be implemented.
5. Avoid launching banner + native + interstitial + rewarded ads together. Start with one format, measure retention/crashes and policy compliance, then decide using evidence.

## Current status
- The core record store supports typed UTC records, legacy-count migration, malformed-history tolerance, and real daily/weekly statistics.
- A versioned JSON backup format now validates version, planning bounds, record types, and timestamps before restore. Settings expose copy/export and confirmed restore flows in all five languages.
- CI run `41147885888` on commit `6d43b00755a2ff556c4e04a744973159a23bdd70` passed all workflow steps: dependency installation, static analysis, unit/widget tests, Android release APK build, and artifact upload. This validates the current feature-branch source in CI, not physical-device behavior.
- The UI still uses a vector fallback until the user supplies the final visual assets. Physical-device review is deliberately deferred until the pre-device phase is complete. Real notification behavior is not implemented; reminder permission, timezone scheduling, rescheduling, and duplicate prevention remain open. Final reference comparison also remains pending.
- The estimate remains a simplified `years × 365 × 5` planning approximation, not a personalized religious calculation or fatwa.
- Do not claim commercial readiness until device acceptance, backup restore on-device, accessibility review, privacy/store disclosures, and release signing are verified.
