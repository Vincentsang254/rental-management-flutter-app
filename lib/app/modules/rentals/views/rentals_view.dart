import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_management/app/models/property_model.dart';
import 'package:rental_management/app/models/rental_model.dart';
import '../controllers/rentals_controller.dart';
import '../../properties/controllers/properties_controller.dart';

class RentalsView extends StatelessWidget {
  const RentalsView({super.key});

  @override
  Widget build(BuildContext context) {
    final rentalsController = Get.find<RentalsController>();
    final propertiesController = Get.find<PropertiesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Rentals')),
      body: Obx(() {
        if (rentalsController.rentals.isEmpty) {
          return const Center(child: Text("No rentals"));
        }

        return ListView.builder(
          itemCount: rentalsController.rentals.length,
          itemBuilder: (context, index) {
            final rental = rentalsController.rentals[index];

            final property = propertiesController.properties.firstWhere(
              (p) => p.id == rental.propertyId,
              orElse: () => Property(
                id: '',
                name: 'Unknown',
                location: '',
                rentAmount: 0,
              ),
            );

            return ListTile(
              title: Text("${rental.tenantName} - ${property.name}"),
              subtitle: Text("KES ${rental.rentAmount}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => rentalsController.deleteRental(rental.id),
              ),
            );
          },
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => _showAddRentalSheet(context),
          child: const Text("Add Rental"),
        ),
      ),
    );
  }

  void _showAddRentalSheet(BuildContext context) {
    final rentalsController = Get.find<RentalsController>();
    final propertiesController = Get.find<PropertiesController>();

    Property? selectedProperty;
    final nameController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Rental"),
              const SizedBox(height: 12),

              DropdownButtonFormField<Property>(
                items: propertiesController.properties
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
                onChanged: (val) => selectedProperty = val,
                decoration: const InputDecoration(labelText: "Property"),
              ),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Tenant Name"),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();

                  if (selectedProperty == null || name.isEmpty) {
                    Get.snackbar("Error", "Fill all fields");
                    return;
                  }

                  rentalsController.addRental(
                    Rental(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      propertyId: selectedProperty!.id,
                      tenantName: name,
                      startDate: DateTime.now().toIso8601String(),
                      rentAmount: selectedProperty!.rentAmount,
                    ),
                  );

                  Get.back();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
