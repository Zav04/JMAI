import 'package:JMAI/Class/ClassesForData.dart';
import 'package:flutter/material.dart';
import 'package:JMAI/screens/main/components/Maps/distritos_concelhos.dart';
import 'package:JMAI/screens/main/components/Maps/concelhos_freguesias.dart';
import 'package:JMAI/screens/main/components/Maps/paises.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:flutter/services.dart';
import 'package:JMAI/screens/main/components/password_field.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:JMAI/screens/main/components/Datepicker.dart';

class SignupMedico extends StatelessWidget {
  final Utilizador? user;
  const SignupMedico({
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
                      SignupMedicoForm(),
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

class SignupMedicoForm extends StatefulWidget {
  const SignupMedicoForm({Key? key}) : super(key: key);

  @override
  _SignupMedicoFormState createState() => _SignupMedicoFormState();
}

class _SignupMedicoFormState extends State<SignupMedicoForm> {
  TextEditingController _nomeCompletoController = TextEditingController();
  TextEditingController _dataDeNascimentoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  String _selectedGender = 'Masculino';
  TextEditingController _nrCedula = TextEditingController();
  TextEditingController _nrOrdem = TextEditingController();
  String? _selectedEspecialidade;
  String _selectedpais = 'Portugal';
  String? _selectedDistrito;
  String? _selectedConcelho;
  String? _selectedFreguesia;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  List<String> especialidade = [];

  @override
  void initState() {
    super.initState();
    loadEspecialidade();
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
            'Registro Médico',
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
                        }),
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
                child: TextFormField(
                  controller: _nrCedula,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nº Cedula Medico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                  controller: _nrOrdem,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nº Ordem Médicos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Especialidade',
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
                      value: _selectedEspecialidade,
                      hint: Text('Especialidade'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedEspecialidade = newValue;
                        });
                      },
                      items: especialidade
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
                  items: naturalidade
                      .map<DropdownMenuItem<String>>((String value) {
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
          const SizedBox(height: 150),
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
    MedicoRegister newmedico = MedicoRegister(
        nomeCompleto: _nomeCompletoController.text.isNotEmpty
            ? _nomeCompletoController.text
            : null,
        dataNascimento: _dataDeNascimentoController.text.isNotEmpty
            ? _dataDeNascimentoController.text
            : null,
        numeroTelemovel: _telefoneController.text.isNotEmpty
            ? _telefoneController.text
            : null,
        numCedula: _nrCedula.text.isNotEmpty ? _nrCedula.text.toString() : null,
        especialidade:
            _selectedEspecialidade != null ? _selectedEspecialidade : null,
        numOrdem: _nrOrdem.text.isNotEmpty ? _nrOrdem.text.toString() : null,
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

    var response = await validationCreateMedico(newmedico);
    if (response.success) {
      newmedico.justvalidateInputs = false;
      response = await validationCreateMedico(newmedico);
      if (response.success) {
        response =
            await singin(_emailController.text, _passwordController.text);
        if (response.success) {
          SuccessAlert.show(context, 'Conta Criada com Sucesso');
          await Future.delayed(Duration(milliseconds: 200));
          setState(() {
            _nomeCompletoController.text = '';
            _dataDeNascimentoController.text = '';
            _telefoneController.text = '';
            _nrCedula.text = '';
            _nrOrdem.text = '';
            _emailController.text = '';
            _passwordController.text = '';
            _selectedEspecialidade = null;
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

  Future<List<String>> loadEspecialidade() async {
    var esp = await loadEspecialidades();
    if (esp.success == false) {
      ErrorAlert.show(context, esp.errorMessage.toString());
      return [];
    }
    List<String> especialidades = List<String>.from(esp.data);
    if (mounted) {
      setState(() {
        especialidade = especialidades;
      });
    }
    return especialidades;
  }
}
