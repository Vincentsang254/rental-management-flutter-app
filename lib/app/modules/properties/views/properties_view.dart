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
                Text(
                  "NO PROPERTIES ADDED",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.properties.length,
          itemBuilder: (context, index) {
            final property = controller.properties[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    child: const Icon(
                      Icons.home,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.houseNumber.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "RENT: ${formatMoney(property.rentAmount)}",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
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
                        middleText: "Are you sure you want to delete this property?",
                        textConfirm: "Delete",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.deleteProperty(property.id);
                          Get.back();
                          AppSnackbar.success("Property deleted");
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

      /// ➕ Floating Button (clean modern style)
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
                  labelText: "RENT AMOUNT (KES)",
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
                    AppSnackbar.success("Property added");
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