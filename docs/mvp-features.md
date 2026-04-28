# MVP Features

## Must Have

1. Create estimate.
2. Create invoice.
3. Convert estimate to invoice.
4. Add client.
5. Add business profile.
6. Add line items.
7. Apply Canadian tax preset.
8. Add discount.
9. Add deposit or partial payment.
10. Add due date and payment terms.
11. Add notes.
12. Add logo.
13. Add signature.
14. Generate professional PDF.
15. Share/export PDF.
16. Save documents locally.
17. Search/filter documents.
18. Enforce free limit and lifetime unlock.

## Out of Scope for v1

- Login.
- Cloud sync.
- Credit card payment collection.
- Stripe.
- QuickBooks integration.
- Bank connection.
- Expense tracking.
- OCR.
- AI invoice creation.
- Multi-user teams.
- Web dashboard.
- Chat support.
- Complex accounting reports.

## User Flows

### First Launch

1. User sees onboarding.
2. User taps Get Started.
3. User completes or skips business setup.
4. User lands on the home dashboard.

### Create Invoice

1. User taps New Invoice.
2. User selects or creates a client.
3. User enters job/service title.
4. User adds line items.
5. App calculates subtotal, discount, tax, total, and balance due.
6. User previews PDF.
7. User shares or saves PDF.

### Create Estimate

1. User taps New Estimate.
2. User completes the document editor.
3. User previews PDF.
4. User shares or saves PDF.
5. User may later convert the estimate to an invoice.

### Convert Estimate to Invoice

1. User opens an estimate.
2. User taps Convert to Invoice.
3. App copies client, title, job address, line items, tax, discount, notes, terms, logo, and signature.
4. App creates a new invoice number.
5. Estimate status becomes Converted.
6. Invoice stores `convertedFromEstimateId`.

### Free Limit

Free users can create 3 total documents across estimates and invoices.

After the limit:

- Existing documents can be viewed.
- Existing documents can be edited.
- New document creation is blocked.
- PDF export is blocked.
- Paywall is shown with lifetime unlock and restore options.

