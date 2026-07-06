import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rental_management/app/models/property_model.dart';
import 'package:rental_management/app/widgets/primary_card.dart';
import 'package:rental_management/app/widgets/app_scaffold.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

import '../controllers/properties_controller.dart';

class PropertiesView extends StatelessWidget {
  const PropertiesView({super.key});

  String formatMoney(double value) {
    return "KES ${value.toStringAsFixed(0)}";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertiesController>();

    return AppScaffold(
      title: 'Properties',
      body: Obx(() {
        if (controller.properties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.home_work_outlined, size: 72, color: Colors.grey),
                SizedBox(height: 12),
                Text("No properties added", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.properties.length,
          itemBuilder: (context, index) {
            final property = controller.properties[index];

            final occupied = controller.isOccupied(property.id);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PrimaryCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.12),
                      child: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.houseNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text("Rent: ${formatMoney(property.rentAmount)}"),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: occupied ? Colors.orange.withOpacity(.10) : Colors.green.withOpacity(.10),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              occupied ? "Occupied" : "Vacant",
                              style: TextStyle(color: occupied ? Colors.orange : Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Property",
                          middleText: "Delete this property?",
                          textConfirm: "Delete",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            controller.deleteProperty(property.id);
                            Get.back();
                          },
                        );
                      },
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
        label: const Text("Add Property"),
        onPressed: () => _showAddPropertySheet(context),
      ),
    );
  }

  void _showAddPropertySheet(BuildContext context) {
    final controller = Get.find<PropertiesController>();

    final houseController = TextEditingController();
    final rentController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add property",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: houseController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: "House number", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Rent amount", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final house = houseController.text.trim();
                    final rent = double.tryParse(rentController.text.trim());

                    if (house.isEmpty || rent == null || rent <= 0) {
                      AppSnackbar.error("Fill all fields correctly");
                      return;
                    }

                    controller.addProperty(
                      Property(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        houseNumber: house,
                        rentAmount: rent,
                      ),
                    );

                    Get.back();
                  },
                  child: const Text("Save"),
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
