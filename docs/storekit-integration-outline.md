# StoreKit Integration Outline

This is the Swift implementation outline for the lifetime unlock.

## Product ID

```text
com.tradebillcanada.lifetimeunlock
```

## Product Type

```text
Non-consumable
```

## PurchaseManager Responsibilities

```text
loadProducts()
purchaseLifetimeUnlock()
restorePurchases()
listenForTransactionUpdates()
refreshEntitlements()
```

## App Launch Flow

1. Load local `PurchaseState`.
2. Use local `hasLifetimeUnlock` for immediate UI.
3. Start StoreKit entitlement refresh.
4. If a verified lifetime unlock is found, update local state.
5. Keep previously verified unlock available if offline.

## Paywall Flow

```text
PaywallView
  -> PaywallViewModel
    -> PurchaseManager.purchaseLifetimeUnlock()
      -> verified transaction
        -> update PurchaseState
        -> dismiss paywall
```

## Restore Flow

```text
Restore Purchase
  -> PurchaseManager.restorePurchases()
  -> refreshEntitlements()
  -> update PurchaseState
```

## Transaction Update Listener

Start a transaction listener at app launch.

Responsibilities:

- Verify transaction.
- Check product ID.
- Mark lifetime unlock true.
- Finish transaction.

## Error States

Handle:

- User cancelled.
- Pending purchase.
- Product unavailable.
- Verification failed.
- Network unavailable.
- StoreKit error.

UI should use plain language:

```text
Purchase cancelled.
Purchase is pending approval.
Unable to complete purchase. Please try again.
```

## Local StoreKit Testing

Create a local StoreKit configuration in Xcode for:

- Successful purchase.
- Cancelled purchase.
- Failed purchase.
- Pending purchase.
- Restore purchase.

Stage 5 cannot fully complete until this is configured and run on Mac/Xcode.

