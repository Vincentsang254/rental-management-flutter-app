import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:rental_management/app/widgets/app_scaffold.dart';
import 'package:rental_management/app/widgets/primary_card.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

import '../controllers/rentals_controller.dart';
import '../../properties/controllers/properties_controller.dart';
import '../../tenants/controllers/tenants_controller.dart';
import '../../models/rental_model.dart';

class RentalDetailView extends StatefulWidget {
  final String rentalId;

  const RentalDetailView({Key? key, required this.rentalId}) : super(key: key);

  @override
  State<RentalDetailView> createState() => _RentalDetailViewState();
}

class _RentalDetailViewState extends State<RentalDetailView> {
  late final RentalsController rentalsController;
  late final PropertiesController propertiesController;
  late final TenantsController tenantsController;

  final amountController = TextEditingController();
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    rentalsController = Get.find<RentalsController>();
    propertiesController = Get.find<PropertiesController>();
    tenantsController = Get.find<TenantsController>();

    final rental = rentalsController.getById(widget.rentalId);
    if (rental != null) {
      amountController.text = rental.expectedAmount.toStringAsFixed(0);
      isActive = rental.isActive;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  String formatMoney(double value) {
    final f = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    return f.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final rental = rentalsController.getById(widget.rentalId);

    if (rental == null) {
      return AppScaffold(
        title: 'Rental',
        body: const Center(child: Text('Rental not found')),
      );
    }

    final property = propertiesController.getById(rental.propertyId);
    final tenant = tenantsController.getById(rental.tenantId);

    return AppScaffold(
      title: 'Rental Details',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: PrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Property', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(property?.houseNumber ?? rental.propertyId, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Tenant', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(tenant?.name ?? rental.tenantId, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Expected Amount', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Text('Paid', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(formatMoney(rental.amountPaid)),
              const SizedBox(height: 12),
              Text('Billing Month', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(DateFormat.yMMMM().format(rental.billingMonth)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Active'),
                  const Spacer(),
                  Switch(value: isActive, onChanged: (v) => setState(() => isActive = v)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final amt = double.tryParse(amountController.text.trim());
                        if (amt == null || amt <= 0) {
                          AppSnackbar.error('Enter a valid amount');
                          return;
                        }

                        // update expectedAmount and isActive by replacing the rental
                        final idx = rentalsController.rentals.indexWhere((r) => r.id == rental.id);
                        if (idx != -1) {
                          final updated = rentalsController.rentals[idx].copyWith(isActive: isActive);
                          // we cannot change expectedAmount via copyWith, so create a new Rental
                          final newRental = Rental(
                            id: updated.id,
                            propertyId: updated.propertyId,
                            tenantId: updated.tenantId,
                            expectedAmount: amt,
                            amountPaid: updated.amountPaid,
                            billingMonth: updated.billingMonth,
                            startDate: updated.startDate,
                            isActive: isActive,
                          );

                          rentalsController.rentals[idx] = newRental;
                          AppSnackbar.success('Rental updated');
                        }
                      },
                      child: const Text('Save Changes'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Delete Rental',
                          middleText: 'Delete this rental?',
                          textConfirm: 'Delete',
                          textCancel: 'Cancel',
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            rentalsController.deleteRental(rental.id);
                            Get.back();
                            Get.back();
                          },
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
