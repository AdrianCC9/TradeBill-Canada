# Screen Specs

These specs should be used for Figma wireframes and SwiftUI implementation.

## Onboarding

Purpose:

Introduce value quickly and move the user into setup.

Primary content:

```text
TradeBill Canada
Create professional Canadian estimates and invoices in seconds.
No login. No subscription. Built for small service businesses.
```

Primary action:

```text
Get Started
```

Notes:

- Keep it to one screen.
- No carousel for MVP.
- White background with turquoise accent.

## Business Setup

Purpose:

Collect defaults needed for professional PDFs.

Fields:

- Business name.
- Owner name.
- Phone.
- Email.
- Address line 1.
- Address line 2.
- City.
- Province.
- Postal code.
- Tax number, optional.
- Logo upload.
- Default tax type.
- Default payment terms.

Actions:

- Save Business Profile.
- Skip for Now.

Validation:

- Business name is recommended, but not required.
- Email should use email keyboard.
- Phone should use phone keyboard.
- Province should use a picker.

## Home Dashboard

Purpose:

Give fast access to creation and recent work.

Top actions:

- New Estimate.
- New Invoice.

Content:

- Search bar.
- Total unpaid invoices.
- Draft count.
- Recent documents.

Document card content:

```text
INV-0007
John Smith
$452.00
Due May 15
Unpaid
```

Empty state:

```text
No documents yet
```

Actions:

- New Estimate.
- New Invoice.

## Document Editor

Purpose:

Create or edit an estimate/invoice quickly.

Sections:

1. Document basics.
2. Client.
3. Job details.
4. Line items.
5. Discount and tax.
6. Deposit/payment.
7. Notes and terms.
8. Signature.
9. Status.

Fields:

- Document type.
- Client.
- Job/service title.
- Job address, optional.
- Issue date.
- Due date.
- Line items.
- Discount.
- Tax.
- Deposit/paid amount.
- Notes.
- Terms.
- Signature.
- Status.

Primary action:

```text
Preview PDF
```

Secondary actions:

- Save Draft.
- Delete, when editing.

Notes:

- Totals should remain visible near the bottom.
- Use Decimal-compatible numeric input.
- Do not force every optional field before preview.

## Client Manager

Purpose:

Create and manage reusable clients.

List content:

- Name.
- Company, optional.
- Phone.
- Email.

Form fields:

- Name.
- Company, optional.
- Phone.
- Email.
- Billing address.
- Notes.

Actions:

- Add Client.
- Save Client.
- Delete Client.

Notes:

- If a client has linked documents, deletion should require confirmation or be disabled in favor of archiving later.

## PDF Preview

Purpose:

Let the user verify the document before sending.

Content:

- Rendered PDF preview.
- Document number.
- Client name.
- Balance due or estimate total.

Actions:

- Share PDF.
- Save to Files.
- Duplicate.
- Convert to Invoice, if estimate.
- Mark as Paid, if invoice.

Gating:

- If free limit is exceeded and user is not unlocked, Share PDF and Save to Files open the paywall.

## Paywall

Purpose:

Explain the lifetime unlock clearly after the free limit.

Copy:

```text
Unlock unlimited invoices and estimates.
One-time purchase. No subscription. No account required.
$19.99 CAD Lifetime
```

Actions:

- Unlock Lifetime Access.
- Restore Purchase.
- Maybe Later.

Notes:

- Do not hide Restore Purchase.
- Do not imply documents are lost.
- Existing documents remain viewable and editable.

## Settings

Purpose:

Manage business defaults, purchase state, and legal links.

Sections:

- Business profile.
- Defaults.
- Logo.
- Signature.
- PDF footer tax disclaimer.
- Lifetime unlock / restore purchase.
- Privacy policy.
- Tax disclaimer.

Notes:

- Default tax province and payment terms live here.
- The tax disclaimer toggle should default on for PDFs.

