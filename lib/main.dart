import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:rental_management/app/theme/app_theme.dart';
import 'package:rental_management/app/services/service_local_storage.dart';

import 'app/modules/dashboard/controllers/dashboard_controller.dart';
import 'app/modules/properties/controllers/properties_controller.dart';
import 'app/modules/rentals/controllers/rentals_controller.dart';
import 'app/modules/tenants/controllers/tenants_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  Get.put(PropertiesController(), permanent: true);
  Get.put(TenantsController(), permanent: true);
  Get.put(RentalsController(), permanent: true);
  Get.put(DashboardController(), permanent: true);

  runApp(const RentalManagementApp());
}

class RentalManagementApp extends StatelessWidget {
  const RentalManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rental Management',
      theme: AppTheme.lightTheme(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
