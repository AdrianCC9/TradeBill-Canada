# Swift Folder Structure

Create this structure inside the Xcode app target when Stage 5 runs on Mac.

```text
TradeBillCanada/
  App/
    TradeBillCanadaApp.swift
    AppRootView.swift
    AppRouter.swift

  Models/
    AppSettings.swift
    BusinessProfile.swift
    Client.swift
    Document.swift
    LineItem.swift
    PurchaseState.swift
    TaxPreset.swift
    Enums.swift

  Views/
    Onboarding/
      OnboardingView.swift
      BusinessSetupView.swift
    Home/
      HomeDashboardView.swift
      DocumentCardView.swift
    Documents/
      DocumentEditorView.swift
      DocumentDetailView.swift
      LineItemEditorView.swift
      TaxPickerView.swift
      SignatureCaptureView.swift
    Clients/
      ClientListView.swift
      ClientEditorView.swift
      ClientPickerView.swift
    PDF/
      PDFPreviewView.swift
    Paywall/
      PaywallView.swift
    Settings/
      SettingsView.swift
      BusinessProfileSettingsView.swift
    Components/
      PrimaryButton.swift
      SecondaryButton.swift
      StatusBadge.swift
      MoneyTextField.swift
      EmptyStateView.swift

  ViewModels/
    BusinessProfileViewModel.swift
    DocumentEditorViewModel.swift
    HomeDashboardViewModel.swift
    ClientEditorViewModel.swift
    PDFPreviewViewModel.swift
    PaywallViewModel.swift

  Services/
    CalculationService.swift
    TaxPresetService.swift
    DocumentNumberService.swift
    DocumentConversionService.swift
    EntitlementGate.swift
    ImageStorageService.swift

  PDF/
    PDFRenderService.swift
    PDFRenderRequest.swift
    PDFLayout.swift
    PDFFilenameService.swift

  Store/
    ProductIDs.swift
    PurchaseManager.swift
    StoreError.swift

  Persistence/
    ModelContainerFactory.swift
    SeedData.swift

  Utilities/
    CurrencyFormatter.swift
    DateFormatterFactory.swift
    DecimalRounding.swift
    FilenameSanitizer.swift
```

## Test Target

```text
TradeBillCanadaTests/
  CalculationServiceTests.swift
  TaxPresetServiceTests.swift
  DocumentNumberServiceTests.swift
  DocumentConversionServiceTests.swift
  EntitlementGateTests.swift
  PDFFilenameServiceTests.swift
```

## Notes

- Keep `PDF/` separate from `Views/PDF/`; one is rendering logic, one is UI.
- Keep StoreKit code in `Store/`.
- Keep all money math outside SwiftUI views.
- Avoid placing model mutation directly inside large view bodies.

