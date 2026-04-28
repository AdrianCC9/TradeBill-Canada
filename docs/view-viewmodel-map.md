# View and ViewModel Map

This map defines the first SwiftUI screens and their state owners.

## App Root

| View | ViewModel | Responsibilities |
| --- | --- | --- |
| `AppRootView` | None or lightweight app state | Choose onboarding/business setup/home based on settings. |
| `OnboardingView` | None | Static first-launch copy and Get Started action. |
| `BusinessSetupView` | `BusinessProfileViewModel` | Create/edit business profile defaults. |

## Home

| View | ViewModel | Responsibilities |
| --- | --- | --- |
| `HomeDashboardView` | `HomeDashboardViewModel` | Recent docs, search/filter, unpaid total, draft count, new document actions. |
| `DocumentCardView` | None | Display document number, client, amount, due date, status. |
| `EmptyStateView` | None | Display empty document state and creation actions. |

## Documents

| View | ViewModel | Responsibilities |
| --- | --- | --- |
| `DocumentEditorView` | `DocumentEditorViewModel` | Manage document form, line items, totals, validation, save action. |
| `DocumentDetailView` | Optional | Read-only/detail actions for existing documents. |
| `LineItemEditorView` | Owned by document editor | Add/edit/delete/reorder line items. |
| `TaxPickerView` | Owned by document editor | Select preset, no-tax, or custom tax. |
| `SignatureCaptureView` | Owned by document editor or service | Capture/store signature image. |

## Clients

| View | ViewModel | Responsibilities |
| --- | --- | --- |
| `ClientListView` | Optional or `@Query` | Search and select clients. |
| `ClientEditorView` | `ClientEditorViewModel` | Create/edit client fields and validation. |
| `ClientPickerView` | Optional | Pick existing client or create a new one inline. |

## PDF

| View | ViewModel | Responsibilities |
| --- | --- | --- |
| `PDFPreviewView` | `PDFPreviewViewModel` | Generate preview, share/save, convert estimate, mark paid. |

## Paywall

| View | ViewModel | Responsibilities |
| --- | --- | --- |
| `PaywallView` | `PaywallViewModel` | Display product, start purchase, restore purchase, handle loading/error state. |

## Settings

| View | ViewModel | Responsibilities |
| --- | --- | --- |
| `SettingsView` | Optional | Link to business profile, defaults, purchase restore, policies. |
| `BusinessProfileSettingsView` | `BusinessProfileViewModel` | Edit profile, logo, signature, default tax and terms. |

## ViewModel Rules

- ViewModels can call services.
- ViewModels should not know PDF drawing details.
- ViewModels should not contain StoreKit transaction verification logic.
- ViewModels should expose display-ready state where practical.
- Views can format simple values, but calculations belong in services.

