--- a/lib/app/modules/rentals/views/rentals_view.dart
+++ b/lib/app/modules/rentals/views/rentals_view.dart
@@
-                        Text(r.balance > 0 ? 'Balance: ${formatMoney(r.balance)}' : 'Settled', style: TextStyle(color: r.balance > 0 ? Colors.orange : Colors.green, fontWeight: FontWeight.bold)),
+                        Text(
+                          r.balance > 0
+                              ? 'Balance: ${formatMoney(r.balance)}'
+                              : r.overpaid > 0
+                                  ? 'Overpaid: ${formatMoney(r.overpaid)}'
+                                  : 'Settled',
+                          style: TextStyle(
+                            color: r.balance > 0 ? Colors.orange : Colors.green,
+                            fontWeight: FontWeight.bold,
+                          ),
+                        ),
*** End Patch
