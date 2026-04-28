# PDF Layout Measurements

These measurements define the target PDF layout for Letter paper and later Swift PDF rendering.

## Page

```text
Paper size: US Letter
Width: 612 pt
Height: 792 pt
Margins: 36 pt
Content width: 540 pt
```

Coordinate assumptions:

- Origin can be top-left in design docs.
- Swift/PDFKit implementation may use bottom-left coordinates, but should convert layout values to preserve this visual structure.

## Vertical Rhythm

| Element | Measurement |
| --- | ---: |
| Top margin | 36 pt |
| Section spacing | 18 pt |
| Small spacing | 8 pt |
| Header accent line | 2 pt |
| Table header height | 24 pt |
| Minimum table row height | 28 pt |
| Footer reserved height | 30 pt |

## Header Layout

Header area:

```text
x: 36
y: 36
width: 540
target height: 88
```

Left business block:

```text
x: 36
y: 36
width: 300
```

Logo:

```text
max width: 56 pt
max height: 56 pt
```

Business text should start to the right of the logo when a logo exists:

```text
x: 104
```

If no logo exists, business text starts at:

```text
x: 36
```

Right document block:

```text
x: 382
y: 36
width: 194
alignment: right
```

Accent line:

```text
x: 36
y: 132
width: 540
height: 2
```

## Bill-To and Job Blocks

Start below header:

```text
y: 154
```

Bill-to block:

```text
x: 36
width: 255
```

Job block:

```text
x: 321
width: 255
```

If no job block exists, bill-to may use the full width.

## Line Item Table

Table starts after bill-to/job content with at least 18 pt spacing.

Table width:

```text
540 pt
```

Columns:

| Column | x | Width | Alignment |
| --- | ---: | ---: | --- |
| Description | 36 | 282 | Left |
| Qty | 318 | 66 | Right |
| Rate | 384 | 90 | Right |
| Amount | 474 | 102 | Right |

Rules:

- Description wraps to multiple lines.
- Row height expands for wrapped descriptions.
- Numeric columns remain top-aligned within expanded rows.
- Table header repeats on continuation pages.
- Keep at least 120 pt free before starting totals; otherwise move totals to next page.

## Totals Block

Position:

```text
x: 342
width: 234
alignment: right
```

Label column:

```text
width: 126
```

Amount column:

```text
width: 108
```

Rows:

- Subtotal.
- Discount, when non-zero.
- Taxable amount, optional but useful for multi-component taxes.
- Tax components.
- Deposit/Paid, when non-zero.
- Total.
- Balance Due.

Balance Due should use the strongest weight.

## Notes, Terms, Signature

Full-width block:

```text
x: 36
width: 540
```

Order:

1. Notes.
2. Terms.
3. Signature.
4. Thank-you message.

Signature image:

```text
max width: 180 pt
max height: 60 pt
```

## Footer

Footer baseline:

```text
y: 760
```

Content:

- Page number, right aligned.
- Optional disclaimer or generated-by line, left aligned.

Keep footer text small but readable.

Suggested size:

```text
8 pt
```

## Typography

| Use | Size | Weight |
| --- | ---: | --- |
| Document type | 24 pt | Bold |
| Business name | 14 pt | Semibold |
| Section label | 9 pt | Semibold |
| Body text | 10 pt | Regular |
| Table header | 9 pt | Semibold |
| Table body | 9 pt | Regular |
| Total | 11 pt | Semibold |
| Balance due | 13 pt | Bold |
| Footer | 8 pt | Regular |

