import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:rental_management/app/models/tenant_model.dart';
import 'package:rental_management/app/widgets/custom_app_bar.dart';
import 'package:rental_management/app/widgets/custom_snackbar.dart';

import '../controllers/tenants_controller.dart';

/// 🔤 Auto-capitalize each word properly
class CapitalizeWordsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    final capitalized = text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');

    return TextEditingValue(text: capitalized, selection: newValue.selection);
  }
}

class TenantsView extends StatelessWidget {
  const TenantsView({super.key});

  /// 🔤 Backup formatter (used before saving)
  String formatName(String name) {
    return name
        .trim()
        .split(" ")
        .where((e) => e.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(" ");
  }

  /// 📱 Clean phone input
  String formatPhone(String phone) {
    return phone.replaceAll(" ", "").trim();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TenantsController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: "TENANTS"),

      body: Obx(() {
        if (controller.tenants.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 70, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  "NO TENANTS YET",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tenants.length,
          itemBuilder: (context, index) {
            final tenant = controller.tenants[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    child: const Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  const SizedBox(width: 12),

                  /// DETAILS
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

                        const SizedBox(height: 6),

                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: tenant.phone),
                            );
                            AppSnackbar.success("Phone copied");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  tenant.phone,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.deleteTenant(tenant.id);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),

      /// ➕ FLOATING BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showAddTenantSheet(context),
        icon: const Icon(Icons.add),
        label: const Text(
          "ADD TENANT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "ADD TENANT",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              /// NAME FIELD (AUTO CAPITALIZE)
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [CapitalizeWordsFormatter()],
                decoration: const InputDecoration(
                  labelText: "FULL NAME",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              /// PHONE FIELD (DIGITS ONLY)
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "PHONE NUMBER",
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
                    final name = formatName(nameController.text);
                    final phone = formatPhone(phoneController.text);

                    if (name.isEmpty || phone.isEmpty) {
                      AppSnackbar.error("Fill all fields");
                      return;
                    }

                    controller.addTenant(
                      Tenant(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        phone: phone,
                      ),
                    );

                    Get.back();
                  },
                  child: const Text("SAVE TENANT"),
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
