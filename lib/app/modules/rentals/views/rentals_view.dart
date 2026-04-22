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

  /// 🔥 STATUS
  Map<String, dynamic> getPaymentUI(Rental rental) {
    if (rental.overpaid > 0) {
      return {"text": "OVERPAID", "color": Colors.blue};
    } else if (rental.amountPaid <= 0) {
      return {"text": "UNPAID", "color": Colors.red};
    } else if (rental.amountPaid < rental.expectedAmount) {
      return {"text": "PARTIAL", "color": Colors.orange};
    } else {
      return {"text": "PAID", "color": Colors.green};
    }
  }

  /// 🔥 BALANCE UI
  Map<String, dynamic> getBalanceUI(Rental rental) {
    if (rental.overpaid > 0) {
      return {
        "text": "CREDIT: ${formatMoney(rental.overpaid)}",
        "color": Colors.blue,
      };
    } else if (rental.remaining > 0) {
      return {
        "text": "BALANCE: ${formatMoney(rental.remaining)}",
        "color": Colors.red,
      };
    } else {
      return {"text": "NO BALANCE", "color": Colors.green};
    }
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
                  Property(id: '', houseNumber: 'UNKNOWN', rentAmount: 0.0),
            );

            final tenant = tenantsController.tenants.firstWhere(
              (t) => t.id == rental.tenantId,
              orElse: () => Tenant(id: '', name: 'UNKNOWN TENANT', phone: ''),
            );

            final status = getPaymentUI(rental);
            final balanceUI = getBalanceUI(rental);

            final Color statusColor = status["color"];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: rental.isActive ? Colors.white : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// 🔹 HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tenant.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              property.houseNumber.toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      /// STATUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status["text"],
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 💰 MONEY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rent: ${formatMoney(rental.expectedAmount)}"),
                      Text("Paid: ${formatMoney(rental.amountPaid)}"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// 🔥 BALANCE
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
                      Text(
                        formatDate(rental.billingMonth),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  /// ⚙️ ACTIONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: rental.isActive
                              ? () => _showAddPaymentDialog(context, rental)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text("Add Payment"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      if (rental.isActive)
                        OutlinedButton(
                          onPressed: () {
                            rentalsController.vacateRental(rental.id);
                          },
                          child: const Text("Vacate"),
                        ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          rentalsController.deleteRental(rental.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),

      /// ➕ ADD RENTAL
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showAddRentalSheet(context),
        icon: const Icon(Icons.add),
        label: const Text(
          "ADD RENTAL",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// 💰 ADD PAYMENT
  void _showAddPaymentDialog(BuildContext context, Rental rental) {
    final controller = Get.find<RentalsController>();
    final paymentController = TextEditingController();

    Get.defaultDialog(
      title: "Add Payment",
      content: Column(
        children: [
          TextField(
            controller: paymentController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Amount Paid",
              border: OutlineInputBorder(),
            ),
          ),
        ],
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

  /// ➕ ADD RENTAL
  void _showAddRentalSheet(BuildContext context) {
    final rentalsController = Get.find<RentalsController>();
    final propertiesController = Get.find<PropertiesController>();
    final tenantsController = Get.find<TenantsController>();

    Property? selectedProperty;
    Tenant? selectedTenant;
    final rentController = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Rental",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<Property>(
                    items: propertiesController.properties
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.houseNumber),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedProperty = val),
                    decoration: const InputDecoration(
                      labelText: "Property",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<Tenant>(
                    items: tenantsController.tenants
                        .map(
                          (t) =>
                              DropdownMenuItem(value: t, child: Text(t.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedTenant = val),
                    decoration: const InputDecoration(
                      labelText: "Tenant",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: rentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Monthly Rent (KES)",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final rent = double.tryParse(
                          rentController.text.trim(),
                        );

                        if (selectedProperty == null ||
                            selectedTenant == null ||
                            rent == null ||
                            rent <= 0) {
                          AppSnackbar.error("Fill all fields correctly");
                          return;
                        }

                        rentalsController.addRental(
                          Rental(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            propertyId: selectedProperty!.id,
                            tenantId: selectedTenant!.id,
                            expectedAmount: rent,
                            amountPaid: 0,
                            startDate: DateTime.now(),
                            billingMonth: DateTime.now(),
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
