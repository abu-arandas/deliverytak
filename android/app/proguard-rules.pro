# Keep Stripe classes
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }

# Keep Stripe model classes
-keep class com.stripe.android.model.** { *; }

# Keep Stripe API classes
-keep class com.stripe.android.networking.** { *; }

# Keep Stripe payment classes
-keep class com.stripe.android.view.** { *; }

# Keep Stripe payment method classes
-keep class com.stripe.android.model.PaymentMethod { *; }
-keep class com.stripe.android.model.PaymentMethodCreateParams { *; }

# Keep Stripe customer classes
-keep class com.stripe.android.model.Customer { *; }
-keep class com.stripe.android.model.CustomerSession { *; }

# Add dontwarn rules for missing push provisioning classes
-dontwarn com.stripe.android.pushProvisioning.** 