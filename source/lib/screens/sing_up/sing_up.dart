import 'package:JMAI/Class/ClassesForData.dart';
import 'package:flutter/material.dart';
import 'package:JMAI/screens/main/components/Maps/distritos_concelhos.dart';
import 'package:JMAI/screens/main/components/Maps/concelhos_freguesias.dart';
import 'package:JMAI/screens/main/components/Maps/paises.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:flutter/services.dart';
import 'package:JMAI/screens/main/components/password_field.dart';
import 'package:JMAI/screens/main/components/codigo_postal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:JMAI/screens/main/components/Datepicker.dart';

class Singup extends StatefulWidget {
  const Singup({Key? key}) : super(key: key);

  @override
  _SingupState createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _dataDeNascimentoController =
      TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  String _selectedGender = 'Masculino';
  String _selectedpaisNaturalidade = 'Portugal';
  String _selectedpaisNacionalidade = 'Portugal';
  String _selectedIdentification = 'CC';
  final TextEditingController _validadeIdentificacaoController =
      TextEditingController();
  final TextEditingController _nrIdentificacaoFiscalController =
      TextEditingController();
  final TextEditingController _nrIdentificacaoController =
      TextEditingController();
  final TextEditingController _nrSegunracaSocialController =
      TextEditingController();
  final TextEditingController _nrUtenteSaudeController =
      TextEditingController();
  final TextEditingController _moradaController = TextEditingController();
  final TextEditingController _nrPortaController = TextEditingController();
  final TextEditingController _nrAndarController = TextEditingController();
  final TextEditingController _codigoPostalController = TextEditingController();
  String? _selectedDistrito;
  String? _selectedConcelho;
  String? _selectedFreguesia;
  String? _selectedCentroSaude;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<String> centrosSaude = [];

  @override
  void initState() {
    super.initState();
    loadCds();
  }

  @override
  void dispose() {
    super.dispose();
    _nomeCompletoController.dispose();
    _dataDeNascimentoController.dispose();
    _telefoneController.dispose();
    _validadeIdentificacaoController.dispose();
    _nrIdentificacaoFiscalController.dispose();
    _nrIdentificacaoController.dispose();
    _nrSegunracaSocialController.dispose();
    _nrUtenteSaudeController.dispose();
    _moradaController.dispose();
    _nrPortaController.dispose();
    _nrAndarController.dispose();
    _codigoPostalController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> distritos = concelhos.keys.toList();
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            color: bgColor,
            surfaceTintColor: bgColor,
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
                              },
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9\-]')),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                          ),
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: TextFormField(
                          controller: _validadeIdentificacaoController,
                          decoration: InputDecoration(
                            labelText: 'Validade Identificação',
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
                                  await presentDatePicker(context,
                                      _validadeIdentificacaoController);
                                }),
                          ),
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9\-]')),
                            createAutoHyphenDateFormatter(),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira a Validade da Identificação';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _nrIdentificacaoFiscalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nº Iden. Fiscal',
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
                          controller: _nrIdentificacaoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nº de Identificação',
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
                          controller: _nrSegunracaSocialController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nº Segurança Social',
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
                            LengthLimitingTextInputFormatter(11),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: TextFormField(
                          controller: _nrUtenteSaudeController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Nº Utente Saúde',
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
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _moradaController,
                          decoration: InputDecoration(
                            labelText: 'Morada',
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
                        child: TextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _nrPortaController,
                          decoration: InputDecoration(
                            labelText: 'Número da Porta',
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
                        child: TextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _nrAndarController,
                          decoration: InputDecoration(
                            labelText: 'Andar',
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              PostalCodeFields(
                                  combinedPostalCodeController:
                                      _codigoPostalController),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
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
                        borderRadius: BorderRadius.circular(
                            30), // Aqui também ajuste o raio
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    child: Text('Registar', style: TextStyle(fontSize: 20)),
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
    if (cds.success == false) {
      ErrorAlert.show(context, cds.errorMessage.toString());
      return [];
    }
    List<String> centros = List<String>.from(cds.data);
    if (mounted) {
      setState(() {
        centrosSaude = centros;
      });
    }
    return centros;
  }

  void registerSubmit() async {
    UtenteRegister newUtente = UtenteRegister(
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
        paisnaturalidade: _selectedpaisNaturalidade,
        paisNacionalidade: _selectedpaisNacionalidade,
        tipoDocumentoIdentificacao: _selectedIdentification,
        documentoValidade: _validadeIdentificacaoController.text.isNotEmpty
            ? _validadeIdentificacaoController.text
            : null,
        numeroIdentificacaoFiscal:
            _nrIdentificacaoFiscalController.text.isNotEmpty
                ? _nrIdentificacaoFiscalController.text
                : null,
        numeroDocumentoIdentificacao: _nrIdentificacaoController.text.isNotEmpty
            ? _nrIdentificacaoController.text
            : null,
        numeroSegurancaSocial: _nrSegunracaSocialController.text.isNotEmpty
            ? _nrSegunracaSocialController.text
            : null,
        numeroUtenteSaude: _nrUtenteSaudeController.text.isNotEmpty
            ? _nrUtenteSaudeController.text
            : null,
        morada:
            _moradaController.text.isNotEmpty ? _moradaController.text : null,
        nrPorta:
            _nrPortaController.text.isNotEmpty ? _nrPortaController.text : null,
        nrAndar:
            _nrAndarController.text.isNotEmpty ? _nrAndarController.text : null,
        codigoPostal: _codigoPostalController.text.isNotEmpty
            ? _codigoPostalController.text
            : null,
        distrito: _selectedDistrito != null ? _selectedDistrito : null,
        concelho: _selectedConcelho != null ? _selectedConcelho : null,
        freguesia: _selectedFreguesia != null ? _selectedFreguesia : null,
        idEntidadeResponsavel:
            _selectedCentroSaude != null ? _selectedCentroSaude : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
        justvalidateInputs: false);

    var response = await validationCreateUser(newUtente);
    if (response.success) {
      newUtente.justvalidateInputs = true;
      response = await validationCreateUser(newUtente);
      if (response.success) {
        response =
            await singin(_emailController.text, _passwordController.text);
        if (response.success) {
          SuccessAlert.show(context, 'Conta Criada com Sucesso');
          Navigator.of(context).pushNamed('/');
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
