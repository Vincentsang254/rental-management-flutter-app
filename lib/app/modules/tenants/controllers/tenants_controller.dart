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

    /// 🔄 Auto-save on changes
    ever(tenants, (_) => saveTenants());
  }

  /// 📥 Load tenants
  void loadTenants() {
    try {
      final saved = LocalStorageService.loadList('tenants');

      tenants.assignAll(saved.map((e) => Tenant.fromMap(e)).toList());
    } catch (e) {
      tenants.clear();
      AppSnackbar.error("Failed to load tenants");
    }
  }

  /// 💾 Save tenants
  void saveTenants() {
    LocalStorageService.saveList(
      'tenants',
      tenants.map((e) => e.toMap()).toList(),
    );
  }

  /// ➕ Add tenant
  void addTenant(Tenant tenant) {
    final name = tenant.name.trim();
    final phone = _normalizePhone(tenant.phone);

    /// ❗ Validate name
    if (name.isEmpty) {
      AppSnackbar.error("Tenant name is required");
      return;
    }

    /// ❗ Validate phone
    if (phone.length < 9) {
      AppSnackbar.error("Enter a valid phone number");
      return;
    }

    /// 🚫 Prevent duplicates
    final exists = tenants.any((t) => _normalizePhone(t.phone) == phone);

    if (exists) {
      AppSnackbar.error("Tenant already exists");
      return;
    }

    tenants.add(tenant.copyWith(phone: phone));

    AppSnackbar.success("Tenant added successfully");
  }

  /// 🗑 Delete tenant
  void deleteTenant(String id) {
    tenants.removeWhere((t) => t.id == id);

    AppSnackbar.success("Tenant deleted");
  }

  /// 🔍 Get tenant by ID
  Tenant? getById(String id) {
    try {
      return tenants.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 📱 Normalize phone numbers
  String _normalizePhone(String phone) {
    return phone.trim().replaceAll(" ", "");
  }
}
