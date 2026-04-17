// lib/app/widgets/custom_bottom_tabs.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/properties/controllers/properties_controller.dart';
import '../modules/tenants/controllers/tenants_controller.dart';
import '../modules/rentals/controllers/rentals_controller.dart';

import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/properties/views/properties_view.dart';
import '../modules/tenants/views/tenants_view.dart';
import '../modules/rentals/views/rentals_view.dart';

class CustomBottomTabs extends StatefulWidget {
  const CustomBottomTabs({super.key});

  @override
  State<CustomBottomTabs> createState() => _CustomBottomTabsState();
}

class _CustomBottomTabsState extends State<CustomBottomTabs> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // 🔥 Inject controllers manually (since we are not using GetPage navigation)
    Get.put(DashboardController());
    Get.put(PropertiesController());
    Get.put(TenantsController());
    Get.put(RentalsController());
  }

  final List<Widget> pages = const [
    DashboardView(),
    PropertiesView(),
    TenantsView(),
    RentalsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work_outlined),
              activeIcon: Icon(Icons.home_work),
              label: 'Properties',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Tenants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_outlined),
              activeIcon: Icon(Icons.attach_money),
              label: 'Rentals',
            ),
          ],
        ),
      ),
    );
  }
}
