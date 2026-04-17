import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_management/app/models/tenant_model.dart';
import '../controllers/tenants_controller.dart';

class TenantsView extends StatelessWidget {
  const TenantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TenantsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tenants')),
      body: Obx(() {
        if (controller.tenants.isEmpty) {
          return const Center(child: Text("No tenants"));
        }

        return ListView.builder(
          itemCount: controller.tenants.length,
          itemBuilder: (context, index) {
            final tenant = controller.tenants[index];

            return ListTile(
              title: Text(tenant.name),
              subtitle: Text("${tenant.phone} • ${tenant.house}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => controller.deleteTenant(tenant.id),
              ),
            );
          },
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => _showAddTenantSheet(context),
          child: const Text("Add Tenant"),
        ),
      ),
    );
  }

  void _showAddTenantSheet(BuildContext context) {
    final controller = Get.find<TenantsController>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final houseController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Tenant"),
              const SizedBox(height: 12),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: houseController,
                decoration: const InputDecoration(labelText: "House"),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final house = houseController.text.trim();

                  if (name.isEmpty || phone.isEmpty || house.isEmpty) {
                    Get.snackbar("Error", "Fill all fields");
                    return;
                  }

                  controller.addTenant(
                    Tenant(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      phone: phone,
                      house: house,
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
