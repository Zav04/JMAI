import 'dart:io';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/controllers/Firebase_File.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:JMAI/Class/ClassesForData.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:flutter_svg/svg.dart';
import 'package:JMAI/screens/main/components/Datepicker.dart';
import 'package:flutter/services.dart';

class RequerimentoForm extends StatefulWidget {
  final Utilizador utilizador;
  final VoidCallback onRequerimentoAdded;
  const RequerimentoForm({
    Key? key,
    required this.utilizador,
    required this.onRequerimentoAdded,
  }) : super(key: key);

  @override
  _RequerimentoFormState createState() => _RequerimentoFormState();
}

class _RequerimentoFormState extends State<RequerimentoForm> {
  List<html.File> uploadedFiles = [];
  List<String> uploadedFilesUrls = [];

  bool _aceitaTermos = false;
  bool _ipveiculo = false;
  bool _multioso = false;
  bool _jaSubmeti = false;
  bool _nuncaSubmeti = false;
  final TextEditingController _dataJuntaMedica = TextEditingController();

  RequerimentoRegister requerimento = new RequerimentoRegister(
    hashed_id: '',
    documentos: [],
    type: 0,
  );

  @override
  void initState() {
    _aceitaTermos = false;
    _multioso = false;
    _ipveiculo = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataJuntaMedica.addListener(_onDataJuntaMedicaChanged);

    return Container(
      width: 1150,
      color: bgColor,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Container(
          color: secondaryColor,
          width: 1100,
          child: Card(
            surfaceTintColor: secondaryColor,
            color: secondaryColor,
            margin: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Text(
                    'Formulário para Junta Médica',
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      CheckboxListTile(
                          title: Text(
                            'Multiuso (Decreto Lei nº 202/96, de 23 de Outubro com a redação dada pelo Decreto Lei nº 147/978 de 19 de julho)',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          value: _multioso,
                          onChanged: _ipveiculo
                              ? null
                              : (bool? valor) {
                                  setState(() {
                                    _multioso = valor!;
                                    if (_multioso) _ipveiculo = false;
                                  });
                                },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0)),
                      CheckboxListTile(
                          title: Text(
                            'Importação de veículo automóvel e outros (Lei nº 22-A/2007, de 29 de Junho)',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          value: _ipveiculo,
                          onChanged: _multioso
                              ? null
                              : (bool? valor) {
                                  setState(() {
                                    _ipveiculo = valor!;
                                    if (_ipveiculo) _multioso = false;
                                  });
                                },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0)),
                      TextButton.icon(
                        icon: Icon(Icons.upload_file, color: Colors.white),
                        label: Text('Carregar Documentos'),
                        onPressed: _pickFile,
                        style: TextButton.styleFrom(
                          backgroundColor: buttonColor,
                          primary: buttonTextColor,
                        ),
                      ),
                      buildFileList(),
                      const SizedBox(height: 150),
                      CheckboxListTile(
                        title: Text(
                          'Nunca foi submetido a Junta Médica de avaliação do Grau de Incapacidade',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        value: _nuncaSubmeti,
                        onChanged: _jaSubmeti
                            ? null
                            : (bool? valor) {
                                setState(() {
                                  _nuncaSubmeti = valor!;
                                  if (_nuncaSubmeti)
                                    _jaSubmeti =
                                        false; // Atualiza _jaSubmeti com base em _nuncaSubmeti
                                });
                              },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _jaSubmeti = !_nuncaSubmeti;
                                if (_jaSubmeti) _nuncaSubmeti = false;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Checkbox(
                                    value: _jaSubmeti,
                                    onChanged: _nuncaSubmeti
                                        ? null
                                        : (bool? valor) {
                                            setState(() {
                                              _jaSubmeti = valor!;
                                              if (_jaSubmeti)
                                                _nuncaSubmeti = false;
                                            });
                                          },
                                  ),
                                  Text(
                                    'Ja foi submetido em',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Container(
                                    width: 250,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _dataJuntaMedica,
                                      decoration: InputDecoration(
                                        labelText: 'Data da Junta Médica',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        suffixIcon: IconButton(
                                          icon:
                                              const Icon(Icons.calendar_today),
                                          onPressed: _jaSubmeti == false
                                              ? null
                                              : () async {
                                                  await presentDatePicker(
                                                      context,
                                                      _dataJuntaMedica);
                                                },
                                        ),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9\-]')),
                                        createAutoHyphenDateFormatter(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(', Pretendo uma Reavaliação',
                                        style: TextStyle(fontSize: 16.0)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Aceito os termos de funcionamento e garanto que os  meus dados estão corretos.',
                    ),
                    value: _aceitaTermos,
                    onChanged: (bool? valor) {
                      setState(() {
                        _aceitaTermos = valor!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: buttonTextColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: cancelButtonColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: _isFormValid() ? _submitForm : null,
                          child: Text(
                            'Submeter Requerimento',
                            style: TextStyle(color: buttonTextColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: buttonColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pickFile() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = '.pdf,.doc,.docx,.xls,.xlsx,.png,.jpg,.jpeg';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          uploadedFiles.addAll(files);
        });
      }
    });
  }

  Widget buildFileIcon(String fileName, String assetName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          child: SvgPicture.asset(
            assetName,
            width: 40,
            height: 40,
          ),
        ),
        SizedBox(height: 4),
        Wrap(
          children: [
            Text(
              fileName,
              style: TextStyle(
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFileList() {
    return SingleChildScrollView(
      child: Column(
        children: uploadedFiles.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;
          final fileName = file.name;
          final fileExtension = fileName.split('.').last.toLowerCase();

          String assetName;
          switch (fileExtension) {
            case 'pdf':
              assetName = 'assets/images/pdf_icon.svg';
              break;
            case 'doc':
            case 'docx':
              assetName = 'assets/images/docx_icon.svg';
              break;
            case 'xls':
            case 'xlsx':
              assetName = 'assets/images/excel_icon.svg';
              break;
            case 'png':
            case 'jpg':
            case 'jpeg':
              assetName = 'assets/images/images_icon.svg';
              break;
            default:
              assetName = 'assets/images/unknown_icon.svg';
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      assetName,
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          fileName,
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          uploadedFiles.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isFormValid() {
    if (_aceitaTermos) if (_multioso || _ipveiculo) if (_jaSubmeti ||
        _nuncaSubmeti) if (_jaSubmeti &&
            _dataJuntaMedica.text == '' ||
        _dataJuntaMedica.text == 'Data da Junta Médica')
      return false;
    else
      return true;
    else
      return false;
    else
      return false;
    else
      return false;
  }

  void _onDataJuntaMedicaChanged() {
    setState(() {
      _isFormValid();
    });
  }

  void _submitForm() async {
    for (var file in uploadedFiles) {
      String? fileUrl = await uploadFileToFirebase(file);
      if (fileUrl != null) {
        uploadedFilesUrls.add(fileUrl);
      } else {
        ErrorAlert.show(context, "Falha ao carregar o arquivo");
      }
    }
    verificarTipoUtilizador(widget.utilizador);
    Navigator.of(context).pop();
    widget.onRequerimentoAdded();
  }

  void verificarTipoUtilizador(Utilizador user) async {
    if (user is Utente) {
      requerimento = RequerimentoRegister(
        hashed_id: user.hashedId,
        documentos: uploadedFilesUrls,
        type: _multioso ? 1 : (_ipveiculo ? 2 : 0),
        submetido: _jaSubmeti,
        nuncaSubmetido: _nuncaSubmeti,
        dataSubmetido: _jaSubmeti ? _dataJuntaMedica.text : null,
      );
      var response = await insertRequerimento(requerimento);
      if (response.success == true) {
        sleep(Durations.medium3);
        SuccessAlert.show(context, 'Requrimento submetido com sucesso');
      } else {
        ErrorAlert.show(context, response.errorMessage.toString());
      }
      setState(() {
        uploadedFiles.clear();
        uploadedFilesUrls.clear();
      });
    }
  }
}
