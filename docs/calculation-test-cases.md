# Calculation Test Cases

Use these cases for XCTest once the Xcode project exists.

## Money Rules

- Use Decimal or integer cents.
- Round displayed currency to 2 decimal places.
- Do not use Double for persisted money calculations.
- Clamp taxable amount and balance due at zero.

## Case 1: Ontario Invoice With Fixed Discount and Deposit

Inputs:

```text
Line items:
  $300.00
  $280.00
  $96.00
Discount: fixed $50.00
Tax: HST 13%
Deposit/Paid: $150.00
```

Expected:

```text
Subtotal: $676.00
Discount: $50.00
Taxable amount: $626.00
HST 13%: $81.38
Total: $707.38
Balance due: $557.38
```

## Case 2: British Columbia Estimate With Percentage Discount

Inputs:

```text
Line items:
  $325.00
  $240.00
  $75.00
Discount: 5%
Tax: GST 5% + PST 7%
Paid: $0.00
```

Expected:

```text
Subtotal: $640.00
Discount: $32.00
Taxable amount: $608.00
GST 5%: $30.40
PST 7%: $42.56
Total: $680.96
Balance due: $680.96
```

## Case 3: No Tax

Inputs:

```text
Subtotal: $250.00
Discount: $0.00
Tax: No tax
Paid: $0.00
```

Expected:

```text
Total: $250.00
Balance due: $250.00
Tax amount: $0.00
```

## Case 4: Discount Greater Than Subtotal

Inputs:

```text
Subtotal: $100.00
Discount: fixed $150.00
Tax: HST 13%
Paid: $0.00
```

Expected:

```text
Taxable amount: $0.00
Tax amount: $0.00
Total: $0.00
Balance due: $0.00
```

## Case 5: Partial Payment

Inputs:

```text
Subtotal: $500.00
Discount: $0.00
Tax: GST 5%
Paid: $200.00
```

Expected:

```text
GST 5%: $25.00
Total: $525.00
Balance due: $325.00
Status suggestion: Partially Paid
```

## Case 6: Fully Paid

Inputs:

```text
Total: $525.00
Paid: $525.00
```

Expected:

```text
Balance due: $0.00
Status suggestion: Paid
```

## Case 7: Quebec Tax Components

Inputs:

```text
Taxable amount: $100.00
Tax: GST 5% + QST 9.975%
```

Expected:

```text
GST 5%: $5.00
QST 9.975%: $9.98
Total tax: $14.98
Total: $114.98
```

## Case 8: Filename Sanitization

Inputs:

```text
Document type: Invoice
Document number: INV-0008
Client name: Smith / Doe: Main House?
```

Expected:

```text
Invoice_INV-0008_Smith-Doe-Main-House.pdf
```

## Case 9: Free Limit

Inputs:

```text
freeDocumentsCreated: 3
hasLifetimeUnlock: false
action: create new invoice
```

Expected:

```text
Allowed: false
Route: Paywall
```

Existing document edit:

```text
Allowed: true
```

## Case 10: Lifetime Unlock

Inputs:

```text
freeDocumentsCreated: 3
hasLifetimeUnlock: true
action: create new invoice
```

Expected:

```text
Allowed: true
```

