import 'package:get/get.dart';
import 'package:rental_management/app/models/tenant_model.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';
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
      AppSnackbar.error("Tenant name is required");
      return;
    }

    // Validate phone
    if (tenant.phone.trim().isEmpty) {
      AppSnackbar.error("Phone number is required");
      return;
    }

    // Prevent duplicate (by phone)
    final exists = tenants.any((t) => t.phone.trim() == tenant.phone.trim());

    if (exists) {
      AppSnackbar.error("Tenant with this phone already exists");
      return;
    }

    tenants.add(tenant);

    AppSnackbar.success("Tenant added successfully");
  }

  /// Delete tenant
  void deleteTenant(String id) {
    tenants.removeWhere((t) => t.id == id);

    AppSnackbar.success("Tenant deleted");
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
