import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_management/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:rental_management/app/modules/properties/controllers/properties_controller.dart';
import 'package:rental_management/app/modules/rentals/controllers/rentals_controller.dart';
import 'package:rental_management/app/modules/tenants/controllers/tenants_controller.dart';
import 'package:rental_management/app/services/service_local_storage.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized (required before async work in main)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage (SharedPreferences)
  await LocalStorageService.init();

  // 🔥 Register all controllers globally
Get.put(PropertiesController(), permanent: true);
Get.put(TenantsController(), permanent: true);
Get.put(RentalsController(), permanent: true);   // ✅ BEFORE Dashboard
Get.put(DashboardController(), permanent: true); // ✅ LAST

  // Run the app
  runApp(const RentalManagementApp());
}

class RentalManagementApp extends StatelessWidget {
  const RentalManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rental Management',

      // Global theme
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true, // optional, for modern Material 3 look
      ),

      // Initial route when app launches
      initialRoute: AppPages.INITIAL,

      // All app routes
      getPages: AppPages.routes,
    );
  }
}
