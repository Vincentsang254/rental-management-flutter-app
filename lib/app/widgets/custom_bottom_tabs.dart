import 'package:flutter/material.dart';

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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,

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
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Rentals',
          ),

        ],
      ),
    );
  }
}
