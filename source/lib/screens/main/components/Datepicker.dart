import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

Future<void> presentDatePicker(
    BuildContext context, TextEditingController entrada) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  if (pickedDate != null) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
    entrada.text = formattedDate;
  }
}

TextInputFormatter createAutoHyphenDateFormatter() {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    bool isRemoving =
        newText.length < oldValue.text.replaceAll(RegExp(r'[^0-9]'), '').length;

    String formattedText = '';
    int cursorIndex = newValue.selection.end;

    for (int i = 0; i < newText.length; i++) {
      if ((i == 2 || i == 4) && newText.length > i) {
        formattedText += '-';
        if (i < cursorIndex) {
          cursorIndex += isRemoving ? 0 : 1;
        }
      }
      formattedText += newText[i];
    }

    if (formattedText.length > 10) {
      formattedText = formattedText.substring(0, 10);
    }

    if (cursorIndex > formattedText.length) {
      cursorIndex = formattedText.length;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorIndex),
    );
  });
}
