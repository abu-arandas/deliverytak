import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/admin_provider.dart';
import 'product_management_page.dart';
import 'order_management_page.dart';
import 'user_management_page.dart';
import 'analytics_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        context.read<AdminProvider>().checkAdminStatus(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (auth.currentUser != null) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await auth.signOut();
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer2<AdminProvider, AuthProvider>(
        builder: (context, adminProvider, authProvider, child) {
          if (authProvider.currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please sign in to access the admin dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          }

          if (adminProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (adminProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    adminProvider.error!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      adminProvider.clearError();
                      adminProvider.checkAdminStatus(authProvider.currentUser!.id);
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (adminProvider.currentAdmin == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You do not have admin access',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Return to Home'),
                  ),
                ],
              ),
            );
          }

          return Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard),
                    label: Text('Overview'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.inventory),
                    label: Text('Products'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.shopping_cart),
                    label: Text('Orders'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people),
                    label: Text('Users'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.analytics),
                    label: Text('Analytics'),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _buildOverviewSection(),
                    _buildProductsSection(),
                    _buildOrdersSection(),
                    _buildUsersSection(),
                    _buildAnalyticsSection(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewSection() {
    return const Center(
      child: Text('Overview Section - Coming Soon'),
    );
  }

  Widget _buildProductsSection() {
    return const ProductManagementPage();
  }

  Widget _buildOrdersSection() {
    return const OrderManagementPage();
  }

  Widget _buildUsersSection() {
    return const UserManagementPage();
  }

  Widget _buildAnalyticsSection() {
    return const AnalyticsPage();
  }
}
