import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WidgetCatalog {
  static String getMonthDayYear(String date) {
    final DateTime now = DateTime.parse(date);
    final String formatted = DateFormat.yMMMMd().format(now);
    return formatted;
  }

  /// SnackBar
  static void showSnackBar(BuildContext context, String content) {
    SnackBar snackBar = SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.yellow),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Android Dialog
  static void androidDialog({
    required String title,
    required String content,
    required GestureTapCallback onTapNo,
    required GestureTapCallback onTapYes,
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(onPressed: onTapNo, child: const Text("Cancel")),
              TextButton(onPressed: onTapYes, child: const Text("Confirm"))
            ],
          );
        });
  }
}
