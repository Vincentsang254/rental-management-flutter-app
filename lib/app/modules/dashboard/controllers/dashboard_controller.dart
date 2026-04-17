import 'package:get/get.dart';
import '../../properties/controllers/properties_controller.dart';
import '../../tenants/controllers/tenants_controller.dart';
import '../../rentals/controllers/rentals_controller.dart';
import '../../payments/controllers/payments_controller.dart';

class DashboardController extends GetxController {
  final PropertiesController propertiesController =
      Get.find<PropertiesController>();
  final TenantsController tenantsController = Get.find<TenantsController>();
  final RentalsController rentalsController = Get.find<RentalsController>();
  final PaymentsController paymentsController = Get.find<PaymentsController>();

  int get totalProperties => propertiesController.properties.length;

  int get vacantProperties =>
      propertiesController.properties.where((p) => !p.isOccupied).length;

  int get totalTenants => tenantsController.tenants.length;

  int get totalRentals =>
      rentalsController.rentals.where((r) => r.isActive).length;

  double get totalCollected => paymentsController.payments
      .where((p) => p.isPaid)
      .fold(0.0, (sum, p) => sum + p.amount);

  double get totalPending => paymentsController.payments
      .where((p) => !p.isPaid)
      .fold(0.0, (sum, p) => sum + p.amount);
}
