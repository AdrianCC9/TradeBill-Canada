# Multi-Page Stress Case

Use this content to test page breaking, repeated table headers, long descriptions, and totals placement.

## Document

```text
Document type: INVOICE
Document number: INV-0021
Status: Unpaid
Issue date: April 28, 2026
Due date: May 28, 2026
Filename: Invoice_INV-0021_Northern-Lakes-Property-Care.pdf
```

## Business

```text
Northern Lakes Property Care
Morgan Taylor
12 Birch Road
Sudbury, ON P3E 2C6
705-555-0171
morgan@northernlakescare.ca
HST No. 11223 3445 RT0001
```

## Client

```text
Northern Lakes Property Care Client Account With A Long Name
Attention: Facilities Manager
984 Longview Industrial Road, Unit 14
Sudbury, ON P3B 1A1
facilities@example.com
705-555-0188
```

## Job

```text
Seasonal property cleanup, repairs, and supply run
984 Longview Industrial Road, Unit 14, Sudbury, ON P3B 1A1
```

## Line Items

Use these repeated rows to create a multi-page invoice:

| Description | Qty | Rate | Amount |
| --- | ---: | ---: | ---: |
| Site walk-through, notes, and work planning | 1 hr | $70.00 | $70.00 |
| Exterior debris cleanup along fence line and parking area | 3 hr | $70.00 | $210.00 |
| Pressure washing front entrance walkway and loading area | 2 hr | $85.00 | $170.00 |
| Minor fence board repair with supplied fasteners | 2 hr | $75.00 | $150.00 |
| Supply run for lumber, fasteners, contractor bags, and disposal tags | 1 | $65.00 | $65.00 |
| Contractor bags and shop supplies | 1 | $48.00 | $48.00 |
| Long description wrapping test: detailed cleanup of north side storage area including sorting, bagging, sweeping, and moving approved items to the designated disposal pickup zone | 4 hr | $70.00 | $280.00 |
| Lawn edge cleanup along front sign | 1.5 hr | $65.00 | $97.50 |
| Mulch touch-up around main entrance | 1 | $125.00 | $125.00 |
| Weed removal around rear loading dock | 2 hr | $65.00 | $130.00 |
| Light fixture lens cleaning | 1 hr | $70.00 | $70.00 |
| Door sweep replacement labour | 1 hr | $75.00 | $75.00 |
| Door sweep material | 1 | $34.00 | $34.00 |
| Gutter check and minor clearing | 2 hr | $80.00 | $160.00 |
| Waste disposal fee | 1 | $95.00 | $95.00 |
| Parking lot line debris removal | 2 hr | $65.00 | $130.00 |
| Safety cone rental | 1 | $28.00 | $28.00 |
| Exterior window spot cleaning | 2 hr | $70.00 | $140.00 |
| Touch-up caulking around service door | 1 hr | $75.00 | $75.00 |
| Caulking material | 1 | $22.50 | $22.50 |
| Final inspection and photo documentation | 1 hr | $70.00 | $70.00 |

## Expected Totals

```text
Subtotal: $2,445.00
Discount: $0.00
Taxable amount: $2,445.00
HST 13%: $317.85
Total: $2,762.85
Amount Paid: $0.00
Balance Due: $2,762.85
```

## Page-Break Expectations

- Page 1 should show the full header, bill-to block, job block, and first portion of the line item table.
- Page 2 should repeat the line item table header.
- Totals should appear only once, after the final line item.
- Notes, terms, and signature should stay after totals on the final page when possible.
- Footer and page number should appear on each page.

