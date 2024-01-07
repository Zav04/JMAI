import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class FloatInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Permitir apenas números e ponto
    newText = newText.replaceAll(RegExp('[^0-9.]'), '');

    // Separar o texto em partes antes e depois do ponto
    List<String> parts = newText.split('.');
    String partBeforeDot = parts[0];
    String partAfterDot = parts.length > 1 ? parts[1] : '';

    // Limitar a parte antes do ponto a 2 dígitos
    if (partBeforeDot.length > 2) {
      partBeforeDot = partBeforeDot.substring(0, 2);
    }

    // Limitar a parte após o ponto a 2 dígitos
    if (partAfterDot.length > 2) {
      partAfterDot = partAfterDot.substring(0, 2);
    }

    // Reconstruir o texto com as restrições aplicadas
    newText = partBeforeDot + (parts.length > 1 ? '.' + partAfterDot : '');

    // Calcular a nova posição do cursor
    int newSelectionIndex = min(newValue.selection.end, newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
