# Component System

This component system should guide Figma components and later SwiftUI views.

## Design Principles

- Fast field use over dense accounting software.
- Clear tap targets.
- Minimal decoration.
- White and turquoise identity.
- Native iOS behavior wherever possible.
- Information hierarchy should make the next action obvious.

## Core Components

### Primary Button

Use for main actions:

- Get Started.
- New Estimate.
- New Invoice.
- Preview PDF.
- Unlock Lifetime Access.

Style:

- Turquoise background `#18BFC3`.
- White text.
- Minimum height: 48 pt.
- Full-width in forms.
- 10 to 12 pt corner radius in app UI.

States:

- Default.
- Pressed: Deep Turquoise `#0E8F94`.
- Disabled: Border Gray background with Muted Text.

### Secondary Button

Use for lower-weight actions:

- Restore Purchase.
- Maybe Later.
- Duplicate.
- Continue Anyway.

Style:

- White or Off White background.
- Dark Text.
- Border Gray stroke.
- Minimum height: 44 pt.

### Destructive Button

Use sparingly:

- Delete client.
- Delete document.
- Cancel invoice.

Style:

- Text or outlined style in Error Red.
- Require confirmation when data loss is possible.

### Document Card

Use on Home Dashboard and document lists.

Content:

```text
Document number
Client name
Amount
Due date or issue date
Status
```

Layout:

- Document number and status in top row.
- Client name and amount in primary row.
- Date metadata below.
- Card background White.
- Border Gray stroke.
- Small status pill or text label.

### Client Card

Content:

```text
Name
Company
Phone
Email
```

Layout:

- Name as primary text.
- Company and contact details as secondary text.
- Tap opens client detail/edit.

### Form Field

Use native SwiftUI text fields where possible.

Guidance:

- Labels should stay visible.
- Placeholder text should not be the only label.
- Use keyboard types for email, phone, decimal, and number fields.
- Money inputs should clearly show CAD formatting.

### Segmented Control

Use for:

- Estimate / Invoice switch.
- Discount type.
- Search filters where options are few.

### Tax Picker

Use a picker or sheet.

Options:

- No tax.
- Province/territory presets.
- Custom percentage.

Display multi-component taxes clearly:

```text
British Columbia
GST 5% + PST 7%
```

### Line Item Row

Fields:

- Description.
- Quantity.
- Rate.
- Amount.

Mobile behavior:

- Keep description full width.
- Quantity and rate side by side when space allows.
- Amount is calculated and read-only.

### Status Badge

Estimate statuses:

- Draft.
- Sent.
- Accepted.
- Rejected.
- Converted.

Invoice statuses:

- Draft.
- Sent.
- Unpaid.
- Partially Paid.
- Paid.
- Overdue.
- Cancelled.

Use color plus text, not color alone.

### Empty State

Home empty state:

```text
No documents yet
```

Actions:

- New Estimate.
- New Invoice.

Avoid long instructional copy.

### Paywall Panel

Content:

```text
Unlock unlimited invoices and estimates.
One-time purchase. No subscription. No account required.
$19.99 CAD Lifetime
```

Actions:

- Unlock Lifetime Access.
- Restore Purchase.
- Maybe Later.

Make restore visible and honest.

