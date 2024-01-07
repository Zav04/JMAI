import 'package:JMAI/Class/ClassesForData.dart';
import 'package:flutter/material.dart';
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
import 'package:JMAI/screens/main/components/Datepicker.dart';

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
  String _selectedpais = 'Portugal';
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
        color: secondaryColor,
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: TextFormField(
                  controller: _dataDeNascimentoController,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        await presentDatePicker(
                            context, _dataDeNascimentoController);
                      }, // Refer step 3
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
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
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
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
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
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
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
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
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
                  value: _selectedpais,
                  items: paises.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedpais = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Nacionalidade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                borderRadius:
                    BorderRadius.circular(30), // Aqui também ajuste o raio
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: Text('Registar', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
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
        pais: _selectedpais,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
        justvalidateInputs: true);

    var response =
        await validationCreateSecretarioClinico(newSecretarioClinico);
    if (response.success) {
      newSecretarioClinico.justvalidateInputs = false;
      response = await validationCreateSecretarioClinico(newSecretarioClinico);
      if (response.success) {
        response =
            await singin(_emailController.text, _passwordController.text);
        if (response.success) {
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
            _selectedpais = 'Portugal';
          });
        } else {
          ErrorAlert.show(context, response.errorMessage.toString());
        }
      } else {
        ErrorAlert.show(context, response.errorMessage.toString());
      }
    } else {
      ErrorAlert.show(context, response.errorMessage.toString());
    }
  }
}
