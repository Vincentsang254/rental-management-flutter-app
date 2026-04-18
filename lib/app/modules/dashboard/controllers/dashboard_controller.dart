import 'package:get/get.dart';
import 'package:rental_management/app/modules/properties/controllers/properties_controller.dart';
import 'package:rental_management/app/modules/rentals/controllers/rentals_controller.dart';
import 'package:rental_management/app/modules/tenants/controllers/tenants_controller.dart';

class DashboardController extends GetxController {
  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  final TenantsController tenantsController = Get.find<TenantsController>();

  final RentalsController rentalsController = Get.find<RentalsController>();

  int get totalProperties => propertiesController.properties.length;

  int get totalTenants => tenantsController.tenants.length;

  /// Only ACTIVE rentals
  int get activeRentals =>
      rentalsController.rentals.where((r) => r.isActive).length;

  /// 💰 Total expected monthly rent (active rentals only)
  double get totalMonthlyExpected => rentalsController.rentals
      .where((r) => r.isActive)
      .fold(0.0, (sum, r) => sum + r.rentAmount);

  /// 💰 Total collected THIS MONTH (simple: isPaid = true)
  double get totalCollectedThisMonth => rentalsController.rentals
      .where((r) => r.isActive && r.isPaid)
      .fold(0.0, (sum, r) => sum + r.rentAmount);

  /// ❗ Pending rent THIS MONTH
  double get totalPendingThisMonth => rentalsController.rentals
      .where((r) => r.isActive && !r.isPaid)
      .fold(0.0, (sum, r) => sum + r.rentAmount);

  /// 🚨 Rentals not paid this month
  int get unpaidRentalsThisMonth =>
      rentalsController.rentals.where((r) => r.isActive && !r.isPaid).length;

  /// 📊 Collection rate
  double get collectionRate {
    if (totalMonthlyExpected == 0) return 0;

    return (totalCollectedThisMonth / totalMonthlyExpected) * 100;
  }

  void resetMonthlyPayments() {
    rentalsController.rentals.value = rentalsController.rentals.map((r) {
      return r.copyWith(isPaid: false);
    }).toList();
  }
}
