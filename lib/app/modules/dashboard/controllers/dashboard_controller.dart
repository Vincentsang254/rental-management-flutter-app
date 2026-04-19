import 'package:get/get.dart';
import 'package:rental_management/app/modules/properties/controllers/properties_controller.dart';
import 'package:rental_management/app/modules/rentals/controllers/rentals_controller.dart';
import 'package:rental_management/app/modules/tenants/controllers/tenants_controller.dart';

class DashboardController extends GetxController {
  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  final TenantsController tenantsController = Get.find<TenantsController>();

  final RentalsController rentalsController = Get.find<RentalsController>();

  /// 📊 Counts
  int get totalProperties => propertiesController.properties.length;

  int get totalTenants => tenantsController.tenants.length;

  int get activeRentals =>
      rentalsController.rentals.where((r) => r.isActive).length;

  /// 💰 Expected monthly rent
  double get totalMonthlyExpected => rentalsController.rentals
      .where((r) => r.isActive)
      .fold(0.0, (sum, r) => sum + r.expectedAmount);

  /// 💰 Collected (fully paid)
  double get totalCollectedThisMonth => rentalsController.rentals
      .where((r) => r.isActive && r.amountPaid == "paid")
      .fold(0.0, (sum, r) => sum + r.expectedAmount);

  /// ⚠️ Partial payments
  double get totalPartialThisMonth => rentalsController.rentals
      .where((r) => r.isActive && r.amountPaid == "partial")
      .fold(0.0, (sum, r) => sum + r.expectedAmount);

  /// ❗ Pending payments
  double get totalPendingThisMonth => rentalsController.rentals
      .where((r) => r.isActive && r.amountPaid == "unpaid")
      .fold(0.0, (sum, r) => sum + r.expectedAmount);

  /// 🚨 Unpaid count
  int get unpaidRentalsThisMonth => rentalsController.rentals
      .where((r) => r.isActive && r.amountPaid == "unpaid")
      .length;

  /// 📊 Collection rate
  double get collectionRate {
    if (totalMonthlyExpected == 0) return 0;
    return (totalCollectedThisMonth / totalMonthlyExpected) * 100;
  }
}
