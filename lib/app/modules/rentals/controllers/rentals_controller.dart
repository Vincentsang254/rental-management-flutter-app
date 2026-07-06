import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';
import '../../../services/service_local_storage.dart';

class RentalsController extends GetxController {
  final rentals = <Rental>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRentals();

    ever(rentals, (_) => saveRentals());
  }

  void loadRentals() {
    try {
      final saved = LocalStorageService.loadList('rentals');
      rentals.assignAll(saved.map((e) => Rental.fromMap(e)).toList());
    } catch (e) {
      rentals.clear();
      AppSnackbar.error('Failed to load rentals');
    }
  }

  void saveRentals() {
    LocalStorageService.saveList('rentals', rentals.map((e) => e.toMap()).toList());
  }

  /// Returns true on success, false on failure (e.g., property occupied).
  bool addRental(Rental rental) {
    if (rental.id.trim().isEmpty) {
      AppSnackbar.error('Invalid rental ID');
      return false;
    }

    if (isPropertyOccupied(rental.propertyId)) {
      AppSnackbar.error('Property is currently occupied by an active rental. Choose another property.');
      return false;
    }

    rentals.add(rental);
    AppSnackbar.success('Rental added');
    return true;
  }

  bool deleteRental(String id) {
    final before = rentals.length;
    rentals.removeWhere((r) => r.id == id);
    final removed = rentals.length < before;
    if (removed) AppSnackbar.success('Rental deleted');
    return removed;
  }

  void addPayment(String id, double amount) {
    final idx = rentals.indexWhere((r) => r.id == id);
    if (idx == -1) return;

    rentals[idx] = rentals[idx].addPayment(amount);
    AppSnackbar.success('Payment added');
  }

  List<Rental> get activeRentals => rentals.where((r) => r.isActive).toList();

  Rental? getById(String id) {
    try {
      return rentals.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Update or replace a rental. Returns true on success, false if blocked (e.g., occupancy).
  bool updateRental(Rental updated) {
    // Check occupancy: block if another active rental holds the same property
    if (isPropertyOccupied(updated.propertyId, excludeRentalId: updated.id)) {
      AppSnackbar.error('Property is currently occupied by another active rental. Choose a different property.');
      return false;
    }

    final idx = rentals.indexWhere((r) => r.id == updated.id);
    if (idx == -1) {
      rentals.add(updated);
    } else {
      rentals[idx] = updated;
    }

    AppSnackbar.success('Rental updated');
    return true;
  }

  /// Checks whether a property is occupied by an active rental.
  /// If excludeRentalId is provided, that rental is ignored (useful when editing).
  bool isPropertyOccupied(String propertyId, {String? excludeRentalId}) {
    return rentals.any((r) =>
        r.propertyId == propertyId &&
        r.isActive &&
        (excludeRentalId == null || r.id != excludeRentalId));
  }
}
