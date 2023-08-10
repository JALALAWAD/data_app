import 'package:flutter/material.dart';

mixin Helpers {
  void showSnackBar(BuildContext context , {required String message, bool error = false } ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:!error ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}