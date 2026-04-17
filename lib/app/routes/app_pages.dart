import 'package:get/get.dart';
import 'package:rental_management/app/modules/payments/bindings/payments_binding.dart';
import 'package:rental_management/app/modules/payments/views/payment_view.dart';
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
  // Initial route when app launches
  static const INITIAL = Routes.HOME;

  // All GetX pages with their respective bindings
  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.PROPERTIES,
      page: () => const PropertiesView(),
      binding: PropertiesBinding(),
    ),
    GetPage(
      name: Routes.PAYMENTS,
      page: () => const PaymentView(),
      binding: PaymentsBinding(),
    ),
    GetPage(
      name: Routes.TENANTS,
      page: () => const TenantsView(),
      binding: TenantsBinding(),
    ),
    GetPage(
      name: Routes.RENTALS,
      page: () => const RentalsView(),
      binding: RentalsBinding(),
    ),
    GetPage(name: Routes.HOME, page: () => const CustomBottomTabs()),
  ];
}
