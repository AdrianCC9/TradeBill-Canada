# PDF Template Spec

The PDF is the core product experience. It should look clean, businesslike, and trustworthy when shared digitally or printed in black and white.

## Filename Format

```text
Invoice_INV-0007_John-Smith.pdf
Estimate_EST-0004_Jane-Doe.pdf
```

Filename normalization:

- Use document type title case.
- Use document number exactly as displayed.
- Replace spaces in client name with hyphens.
- Strip characters that are invalid for filenames.

## Page Setup

- Paper size: Letter, 8.5 x 11 inches.
- Margins: 36 pt.
- Background: white.
- Accent color: turquoise `#18BFC3`.
- Text color: dark `#172326`.
- Secondary text: muted `#6B7A7C`.
- Borders: light gray `#DDE7E8`.

## Header

Left side:

- Business logo, if available.
- Business name.
- Business contact info.
- Tax number, if present.

Right side:

- Document type: ESTIMATE or INVOICE.
- Document number.
- Issue date.
- Due date, if applicable.
- Status, if appropriate.

Add a thin turquoise accent line below the header.

## Bill-To Block

Label:

```text
Bill To
```

Fields:

- Client name.
- Company name, optional.
- Billing address.
- Email.
- Phone.

## Job Block

Show when fields exist:

- Job/service title.
- Job address.

## Line Item Table

Columns:

```text
Description | Qty | Rate | Amount
```

Rules:

- Description is left aligned.
- Qty, Rate, and Amount are right aligned.
- Long descriptions wrap cleanly.
- Header row uses a light off-white fill.
- Borders should be thin and subtle.
- Repeat table header if content spans pages.

## Totals Section

Right aligned block:

```text
Subtotal
Discount
GST/HST/PST/QST label and rate
Deposit/Paid
Total
Balance Due
```

Rules:

- Display component taxes separately when a province uses multiple tax components.
- Total and Balance Due should be visually emphasized.
- Do not hide zero-tax; show `No tax` or omit the tax row based on the selected preset.

## Notes and Terms

Bottom section:

- Notes.
- Payment terms.
- Tax disclaimer, when the setting is enabled.
- Thank-you message.

Default thank-you copy:

```text
Thank you for your business.
```

Default tax disclaimer:

```text
Tax calculations are provided for convenience only. Users are responsible for confirming applicable tax requirements.
```

## Signature

If a signature exists, show it near the bottom with a small label:

```text
Authorized signature
```

## Multi-Page Behavior

- Header appears on the first page.
- Footer appears on every page.
- Line item table can continue onto additional pages.
- Totals should stay together when possible.
- Notes, terms, signature, and footer can move to the final page.

## Footer

Footer should be subtle:

- Page number.
- Optional tax disclaimer.
- Optional generated-by line:

```text
Created with TradeBill Canada
```

