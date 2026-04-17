import 'package:get/get.dart';
import 'package:rental_management/app/models/payment_model.dart';
import '../../../services/service_local_storage.dart';

class PaymentController extends GetxController {
  final payments = <Payment>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPayments();
    ever(payments, (_) => savePayments());
  }

  void loadPayments() {
    final saved = LocalStorageService.loadList('payments');
    payments.assignAll(
      saved.map((e) => Payment.fromMap(e)).toList(),
    );
  }

  void savePayments() {
    LocalStorageService.saveList(
      'payments',
      payments.map((e) => e.toMap()).toList(),
    );
  }

  void addPayment(Payment payment) {
    payments.add(payment);
  }

  void deletePayment(String id) {
    payments.removeWhere((p) => p.id == id);
  }

  double totalCollected() {
    return payments
        .where((p) => p.isPaid)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double totalPending() {
    return payments
        .where((p) => !p.isPaid)
        .fold(0.0, (sum, p) => sum + p.amount);
  }
}