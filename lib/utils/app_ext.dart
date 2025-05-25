import 'package:flutter/material.dart';

extension SnackbarExt on BuildContext {
  void showSnakbar(String content) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(content)));
  }
}
