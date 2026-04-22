import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/services/service_local_storage.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

class RentalsController extends GetxController {
  final rentals = <Rental>[].obs;
  final isLoading = false.obs;

  /// 📅 Current Month Key (YYYY-MM)
  String get currentMonth {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
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

    if (amount <= 0) return;

    final newAmount = (rental.amountPaid + amount)
        .clamp(0, rental.expectedAmount * 2)
        .toDouble();

    rentals[index] = rental.copyWith(amountPaid: newAmount);

    AppSnackbar.success("Payment added");
  }

  // =========================
  // 🔄 TOGGLE PAYMENT (QUICK ACTION)
  // =========================
  void togglePayment(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

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
  List<Rental> get monthlyRentals => rentals.where((r) {
    final monthKey =
        "${r.billingMonth.year}-${r.billingMonth.month.toString().padLeft(2, '0')}";
    return monthKey == currentMonth;
  }).toList();

  List<Rental> get activeRentals => rentals.where((r) {
    final monthKey =
        "${r.billingMonth.year}-${r.billingMonth.month.toString().padLeft(2, '0')}";
    return r.isActive && monthKey == currentMonth;
  }).toList();

  // =========================
  // 📊 FINANCIAL HELPERS
  // =========================
  double get totalExpected =>
      monthlyRentals.fold(0.0, (sum, r) => sum + r.expectedAmount);

  double get totalCollected =>
      monthlyRentals.fold(0.0, (sum, r) => sum + r.amountPaid);

  double get totalBalance =>
      monthlyRentals.fold(0.0, (sum, r) => sum + r.remaining);

  int get unpaidCount => monthlyRentals.where((r) => !r.isPaid).length;
}
