# Project Stages

TradeBill Canada will move one stage at a time. After each stage, development pauses until the next explicit prompt.

## Stage 1: Repository and Planning Foundation

Status: Completed.

Completed artifacts:

- Repository folder structure.
- [README](../README.md).
- [Product spec](product-spec.md).
- [MVP feature boundary](mvp-features.md).
- [Data model](data-model.md).
- [PDF template spec](pdf-template-spec.md).
- [Canadian tax rules](tax-rules.md).
- [App Store copy](app-store-copy.md).
- [Test plan](test-plan.md).
- [Color system](../design/color-system.md).
- [Basic wireframe checklist](../design/wireframes.md).
- [Privacy policy draft](../legal/privacy-policy.md).
- [Terms/disclaimer draft](../legal/terms-disclaimer.md).
- [Marketing landing page copy](../marketing/landing-page-copy.md).
- [StoreKit unlock plan](storekit-unlock.md).
- [Development plan](development-plan.md).

Notes:

- The tax-rules doc includes the Nova Scotia HST correction to 14%.
- This stage did not include compiled Swift code, Xcode setup, or actual Figma binary design files.

## Stage 2: Design Handoff Package

Status: Completed.

Goal:

Create enough screen, component, icon, and screenshot direction for Figma design work and later SwiftUI implementation.

Completed artifacts:

- [Screen-by-screen UI specs](../design/screen-specs.md).
- [Component system](../design/component-system.md).
- [App flow map](../design/app-flow.md).
- [App icon brief](../design/app-icon-brief.md).
- [App Store screenshot plan](../app-store/screenshot-plan.md).

## Stage 3: PDF Reference Package

Status: Completed.

Goal:

Define the invoice and estimate PDF visual system in enough detail to create sample PDFs and later implement rendering in Swift.

Completed artifacts:

- [Invoice sample content](../sample-pdfs/invoice-sample-content.md).
- [Estimate sample content](../sample-pdfs/estimate-sample-content.md).
- [Multi-page stress case](../sample-pdfs/multi-page-stress-case.md).
- [PDF layout measurements](pdf-layout-measurements.md).
- [Multi-page PDF behavior](pdf-multipage-behavior.md).
- [Black-and-white print checklist](pdf-print-checklist.md).
- [PDF QA checklist](pdf-qa-checklist.md).

Notes:

- This stage created reference content and QA specs, not final rendered PDF binaries.
- Final rendered PDFs should be produced later from these references in Figma/Canva or by the Swift PDF renderer.

## Stage 4: SwiftUI Architecture Plan

Status: Completed.

Goal:

Prepare the implementation blueprint before Xcode work starts.

Completed artifacts:

- [SwiftUI architecture plan](swiftui-architecture-plan.md).
- [Swift folder/module plan](swift-folder-structure.md).
- [View and ViewModel map](view-viewmodel-map.md).
- [SwiftData model mapping](swiftdata-model-mapping.md).
- [Service responsibilities](service-responsibilities.md).
- [Calculation test cases](calculation-test-cases.md).
- [StoreKit integration outline](storekit-integration-outline.md).

## Stage 5: Xcode Project Setup

Status: Prepared; blocked until Mac/Xcode is available.

Goal:

Create the actual iOS app project on Mac with SwiftUI, local persistence, assets, and test target.

Prepared artifacts:

- [Xcode project setup guide](xcode-project-setup.md).
- [Xcode Mac handoff checklist](xcode-mac-handoff-checklist.md).
- [Source placeholder folder structure](../src-placeholder/README.md).
- Planned bundle ID documented.
- Mac-only completion criteria documented.

Blocked artifacts:

- Xcode project.
- Bundle ID configured inside Xcode.
- App shell compiled in Xcode.
- Local iOS simulator build verification.
- Unit test target verification.
- Git commit with initial app project.

Notes:

- This Windows machine does not have Swift, Xcode, `xcodebuild`, or iOS Simulator.
- Stage 5 should be marked completed only after the Mac checklist is executed and the app builds locally.

## Stage 6: Local Data and Core CRUD

Status: Not started.

Goal:

Implement business profile, clients, documents, and line items with local persistence.

Expected artifacts:

- SwiftData or SQLite persistence.
- Business profile setup.
- Client CRUD.
- Document CRUD.
- Line item editor.
- Basic search/filter.

## Stage 7: Calculations and Tax Logic

Status: Not started.

Goal:

Implement reliable invoice totals, discounts, deposits, payments, and Canadian tax presets.

Expected artifacts:

- Decimal money math.
- Tax presets.
- Custom/no-tax support.
- Unit tests for calculations.

## Stage 8: PDF Preview and Export

Status: Not started.

Goal:

Generate professional PDFs and support preview, share, and save flows.

Expected artifacts:

- PDF renderer.
- PDF preview screen.
- Share/export flow.
- Filename generation.
- PDF QA pass.

## Stage 9: StoreKit and Paywall

Status: Not started.

Goal:

Add the lifetime unlock purchase and enforce the free limit.

Expected artifacts:

- StoreKit 2 purchase manager.
- Paywall.
- Restore purchase.
- Free limit gating.
- StoreKit local test pass.

## Stage 10: Launch Preparation

Status: Not started.

Goal:

Prepare TestFlight and App Store materials.

Expected artifacts:

- App icon.
- Screenshots.
- Final privacy policy URL.
- App Store metadata.
- TestFlight checklist.
- App Review readiness pass.
