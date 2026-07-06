import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rental_management/app/modules/dashboard/views/dashboard_view.dart';
import 'package:rental_management/app/modules/properties/views/properties_view.dart';
import 'package:rental_management/app/modules/tenants/views/tenants_view.dart';
import 'package:rental_management/app/modules/rentals/views/rentals_view.dart';

class CustomBottomTabs extends StatefulWidget {
  const CustomBottomTabs({super.key});

  @override
  State<CustomBottomTabs> createState() => _CustomBottomTabsState();
}

class _CustomBottomTabsState extends State<CustomBottomTabs> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardView(),
    PropertiesView(),
    TenantsView(),
    RentalsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.home_work_outlined), selectedIcon: Icon(Icons.home_work), label: 'Properties'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Tenants'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Rentals'),
        ],
      ),
    );
  }
}
