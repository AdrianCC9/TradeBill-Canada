# StoreKit Unlock Plan

## Product

Suggested product ID:

```text
com.tradebillcanada.lifetimeunlock
```

Suggested price:

```text
$19.99 CAD
```

Type:

```text
Non-consumable lifetime unlock
```

## Free Limit

Free users can create 3 total documents across estimates and invoices.

After the free limit:

- Allow viewing existing documents.
- Allow editing existing documents.
- Block creating new documents.
- Block PDF export.
- Show paywall with purchase, restore, and maybe-later actions.

This avoids trapping user data while still protecting the paid value.

## Required Behaviors

- Fetch product metadata from StoreKit.
- Start purchase flow.
- Handle success.
- Handle user cancellation.
- Handle pending purchase.
- Handle failure.
- Persist local unlock state.
- Re-check current entitlements on app launch.
- Restore purchases from Settings and paywall.
- Keep UI honest and clear.

## Suggested Swift Structure

```text
Store/
  PurchaseManager.swift
  ProductIDs.swift
  PurchaseState.swift
```

`PurchaseManager` responsibilities:

- Load products.
- Purchase lifetime unlock.
- Observe transaction updates.
- Verify transactions.
- Finish verified transactions.
- Restore purchases.
- Publish entitlement state.

## Local State

Use local persistence for quick app gating:

```text
hasLifetimeUnlock: Bool
lastEntitlementCheckAt: Date?
lastTransactionId: String?
```

On app launch:

1. Read local unlock state for immediate UI.
2. Ask StoreKit for current entitlements.
3. Update local state if entitlement is found.
4. Do not remove access aggressively when offline if a verified unlock was previously stored.

## Paywall Copy

```text
Unlock unlimited invoices and estimates.

One-time purchase. No subscription. No account required.

$19.99 CAD Lifetime
```

Buttons:

```text
Unlock Lifetime Access
Restore Purchase
Maybe Later
```

## StoreKit Testing

Before App Store Connect setup is complete, use a local StoreKit configuration in Xcode to test:

- First purchase.
- Restore purchase.
- Cancelled purchase.
- Failed purchase.
- Pending purchase.
- App relaunch after unlock.
- Offline app launch after prior unlock.

