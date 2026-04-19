// rentals_controller.dart

import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';
import '../../../services/service_local_storage.dart';

class RentalsController extends GetxController {
  final rentals = <Rental>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRentals();

    /// 🔥 Auto-save (optimized)
    debounce(
      rentals,
      (_) => saveRentals(),
      time: const Duration(milliseconds: 500),
    );
  }

  /// 🔄 Load rentals
  void loadRentals() {
    isLoading.value = true;

    try {
      final saved = LocalStorageService.loadList('rentals');

      rentals.assignAll(
        saved.map((e) => Rental.fromMap(e)).toList(),
      );
    } catch (e) {
      rentals.clear();
      AppSnackbar.error("Failed to load rentals");
    } finally {
      isLoading.value = false;
    }
  }

  /// 💾 Save rentals
  void saveRentals() {
    LocalStorageService.saveList(
      'rentals',
      rentals.map((e) => e.toMap()).toList(),
    );
  }

  /// ➕ Add rental (prevents double booking)
  void addRental(Rental rental) {
    final propertyOccupied = rentals.any(
      (r) => r.propertyId == rental.propertyId && r.isActive,
    );

    if (propertyOccupied) {
      AppSnackbar.error("Property is already occupied");
      return;
    }

    final tenantActive = rentals.any(
      (r) => r.tenantId == rental.tenantId && r.isActive,
    );

    if (tenantActive) {
      AppSnackbar.error("Tenant already has an active rental");
      return;
    }

    rentals.add(rental);

    AppSnackbar.success("Rental assigned successfully");
  }

  /// 🗑 Delete rental
  void deleteRental(String id) {
    rentals.removeWhere((r) => r.id == id);

    AppSnackbar.success("Rental deleted");
  }

  /// 💰 Cycle payment status
  void togglePayment(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

    String nextStatus;

    switch (rental.amountPaid) {
      case "unpaid":
        nextStatus = "partial";
        break;
      case "partial":
        nextStatus = "paid";
        break;
      default:
        nextStatus = "unpaid";
    }

    rentals[index] = rental.copyWith(amountPaid: nextStatus);
  }

  /// 🚪 Vacate rental
  void vacateRental(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

    rentals[index] = rental.copyWith(
      isActive: false,
      amountPaid: "unpaid", // reset when vacated
    );

    AppSnackbar.success("Property vacated");
  }

  /// 🔍 Get active rentals
  List<Rental> get activeRentals =>
      rentals.where((r) => r.isActive).toList();

  /// 🔍 Get inactive rentals
  List<Rental> get inactiveRentals =>
      rentals.where((r) => !r.isActive).toList();

  /// 🔍 Rentals by property
  List<Rental> getByProperty(String propertyId) {
    return rentals
        .where((r) => r.propertyId == propertyId && r.isActive)
        .toList();
  }

  /// 🔍 Rentals by tenant
  List<Rental> getByTenant(String tenantId) {
    return rentals
        .where((r) => r.tenantId == tenantId && r.isActive)
        .toList();
  }

  /// ✅ Check if tenant has active rental
  bool isTenantActive(String tenantId) {
    return rentals.any(
      (r) => r.tenantId == tenantId && r.isActive,
    );
  }

  /// 📊 Helpers for UI

  int get totalActive => activeRentals.length;

  int get totalPaid =>
      rentals.where((r) => r.amountPaid == "paid").length;

  int get totalPartial =>
      rentals.where((r) => r.amountPaid == "partial").length;

  int get totalUnpaid =>
      rentals.where((r) => r.amountPaid == "unpaid").length;
}