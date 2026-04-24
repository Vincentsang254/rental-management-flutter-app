import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';

import '../../properties/controllers/properties_controller.dart';
import '../../rentals/controllers/rentals_controller.dart';
import '../../tenants/controllers/tenants_controller.dart';

class DashboardController extends GetxController {
  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  final TenantsController tenantsController =
      Get.find<TenantsController>();

  final RentalsController rentalsController =
      Get.find<RentalsController>();

  /// =========================
  /// COUNTS
  /// =========================

  int get totalProperties =>
      propertiesController.properties.length;

  int get totalTenants =>
      tenantsController.tenants.length;

  int get activeRentals =>
      rentalsController.activeRentals.length;

  int get vacantUnits =>
      totalProperties - activeRentals;

  /// =========================
  /// OCCUPANCY
  /// =========================

  double get occupancyRate {
    if (totalProperties == 0) {
      return 0;
    }

    return
        (activeRentals /
                totalProperties) *
            100;
  }

  /// =========================
  /// ACTIVE RENTALS THIS MONTH
  /// =========================

  List<Rental> get _monthly =>
      rentalsController.activeRentals;

  List<Rental> get monthlyRentals =>
      _monthly;

  /// =========================
  /// FINANCIALS
  /// =========================

  /// Expected monthly rent
  double get totalMonthlyExpected =>
      _monthly.fold(
        0.0,
        (sum, r) =>
            sum +
            r.expectedAmount,
      );

  /// All cash received
  /// Includes overpayments
  double get totalCollectedThisMonth =>
      _monthly.fold(
        0.0,
        (sum, r) =>
            sum + r.amountPaid,
      );

  /// Only rent due covered
  /// (caps each rental at expected)
  double get collectedAgainstRent =>
      _monthly.fold(
        0.0,
        (
          sum,
          r,
        ) =>
            sum +
            (
              r.amountPaid >
                      r.expectedAmount
                  ? r.expectedAmount
                  : r.amountPaid
            ),
      );

  /// Remaining balances
  double get totalPendingThisMonth =>
      _monthly.fold(
        0.0,
        (sum, r) =>
            sum +
            r.remaining,
      );

  /// Credit from overpayments
  double get totalOverpaidThisMonth =>
      _monthly.fold(
        0.0,
        (sum, r) =>
            sum +
            r.overpaid,
      );

  /// Partial collections only
  double get totalPartialThisMonth =>
      partialRentals.fold(
        0.0,
        (sum, r) =>
            sum +
            r.amountPaid,
      );

  /// =========================
  /// RENT STATUS
  /// =========================

  /// Fully unpaid
  List<Rental> get unpaidRentals =>
      _monthly.where(
        (r) =>
            r.amountPaid == 0,
      ).toList();

  /// Partially paid
  List<Rental> get partialRentals =>
      _monthly.where(
        (r) =>
            r.amountPaid >
                0 &&
            r.amountPaid <
                r.expectedAmount,
      ).toList();

  /// Exactly paid
  List<Rental> get paidRentals =>
      _monthly.where(
        (r) =>
            r.amountPaid ==
            r.expectedAmount,
      ).toList();

  /// Paid above rent
  List<Rental> get overpaidRentals =>
      _monthly.where(
        (r) =>
            r.amountPaid >
            r.expectedAmount,
      ).toList();

  int get unpaidCount =>
      unpaidRentals.length;

  int get partialCount =>
      partialRentals.length;

  int get paidCount =>
      paidRentals.length;

  int get overpaidCount =>
      overpaidRentals.length;

  /// Any rent not fully settled
  int get unsettledCount =>
      unpaidCount +
      partialCount;

  /// =========================
  /// COLLECTION RATES
  /// =========================

  /// Can exceed 100%
  /// Shows actual cash received
  double get grossCollectionRate {
    if (totalMonthlyExpected == 0) {
      return 0;
    }

    return
        (totalCollectedThisMonth /
                totalMonthlyExpected) *
            100;
  }

  /// Fulfillment progress
  /// Capped at 100
  double get collectionRate {
    if (totalMonthlyExpected == 0) {
      return 0;
    }

    final rate =
        (collectedAgainstRent /
                totalMonthlyExpected) *
            100;

    return rate > 100
        ? 100
        : rate;
  }

  /// =========================
  /// QUICK SUMMARY FLAGS
  /// =========================

  bool get hasArrears =>
      totalPendingThisMonth > 0;

  bool get hasCredits =>
      totalOverpaidThisMonth > 0;

  bool get hasPartialPayments =>
      partialCount > 0;
}