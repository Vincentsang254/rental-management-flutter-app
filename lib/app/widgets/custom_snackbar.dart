import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void success(String message) {
    Get.showSnackbar(
      GetSnackBar(
        title: "Success",
        message: message,
        backgroundColor: Colors.green,
        margin: EdgeInsets.all(12),
        borderRadius: 12,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void error(String message) {
    Get.showSnackbar(
      GetSnackBar(
        title: "Error",
        message: message,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(12),
        borderRadius: 12,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
