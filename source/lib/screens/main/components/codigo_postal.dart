import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostalCodeFields extends StatelessWidget {
  final TextEditingController combinedPostalCodeController;
  final TextEditingController postalCode1Controller = TextEditingController();
  final TextEditingController postalCode2Controller = TextEditingController();

  PostalCodeFields({Key? key, required this.combinedPostalCodeController})
      : super(key: key) {
    _initializeControllers();
  }

  void _initializeControllers() {
    if (combinedPostalCodeController.text.isNotEmpty) {
      final parts = combinedPostalCodeController.text.split('-');
      if (parts.length == 2) {
        postalCode1Controller.text = parts[0];
        postalCode2Controller.text = parts[1];
      }
    }

    postalCode1Controller.addListener(_updateCombinedPostalCode);
    postalCode2Controller.addListener(_updateCombinedPostalCode);
  }

  void _updateCombinedPostalCode() {
    combinedPostalCodeController.text =
        '${postalCode1Controller.text}-${postalCode2Controller.text}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: postalCode1Controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            decoration: const InputDecoration(
              labelText: 'Código Postal',
              hintText: 'Insira os primeiros 4 digitos do Código Postal',
            ),
            onChanged: (value) {
              _updateCombinedPostalCode();
            },
          ),
        ),
        const SizedBox(width: 10),
        const Text("-", style: TextStyle(fontSize: 30, height: 2)),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: postalCode2Controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: const InputDecoration(
              labelText: 'Código Postal',
              hintText: 'Insira os ultimos 3 digitos do Código Postal',
            ),
            onChanged: (value) {
              _updateCombinedPostalCode();
            },
          ),
        ),
      ],
    );
  }
}
