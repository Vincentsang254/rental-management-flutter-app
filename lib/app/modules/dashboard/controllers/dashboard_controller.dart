import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/modules/properties/controllers/properties_controller.dart';
import 'package:rental_management/app/modules/rentals/controllers/rentals_controller.dart';
import 'package:rental_management/app/modules/tenants/controllers/tenants_controller.dart';

class DashboardController extends GetxController {
  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  final TenantsController tenantsController = Get.find<TenantsController>();

  final RentalsController rentalsController = Get.find<RentalsController>();

  /// 📊 COUNTS
  int get totalProperties => propertiesController.properties.length;

  int get totalTenants => tenantsController.tenants.length;

  int get activeRentals => rentalsController.activeRentals.length;

  /// 📅 MONTHLY RENTALS
  List<Rental> get monthlyRentals => rentalsController.monthlyRentals;

  /// 💰 EXPECTED
  double get totalMonthlyExpected =>
      monthlyRentals.fold(0.0, (sum, r) => sum + r.expectedAmount);

  /// 💰 COLLECTED
  double get totalCollectedThisMonth =>
      monthlyRentals.fold(0.0, (sum, r) => sum + r.amountPaid);

  /// ⚠️ PARTIAL
  double get totalPartialThisMonth => monthlyRentals
      .where((r) => r.amountPaid > 0 && !r.isPaid)
      .fold(0.0, (sum, r) => sum + r.amountPaid);

  /// ❗ PENDING
  double get totalPendingThisMonth =>
      monthlyRentals.fold(0.0, (sum, r) => sum + r.remaining);

  /// 🚨 UNPAID COUNT
  int get unpaidRentalsThisMonth =>
      monthlyRentals.where((r) => !r.isPaid).length;

  /// 📊 COLLECTION RATE
  double get collectionRate {
    if (totalMonthlyExpected == 0) return 0;

    final rate = (totalCollectedThisMonth / totalMonthlyExpected) * 100;

    return rate > 100 ? 100 : rate;
  }
}
