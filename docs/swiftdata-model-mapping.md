# SwiftData Model Mapping

SwiftData should be the first persistence choice for MVP.

## Persisted Models

### BusinessProfile

SwiftData class:

```text
@Model final class BusinessProfile
```

Relationships:

- None required for MVP.

Notes:

- Store one active business profile.
- Logo and signature should store local file paths or asset identifiers, not large image blobs unless testing shows this is acceptable.

### Client

SwiftData class:

```text
@Model final class Client
```

Relationships:

- Can be referenced by Document.

Delete behavior:

- For v1, avoid hard-deleting clients with linked documents unless the user confirms.
- Consider leaving historical client text snapshots on documents later.

### Document

SwiftData class:

```text
@Model final class Document
```

Relationships:

- Optional `client`.
- Cascade or explicit delete for `lineItems`.

Important:

- Store selected tax label, tax province, tax rate, and tax component snapshot on the document so old documents do not change if tax presets are updated later.

### LineItem

SwiftData class:

```text
@Model final class LineItem
```

Relationships:

- Belongs to one Document.

Sorting:

- Use `sortOrder`.

### AppSettings

SwiftData class:

```text
@Model final class AppSettings
```

Notes:

- Store one row.
- Create default settings at first launch if missing.

### PurchaseState

SwiftData class:

```text
@Model final class PurchaseState
```

Notes:

- Store local entitlement cache.
- StoreKit remains the source for re-checking verified entitlements.

## Value Types

These do not need SwiftData persistence:

- `TaxPreset`
- `TaxComponent`
- `MoneyCalculationResult`
- `PDFRenderRequest`
- `DocumentTotals`

## Decimal Persistence

SwiftData support for Decimal should be verified in Xcode. If Decimal persistence is awkward, use one of these approaches:

1. Store money as integer cents.
2. Store Decimal as String.
3. Use SQLite directly.

Preferred MVP approach:

```text
Store user-facing money as Decimal in app logic.
Persist as integer cents if SwiftData Decimal behavior is not clean.
```

## Model Container

Create a factory:

```text
ModelContainerFactory.makeProductionContainer()
ModelContainerFactory.makePreviewContainer()
ModelContainerFactory.makeTestContainer()
```

This keeps previews and tests separate from production data.

## Migration

No migration is needed for the initial TestFlight build.

Before App Store release:

- Confirm model names.
- Confirm optional fields.
- Confirm delete rules.
- Avoid unnecessary schema churn after users create real documents.

