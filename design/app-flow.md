# App Flow Map

This flow map defines the MVP navigation model for Figma and SwiftUI.

## First Launch

```text
Onboarding
  -> Business Setup
    -> Home Dashboard
```

Business setup can be skipped:

```text
Onboarding
  -> Business Setup
    -> Skip
      -> Home Dashboard
```

Before PDF export, if business name is missing:

```text
PDF Preview or Export Attempt
  -> Missing Business Name Reminder
    -> Business Setup
    -> Continue Anyway
```

## Main App

```text
Home Dashboard
  -> New Estimate
  -> New Invoice
  -> Document Detail
  -> Clients
  -> Settings
```

## Document Creation

```text
New Estimate / New Invoice
  -> Document Editor
    -> Client Picker
      -> Existing Client
      -> New Client Form
    -> Line Item Editor
    -> Tax Picker
    -> Signature Capture
    -> PDF Preview
      -> Share PDF
      -> Save to Files
```

## Estimate Conversion

```text
Estimate Detail
  -> PDF Preview
    -> Convert to Invoice
      -> New Invoice Editor
        -> Save
```

After conversion:

```text
Original estimate status = Converted
New invoice convertedFromEstimateId = original estimate id
```

## Free Limit

```text
Home Dashboard
  -> New Estimate / New Invoice
    -> If freeDocumentsCreated < 3
      -> Document Editor
    -> Else if hasLifetimeUnlock
      -> Document Editor
    -> Else
      -> Paywall
```

PDF export gating:

```text
PDF Preview
  -> Share or Save
    -> If under free limit or unlocked
      -> Share Sheet / File Exporter
    -> Else
      -> Paywall
```

## Settings

```text
Settings
  -> Business Profile
  -> Defaults
  -> Logo
  -> Signature
  -> Purchase / Restore
  -> Privacy Policy
  -> Tax Disclaimer
```

