import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'config/firebase_options.dart';

import 'services/auth_service.dart';
import 'services/delivery_service.dart';
import 'services/driver_service.dart';
import 'services/earnings_service.dart';
import 'services/route_optimization_service.dart';
import 'services/batch_delivery_service.dart';
import 'services/delivery_schedule_service.dart';
import 'services/schedule_conflict_service.dart';
import 'services/notification_service.dart';

import 'providers/auth_provider.dart';
import 'providers/delivery_provider.dart';
import 'providers/driver_provider.dart';
import 'providers/earnings_provider.dart';
import 'providers/route_optimization_provider.dart';
import 'providers/batch_delivery_provider.dart';
import 'providers/delivery_schedule_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();

  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('main');

  // Initialize notification service
  final notificationService = NotificationService(logger);
  await notificationService.initialize();

  // Initialize services
  final authService = AuthService(null, logger);
  final driverService = DriverService(null, logger);
  final deliveryService = DeliveryService(firestore: FirebaseFirestore.instance, logger: logger);
  final earningsService = EarningsService(firestore: FirebaseFirestore.instance, logger: logger);
  final batchDeliveryService = BatchDeliveryService(firestore: FirebaseFirestore.instance, logger: logger);
  final routeOptimizationService = RouteOptimizationService(
    firestore: FirebaseFirestore.instance,
    googleMapsApiKey: dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '',
    logger: logger,
  );
  final scheduleConflictService = ScheduleConflictService(null, logger);
  final deliveryScheduleService = DeliveryScheduleService(null, logger);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => DriverProvider(driverService, logger),
        ),
        ChangeNotifierProvider(
          create: (_) => DeliveryProvider(deliveryService),
        ),
        ChangeNotifierProvider(
          create: (_) => EarningsProvider(earningsService),
        ),
        ChangeNotifierProvider(
          create: (_) => BatchDeliveryProvider(batchDeliveryService),
        ),
        ChangeNotifierProvider(
          create: (_) => RouteOptimizationProvider(
            service: routeOptimizationService,
            logger: logger,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DeliveryScheduleProvider(
            deliveryScheduleService,
            scheduleConflictService,
            notificationService,
            logger,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'DeliveryTak',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
      ),
    ),
  );
}
