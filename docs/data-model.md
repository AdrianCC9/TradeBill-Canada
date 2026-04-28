# Data Model

The app should use local persistence. SwiftData is the preferred first choice once Xcode development begins, unless its migration or relationship behavior creates unnecessary complexity.

## Entities

```text
BusinessProfile
Client
Document
LineItem
TaxPreset
AppSettings
PurchaseState
```

## BusinessProfile

```text
id: UUID
businessName: String
ownerName: String
email: String
phone: String
addressLine1: String
addressLine2: String
city: String
province: ProvinceCode
postalCode: String
taxNumber: String?
logoImagePath: String?
signatureImagePath: String?
defaultTaxProvince: ProvinceCode?
defaultPaymentTerms: String
createdAt: Date
updatedAt: Date
```

## Client

```text
id: UUID
name: String
companyName: String?
email: String
phone: String
addressLine1: String
addressLine2: String
city: String
province: ProvinceCode?
postalCode: String
notes: String
createdAt: Date
updatedAt: Date
```

## Document

```text
id: UUID
type: DocumentType // estimate, invoice
documentNumber: String
clientId: UUID?
title: String
jobAddress: String?
issueDate: Date
dueDate: Date?
status: DocumentStatus
subtotal: Decimal
discountType: DiscountType // none, percentage, fixedAmount
discountValue: Decimal
taxProvince: ProvinceCode?
taxLabel: String
taxRate: Decimal
taxAmount: Decimal
depositAmount: Decimal
amountPaid: Decimal
total: Decimal
balanceDue: Decimal
notes: String
terms: String
convertedFromEstimateId: UUID?
createdAt: Date
updatedAt: Date
```

## LineItem

```text
id: UUID
documentId: UUID
description: String
quantity: Decimal
unitPrice: Decimal
lineTotal: Decimal
sortOrder: Int
createdAt: Date
updatedAt: Date
```

## TaxPreset

```text
id: UUID
province: ProvinceCode?
displayName: String
components: [TaxComponent]
combinedRate: Decimal
isCustom: Bool
isNoTax: Bool
```

## TaxComponent

```text
label: String // GST, HST, PST, RST, QST
rate: Decimal
```

## AppSettings

```text
id: UUID
nextInvoiceNumber: Int
nextEstimateNumber: Int
freeDocumentsCreated: Int
hasLifetimeUnlock: Bool
currencyCode: String // CAD
createdAt: Date
updatedAt: Date
```

## PurchaseState

```text
id: UUID
productId: String
hasLifetimeUnlock: Bool
lastEntitlementCheckAt: Date?
lastTransactionId: String?
updatedAt: Date
```

## Enums

```text
DocumentType:
  estimate
  invoice

EstimateStatus:
  draft
  sent
  accepted
  rejected
  converted

InvoiceStatus:
  draft
  sent
  unpaid
  partiallyPaid
  paid
  overdue
  cancelled

DiscountType:
  none
  percentage
  fixedAmount

ProvinceCode:
  AB, BC, MB, NB, NL, NT, NS, NU, ON, PE, QC, SK, YT
```

## Numbering

Use sequential local numbering:

```text
INV-0001
EST-0001
```

Increment the relevant counter only after document creation succeeds.

## Calculation Rules

Line total:

```text
quantity * unitPrice
```

Subtotal:

```text
sum(lineItem.lineTotal)
```

Discount:

```text
fixed amount, or subtotal * percentage
```

Tax base:

```text
max(subtotal - discount, 0)
```

Tax amount:

```text
sum(tax base * component rate)
```

Total:

```text
tax base + tax amount
```

Balance due:

```text
max(total - depositAmount - amountPaid, 0)
```

Use Decimal for money. Avoid binary floating-point types for persisted amounts and calculations.

