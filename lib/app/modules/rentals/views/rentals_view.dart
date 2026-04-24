import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:rental_management/app/models/property_model.dart';
import 'package:rental_management/app/models/rental_model.dart';
import 'package:rental_management/app/models/tenant_model.dart';

import 'package:rental_management/app/widgets/custom_app_bar.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

import '../controllers/rentals_controller.dart';
import '../../properties/controllers/properties_controller.dart';
import '../../tenants/controllers/tenants_controller.dart';

class RentalsView extends StatelessWidget {
  const RentalsView({super.key});

  String formatMoney(double value) {
    return "KES ${value.toStringAsFixed(0)}";
  }

  String formatDate(DateTime date) {
    return DateFormat("dd MMM yyyy").format(date);
  }

  Map<String, dynamic> getPaymentUI(Rental rental) {
    if (rental.overpaid > 0) {
      return {"text": "OVERPAID", "color": Colors.blue};
    }

    if (rental.amountPaid <= 0) {
      return {"text": "UNPAID", "color": Colors.red};
    }

    if (rental.amountPaid < rental.expectedAmount) {
      return {"text": "PARTIAL", "color": Colors.orange};
    }

    return {"text": "PAID", "color": Colors.green};
  }

  Map<String, dynamic> getBalanceUI(Rental rental) {
    if (rental.overpaid > 0) {
      return {
        "text": "CREDIT ${formatMoney(rental.overpaid)}",
        "color": Colors.blue,
      };
    }

    if (rental.remaining > 0) {
      return {
        "text": "BALANCE ${formatMoney(rental.remaining)}",
        "color": Colors.red,
      };
    }

    return {"text": "NO BALANCE", "color": Colors.green};
  }

  @override
  Widget build(BuildContext context) {
    final rentalsController = Get.find<RentalsController>();

    final propertiesController = Get.find<PropertiesController>();

    final tenantsController = Get.find<TenantsController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: "Rentals"),

      body: Obx(() {
        if (rentalsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (rentalsController.rentals.isEmpty) {
          return const Center(child: Text("No rentals"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rentalsController.rentals.length,
          itemBuilder: (context, index) {
            final rental = rentalsController.rentals[index];

            final property = propertiesController.properties.firstWhere(
              (p) => p.id == rental.propertyId,
              orElse: () =>
                  Property(id: '', houseNumber: 'UNKNOWN', rentAmount: 0),
            );

            final tenant = tenantsController.tenants.firstWhere(
              (t) => t.id == rental.tenantId,
              orElse: () => Tenant(id: '', name: 'UNKNOWN', phone: ''),
            );

            final status = getPaymentUI(rental);

            final balanceUI = getBalanceUI(rental);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: rental.isActive ? Colors.white : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: const Icon(Icons.person)),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tenant.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(property.houseNumber),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: status["color"].withOpacity(.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status["text"],
                          style: TextStyle(
                            color: status["color"],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rent ${formatMoney(rental.expectedAmount)}"),
                      Text("Paid ${formatMoney(rental.amountPaid)}"),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        balanceUI["text"],
                        style: TextStyle(
                          color: balanceUI["color"],
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(formatDate(rental.billingMonth)),
                    ],
                  ),

                  const Divider(),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: rental.isActive
                              ? () => _showAddPaymentDialog(context, rental)
                              : null,
                          child: const Text("Add Payment"),
                        ),
                      ),

                      const SizedBox(width: 8),

                      if (rental.isActive)
                        OutlinedButton(
                          onPressed: () {
                            rentalsController.vacateRental(rental.id);
                          },
                          child: const Text("Vacate"),
                        ),

                      IconButton(
                        onPressed: () {
                          rentalsController.deleteRental(rental.id);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showAddRentalSheet(context),
        icon: const Icon(Icons.add),
        label: const Text("ADD RENTAL"),
      ),
    );
  }

  /// PAYMENT
  void _showAddPaymentDialog(BuildContext context, Rental rental) {
    final controller = Get.find<RentalsController>();

    final paymentController = TextEditingController();

    Get.defaultDialog(
      title: "Add Payment",
      content: TextField(
        controller: paymentController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Amount"),
      ),
      textConfirm: "Save",
      onConfirm: () {
        final amount = double.tryParse(paymentController.text.trim());

        if (amount == null || amount <= 0) {
          AppSnackbar.error("Enter valid amount");
          return;
        }

        controller.updatePayment(rental.id, amount);

        Get.back();
      },
    );
  }

  /// ADD RENTAL
  void _showAddRentalSheet(BuildContext context) {
    final rentalsController = Get.find<RentalsController>();

    final propertiesController = Get.find<PropertiesController>();

    final tenantsController = Get.find<TenantsController>();

    Property? selectedProperty;
    Tenant? selectedTenant;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Rental",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<Property>(
                    items: propertiesController.properties
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.houseNumber),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedProperty = val;
                      });
                    },
                    decoration: const InputDecoration(labelText: "Property"),
                  ),

                  const SizedBox(height: 12),

                  if (selectedProperty != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Monthly Rent: ${formatMoney(selectedProperty!.rentAmount)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<Tenant>(
                    items: tenantsController.tenants
                        .map(
                          (t) =>
                              DropdownMenuItem(value: t, child: Text(t.name)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedTenant = val;
                      });
                    },
                    decoration: const InputDecoration(labelText: "Tenant"),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedProperty == null ||
                            selectedTenant == null) {
                          AppSnackbar.error("Select property and tenant");
                          return;
                        }

                        rentalsController.addRental(
                          Rental(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),

                            propertyId: selectedProperty!.id,

                            tenantId: selectedTenant!.id,

                            /// Auto from room
                            expectedAmount: selectedProperty!.rentAmount,

                            amountPaid: 0,

                            billingMonth: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              1,
                            ),

                            startDate: DateTime.now(),
                          ),
                        );

                        Get.back();
                      },
                      child: const Text("Save Rental"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
