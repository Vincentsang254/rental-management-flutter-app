import 'package:get/get.dart';
import 'package:rental_management/app/models/property_model.dart';
import 'package:rental_management/app/services/service_local_storage.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

class PropertiesController extends GetxController {
  final properties = <Property>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProperties();

    /// 🔄 Auto-save on changes
    ever(properties, (_) => saveProperties());
  }

  /// 📥 Load properties
  void loadProperties() {
    try {
      final saved = LocalStorageService.loadList('properties');

      properties.assignAll(saved.map((e) => Property.fromMap(e)).toList());
    } catch (e) {
      properties.clear();
      AppSnackbar.error("Failed to load properties");
    }
  }

  /// 💾 Save properties
  void saveProperties() {
    LocalStorageService.saveList(
      'properties',
      properties.map((e) => e.toMap()).toList(),
    );
  }

  /// ➕ Add property
  void addProperty(Property property) {
    final houseNumber = property.houseNumber.trim();

    /// 🚫 Validate house number
    if (houseNumber.isEmpty) {
      AppSnackbar.error("House number is required");
      return;
    }

    /// 🚫 Validate rent
    if (property.rentAmount <= 0) {
      AppSnackbar.error("Rent must be greater than 0");
      return;
    }

    /// 🚫 Prevent duplicates
    final exists = properties.any(
      (p) => p.houseNumber.toLowerCase().trim() == houseNumber.toLowerCase(),
    );

    if (exists) {
      AppSnackbar.error("Property already exists");
      return;
    }

    properties.add(property);

    AppSnackbar.success("Property added successfully");
  }

  /// 🗑 Delete property
  void deleteProperty(String id) {
    properties.removeWhere((p) => p.id == id);

    AppSnackbar.success("Property deleted");
  }

  /// 🔍 Get property by ID
  Property? getById(String id) {
    try {
      return properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
