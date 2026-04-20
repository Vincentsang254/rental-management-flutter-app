import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/services/service_local_storage.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

class RentalsController extends GetxController {
  final rentals = <Rental>[].obs;
  final isLoading = false.obs;

  String get currentMonth {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  @override
  void onInit() {
    super.onInit();
    loadRentals();

    ever(rentals, (_) => saveRentals());
  }

  /// 🔄 LOAD
  void loadRentals() {
    isLoading.value = true;

    try {
      final saved = LocalStorageService.loadList('rentals');

      rentals.assignAll(saved.map((e) => Rental.fromMap(e)).toList());
    } catch (e) {
      rentals.clear();
      AppSnackbar.error("Failed to load rentals");
    } finally {
      isLoading.value = false;
    }
  }

  /// 💾 SAVE
  void saveRentals() {
    LocalStorageService.saveList(
      'rentals',
      rentals.map((e) => e.toMap()).toList(),
    );
  }

  /// ➕ ADD RENTAL
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

  /// ❌ DELETE
  void deleteRental(String id) {
    rentals.removeWhere((r) => r.id == id);
    AppSnackbar.success("Rental deleted");
  }

  /// 💰 ADD PAYMENT (MAIN LOGIC)
  void updatePayment(String id, double amount) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

    final newAmount = rental.amountPaid + amount;

    rentals[index] = rental.copyWith(amountPaid: newAmount);

    AppSnackbar.success("Payment added");
  }

  /// 🔄 OPTIONAL QUICK TOGGLE (FULL / RESET)
  void togglePayment(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

    double next;

    if (rental.amountPaid == 0) {
      next = rental.expectedAmount; // mark fully paid
    } else {
      next = 0; // reset
    }

    rentals[index] = rental.copyWith(amountPaid: next);
  }

  /// 🚪 VACATE
  void vacateRental(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    rentals[index] = rentals[index].copyWith(
      isActive: false,
      amountPaid: 0, // reset correctly as double
    );

    AppSnackbar.success("Property vacated");
  }

  /// 📊 MONTH FILTER
  List<Rental> get monthlyRentals =>
      rentals.where((r) => r.month == currentMonth).toList();

  List<Rental> get activeRentals =>
      rentals.where((r) => r.isActive && r.month == currentMonth).toList();

  /// 📊 FINANCIAL HELPERS (NEW)
  double get totalExpected =>
      monthlyRentals.fold(0, (sum, r) => sum + r.expectedAmount);

  double get totalCollected =>
      monthlyRentals.fold(0, (sum, r) => sum + r.amountPaid);

  double get totalBalance => totalExpected - totalCollected;
}
