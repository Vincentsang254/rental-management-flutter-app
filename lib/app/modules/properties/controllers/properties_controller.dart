import 'package:get/get.dart';
import 'package:rental_management/app/models/property_model.dart';
import '../../../services/service_local_storage.dart';

class PropertiesController extends GetxController {
  final properties = <Property>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProperties();
    ever(properties, (_) => saveProperties());
  }

  void loadProperties() {
    final saved = LocalStorageService.loadList('properties');
    properties.assignAll(saved.map((e) => Property.fromMap(e)).toList());
  }

  void saveProperties() {
    LocalStorageService.saveList(
      'properties',
      properties.map((e) => e.toMap()).toList(),
    );
  }

  void addProperty(Property property) {
    properties.add(property);
  }

  void deleteProperty(String id) {
    properties.removeWhere((p) => p.id == id);
  }
}
