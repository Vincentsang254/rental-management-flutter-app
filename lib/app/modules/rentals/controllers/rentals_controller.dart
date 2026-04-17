import 'package:get/get.dart';
import 'package:rental_management/app/models/rental_model.dart';
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
    final saved = LocalStorageService.loadList('rentals');
    rentals.assignAll(saved.map((e) => Rental.fromMap(e)).toList());
  }

  void saveRentals() {
    LocalStorageService.saveList(
      'rentals',
      rentals.map((e) => e.toMap()).toList(),
    );
  }

  void addRental(Rental rental) {
    rentals.add(rental);
  }

  void deleteRental(String id) {
    rentals.removeWhere((r) => r.id == id);
  }
}
