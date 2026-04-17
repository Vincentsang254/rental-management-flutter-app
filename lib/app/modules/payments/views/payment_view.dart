import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_management/app/modules/payments/controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: Center(
        child: Text('Payment management coming soon!'),
      ),
    );
  }
}