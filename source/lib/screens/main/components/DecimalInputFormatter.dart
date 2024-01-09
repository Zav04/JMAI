import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class FloatInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(RegExp('[^0-9.]'), '');

    List<String> parts = newText.split('.');
    String partBeforeDot = parts[0];
    String partAfterDot = parts.length > 1 ? parts[1] : '';

    if (partBeforeDot.length > 2) {
      partBeforeDot = partBeforeDot.substring(0, 2);
    }

    if (partAfterDot.length > 2) {
      partAfterDot = partAfterDot.substring(0, 2);
    }

    newText = partBeforeDot + (parts.length > 1 ? '.' + partAfterDot : '');

    int newSelectionIndex = min(newValue.selection.end, newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
