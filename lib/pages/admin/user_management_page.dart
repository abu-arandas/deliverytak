import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/admin_user.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminProvider>().fetchAllAdmins();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createAdmin(String userId, String email, String name) async {
    try {
      await context.read<AdminProvider>().createAdmin(
        userId: userId,
        email: email,
        name: name,
        roles: ['admin'],
      );
      await context.read<AdminProvider>().fetchAllAdmins();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin user created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateAdminRoles(String userId, List<String> roles) async {
    try {
      await context.read<AdminProvider>().updateAdminRoles(
            userId: userId,
            roles: roles,
          );
      await context.read<AdminProvider>().fetchAllAdmins();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin roles updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeAdmin(String userId) async {
    try {
      await context.read<AdminProvider>().removeAdmin(userId);
      await context.read<AdminProvider>().fetchAllAdmins();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin user removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCreateAdminDialog() {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Admin User'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _createAdmin(
                  DateTime.now().toString(), // Temporary ID
                  emailController.text,
                  nameController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showUpdateRolesDialog(AdminUser admin) {
    final roles = ['admin', 'product_manager', 'order_manager', 'user_manager'];
    final selectedRoles = List<String>.from(admin.roles);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Admin Roles'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: roles.map((role) {
            return CheckboxListTile(
              title: Text(role.toUpperCase()),
              value: selectedRoles.contains(role),
              onChanged: (selected) {
                setState(() {
                  if (selected == true) {
                    selectedRoles.add(role);
                  } else {
                    selectedRoles.remove(role);
                  }
                });
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateAdminRoles(admin.id, selectedRoles);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Management',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton.icon(
                onPressed: _showCreateAdminDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create Admin'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<AdminProvider>(
                  builder: (context, adminProvider, child) {
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
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              adminProvider.error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                adminProvider.clearError();
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    }

                    final admins = adminProvider.admins.where((admin) {
                      if (_searchQuery.isEmpty) return true;
                      return admin.email.toLowerCase().contains(_searchQuery) ||
                          admin.name.toLowerCase().contains(_searchQuery);
                    }).toList();

                    if (admins.isEmpty) {
                      return const Center(
                        child: Text('No users found'),
                      );
                    }

                    return ListView.builder(
                      itemCount: admins.length,
                      itemBuilder: (context, index) {
                        final admin = admins[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(admin.name[0].toUpperCase()),
                            ),
                            title: Text(admin.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(admin.email),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  children: admin.roles.map((role) {
                                    return Chip(
                                      label: Text(
                                        role.toUpperCase(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showUpdateRolesDialog(admin),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Remove Admin'),
                                        content: const Text(
                                          'Are you sure you want to remove this admin user?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Remove'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmed == true) {
                                      _removeAdmin(admin.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
