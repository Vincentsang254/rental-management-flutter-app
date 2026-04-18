import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_management/app/models/tenant_model.dart';
import 'package:rental_management/app/widgets/custom_app_bar.dart';
import '../controllers/tenants_controller.dart';

class TenantsView extends StatelessWidget {
  const TenantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TenantsController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: "Tenants"),

      body: Obx(() {
        if (controller.tenants.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text("No tenants yet"),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.tenants.length,
          itemBuilder: (context, index) {
            final tenant = controller.tenants[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.deepPurple),
                title: Text(
                  tenant.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(tenant.phone),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Delete Tenant"),
                        content: const Text(
                          "Are you sure you want to delete this tenant?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.deleteTenant(tenant.id);
                              Get.back();
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("Add Tenant"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => _showAddTenantSheet(context),
        ),
      ),
    );
  }

  void _showAddTenantSheet(BuildContext context) {
    final controller = Get.find<TenantsController>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();

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
                    "Add Tenant",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone",
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
                        final name = nameController.text.trim();
                        final phone = phoneController.text
                            .replaceAll(" ", "")
                            .trim();

                        if (name.isEmpty || phone.isEmpty) {
                          Get.snackbar("Error", "Fill all fields");
                          return;
                        }

                        controller.addTenant(
                          Tenant(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            name: name,
                            phone: phone,
                          ),
                        );

                        Get.back();
                      },
                      child: const Text("Save Tenant"),
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
