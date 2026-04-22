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

  /// =========================
  /// 📊 COUNTS
  /// =========================
  int get totalProperties => propertiesController.properties.length;

  int get totalTenants => tenantsController.tenants.length;

  int get activeRentals => rentalsController.activeRentals.length;

  /// =========================
  /// 📅 MONTHLY DATA (CACHED)
  /// =========================
  List<Rental> get _monthly => rentalsController.monthlyRentals;

  /// Public access (if needed)
  List<Rental> get monthlyRentals => _monthly;

  /// =========================
  /// 💰 FINANCIALS
  /// =========================
  double get totalMonthlyExpected =>
      _monthly.fold(0.0, (sum, r) => sum + r.expectedAmount);

  double get totalCollectedThisMonth =>
      _monthly.fold(0.0, (sum, r) => sum + r.amountPaid);

  double get totalPartialThisMonth => _monthly
      .where((r) => r.amountPaid > 0 && !r.isPaid)
      .fold(0.0, (sum, r) => sum + r.amountPaid);

  double get totalPendingThisMonth =>
      _monthly.fold(0.0, (sum, r) => sum + r.remaining);

  double get totalOverpaidThisMonth =>
      _monthly.fold(0.0, (sum, r) => sum + r.overpaid);

  /// =========================
  /// 🚨 ALERTS / LISTS
  /// =========================

  /// ❗ All unpaid (including partial)
  List<Rental> get unpaidRentals => _monthly.where((r) => !r.isPaid).toList();

  /// ❗ Fully unpaid only
  List<Rental> get fullyUnpaidRentals =>
      _monthly.where((r) => r.amountPaid == 0).toList();

  /// ⚠️ Partial payments only
  List<Rental> get partialRentals =>
      _monthly.where((r) => r.amountPaid > 0 && !r.isPaid).toList();

  int get unpaidRentalsThisMonth => unpaidRentals.length;

  /// =========================
  /// 📊 COLLECTION RATE
  /// =========================
  double get collectionRate {
    if (totalMonthlyExpected == 0) return 0;

    final rate = (totalCollectedThisMonth / totalMonthlyExpected) * 100;

    return rate > 100 ? 100 : rate;
  }
}
