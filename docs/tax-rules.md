# Canadian Tax Rules

This document defines the MVP tax presets for TradeBill Canada. It is a product and engineering reference, not tax advice.

Last reviewed against official sources: 2026-04-28.

## Disclaimer

Use this disclaimer in Settings and optionally in the PDF footer:

```text
Tax calculations are provided for convenience only. Users are responsible for confirming applicable tax requirements.
```

## Important Product Notes

- Tax requirements depend on registration status, customer, place of supply, service type, exemptions, and province-specific rules.
- The app should let users choose `No tax` and `Custom percentage`.
- Store tax presets as editable configuration so rates can be updated without rewriting calculation code.
- Use Decimal calculations and round currency amounts to the nearest cent.
- Quebec should display GST and QST as separate components, while also allowing a combined display total.
- British Columbia, Manitoba, and Saskatchewan should display GST and provincial tax components separately.

## MVP Presets

| Province/Territory | Preset label | Components | Combined rate |
| --- | --- | --- | --- |
| Alberta | GST 5% | GST 5% | 5% |
| British Columbia | GST 5% + PST 7% | GST 5%, PST 7% | 12% |
| Manitoba | GST 5% + RST 7% | GST 5%, RST 7% | 12% |
| New Brunswick | HST 15% | HST 15% | 15% |
| Newfoundland and Labrador | HST 15% | HST 15% | 15% |
| Northwest Territories | GST 5% | GST 5% | 5% |
| Nova Scotia | HST 14% | HST 14% | 14% |
| Nunavut | GST 5% | GST 5% | 5% |
| Ontario | HST 13% | HST 13% | 13% |
| Prince Edward Island | HST 15% | HST 15% | 15% |
| Quebec | GST 5% + QST 9.975% | GST 5%, QST 9.975% | 14.975% |
| Saskatchewan | GST 5% + PST 6% | GST 5%, PST 6% | 11% |
| Yukon | GST 5% | GST 5% | 5% |

## Correction From Initial MVP Brief

The initial planning brief listed Nova Scotia as HST 15%. Current CRA guidance states that Nova Scotia HST decreased to 14% as of April 1, 2025. Use 14% for MVP defaults unless this changes before launch.

## Calculation Behavior

Tax base:

```text
subtotal - discount
```

Component tax:

```text
roundToCent(taxBase * componentRate)
```

Tax amount:

```text
sum(componentTax)
```

Total:

```text
taxBase + taxAmount
```

For provinces with multiple components, store each component and its amount so PDFs can show transparent tax rows:

```text
GST 5%
PST 7%
```

## Custom Presets

Add:

```text
No tax
Custom percentage
```

For custom percentage:

- User enters label.
- User enters percentage.
- App stores the custom tax label and rate on the document snapshot.

## Official Sources Checked

- CRA GST/HST calculator and rates: https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/gst-hst-businesses/charge-collect-which-rate/calculator.html
- Revenu Quebec taxable supplies: https://www.revenuquebec.ca/en/businesses/consumption-taxes/gsthst-and-qst/basic-rules-for-applying-the-gsthst-and-qst/types-of-supplies/taxable-supplies/
- Revenu Quebec calculating the taxes: https://www.revenuquebec.ca/en/businesses/consumption-taxes/gsthst-and-qst/collecting-gst-and-qst/calculating-the-taxes/
- British Columbia small business guide to PST: https://www2.gov.bc.ca/gov/content/taxes/sales-taxes/pst/publications/small-business-guide
- Manitoba Retail Sales Tax: https://www.gov.mb.ca/finance/taxation/taxes/print,retail.html
- Nova Scotia HST transition notice: https://notices.novascotia.ca/files/ftb-taxation/ftb-tn-hst-rate-decrease-transitional-rules-2024-12-20.pdf

