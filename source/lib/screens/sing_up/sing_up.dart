import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'distritos_concelhos.dart';
import 'concelhos_freguesias.dart';
import '../../constants.dart';
import 'package:flutter/services.dart';
import '../main/components/password_field.dart';
import '../main/components/codigo_postal.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Singup extends StatefulWidget {
  const Singup({Key? key}) : super(key: key);

  @override
  _SingupState createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  // Controladores
  final TextEditingController _completeNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _doorNumberController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String? selectedDistrito;
  String? selectedConcelho;
  String? selectedFreguesia;

  @override
  void dispose() {
    _completeNameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _doorNumberController.dispose();
    _floorNumberController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> distritos = concelhos.keys.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Permite rolagem quando o conteúdo é maior que a tela
        child: Center(
          child: Card(
            // Cor do fundo do Card
            color: bgColor,
            // Adiciona uma borda ao Card
            shape: RoundedRectangleBorder(
              // Define a borda para ser preta
              side: BorderSide(color: Colors.black, width: 2.0),
              // Raio da borda (opcional, se você quiser bordas arredondadas)
              borderRadius: BorderRadius.circular(4.0),
            ),
            // Define a margem em torno do Card
            margin: const EdgeInsets.all(10),
            // Define o preenchimento dentro do Card
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        // Envolve o SVG em um Flexible
                        child: SvgPicture.asset(
                          'assets/images/logo-no-background.svg',
                          width: 100, // Ajuste conforme necessário
                          height: 100, // Ajuste conforme necessário
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Registro Utente',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _completeNameController,
                          decoration: InputDecoration(
                            labelText: 'Nome Completo',
                            hintText: 'Insira o seu Nome Completo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _birthDateController,
                          decoration: InputDecoration(
                            labelText: 'Data de Nascimento',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: _presentDatePicker,
                            ),
                          ),
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira a sua Data de Nascimento';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Morada',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                          controller: _doorNumberController,
                          decoration: InputDecoration(
                            labelText: 'Número da Porta',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                          controller: _floorNumberController,
                          decoration: InputDecoration(
                            labelText: 'Andar',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              PostalCodeFields(
                                  combinedPostalCodeController:
                                      _zipCodeController),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                elevation: 0,
                                value: selectedDistrito,
                                hint: Text('Distrito'),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDistrito = newValue;
                                    selectedConcelho = null; // Reset concelho
                                    selectedFreguesia = null; // Reset freguesia
                                  });
                                },
                                items: distritos.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                elevation: 0,
                                value: selectedConcelho,
                                hint: Text('Concelho'),
                                onChanged: selectedDistrito == null
                                    ? null
                                    : (newValue) {
                                        setState(() {
                                          selectedConcelho = newValue;
                                          selectedFreguesia = null;
                                        });
                                      },
                                items: selectedDistrito == null
                                    ? []
                                    : concelhos[selectedDistrito]!
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                elevation: 0,
                                value: selectedFreguesia,
                                hint: Text('Freguesia'),
                                onChanged: selectedConcelho == null
                                    ? null
                                    : (newValue) {
                                        setState(() {
                                          selectedFreguesia = newValue;
                                        });
                                      },
                                items: selectedConcelho == null
                                    ? []
                                    : freguesias[selectedConcelho]!
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        // Use Expanded ou Flexible para os TextFields
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Insira o seu Email para o Registro',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Adicione um espaço entre os TextFields
                      Flexible(
                        // Use Expanded ou Flexible para os TextFields
                        child: PasswordField(controller: _passwordController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType
                        .phone, // Define o teclado para tipo telefone
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                      prefixText:
                          '+351 ', // Define o texto de prefixo para o código de área
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Permite apenas dígitos
                      LengthLimitingTextInputFormatter(
                          9), // Limita o comprimento (+351 123456789)
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO Lógica para submeter o formulário
                    },
                    child: Text('Registrar'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _birthDateController.text = formattedDate;
      });
    }
  }
}
