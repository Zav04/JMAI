import 'package:JMAI/Class/ClassesForData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:JMAI/screens/main/components/Maps/distritos_concelhos.dart';
import 'package:JMAI/screens/main/components/Maps/concelhos_freguesias.dart';
import 'package:JMAI/screens/main/components/Maps/paises.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:flutter/services.dart';
import 'package:JMAI/screens/main/components/password_field.dart';
import 'package:JMAI/screens/dashboard/components/sleep.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/responsive.dart';

class SignupSecretarioClinico extends StatelessWidget {
  final Utilizador? user;
  const SignupSecretarioClinico({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(user: user),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      SignupSecretarioClinicoForm(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SignupSecretarioClinicoForm extends StatefulWidget {
  const SignupSecretarioClinicoForm({Key? key}) : super(key: key);

  @override
  _SignupSecretarioClinicoFormState createState() =>
      _SignupSecretarioClinicoFormState();
}

class _SignupSecretarioClinicoFormState
    extends State<SignupSecretarioClinicoForm> {
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _dataDeNascimentoController =
      TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  String _selectedGender = 'Masculino';
  String _selectedpaisNacionalidade = 'Portugal';
  String? _selectedDistrito;
  String? _selectedConcelho;
  String? _selectedFreguesia;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nomeCompletoController.dispose();
    _dataDeNascimentoController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> distritos = concelhos.keys.toList();
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Registro Secretario Clinico',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _nomeCompletoController,
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
                  controller: _dataDeNascimentoController,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: presentDatePickerDataNascimento,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                    createAutoHyphenDateFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira a sua Data de Nascimento';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: TextFormField(
                  controller: _telefoneController,
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
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Distrito',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      elevation: 0,
                      value: _selectedDistrito,
                      hint: Text('Distrito'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDistrito = newValue;
                          _selectedConcelho = null;
                          _selectedFreguesia = null;
                        });
                      },
                      items: distritos
                          .map<DropdownMenuItem<String>>((String value) {
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      elevation: 0,
                      value: _selectedConcelho,
                      hint: Text('Concelho'),
                      onChanged: _selectedDistrito == null
                          ? null
                          : (newValue) {
                              setState(() {
                                _selectedConcelho = newValue;
                                _selectedFreguesia = null;
                              });
                            },
                      items: _selectedDistrito == null
                          ? []
                          : concelhos[_selectedDistrito]!
                              .map<DropdownMenuItem<String>>((String value) {
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      elevation: 0,
                      value: _selectedFreguesia,
                      hint: Text('Freguesia'),
                      onChanged: _selectedConcelho == null
                          ? null
                          : (newValue) {
                              setState(() {
                                _selectedFreguesia = newValue;
                              });
                            },
                      items: _selectedConcelho == null
                          ? []
                          : freguesias[_selectedConcelho]!
                              .map<DropdownMenuItem<String>>((String value) {
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
                child: DropdownButtonFormField<String>(
                  value: _selectedpaisNacionalidade,
                  items: paises.map<DropdownMenuItem<String>>((String value) {
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
          const SizedBox(height: 200),
          ElevatedButton(
            onPressed: () {
              registerSubmit();
            },
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              onPrimary: buttonTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              fixedSize: const Size(200, 50),
            ),
            child: Text('Registar', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void presentDatePickerDataNascimento() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _dataDeNascimentoController.text = formattedDate;
      });
    }
  }

  TextInputFormatter createAutoHyphenDateFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

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

  void registerSubmit() async {
    SecretarioClinicoRegister newSecretarioClinico = SecretarioClinicoRegister(
        nomeCompleto: _nomeCompletoController.text.isNotEmpty
            ? _nomeCompletoController.text
            : null,
        dataNascimento: _dataDeNascimentoController.text.isNotEmpty
            ? _dataDeNascimentoController.text
            : null,
        numeroTelemovel: _telefoneController.text.isNotEmpty
            ? _telefoneController.text
            : null,
        sexo: _selectedGender,
        distrito: _selectedDistrito != null ? _selectedDistrito : null,
        concelho: _selectedConcelho != null ? _selectedConcelho : null,
        freguesia: _selectedFreguesia != null ? _selectedFreguesia : null,
        paisNacionalidade: _selectedpaisNacionalidade,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
        justvalidateInputs: false);

    var response =
        await validationCreateSecretarioClinico(newSecretarioClinico);
    if (response.success) {
      response = await singin(_emailController.text, _passwordController.text);
      if (response.success) {
        newSecretarioClinico.justvalidateInputs = true;
        response =
            await validationCreateSecretarioClinico(newSecretarioClinico);
        SuccessAlert.show(context, 'Conta Criada com Sucesso');
        await fazerPausaAssincrona();
        setState(() {
          _nomeCompletoController.text = '';
          _dataDeNascimentoController.text = '';
          _telefoneController.text = '';
          _emailController.text = '';
          _passwordController.text = '';
          _selectedDistrito = null;
          _selectedConcelho = null;
          _selectedFreguesia = null;
          _selectedGender = 'Masculino';
          _selectedpaisNacionalidade = 'Portugal';
        });
      } else {
        ErrorAlert.show(context, response.errorMessage.toString());
      }
    } else {
      ErrorAlert.show(context, response.errorMessage.toString());
    }
  }
}
