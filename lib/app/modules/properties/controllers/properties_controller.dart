import 'package:get/get.dart';
import 'package:rental_management/app/models/property_model.dart';
import 'package:rental_management/app/services/service_local_storage.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

import '../../rentals/controllers/rentals_controller.dart';

class PropertiesController extends GetxController {
  final properties = <Property>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadProperties();

    ever(properties, (_) => saveProperties());
  }

  /// =====================
  /// LOAD
  /// =====================
  void loadProperties() {
    try {
      final saved = LocalStorageService.loadList('properties');

      properties.assignAll(saved.map((e) => Property.fromMap(e)).toList());
    } catch (e) {
      properties.clear();
      AppSnackbar.error("Failed to load properties");
    }
  }

  /// =====================
  /// SAVE
  /// =====================
  void saveProperties() {
    LocalStorageService.saveList(
      'properties',
      properties.map((e) => e.toMap()).toList(),
    );
  }

  /// =====================
  /// ADD PROPERTY
  /// =====================
  void addProperty(Property property) {
    final houseNumber = property.houseNumber.trim().toUpperCase();

    if (houseNumber.isEmpty) {
      AppSnackbar.error("House number required");
      return;
    }

    if (property.rentAmount <= 0) {
      AppSnackbar.error("Invalid rent amount");
      return;
    }

    final exists = properties.any(
      (p) => p.houseNumber.trim().toUpperCase() == houseNumber,
    );

    if (exists) {
      AppSnackbar.error("Property already exists");
      return;
    }

    properties.add(
      Property(
        id: property.id,
        houseNumber: houseNumber,
        rentAmount: property.rentAmount,
      ),
    );

    AppSnackbar.success("Property added");
  }

  /// =====================
  /// DELETE PROPERTY
  /// =====================
  void deleteProperty(String id) {
    try {
      final rentalsController = Get.find<RentalsController>();

      final occupied = rentalsController.rentals.any(
        (r) => r.propertyId == id && r.isActive,
      );

      if (occupied) {
        AppSnackbar.error("Cannot delete occupied property");
        return;
      }
    } catch (_) {}

    properties.removeWhere((p) => p.id == id);

    AppSnackbar.success("Property deleted");
  }

  /// =====================
  /// HELPERS
  /// =====================
  Property? getById(String id) {
    try {
      return properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isOccupied(String propertyId) {
    try {
      final rentalsController = Get.find<RentalsController>();

      return rentalsController.rentals.any(
        (r) => r.propertyId == propertyId && r.isActive,
      );
    } catch (_) {
      return false;
    }
  }
}
