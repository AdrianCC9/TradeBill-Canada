# Test Plan

## Manual Test Matrix

### Onboarding and Business Setup

- Fresh install shows onboarding.
- Get Started opens business setup.
- Business setup can be completed.
- Business setup can be skipped.
- Missing business name warning appears before PDF export.
- Logo can be added.
- Signature can be added.
- Defaults persist after app close and reopen.

### Client CRUD

- Create client with required fields only.
- Create client with company, phone, email, address, and notes.
- Edit client.
- Delete client only when safe, or confirm behavior when linked to documents.
- Search client list.

### Document Creation

- Create estimate.
- Create invoice.
- Document numbers increment correctly.
- Issue date defaults to today.
- Due date follows default payment terms.
- Status defaults correctly by document type.
- Existing documents can be edited after free limit is reached.

### Line Items

- Add one line item.
- Add multiple line items.
- Edit description, quantity, and unit price.
- Reorder line items.
- Delete line items.
- Decimal quantities calculate correctly.
- Long descriptions wrap in editor and PDF.
- Zero quantity and zero price behavior is handled intentionally.

### Discounts and Payments

- No discount.
- Fixed amount discount.
- Percentage discount.
- Discount cannot make taxable base negative.
- Deposit amount reduces balance due.
- Amount paid reduces balance due.
- Partially paid invoice shows correct status.
- Paid invoice shows zero balance.

### Taxes

- No tax invoice.
- Custom percentage invoice.
- Ontario HST 13%.
- Nova Scotia HST 14%.
- Quebec GST 5% + QST 9.975%.
- British Columbia GST 5% + PST 7%.
- Manitoba GST 5% + RST 7%.
- Saskatchewan GST 5% + PST 6%.
- GST-only province or territory.
- Tax rows display correctly in PDF.
- Rounding is correct to nearest cent.

### PDF

- Preview loads for estimate.
- Preview loads for invoice.
- Share sheet opens.
- Save to Files works.
- Long client names do not break layout.
- Long business names do not break layout.
- Long line item tables continue to second page.
- Totals stay readable.
- Black-and-white print output remains legible.
- Filename matches required format.

### Estimate Conversion

- Convert estimate to invoice.
- New invoice number is generated.
- Estimate status changes to Converted.
- New invoice stores convertedFromEstimateId.
- Client, line items, tax, discount, notes, and terms are copied.

### Search and Filters

- Search by document number.
- Search by client name.
- Filter estimates.
- Filter invoices.
- Filter unpaid invoices.
- Filter drafts.
- Overdue status updates when due date has passed.
- Filter overdue invoices.

### Free Limit and Purchase

- First 3 document creations are allowed for free users.
- Fourth document creation shows paywall.
- PDF export is blocked after free limit until unlock.
- Existing documents remain viewable.
- Existing documents remain editable.
- Purchase unlock succeeds in StoreKit local testing.
- Cancelled purchase is handled gracefully.
- Failed purchase is handled gracefully.
- Restore purchase works.
- Entitlement re-check on app launch updates local state.

## Unit Test Targets

- Money calculations use Decimal.
- Document numbering increments correctly.
- Estimate-to-invoice copy logic preserves expected fields.
- Document client snapshots clear correctly when a client is removed.
- Past-due unpaid invoices display as overdue.
- Tax presets return expected components.
- Tax calculations round correctly.
- Free limit logic blocks only new creation/export.
- PDF filename sanitizer removes invalid characters.
- PDF output includes paid/deposit amount rows.
- PDF output includes all line items across multiple pages.

## Device Coverage

Test on at least:

- Small iPhone viewport.
- Standard iPhone viewport.
- Large iPhone viewport.
- Light mode.
- Dark mode if supported.
- Offline mode.
- Fresh install smoke screenshot with `scripts/smoke-ios-simulator.sh`.
