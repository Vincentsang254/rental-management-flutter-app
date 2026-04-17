import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_management/app/models/property_model.dart';
import '../controllers/properties_controller.dart';

class PropertiesView extends StatelessWidget {
  const PropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertiesController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Properties'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.properties.isEmpty) {
          return const Center(child: Text("No properties added yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.properties.length,
          itemBuilder: (context, index) {
            final property = controller.properties[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(property.location),
                      ],
                    ),
                  ),
                  Text("KES ${property.rentAmount}"),
                ],
              ),
            );
          },
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => _showAddPropertySheet(context),
          child: const Text("Add Property"),
        ),
      ),
    );
  }

  void _showAddPropertySheet(BuildContext context) {
    final controller = Get.find<PropertiesController>();

    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final rentController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Property"),
              const SizedBox(height: 12),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              TextField(
                controller: rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Rent"),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final location = locationController.text.trim();
                  final rent = double.tryParse(rentController.text.trim());

                  if (name.isEmpty || location.isEmpty || rent == null) {
                    Get.snackbar("Error", "Fill all fields correctly");
                    return;
                  }

                  controller.addProperty(
                    Property(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      location: location,
                      rentAmount: rent,
                    ),
                  );

                  FocusManager.instance.primaryFocus?.unfocus();
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
