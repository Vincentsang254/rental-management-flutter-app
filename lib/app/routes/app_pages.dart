import 'package:get/get.dart';
import 'package:rental_management/app/widgets/custom_bottom_tabs.dart';

import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';

import '../modules/properties/bindings/properties_binding.dart';
import '../modules/properties/views/properties_view.dart';

import '../modules/tenants/bindings/tenants_binding.dart';
import '../modules/tenants/views/tenants_view.dart';

import '../modules/rentals/bindings/rentals_binding.dart';
import '../modules/rentals/views/rentals_view.dart';

import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    /// 🏠 HOME (no animation needed)
    GetPage(
      name: Routes.HOME,
      page: () => const CustomBottomTabs(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// 📊 DASHBOARD
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// 🏠 PROPERTIES
    GetPage(
      name: Routes.PROPERTIES,
      page: () => const PropertiesView(),
      binding: PropertiesBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// 👤 TENANTS
    GetPage(
      name: Routes.TENANTS,
      page: () => const TenantsView(),
      binding: TenantsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// 💰 RENTALS
    GetPage(
      name: Routes.RENTALS,
      page: () => const RentalsView(),
      binding: RentalsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
