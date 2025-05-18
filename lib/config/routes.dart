import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/product_catalog_page.dart';
import '../pages/cart_page.dart';
import '../pages/checkout_page.dart';
import '../pages/orders_page.dart';
import '../pages/profile_page.dart';
import '../pages/wishlist_page.dart';
import '../pages/admin/dashboard_page.dart';
import '../pages/delivery_tracking_page.dart';
import '../pages/driver/delivery_details_page.dart';
import '../pages/driver/earnings_dashboard_page.dart';
import '../pages/driver/optimized_route_page.dart';
import '../pages/driver/batch_delivery_page.dart';
import '../pages/driver/batch_delivery_details_page.dart';
import '../pages/driver/schedule_page.dart';
import '../pages/driver/create_schedule_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String products = '/products';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String wishlist = '/wishlist';
  static const String admin = '/admin';
  static const String deliveryTracking = '/delivery-tracking';
  static const String driverDeliveryDetails = '/driver/delivery-details';
  static const String driverEarnings = '/driver/earnings';
  static const String optimizedRoute = '/driver/optimized-route';
  static const String driverBatchDeliveries = '/driver/batch-deliveries';
  static const String driverBatchDetails = '/driver/batch-details';
  static const String driverSchedule = '/driver/schedule';
  static const String createSchedule = '/driver/create-schedule';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomePage(),
        login: (context) => const LoginPage(),
        register: (context) => const RegisterPage(),
        products: (context) => const ProductCatalogPage(),
        cart: (context) => const CartPage(),
        checkout: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CheckoutPage(
            orderId: args['orderId'] as String,
            amount: args['amount'] as double,
            currency: args['currency'] as String,
          );
        },
        orders: (context) => const OrdersPage(),
        profile: (context) => const ProfilePage(),
        wishlist: (context) => const WishlistPage(),
        productDetails: (context) => const Scaffold(
              body: Center(
                child: Text('Product Details Page - Coming Soon'),
              ),
            ),
        admin: (context) => const AdminDashboardPage(),
        deliveryTracking: (context) => DeliveryTrackingPage(
              deliveryId: '', // You'll need to handle parameters differently
            ),
        driverDeliveryDetails: (context) => DriverDeliveryDetailsPage(
              deliveryId: '', // You'll need to handle parameters differently
            ),
        driverEarnings: (context) => const DriverEarningsDashboardPage(),
        optimizedRoute: (context) => const OptimizedRoutePage(
              deliveryId: '',
              waypoints: [],
              origin: GeoPoint(0, 0),
              destination: GeoPoint(0, 0),
            ),
        driverBatchDeliveries: (context) => const BatchDeliveryPage(),
        driverBatchDetails: (context) => BatchDeliveryDetailsPage(
              batchId: '', // You'll need to handle arguments differently
            ),
        driverSchedule: (context) => const SchedulePage(),
        createSchedule: (context) => const CreateSchedulePage(),
      };
}
