# Xcode Project Setup

This is the Stage 5 setup guide for the MacBook.

## Current Status

Windows preparation is complete enough to create the Xcode project, but the actual project cannot be created or verified on this Windows machine.

Required Mac-only tools:

- Xcode.
- iOS Simulator.
- `xcodebuild`.

## Create Project

In Xcode:

1. Open Xcode.
2. Choose `Create New Project`.
3. Select `iOS`.
4. Select `App`.
5. Product name:

```text
TradeBillCanada
```

6. Interface:

```text
SwiftUI
```

7. Language:

```text
Swift
```

8. Storage:

```text
SwiftData
```

9. Include tests:

```text
Yes
```

10. Organization identifier:

```text
com.yourname
```

11. Bundle identifier:

```text
com.yourname.tradebillcanada
```

Replace `yourname` before release.

## Deployment

Recommended starting point:

```text
iOS 17+
Portrait only
iPhone only for MVP
```

Use iOS 18+ only if the current Xcode template or APIs make that the cleaner choice at build time.

## Project Folders

After project creation, add the folders from:

- [Swift folder structure](swift-folder-structure.md)

## Capabilities

Initial capabilities:

- In-App Purchase.

Do not add:

- iCloud.
- Push notifications.
- Sign in with Apple.
- Background modes.

## First Build Check

Before adding feature code:

1. Build the empty app.
2. Run on iPhone simulator.
3. Confirm portrait orientation.
4. Confirm test target runs.
5. Commit the initial Xcode project.

## First App Shell Check

After adding the first app shell:

1. App launches.
2. Onboarding appears on first launch.
3. Get Started opens business setup.
4. Skip or save opens home dashboard.
5. No crash on simulator relaunch.

