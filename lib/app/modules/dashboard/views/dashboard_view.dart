import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildStatCard(
                title: "Total Properties",
                value: controller.totalProperties.toString(),
                icon: Icons.home_work,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              _buildStatCard(
                title: "Vacant Rooms",
                value: controller.vacantProperties.toString(),
                icon: Icons.meeting_room_outlined,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              _buildStatCard(
                title: "Total Tenants",
                value: controller.totalTenants.toString(),
                icon: Icons.people,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              _buildStatCard(
                title: "Active Rentals",
                value: controller.totalRentals.toString(),
                icon: Icons.assignment_turned_in,
                color: Colors.orange,
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
            // ignore: deprecated_member_use
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
          Column(
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
