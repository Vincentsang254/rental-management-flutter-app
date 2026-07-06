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

  void addRental(Rental rental) {
    if (rental.id.trim().isEmpty) {
      AppSnackbar.error('Invalid rental ID');
      return;
    }

    rentals.add(rental);
    AppSnackbar.success('Rental added');
  }

  void deleteRental(String id) {
    rentals.removeWhere((r) => r.id == id);
    AppSnackbar.success('Rental deleted');
  }

  void addPayment(String id, double amount) {
    final idx = rentals.indexWhere((r) => r.id == id);
    if (idx == -1) return;

    rentals[idx] = rentals[idx].addPayment(amount);
    AppSnackbar.success('Payment added');
  }

  List<Rental> get activeRentals => rentals.where((r) => r.isActive).toList();
}
