import 'package:get/get.dart';
import 'package:rental_management/app/modules/properties/controllers/properties_controller.dart';
import 'package:rental_management/app/modules/rentals/controllers/rentals_controller.dart';
import 'package:rental_management/app/modules/tenants/controllers/tenants_controller.dart';

class DashboardController extends GetxController {
  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  final TenantsController tenantsController =
      Get.find<TenantsController>();

  final RentalsController rentalsController =
      Get.find<RentalsController>();

  /// 📊 COUNTS
  int get totalProperties => propertiesController.properties.length;

  int get totalTenants => tenantsController.tenants.length;

  int get activeRentals =>
      rentalsController.activeRentals.length;

  /// 📅 CURRENT MONTH RENTALS
  List get monthlyRentals => rentalsController.monthlyRentals;

  /// 💰 EXPECTED RENT
  double get totalMonthlyExpected => monthlyRentals
      .fold(0.0, (sum, r) => sum + r.expectedAmount);

  /// 💰 TOTAL COLLECTED
  double get totalCollectedThisMonth => monthlyRentals
      .fold(0.0, (sum, r) => sum + r.amountPaid);

  /// ⚠️ PARTIAL PAYMENTS
  double get totalPartialThisMonth => monthlyRentals
      .where((r) => r.amountPaid > 0 && r.amountPaid < r.expectedAmount)
      .fold(0.0, (sum, r) => sum + r.amountPaid);

  /// ❗ PENDING (UNPAID BALANCE)
  double get totalPendingThisMonth => monthlyRentals
      .fold(
        0.0,
        (sum, r) => sum + (r.expectedAmount - r.amountPaid),
      );

  /// 🚨 UNPAID RENTALS COUNT
  int get unpaidRentalsThisMonth => monthlyRentals
      .where((r) => r.amountPaid == 0)
      .length;

  /// 📊 COLLECTION RATE
  double get collectionRate {
    if (totalMonthlyExpected == 0) return 0;

    return (totalCollectedThisMonth / totalMonthlyExpected) * 100;
  }
}