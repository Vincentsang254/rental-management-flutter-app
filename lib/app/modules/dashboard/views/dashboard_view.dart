*** Begin Patch
*** Update File: lib/app/modules/dashboard/views/dashboard_view.dart
@@
               _bigCard(
                 "PARTIAL PAYMENTS",
                 formatMoney(
                   controller
                       .totalPartialThisMonth,
                 ),
                 Icons.timelapse,
                 Colors.orange,
               ),
 
-              if (controller
-                       .totalOverpaidThisMonth >
-                   0) ...[
-                const SizedBox(
-                  height: 12,
-                ),
-
-                _bigCard(
-                  "OVERPAID CREDIT",
-                  formatMoney(
-                    controller
-                        .totalOverpaidThisMonth,
-                  ),
-                  Icons.trending_up,
-                  Colors.blue,
-                ),
-              ],
+              if (controller
+                      .totalOverpaidThisMonth >
+                  0) ...[
+                const SizedBox(
+                  height: 12,
+                ),
+
+                _bigCard(
+                  "OVERPAID CREDIT",
+                  formatMoney(
+                    controller
+                        .totalOverpaidThisMonth,
+                  ),
+                  Icons.trending_up,
+                  Colors.blue,
+                ),
+              ],
+
+              // NET PENDING / CREDIT after considering overpayments
+              const SizedBox(
+                height: 12,
+              ),
+              Builder(builder: (context) {
+                final net = controller.totalPendingThisMonth - controller.totalOverpaidThisMonth;
+                if (net > 0) {
+                  return _bigCard(
+                    "NET PENDING",
+                    formatMoney(net),
+                    Icons.warning,
+                    Colors.red,
+                  );
+                } else {
+                  return _bigCard(
+                    "NET CREDIT",
+                    formatMoney(net.abs()),
+                    Icons.trending_up,
+                    Colors.green,
+                  );
+                }
+              }),
*** End Patch
