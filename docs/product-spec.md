# Product Spec

## Product

TradeBill Canada is a simple, no-subscription iPhone app for Canadian small contractors, handymen, cleaners, landscapers, mobile detailers, tutors, and solo service providers.

The app lets users create professional estimates and invoices quickly, apply Canadian tax presets, generate clean PDFs, and share them with clients from their phone.

## Positioning

TradeBill Canada should feel like a fast field tool, not accounting software. The target user may be standing in a driveway, shop, client's house, or truck and needs to send a professional document immediately.

Core promise:

```text
Create a Canadian estimate or invoice, add HST/GST/PST/QST, export a clean PDF, and send it to the client in seconds.
```

## App Store Metadata

```text
Name: TradeBill Canada
Subtitle: Invoices & Estimates
Primary category: Business
Secondary category: Productivity
```

## Target Platform

- iPhone first.
- iOS only.
- Portrait orientation for MVP.
- iOS 17+ or iOS 18+, depending on the active Xcode template when development begins.
- No Android, web app, iPad, Mac app, login, team accounts, cloud sync, or backend in v1.

## Technical Direction

Recommended stack:

- Swift
- SwiftUI
- SwiftData, or local SQLite if SwiftData constraints become a blocker
- PDFKit or custom Swift PDF rendering
- StoreKit 2 for lifetime unlock
- AppStorage/UserDefaults for lightweight settings
- FileExporter/ShareLink for PDF export and sharing
- XCTest for unit tests

## Monetization

Freemium model:

- Free download.
- 3 total documents included for free.
- One-time lifetime unlock after the free limit.
- Suggested price: CAD $19.99.
- Suggested product ID:

```text
com.tradebillcanada.lifetimeunlock
```

The app must not use a subscription for v1.

## Local-Only Principle

Version 1 must not require an account or remote storage. All business profiles, clients, documents, line items, purchase state cache, logo references, and signature references are stored locally on device.

Purchase entitlement should still be re-checked with StoreKit on app launch when possible.

## Launch Success Criteria

The app is ready for TestFlight/App Store review when:

- A user can create a complete invoice in under 60 seconds.
- PDF output looks professional and printable.
- Tax math matches the configured preset.
- App works offline.
- No login is required.
- Free limit and lifetime unlock work.
- Restore purchase works.
- Privacy policy exists.
- Common flows do not crash.
- Screenshots clearly explain the value.

