import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main/components/Maps/distritos_concelhos.dart';
import '../main/components/Maps/concelhos_freguesias.dart';
import '../main/components/Maps/paises.dart';
import '../main/components/constants.dart';
import 'package:flutter/services.dart';
import '../main/components/password_field.dart';
import '../main/components/codigo_postal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/API_Connection.dart';

class Singup extends StatefulWidget {
  const Singup({Key? key}) : super(key: key);

  @override
  _SingupState createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  final TextEditingController _completeNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _doorNumberController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String _selectedGender = 'Masculino';
  String _selectedIdentification = 'CC';
  String _selectedpaisNaturalidade = 'Portugal';
  String _selectedpaisNacionalidade = 'Portugal';
  String? selectedDistrito;
  String? selectedConcelho;
  String? selectedFreguesia;
  String? _selectedCentroSaude;
  List<String> centrosSaude = [];
  var cds;

  @override
  void initState() {
    super.initState();
    loadCds();
  }

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
        child: Center(
          child: Card(
            color: bgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            margin: const EdgeInsets.all(10),
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
                        child: SvgPicture.asset(
                          'assets/images/logo-no-background.svg',
                          width: 200,
                          height: 200,
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
                      Flexible(
                        child: TextField(
                          controller: _completeNameController,
                          decoration: InputDecoration(
                            labelText: 'Nome Completo',
                            hintText: 'Insira o seu Nome Completo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
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
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9\-]')),
                            createAutoHyphenDateFormatter(), // Adiciona o formatador personalizado
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira a sua Data de Nascimento';
                            }
                            // Adicione mais validação conforme necessário
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            border: OutlineInputBorder(),
                            prefixText: '+351 ',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          items: <String>['Masculino', 'Feminimo']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Genero',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            // Removido suffixIcon: const Icon(Icons.arrow_drop_down),
                          ),
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: _selectedpaisNaturalidade,
                          items: naturalidade
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedpaisNaturalidade = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Naturalidade',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                          ),
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: _selectedpaisNacionalidade,
                          items: paises
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedpaisNacionalidade = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Nacionalidade',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                          ),
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: _selectedIdentification,
                          items: <String>[
                            'CC',
                            'Bilhete Identidade',
                            'Cedula Militar'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedIdentification = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Identificação',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            // Removido suffixIcon: const Icon(Icons.arrow_drop_down),
                          ),
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Nº Iden. Fiscal',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Nº de Identificação',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Nº Segurança Social',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Nº Utente Saúde',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
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
                      const SizedBox(width: 20),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _doorNumberController,
                          decoration: InputDecoration(
                            labelText: 'Número da Porta',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _floorNumberController,
                          decoration: InputDecoration(
                            labelText: 'Andar',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Distrito',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              elevation: 0,
                              value: selectedDistrito,
                              hint: Text('Distrito'),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDistrito = newValue;
                                  selectedConcelho = null;
                                  selectedFreguesia = null;
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
                      const SizedBox(width: 20),
                      Flexible(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Concelho',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                      const SizedBox(width: 20),
                      Flexible(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Freguesia',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                      const SizedBox(width: 20),
                      Flexible(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Centro de Saúde',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              elevation: 0,
                              value: _selectedCentroSaude,
                              hint: Text('Centro de Saúde'),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCentroSaude = newValue;
                                });
                              },
                              items: centrosSaude.map<DropdownMenuItem<String>>(
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Insira o seu Email para o Registro',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: PasswordField(controller: _passwordController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO Lógica para submeter o formulário
                    },
                    style: ElevatedButton.styleFrom(
                      primary: buttonColor,
                      onPrimary: buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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

  Future<List<String>> loadCds() async {
    var cds = await getEntidadesResponsaveis();
    List<String> centros = List<String>.from(cds.data['nomes_entidades']);
    if (mounted) {
      setState(() {
        centrosSaude = centros;
      });
    }
    return centros;
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

  TextInputFormatter createAutoHyphenDateFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

      // Determinar se está adicionando ou removendo caracteres
      bool isRemoving = newText.length <
          oldValue.text.replaceAll(RegExp(r'[^0-9]'), '').length;

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

      // Limitar o texto a 10 caracteres
      if (formattedText.length > 10) {
        formattedText = formattedText.substring(0, 10);
      }

      // Ajustar a posição do cursor se estiver à frente do texto formatado
      if (cursorIndex > formattedText.length) {
        cursorIndex = formattedText.length;
      }

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: cursorIndex),
      );
    });
  }
}
