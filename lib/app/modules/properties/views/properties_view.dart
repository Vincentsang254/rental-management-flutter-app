import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rental_management/app/models/property_model.dart';
import 'package:rental_management/app/widgets/custom_app_bar.dart';
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

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: const CustomAppBar(title: "PROPERTIES"),

      body: Obx(() {
        if (controller.properties.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_work_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text("NO PROPERTIES ADDED"),
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

            return Container(
              margin: const EdgeInsets.only(bottom: 14),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.withOpacity(.10),
                    child: const Icon(Icons.home, color: Colors.deepPurple),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.houseNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text("Rent: ${formatMoney(property.rentAmount)}"),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: occupied
                                ? Colors.orange.withOpacity(.10)
                                : Colors.green.withOpacity(.10),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            occupied ? "Occupied" : "Vacant",
                            style: TextStyle(
                              color: occupied ? Colors.orange : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
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
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text("ADD PROPERTY"),
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
                "ADD PROPERTY",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: houseController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: "HOUSE NUMBER",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "RENT AMOUNT",
                  border: OutlineInputBorder(),
                ),
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
                  child: const Text("SAVE PROPERTY"),
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
