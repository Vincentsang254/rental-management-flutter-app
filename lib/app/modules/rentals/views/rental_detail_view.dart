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

  String? selectedPropertyId;
  String? selectedTenantId;
  late DateTime billingMonth;

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
      selectedPropertyId = rental.propertyId;
      selectedTenantId = rental.tenantId;
      billingMonth = rental.billingMonth;
    } else {
      billingMonth = DateTime.now();
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

  Future<void> _pickBillingMonth() async {
    final now = DateTime.now();
    final initialDate = billingMonth;
    final firstDate = DateTime(now.year - 5, 1);
    final lastDate = DateTime(now.year + 5, 12);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select billing month (pick any day in month)',
    );

    if (picked != null) {
      setState(() {
        billingMonth = DateTime(picked.year, picked.month, 1);
      });
    }
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

    final propertyItems = propertiesController.properties
        .map((p) => DropdownMenuItem(value: p.id, child: Text(p.houseNumber)))
        .toList();

    final tenantItems = tenantsController.tenants
        .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
        .toList();

    return AppScaffold(
      title: 'Rental Details',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: PrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Property', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedPropertyId,
                items: propertyItems,
                onChanged: (v) => setState(() => selectedPropertyId = v),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              const Text('Tenant', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedTenantId,
                items: tenantItems,
                onChanged: (v) => setState(() => selectedTenantId = v),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              const Text('Expected Amount', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
              const SizedBox(height: 12),
              const Text('Paid', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(formatMoney(rental.amountPaid)),
              const SizedBox(height: 12),
              const Text('Billing Month', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(DateFormat.yMMMM().format(billingMonth)),
                  const Spacer(),
                  TextButton(onPressed: _pickBillingMonth, child: const Text('Change')),
                ],
              ),
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

                        if (selectedPropertyId == null || selectedTenantId == null) {
                          AppSnackbar.error('Select property and tenant');
                          return;
                        }

                        // update rental
                        final updated = Rental(
                          id: rental.id,
                          propertyId: selectedPropertyId!,
                          tenantId: selectedTenantId!,
                          expectedAmount: amt,
                          amountPaid: rental.amountPaid,
                          billingMonth: billingMonth,
                          startDate: rental.startDate,
                          isActive: isActive,
                        );

                        rentalsController.updateRental(updated);
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
