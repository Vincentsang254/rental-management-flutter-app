import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  /// 🔥 Payment status UI helper
  (Color, IconData) getStatusUI(String status) {
    switch (status) {
      case "paid":
        return (Colors.green, Icons.check_circle);
      case "partial":
        return (Colors.orange, Icons.timelapse);
      default:
        return (Colors.red, Icons.radio_button_unchecked);
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
              orElse: () => Property(
                id: '',
                houseNumber: 'Unknown Property',
                rentAmount: 0.0,
              ),
            );

            final tenant = tenantsController.tenants.firstWhere(
              (t) => t.id == rental.tenantId,
              orElse: () => Tenant(id: '', name: 'Unknown Tenant', phone: ''),
            );

            final (statusColor, statusIcon) = getStatusUI(rental.amountPaid);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: rental.isActive ? Colors.white : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.deepPurple),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tenant.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(property.houseNumber),
                            Text(formatMoney(rental.expectedAmount)),
                          ],
                        ),
                      ),

                      /// 🔥 Payment Status Button
                      IconButton(
                        icon: Icon(statusIcon, color: statusColor),
                        onPressed: () {
                          rentalsController.togglePayment(rental.id);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// STATUS TEXT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rental.isActive ? "Active" : "Vacated",
                            style: TextStyle(
                              color: rental.isActive
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            rental.amountPaid.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          /// 🏠 Vacate
                          if (rental.isActive)
                            TextButton(
                              onPressed: () {
                                rentalsController.vacateRental(rental.id);
                              },
                              child: const Text("Vacate"),
                            ),

                          /// 🗑 Delete
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
                ],
              ),
            );
          },
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => _showAddRentalSheet(context),
          child: const Text("Add Rental"),
        ),
      ),
    );
  }

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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
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
