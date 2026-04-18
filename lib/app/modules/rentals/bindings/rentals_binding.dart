// lib/app/modules/rentals/bindings/rentals_binding.dart
import 'package:get/get.dart';
import 'package:rental_management/app/modules/rentals/controllers/rentals_controller.dart';

class RentalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentalsController>(() => RentalsController());
  }
}
