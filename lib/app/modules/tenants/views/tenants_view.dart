import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rental_management/app/widgets/app_scaffold.dart';
import 'package:rental_management/app/widgets/primary_card.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';
import 'package:rental_management/app/modules/tenants/controllers/tenants_controller.dart';
import 'package:rental_management/app/models/tenant_model.dart';

class TenantsView extends StatelessWidget {
  const TenantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TenantsController>();

    return AppScaffold(
      title: 'Tenants',
      body: Obx(() {
        if (controller.tenants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.people_outline, size: 72, color: Colors.grey),
                SizedBox(height: 12),
                Text('No tenants added', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tenants.length,
          itemBuilder: (context, index) {
            final t = controller.tenants[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PrimaryCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.12),
                      child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(t.phone),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Delete Tenant',
                          middleText: 'Delete this tenant?',
                          textConfirm: 'Delete',
                          textCancel: 'Cancel',
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            controller.deleteTenant(t.id);
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
        icon: const Icon(Icons.person_add),
        label: const Text('Add Tenant'),
        onPressed: () => _showAddTenantSheet(context),
      ),
    );
  }

  void _showAddTenantSheet(BuildContext context) {
    final controller = Get.find<TenantsController>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add tenant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();

                    if (name.isEmpty || phone.length < 9) {
                      AppSnackbar.error('Fill all fields correctly');
                      return;
                    }

                    controller.addTenant(Tenant(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, phone: phone));

                    Get.back();
                  },
                  child: const Text('Save'),
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
