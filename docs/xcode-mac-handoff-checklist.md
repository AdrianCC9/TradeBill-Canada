# Xcode Mac Handoff Checklist

Use this checklist when the MacBook is available.

## Before Opening Xcode

- Clone the GitHub repo.
- Confirm all docs are present.
- Confirm current branch is clean or intentionally dirty.
- Install latest stable Xcode from Apple.
- Open Xcode once to install required components.

## Create Initial Project

- Create SwiftUI iOS app.
- Enable SwiftData.
- Include unit tests.
- Set bundle ID.
- Set iPhone-only deployment.
- Set portrait orientation only.
- Add In-App Purchase capability.
- Add app folders from the architecture plan.

## Add Existing Planning Assets

- Keep docs in repo.
- Add design assets later when real images exist.
- Do not add placeholder Figma files to the Xcode target.
- Do not add legal docs to the app bundle unless needed for in-app display.

## Add Initial Source Shell

Minimum first shell:

- `TradeBillCanadaApp`.
- `AppRootView`.
- `OnboardingView`.
- `BusinessSetupView`.
- `HomeDashboardView`.
- Basic theme colors.

## Verify

- Build app.
- Run app in simulator.
- Run unit test target.
- Check app starts in portrait.
- Check no default sample Xcode content remains.

## Commit

Suggested commit message:

```text
Create initial SwiftUI iOS project
```

## Stage 5 Completion Criteria

Stage 5 can be marked completed only after:

- `.xcodeproj` exists.
- App target exists.
- Test target exists.
- Bundle ID is configured.
- App launches in iOS simulator.
- Unit test target runs.
- Initial project commit is made.

