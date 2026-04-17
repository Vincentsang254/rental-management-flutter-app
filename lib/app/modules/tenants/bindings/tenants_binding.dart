// lib/app/modules/tenants/bindings/tenants_binding.dart
import 'package:get/get.dart';
import '../controllers/tenants_controller.dart';

class TenantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenantsController>(() => TenantsController());
  }
}
