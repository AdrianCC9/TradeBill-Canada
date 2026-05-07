# TradeBill Canada

TradeBill Canada is an iPhone-first SwiftUI app for Canadian solo service providers who need to create estimates, invoices, and clean PDFs quickly in the field.

The v1 product is local-only, portrait-only, and intentionally small:

- Create estimates and invoices.
- Add clients, line items, discounts, deposits, and Canadian tax presets.
- Convert accepted estimates into invoices.
- Generate and share professional PDFs.
- Allow 3 free documents, then require a one-time lifetime unlock.

## Current Stage

The Windows planning package is complete, and the Mac/Xcode implementation has started. The repository now contains a real SwiftUI iOS project, SwiftData models, core document flows, PDF rendering, StoreKit unlock scaffolding, and XCTest coverage for core business rules.

See [project stages](docs/stages.md) for the current checkpoint and the next approved stage.

## Xcode Structure

```text
TradeBillCanada/
  App/
  Models/
  Views/
  ViewModels/
  Services/
  PDF/
  Store/
  Persistence/
  Assets/
  Utilities/
```

## Key Docs

- [Product spec](docs/product-spec.md)
- [Project stages](docs/stages.md)
- [MVP features](docs/mvp-features.md)
- [Data model](docs/data-model.md)
- [PDF template spec](docs/pdf-template-spec.md)
- [PDF layout measurements](docs/pdf-layout-measurements.md)
- [PDF multi-page behavior](docs/pdf-multipage-behavior.md)
- [PDF print checklist](docs/pdf-print-checklist.md)
- [PDF QA checklist](docs/pdf-qa-checklist.md)
- [Tax rules](docs/tax-rules.md)
- [StoreKit unlock plan](docs/storekit-unlock.md)
- [SwiftUI architecture plan](docs/swiftui-architecture-plan.md)
- [Swift folder structure](docs/swift-folder-structure.md)
- [View and ViewModel map](docs/view-viewmodel-map.md)
- [SwiftData model mapping](docs/swiftdata-model-mapping.md)
- [Service responsibilities](docs/service-responsibilities.md)
- [Calculation test cases](docs/calculation-test-cases.md)
- [StoreKit integration outline](docs/storekit-integration-outline.md)
- [Xcode project setup](docs/xcode-project-setup.md)
- [Xcode Mac handoff checklist](docs/xcode-mac-handoff-checklist.md)
- [Development plan](docs/development-plan.md)
- [App Store copy](docs/app-store-copy.md)
- [Test plan](docs/test-plan.md)
- [Color system](design/color-system.md)
- [Wireframes](design/wireframes.md)
- [App flow](design/app-flow.md)
- [Screen specs](design/screen-specs.md)
- [Component system](design/component-system.md)
- [App icon brief](design/app-icon-brief.md)
- [Screenshot plan](app-store/screenshot-plan.md)
- [Privacy policy draft](legal/privacy-policy.md)
- [Terms and disclaimer draft](legal/terms-disclaimer.md)

## Local Build

```sh
xcodebuild -project TradeBillCanada.xcodeproj -scheme TradeBillCanada -destination 'generic/platform=iOS Simulator' build
```

If Xcode reports that the iOS platform is missing, install it first:

```sh
xcodebuild -downloadPlatform iOS
```

## Local Testing

Run the app test suite on a booted or available simulator:

```sh
scripts/run-ios-tests.sh
```

The script prefers a booted iPhone simulator, then the first available iPhone simulator. For a deterministic target, pass the simulator UUID:

```sh
DEVICE_ID=73466A72-167A-446E-B4B3-7D840709D7B1 scripts/run-ios-tests.sh
```

You can also target a simulator by exact name:

```sh
DEVICE_NAME='iPhone 17' scripts/run-ios-tests.sh
```

If Simulator/Xcode gets stuck during first boot or test launch, capture a diagnostic snapshot:

```sh
BOOTSTATUS_TIMEOUT_SECONDS=20 scripts/diagnose-ios-simulator.sh
```
