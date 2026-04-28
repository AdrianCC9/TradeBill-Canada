# PDF Multi-Page Behavior

The PDF renderer must handle long documents without clipped content.

## Page Types

### First Page

Includes:

- Header with business and document details.
- Accent line.
- Bill-to block.
- Job block, if present.
- Line item table start.
- Footer.

### Continuation Pages

Includes:

- Compact continuation header.
- Repeated line item table header.
- Continued line items.
- Footer.

Continuation header content:

```text
INVOICE INV-0007 continued
Client: John Smith
```

For estimates:

```text
ESTIMATE EST-0004 continued
Client: Jane Doe
```

## Table Splitting

Rules:

- Never split a single line item row across pages unless its wrapped description is taller than the remaining page body and cannot fit on an empty page.
- Repeat the table header on every continuation page.
- Preserve row order.
- Keep row borders aligned across pages.
- Do not orphan totals at the bottom of a page with no space for at least the Total and Balance Due rows.

## Totals Placement

Totals should appear once, after the final line item.

Before drawing totals, check available vertical space:

```text
requiredTotalsHeight = totalsRowsHeight + sectionSpacing
```

If available space is too small:

1. Start a new page.
2. Draw continuation header.
3. Draw totals.
4. Draw notes, terms, signature, and footer if space allows.

## Notes and Terms Placement

Notes and terms should stay with the final totals when possible.

If they do not fit:

- Keep totals on the current final line-item page.
- Move notes and terms to the next page.
- Use a compact continuation header on the notes/terms page.

## Signature Placement

Signature appears after terms.

If signature does not fit:

- Move signature and thank-you message to the next page.
- Do not shrink the signature below legibility.

## Footer

Every page must include:

```text
Page X of Y
```

Optional left footer:

```text
Created with TradeBill Canada
```

or the tax disclaimer if enabled.

## Stress Cases

Test with:

- 20+ line items.
- One very long line item description.
- Long business name.
- Long client company name.
- Missing logo.
- Logo present.
- Signature present.
- Notes and terms both present.

