# Service Responsibilities

Services keep business logic out of SwiftUI views.

## CalculationService

Responsibilities:

- Calculate line totals.
- Calculate subtotal.
- Apply fixed and percentage discounts.
- Calculate tax base.
- Calculate tax component amounts.
- Calculate total.
- Calculate balance due.

Inputs:

- Line items.
- Discount type and value.
- Tax preset/components.
- Deposit amount.
- Amount paid.

Output:

- `DocumentTotals` or `MoneyCalculationResult`.

## TaxPresetService

Responsibilities:

- Provide MVP province/territory tax presets.
- Provide no-tax preset.
- Build custom tax preset.
- Return display labels for tax picker and PDF rows.

Notes:

- Tax rates should be centralized here.
- Documents should store a snapshot of selected tax data.

## DocumentNumberService

Responsibilities:

- Generate next invoice number.
- Generate next estimate number.
- Increment counters only after document creation succeeds.

Formats:

```text
INV-0001
EST-0001
```

## DocumentConversionService

Responsibilities:

- Convert estimate to invoice.
- Copy client, title, job address, line items, tax, discount, notes, terms, logo/signature references as appropriate.
- Assign a new invoice number.
- Set source estimate status to Converted.
- Store `convertedFromEstimateId` on invoice.

## EntitlementGate

Responsibilities:

- Decide whether the user can create a document.
- Decide whether the user can export a PDF.
- Respect lifetime unlock.
- Respect the 3-document free limit.
- Allow viewing and editing existing documents after the limit.

## PDFRenderService

Responsibilities:

- Render PDF data from a `PDFRenderRequest`.
- Use layout rules from `pdf-layout-measurements.md`.
- Support single-page and multi-page documents.
- Return PDF data or a temporary file URL.

## PDFFilenameService

Responsibilities:

- Build export filenames.
- Normalize client names.
- Strip invalid filename characters.

Examples:

```text
Invoice_INV-0007_John-Smith.pdf
Estimate_EST-0004_Jane-Doe.pdf
```

## ImageStorageService

Responsibilities:

- Persist logo image.
- Persist signature image.
- Return local paths or identifiers.
- Resize/compress images if needed.

## PurchaseManager

Responsibilities:

- Load StoreKit product metadata.
- Purchase lifetime unlock.
- Restore purchases.
- Listen for transaction updates.
- Verify transactions.
- Update local purchase state.

