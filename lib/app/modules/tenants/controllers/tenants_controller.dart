import 'package:get/get.dart';
import 'package:rental_management/app/models/tenant_model.dart';
import '../../../services/service_local_storage.dart';

class TenantsController extends GetxController {
  final tenants = <Tenant>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTenants();

    // ✅ Auto-save whenever list changes
    ever(tenants, (_) => saveTenants());
  }

  /// Load saved tenants
  void loadTenants() {
    final saved = LocalStorageService.loadList('tenants');

    try {
      tenants.assignAll(saved.map((e) => Tenant.fromMap(e)).toList());
    } catch (e) {
      tenants.clear();
    }
  }

  /// Save tenants locally
  void saveTenants() {
    LocalStorageService.saveList(
      'tenants',
      tenants.map((e) => e.toMap()).toList(),
    );
  }

  /// ✅ Add tenant with proper validation
  void addTenant(Tenant tenant) {
    // Validate name
    if (tenant.name.trim().isEmpty) {
      Get.snackbar("Error", "Tenant name is required");
      return;
    }

    // Validate phone
    if (tenant.phone.trim().isEmpty) {
      Get.snackbar("Error", "Phone number is required");
      return;
    }

    // Prevent duplicate (by phone)
    final exists = tenants.any((t) => t.phone.trim() == tenant.phone.trim());

    if (exists) {
      Get.snackbar("Error", "Tenant with this phone already exists");
      return;
    }

    tenants.add(tenant);

    Get.snackbar("Success", "Tenant added successfully");
  }

  /// Delete tenant
  void deleteTenant(String id) {
    tenants.removeWhere((t) => t.id == id);

    Get.snackbar("Success", "Tenant deleted");
  }

  /// 🔥 Helper: get tenant by ID
  Tenant? getById(String id) {
    try {
      return tenants.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
