import 'package:flutter/material.dart';

void showMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontFamily: 'Playfair'),
      ),
      backgroundColor: Colors.black38,
    ),
  );
}
