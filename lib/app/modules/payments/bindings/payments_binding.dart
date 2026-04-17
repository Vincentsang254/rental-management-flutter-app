// lib/app/modules/payments/bindings/payments_binding.dart
import 'package:get/get.dart';
import '../../payments/controllers/payment_controller.dart';

class PaymentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
