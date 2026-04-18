
import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import '../../../services/service_local_storage.dart';

class RentalsController extends GetxController {
  final rentals = <Rental>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRentals();

    // ✅ auto-save whenever list changes
    ever(rentals, (_) => saveRentals());
  }

  /// Load rentals from local storage
  void loadRentals() {
    final saved = LocalStorageService.loadList('rentals');

    try {
      rentals.assignAll(
        saved.map((e) => Rental.fromMap(e)).toList(),
      );
    } catch (e) {
      rentals.clear();
    }
  }

  /// Save rentals locally
  void saveRentals() {
    LocalStorageService.saveList(
      'rentals',
      rentals.map((e) => e.toMap()).toList(),
    );
  }

  /// ✅ Add rental (PREVENT double booking)
  void addRental(Rental rental) {
    // 🚫 Check if property already occupied
    final propertyOccupied = rentals.any(
      (r) => r.propertyId == rental.propertyId && r.isActive,
    );

    if (propertyOccupied) {
      Get.snackbar("Error", "Property is already occupied");
      return;
    }

    // 🚫 Check if tenant already renting somewhere
    final tenantActive = rentals.any(
      (r) => r.tenantId == rental.tenantId && r.isActive,
    );

    if (tenantActive) {
      Get.snackbar("Error", "Tenant already has an active rental");
      return;
    }

    rentals.add(rental);

    Get.snackbar("Success", "Rental assigned successfully");
  }

  /// Delete rental
  void deleteRental(String id) {
    rentals.removeWhere((r) => r.id == id);

    Get.snackbar("Success", "Rental deleted");
  }

  /// 🔥 Mark rent paid/unpaid
  void togglePayment(String id) {
    final index = rentals.indexWhere((r) => r.id == id);

    if (index == -1) return;

    final rental = rentals[index];

    rentals[index] = rental.copyWith(isPaid: !rental.isPaid);
  }

  /// 🔥 Vacate property
  void vacateRental(String id) {
    final index = rentals.indexWhere((r) => r.id == id);

    if (index == -1) return;

    final rental = rentals[index];

    rentals[index] = rental.copyWith(isActive: false);

    Get.snackbar("Success", "Property vacated");
  }

  /// 🔥 Helper: get rentals by property
  List<Rental> getByProperty(String propertyId) {
    return rentals
        .where((r) => r.propertyId == propertyId && r.isActive)
        .toList();
  }

  /// 🔥 Helper: get rentals by tenant
  List<Rental> getByTenant(String tenantId) {
    return rentals
        .where((r) => r.tenantId == tenantId && r.isActive)
        .toList();
  }

  /// 🔥 Check if tenant has active rental
  bool isTenantActive(String tenantId) {
    return rentals.any(
      (r) => r.tenantId == tenantId && r.isActive,
    );
  }
}

