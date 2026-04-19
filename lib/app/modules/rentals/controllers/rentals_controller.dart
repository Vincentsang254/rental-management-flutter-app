import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';
import '../../../services/service_local_storage.dart';

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

  void saveRentals() {
    LocalStorageService.saveList(
      'rentals',
      rentals.map((e) => e.toMap()).toList(),
    );
  }

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

  void deleteRental(String id) {
    rentals.removeWhere((r) => r.id == id);
    AppSnackbar.success("Rental deleted");
  }

  /// 🔁 Cycle payment status
  void togglePayment(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final rental = rentals[index];

    String next;

    switch (rental.amountPaid) {
      case "unpaid":
        next = "partial";
        break;
      case "partial":
        next = "paid";
        break;
      default:
        next = "unpaid";
    }

    rentals[index] = rental.copyWith(amountPaid: next);
  }

  void vacateRental(String id) {
    final index = rentals.indexWhere((r) => r.id == id);
    if (index == -1) return;

    rentals[index] = rentals[index].copyWith(
      isActive: false,
      amountPaid: "unpaid",
    );

    AppSnackbar.success("Property vacated");
  }

  /// 📊 MONTH FILTERED HELPERS
  List<Rental> get activeRentals =>
      rentals.where((r) => r.isActive && r.month == currentMonth).toList();

  List<Rental> get monthlyRentals =>
      rentals.where((r) => r.month == currentMonth).toList();

  int get totalPaid =>
      monthlyRentals.where((r) => r.amountPaid == "paid").length;

  int get totalPartial =>
      monthlyRentals.where((r) => r.amountPaid == "partial").length;

  int get totalUnpaid =>
      monthlyRentals.where((r) => r.amountPaid == "unpaid").length;
}
