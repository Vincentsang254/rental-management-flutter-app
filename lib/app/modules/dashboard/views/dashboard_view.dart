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
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CustomAppBar(title: "DASHBOARD"),

      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =========================
              /// 📊 OVERVIEW
              /// =========================
              _sectionTitle("OVERVIEW"),
              const SizedBox(height: 12),

              _miniCard(
                "PROPERTIES",
                controller.totalProperties.toString(),
                Icons.home_work,
                Colors.blue,
              ),

              const SizedBox(height: 12),

              _miniCard(
                "TENANTS",
                controller.totalTenants.toString(),
                Icons.people,
                Colors.green,
              ),

              const SizedBox(height: 12),

              _miniCard(
                "ACTIVE RENTALS",
                controller.activeRentals.toString(),
                Icons.assignment,
                Colors.orange,
              ),

              const SizedBox(height: 20),

              /// =========================
              /// 💰 FINANCIAL
              /// =========================
              _sectionTitle("FINANCIAL SUMMARY"),
              const SizedBox(height: 12),

              _bigCard(
                "MONTHLY EXPECTED",
                formatMoney(controller.totalMonthlyExpected),
                Icons.request_quote,
                Colors.purple,
              ),

              const SizedBox(height: 12),

              _bigCard(
                "COLLECTED",
                formatMoney(controller.totalCollectedThisMonth),
                Icons.payments,
                Colors.teal,
              ),

              const SizedBox(height: 12),

              _bigCard(
                "PENDING",
                formatMoney(controller.totalPendingThisMonth),
                Icons.warning_amber,
                Colors.red,
              ),

              const SizedBox(height: 12),

              _bigCard(
                "PARTIAL PAYMENTS",
                formatMoney(controller.totalPartialThisMonth),
                Icons.timelapse,
                Colors.orange,
              ),

              if (controller.totalOverpaidThisMonth > 0) ...[
                const SizedBox(height: 12),

                _bigCard(
                  "OVERPAID (CREDIT)",
                  formatMoney(controller.totalOverpaidThisMonth),
                  Icons.trending_up,
                  Colors.blue,
                ),
              ],

              const SizedBox(height: 20),

              /// =========================
              /// ⚠️ ALERTS
              /// =========================
              _sectionTitle("ALERTS"),
              const SizedBox(height: 12),

              _miniCard(
                "UNPAID RENTALS",
                controller.unpaidRentalsThisMonth.toString(),
                Icons.error_outline,
                Colors.deepOrange,
              ),

              const SizedBox(height: 12),

              /// =========================
              /// 📊 COLLECTION RATE
              /// =========================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "COLLECTION RATE",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "${controller.collectionRate.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    LinearProgressIndicator(
                      value: controller.collectionRate / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: controller.collectionRate >= 80
                          ? Colors.green
                          : controller.collectionRate >= 50
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  /// =========================
  /// SECTION TITLE
  /// =========================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.black87,
      ),
    );
  }

  /// =========================
  /// MINI CARD
  /// =========================
  Widget _miniCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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

  /// =========================
  /// BIG CARD
  /// =========================
  Widget _bigCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
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
