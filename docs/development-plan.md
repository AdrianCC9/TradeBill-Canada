# Development Plan

## Phase 1: Windows Prep

Complete before MacBook/Xcode development starts:

- Finalize product spec.
- Create Figma wireframes.
- Create app icon drafts.
- Write PDF template spec.
- Write tax preset table.
- Write App Store copy.
- Set up GitHub repository.
- Create privacy policy draft.
- Create terms/disclaimer draft.
- Create sample invoice PDFs manually in Figma or Canva for visual reference.

## Phase 2: Mac and Xcode Setup

When the MacBook is available:

1. Install current Xcode.
2. Clone this repository.
3. Create a new SwiftUI iOS app.
4. Set the bundle ID.

```text
com.tradebillcanada.app
```

5. Add the prepared docs/design assets to the Xcode project as needed.
6. Create the app folder structure.

```text
TradeBillCanada/
  App/
  Models/
  Views/
  ViewModels/
  Services/
  PDF/
  Store/
  Persistence/
  Assets/
  Utilities/
```

## Phase 3: MVP Build Order

1. App shell and navigation.
2. Business profile setup.
3. Local data models.
4. Client CRUD.
5. Document CRUD.
6. Line item editor.
7. Tax calculations.
8. Totals calculations.
9. PDF generation.
10. PDF preview and share.
11. Document search and statuses.
12. StoreKit lifetime unlock.
13. Paywall.
14. App icon and screenshots.
15. TestFlight testing.
16. App Store submission.

## Phase 4: Testing

Use [test-plan.md](test-plan.md) as the source of truth for manual and automated testing.

Minimum launch checks:

- Create estimate.
- Create invoice.
- Convert estimate to invoice.
- Edit client.
- Add and remove line items.
- Handle decimal quantities.
- Handle zero-tax invoice.
- Handle HST invoice.
- Handle GST/PST invoice.
- Handle long names and descriptions.
- Export/share PDF.
- Preserve local data across app close/reopen.
- Purchase unlock.
- Restore purchase.
- Enforce free limit behavior.
