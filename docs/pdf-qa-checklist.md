# PDF QA Checklist

Use this checklist before Stage 8 is considered complete.

## Rendering

- Invoice PDF renders.
- Estimate PDF renders.
- PDF preview loads quickly.
- PDF can be regenerated after document edits.
- No blank pages are produced.
- No content is clipped.
- No content overlaps.
- Page count is correct.

## Header

- Logo appears when provided.
- Layout still works without logo.
- Business name appears.
- Business contact info appears.
- Tax number appears only when present.
- Document type appears.
- Document number appears.
- Issue date appears.
- Due date or valid-until date appears.

## Client and Job

- Bill-to block appears.
- Client company is optional.
- Client email and phone are optional.
- Job title appears when present.
- Job address appears when present.
- Missing optional fields do not leave awkward gaps.

## Line Items

- Description wraps cleanly.
- Quantity aligns right.
- Rate aligns right.
- Amount aligns right.
- Row totals match calculations.
- Table header repeats on continuation pages.
- Rows do not overlap footer.

## Totals

- Subtotal is correct.
- Discount is correct.
- Tax base is correct.
- Tax components are correct.
- Combined tax total is correct.
- Deposit or amount paid reduces balance due.
- Total is correct.
- Balance due is correct.
- Zero-tax documents are clear.

## Tax Display

- Ontario HST displays correctly.
- Nova Scotia HST 14% displays correctly.
- Quebec GST and QST display separately.
- BC GST and PST display separately.
- Manitoba GST and RST display separately.
- Saskatchewan GST and PST display separately.
- Custom tax label displays correctly.
- No-tax preset displays correctly.

## Multi-Page

- Long documents continue to a second page.
- Continuation header appears.
- Table header repeats.
- Totals appear after final line item.
- Notes and terms move gracefully if needed.
- Page numbers show `Page X of Y`.

## Export

- Share PDF opens the share sheet.
- Save to Files works.
- Filename matches expected pattern.
- Invalid filename characters are removed.
- Export is blocked by paywall when required.
- Export works after lifetime unlock.

## Sample Data Tests

Use these references:

- [Invoice sample content](../sample-pdfs/invoice-sample-content.md)
- [Estimate sample content](../sample-pdfs/estimate-sample-content.md)
- [Multi-page stress case](../sample-pdfs/multi-page-stress-case.md)

