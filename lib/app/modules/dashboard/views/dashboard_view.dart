import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_management/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:rental_management/app/widgets/custom_app_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  String formatMoney(double value) {
    return "KES ${value.toStringAsFixed(0)}";
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: use find instead of put
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: "Dashboard"),

      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔥 OPTIONAL: Reset Month Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.resetMonthlyPayments();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Start New Month"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),

              _buildStatCard(
                title: "Total Properties",
                value: controller.totalProperties.toString(),
                icon: Icons.home_work,
                color: Colors.blue,
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                title: "Total Tenants",
                value: controller.totalTenants.toString(),
                icon: Icons.people,
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                title: "Active Rentals",
                value: controller.activeRentals.toString(),
                icon: Icons.assignment,
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                title: "Monthly Expected Rent",
                value: formatMoney(controller.totalMonthlyExpected),
                icon: Icons.request_quote,
                color: Colors.purple,
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                title: "Collected This Month",
                value: formatMoney(controller.totalCollectedThisMonth),
                icon: Icons.payments,
                color: Colors.teal,
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                title: "Pending This Month",
                value: formatMoney(controller.totalPendingThisMonth),
                icon: Icons.warning,
                color: Colors.red,
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                title: "Unpaid Rentals",
                value: controller.unpaidRentalsThisMonth.toString(),
                icon: Icons.error_outline,
                color: Colors.deepOrange,
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                title: "Collection Rate",
                value: "${controller.collectionRate.toStringAsFixed(1)}%",
                icon: Icons.pie_chart,
                color: Colors.indigo,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
            radius: 28,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
