import 'package:get/get.dart';
import 'package:rental_management/app/models/property_model.dart';
import 'package:rental_management/app/services/service_local_storage.dart';

class PropertiesController extends GetxController {
  final properties = <Property>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProperties();

    // ✅ Auto-save whenever list changes
    ever(properties, (_) => saveProperties());
  }

  /// Load saved properties from storage
  void loadProperties() {
    final saved = LocalStorageService.loadList('properties');

    properties.assignAll(saved.map((e) => Property.fromMap(e)).toList());
  }

  /// Save to local storage
  void saveProperties() {
    LocalStorageService.saveList(
      'properties',
      properties.map((e) => e.toMap()).toList(),
    );
  }

  /// Add property (with proper validation)
  void addProperty(Property property) {
    // ✅ Validate house number
    if (property.houseNumber.trim().isEmpty) {
      Get.snackbar("Error", "House number is required");
      return;
    }

    // ✅ Validate rent
    if (property.rentAmount <= 0) {
      Get.snackbar("Error", "Rent must be greater than 0");
      return;
    }

    // ✅ Prevent duplicate house numbers (NOT id)
    final exists = properties.any(
      (p) =>
          p.houseNumber.toLowerCase().trim() ==
          property.houseNumber.toLowerCase().trim(),
    );

    if (exists) {
      Get.snackbar("Error", "House already exists");
      return;
    }

    properties.add(property);

    Get.snackbar("Success", "Property added successfully");
  }

  /// Delete property
  void deleteProperty(String id) {
    properties.removeWhere((p) => p.id == id);

    Get.snackbar("Success", "Property deleted");
  }

  /// Helper: get property by ID
  Property? getById(String id) {
    try {
      return properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
