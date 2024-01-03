import 'package:JMAI/Class/ClassesForData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:JMAI/screens/main/components/Maps/distritos_concelhos.dart';
import 'package:JMAI/screens/main/components/Maps/concelhos_freguesias.dart';
import 'package:JMAI/screens/main/components/Maps/paises.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:flutter/services.dart';
import 'package:JMAI/screens/main/components/codigo_postal.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:JMAI/screens/main/components/responsive.dart';

class EditarPerfilUtente extends StatelessWidget {
  final Utilizador user;
  const EditarPerfilUtente({
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
                      EditarPerfilUtenteForm(user: user),
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

class EditarPerfilUtenteForm extends StatefulWidget {
  final Utilizador user;
  const EditarPerfilUtenteForm({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _EditarPerfilUtenteFormState createState() => _EditarPerfilUtenteFormState();
}

class _EditarPerfilUtenteFormState extends State<EditarPerfilUtenteForm> {
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
  List<String> centrosSaude = [];

  @override
  void initState() {
    super.initState();
    loadCds();
    loadAllFromUser(widget.user);
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
          // style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Alterar Perfil Utente',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  ),
                  isExpanded: true,
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
              const SizedBox(width: 20),
              Flexible(
                child: DropdownButtonFormField<String>(
                  value: _selectedIdentification,
                  items: <String>['CC', 'Bilhete Identidade', 'Cedula Militar']
                      .map<DropdownMenuItem<String>>((String value) {
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: presentDatePickerValidade,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
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
                  controller: _nrIdentificacaoController,
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
                  controller: _nrSegunracaSocialController,
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
                  controller: _nrUtenteSaudeController,
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
                  controller: _moradaController,
                  decoration: InputDecoration(
                    labelText: 'Morada',
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Centro de Saúde',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      items: centrosSaude
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
          const SizedBox(height: 100),
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
              alignment: Alignment.center,
            ),
            child: Text('Editar', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 20),
        ],
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

  void presentDatePickerValidade() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _validadeIdentificacaoController.text = formattedDate;
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
    UtenteRegister newUtente = UtenteRegister(
        hashed_id: widget.user.hashedId,
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
        justvalidateInputs: true);

    var response = await validationEditUser(newUtente);
    if (response.success) {
      SuccessAlert.show(context, 'Conta Alterada com Sucesso');
    } else {
      ErrorAlert.show(context, response.errorMessage.toString());
    }
  }

  void loadAllFromUser(Utilizador user) async {
    if (user is Utente) {
      setState(() {
        _nomeCompletoController.text = user.nomeCompleto;
        _dataDeNascimentoController.text = user.dataNascimento;
        _telefoneController.text = user.numeroTelemovel;
        _selectedGender = user.sexo;
        _selectedpaisNaturalidade = user.naturalidade;
        _selectedpaisNacionalidade = user.paisNacionalidade;
        if (user.tipoDocumentoIdentificacao == 1)
          _selectedIdentification = 'CC';
        else if (user.tipoDocumentoIdentificacao == 2)
          _selectedIdentification = 'Bilhete Identidade';
        else if (user.tipoDocumentoIdentificacao == 3)
          _selectedIdentification = 'Cedula Militar';
        _validadeIdentificacaoController.text = user.documentoValidade;
        _nrIdentificacaoFiscalController.text = user.numeroIdentificacaoFiscal;
        _nrIdentificacaoController.text = user.numeroDocumentoIdentificacao;
        _nrSegunracaSocialController.text = user.numeroSegurancaSocial;
        _nrUtenteSaudeController.text = user.numeroUtenteSaude;
        _moradaController.text = user.morada;
        _nrPortaController.text = user.nr_porta;
        _nrAndarController.text = user.nr_andar;
        _codigoPostalController.text = user.nr_codigo_postal;
        _selectedDistrito = user.distrito;
        _selectedConcelho = user.concelho;
        _selectedFreguesia = user.freguesia;
        _selectedCentroSaude = user.nomeEntidadeResponsavel;
      });
    }
  }
}
