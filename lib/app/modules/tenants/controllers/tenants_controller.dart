import 'package:get/get.dart';
import 'package:rental_management/app/models/tenant_model.dart';
import '../../../services/service_local_storage.dart';

class TenantsController extends GetxController {
  final tenants = <Tenant>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTenants();
    ever(tenants, (_) => saveTenants());
  }

  void loadTenants() {
    final saved = LocalStorageService.loadList('tenants');
    tenants.assignAll(saved.map((e) => Tenant.fromMap(e)).toList());
  }

  void saveTenants() {
    LocalStorageService.saveList(
      'tenants',
      tenants.map((e) => e.toMap()).toList(),
    );
  }

  void addTenant(Tenant tenant) {
    tenants.add(tenant);
  }

  void deleteTenant(String id) {
    tenants.removeWhere((t) => t.id == id);
  }
}
