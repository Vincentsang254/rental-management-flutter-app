import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:rental_management/app/widgets/app_scaffold.dart';
import 'package:rental_management/app/widgets/primary_card.dart';

import '../controllers/rentals_controller.dart';
import '../../models/rental_model.dart';
import '../../models/property_model.dart';
import '../../models/tenant_model.dart';

class RentalsView extends StatelessWidget {
  const RentalsView({super.key});

  String formatMoney(double value) {
    final f = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    return f.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RentalsController>();

    return AppScaffold(
      title: 'Rentals',
      body: Obx(() {
        if (controller.rentals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.assignment_outlined, size: 72, color: Colors.grey),
                SizedBox(height: 12),
                Text('No rentals', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.rentals.length,
          itemBuilder: (context, index) {
            final r = controller.rentals[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.12), child: Icon(Icons.home, color: Theme.of(context).colorScheme.primary)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Property: ${r.propertyId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Text(r.isActive ? 'Active' : 'Inactive', style: TextStyle(color: r.isActive ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Tenant: ${r.tenantId}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Due: ${formatMoney(r.expectedAmount)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Text('Paid: ${formatMoney(r.amountPaid)}'),
                        const Spacer(),
                        Text(r.balance > 0 ? 'Balance: ${formatMoney(r.balance)}' : 'Settled', style: TextStyle(color: r.balance > 0 ? Colors.orange : Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _showAddPaymentSheet(context, r),
                          child: const Text('Add Payment'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Rental'),
        onPressed: () => _showAddRentalSheet(context),
      ),
    );
  }

  void _showAddPaymentSheet(BuildContext context, Rental rental) {
    final controller = Get.find<RentalsController>();
    final amountController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amt = double.tryParse(amountController.text.trim());
                    if (amt == null || amt <= 0) return;
                    controller.addPayment(rental.id, amt);
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAddRentalSheet(BuildContext context) {
    final controller = Get.find<RentalsController>();
    final propertyController = TextEditingController();
    final tenantController = TextEditingController();
    final amountController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add rental', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              TextField(controller: propertyController, decoration: const InputDecoration(labelText: 'Property ID', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: tenantController, decoration: const InputDecoration(labelText: 'Tenant ID', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Expected amount', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final pid = propertyController.text.trim();
                    final tid = tenantController.text.trim();
                    final amt = double.tryParse(amountController.text.trim());

                    if (pid.isEmpty || tid.isEmpty || amt == null || amt <= 0) return;

                    controller.addRental(
                      Rental(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        propertyId: pid,
                        tenantId: tid,
                        expectedAmount: amt,
                        amountPaid: 0,
                        billingMonth: DateTime.now(),
                        startDate: DateTime.now(),
                      ),
                    );

                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
