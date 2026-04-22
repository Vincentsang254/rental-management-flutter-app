import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/services/service_local_storage.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

class RentalsController extends GetxController {
  final rentals = <Rental>[].obs;
  final isLoading = false.obs;

  /// =========================
  /// 📅 CURRENT MONTH KEY
  /// =========================
  String get currentMonth {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  /// Helper to extract month key from rental
  String _monthKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  @override
  void onInit() {
    super.onInit();
    loadRentals();

    /// Auto-save whenever rentals change
    ever(rentals, (_) => saveRentals());
  }

  // =========================
  // 🔄 LOAD RENTALS
  // =========================
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

  // =========================
  // 💾 SAVE RENTALS
  // =========================
  void saveRentals() {
    LocalStorageService.saveList(
      'rentals',
      rentals.map((e) => e.toMap()).toList(),
    );
  }

  // =========================
  // ➕ ADD RENTAL
  // =========================
  void addRental(Rental rental) {
    if (rental.id.trim().isEmpty) {
      AppSnackbar.error("Invalid rental ID");
      return;
    }

    if (rental.expectedAmount <= 0) {
      AppSnackbar.error("Invalid rent amount");
      return;
    }

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

  // =========================
  // ❌ DELETE RENTAL
  // =========================
  void deleteRental(String id) {
    rentals.removeWhere((r) => r.id == id);
    AppSnackbar.success("Rental deleted");
  }

  // =========================
  // 💰 PAYMENT LOGIC
  // =========================
  void updatePayment(String id, double amount) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

    /// ❌ BLOCK if vacated
    if (!rental.isActive) {
      AppSnackbar.error("Cannot add payment. Tenant has vacated.");
      return;
    }

    /// ❌ Invalid amount
    if (amount <= 0) return;

    final newAmount = (rental.amountPaid + amount)
        .clamp(0, rental.expectedAmount * 2)
        .toDouble();

    rentals[index] = rental.copyWith(amountPaid: newAmount);

    AppSnackbar.success("Payment added");
  }

  // =========================
  // 🔄 TOGGLE PAYMENT
  // =========================
  void togglePayment(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

    /// ❌ Prevent toggle if vacated
    if (!rental.isActive) {
      AppSnackbar.error("Cannot modify payment. Tenant has vacated.");
      return;
    }

    final nextAmount = rental.amountPaid <= 0 ? rental.expectedAmount : 0.0;

    rentals[index] = rental.copyWith(amountPaid: nextAmount);
  }

  // =========================
  // 🚪 VACATE PROPERTY
  // =========================
  void vacateRental(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    rentals[index] = rentals[index].copyWith(isActive: false);

    AppSnackbar.success("Property vacated");
  }

  // =========================
  // 📅 MONTH FILTERING
  // =========================
  List<Rental> get monthlyRentals =>
      rentals.where((r) => _monthKey(r.billingMonth) == currentMonth).toList();

  List<Rental> get activeRentals => rentals
      .where((r) => r.isActive && _monthKey(r.billingMonth) == currentMonth)
      .toList();

  /// Cached alias
  List<Rental> get _monthly => monthlyRentals;

  // =========================
  // 📊 FINANCIAL HELPERS
  // =========================
  double get totalExpected =>
      _monthly.fold(0.0, (sum, r) => sum + r.expectedAmount);

  double get totalCollected =>
      _monthly.fold(0.0, (sum, r) => sum + r.amountPaid);

  double get totalBalance => _monthly.fold(0.0, (sum, r) => sum + r.remaining);

  int get unpaidCount => _monthly.where((r) => !r.isPaid).length;
}
