*** Begin Patch
*** Update File: lib/app/modules/dashboard/views/dashboard_view.dart
@@
-              Builder(builder: (context) {
-                final net = controller.totalPendingThisMonth - controller.totalOverpaidThisMonth;
-                if (net > 0) {
-                  return _bigCard(
-                    "NET PENDING",
-                    formatMoney(net),
-                    Icons.warning,
-                    Colors.red,
-                  );
-                } else {
-                  return _bigCard(
-                    "NET CREDIT",
-                    formatMoney(net.abs()),
-                    Icons.trending_up,
-                    Colors.green,
-                  );
-                }
-              }),
+              Builder(builder: (context) {
+                final net = controller.totalPendingThisMonth - controller.totalOverpaidThisMonth;
+                final widget = net > 0
+                    ? _bigCard(
+                        "NET PENDING",
+                        formatMoney(net),
+                        Icons.warning,
+                        Colors.red,
+                      )
+                    : _bigCard(
+                        "NET CREDIT",
+                        formatMoney(net.abs()),
+                        Icons.trending_up,
+                        Colors.green,
+                      );
+
+                return Tooltip(
+                  message:
+                      'Net = Pending - Overpaid. Positive = amount owed; Zero/Negative = net credit available',
+                  child: widget,
+                );
+              }),
*** End Patch
