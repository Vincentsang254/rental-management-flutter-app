import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import 'package:rental_management/app/widgets/custom_app_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
  });

  String formatMoney(
    double value,
  ) {
    return "KES ${value.toStringAsFixed(0)}";
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller =
        Get.find<
            DashboardController>();

    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,

      appBar:
          const CustomAppBar(
        title:
            "DASHBOARD",
      ),

      body: Obx(
        () => SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            16,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              /// OVERVIEW
              _sectionTitle(
                "OVERVIEW",
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "PROPERTIES",
                controller
                    .totalProperties
                    .toString(),
                Icons.home_work,
                Colors.blue,
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "TENANTS",
                controller
                    .totalTenants
                    .toString(),
                Icons.people,
                Colors.green,
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "ACTIVE RENTALS",
                controller
                    .activeRentals
                    .toString(),
                Icons.assignment,
                Colors.orange,
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "VACANT UNITS",
                controller
                    .vacantUnits
                    .toString(),
                Icons.meeting_room,
                Colors.indigo,
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "OCCUPANCY",
                "${controller.occupancyRate.toStringAsFixed(1)}%",
                Icons.apartment,
                Colors.deepPurple,
              ),

              const SizedBox(
                height: 24,
              ),

              /// FINANCIALS
              _sectionTitle(
                "FINANCIAL SUMMARY",
              ),

              const SizedBox(
                height: 12,
              ),

              _bigCard(
                "MONTHLY EXPECTED",
                formatMoney(
                  controller
                      .totalMonthlyExpected,
                ),
                Icons.request_quote,
                Colors.purple,
              ),

              const SizedBox(
                height: 12,
              ),

              _bigCard(
                "COLLECTED",
                formatMoney(
                  controller
                      .totalCollectedThisMonth,
                ),
                Icons.payments,
                Colors.teal,
              ),

              const SizedBox(
                height: 12,
              ),

              _bigCard(
                "PENDING",
                formatMoney(
                  controller
                      .totalPendingThisMonth,
                ),
                Icons.warning,
                Colors.red,
              ),

              const SizedBox(
                height: 12,
              ),

              _bigCard(
                "PARTIAL PAYMENTS",
                formatMoney(
                  controller
                      .totalPartialThisMonth,
                ),
                Icons.timelapse,
                Colors.orange,
              ),

              if (controller
                      .totalOverpaidThisMonth >
                  0) ...[
                const SizedBox(
                  height: 12,
                ),

                _bigCard(
                  "OVERPAID CREDIT",
                  formatMoney(
                    controller
                        .totalOverpaidThisMonth,
                  ),
                  Icons.trending_up,
                  Colors.blue,
                ),
              ],

              const SizedBox(
                height: 12,
              ),

              // NET PENDING / CREDIT after considering overpayments
              Builder(builder: (context) {
                final net = controller.totalPendingThisMonth - controller.totalOverpaidThisMonth;
                final widget = net > 0
                    ? _bigCard(
                        "NET PENDING",
                        formatMoney(net),
                        Icons.warning,
                        Colors.red,
                      )
                    : _bigCard(
                        "NET CREDIT",
                        formatMoney(net.abs()),
                        Icons.trending_up,
                        Colors.green,
                      );

                return Tooltip(
                  message:
                      'Net = Pending - Overpaid. Positive = amount owed; Zero/Negative = net credit available',
                  child: widget,
                );
              }),

              const SizedBox(
                height: 24,
              ),

              /// RENT STATUS
              _sectionTitle(
                "RENT STATUS",
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "UNPAID",
                controller
                    .unpaidCount
                    .toString(),
                Icons.error_outline,
                Colors.red,
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "PARTIAL",
                controller
                    .partialCount
                    .toString(),
                Icons.timelapse,
                Colors.orange,
              ),

              const SizedBox(
                height: 12,
              ),

              _miniCard(
                "PAID",
                controller
                    .paidCount
                    .toString(),
                Icons.check_circle,
                Colors.green,
              ),

              if (controller
                      .overpaidCount >
                  0) ...[
                const SizedBox(
                  height: 12,
                ),

                _miniCard(
                  "OVERPAID",
                  controller
                      .overpaidCount
                      .toString(),
                  Icons.trending_up,
                  Colors.blue,
                ),
              ],

              const SizedBox(
                height: 24,
              ),

              /// COLLECTION RATE
              Container(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [

                    Text(
                      "COLLECTION RATE",
                      style: TextStyle(
                        color: Colors
                            .grey
                            .shade600,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      "${controller.collectionRate.toStringAsFixed(1)}%",
                      style:
                          const TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    if (controller
                            .grossCollectionRate >
                        100)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 6,
                        ),
                        child: Text(
                          "Cash Collected: ${controller.grossCollectionRate.toStringAsFixed(1)}%",
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .w500,
                          ),
                        ),
                      ),

                    const SizedBox(
                      height: 12,
                    ),

                    LinearProgressIndicator(
                      value: controller
                              .collectionRate /
                          100,

                      minHeight:
                          10,

                      backgroundColor:
                          Colors.grey
                              .shade300,

                      color: controller
                                  .collectionRate >=
                              80
                          ? Colors.green
                          : controller.collectionRate >=
                                  50
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title,
  ) {
    return Text(
      title,
      style:
          const TextStyle(
        fontSize: 14,
        fontWeight:
            FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _miniCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: Row(
        children: [

          CircleAvatar(
            backgroundColor:
                color.withOpacity(
              .10,
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [

                Text(
                  title,
                  style:
                      TextStyle(
                    color: Colors
                        .grey
                        .shade600,
                    fontSize:
                        12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize:
                        16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 26,
            backgroundColor:
                color.withOpacity(
              .10,
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [

                Text(
                  title,
                  style:
                      TextStyle(
                    color: Colors
                        .grey
                        .shade600,
                    fontSize:
                        12,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize:
                        20,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
