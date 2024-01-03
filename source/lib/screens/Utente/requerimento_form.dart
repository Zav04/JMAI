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

class RequerimentoForm extends StatefulWidget {
  final Utilizador utilizador;
  const RequerimentoForm({
    Key? key,
    required this.utilizador,
  }) : super(key: key);

  @override
  _RequerimentoFormState createState() => _RequerimentoFormState();
}

class _RequerimentoFormState extends State<RequerimentoForm> {
  List<html.File> uploadedFiles = [];
  List<String> uploadedFilesUrls = [];
  final TextEditingController _observacoesController = TextEditingController();

  bool _aceitaTermos = false;
  bool _ipveiculo = false;
  bool _multioso = false;
  RequerimentoRegister requerimento = new RequerimentoRegister(
    hashed_id: '',
    documentos: [],
    observacoes: '',
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
    return Container(
      color: bgColor,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Container(
          color: bgColor,
          width: double.infinity,
          child: Card(
            shadowColor: bgColor,
            surfaceTintColor: bgColor,
            color: bgColor,
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
                      color: selectedColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: Text(
                      'Multioso (Decreto Lei nº 202/96, de 23 de Outubro com a redação dada pelo Decreto Lei nº 147/978 de 19 de julho)',
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
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Importação de veículo automóvel e outros (Lei nº 22-A/2007, de 29 de Junho)',
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
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.upload_file, color: Colors.white),
                    label: Text('Carregar ficheiro'),
                    onPressed: _pickFile,
                    style: TextButton.styleFrom(
                      backgroundColor: buttonColor,
                      primary: buttonTextColor,
                    ),
                  ),
                  buildFileList(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _observacoesController,
                      maxLines: 3, // Permite várias linhas de texto
                      decoration: InputDecoration(
                        labelText: 'Observações',
                        border:
                            OutlineInputBorder(), // Adiciona uma borda ao redor do campo de texto
                        hintText: 'Digite suas observações aqui',
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  CheckboxListTile(
                    title: Text(
                      'Aceito os termos de funcionamento e garanto que os dados de utente estão corretos.',
                    ),
                    value: _aceitaTermos,
                    onChanged: (bool? valor) {
                      setState(() {
                        _aceitaTermos = valor!;
                      });
                    },
                  ),
                  const SizedBox(height: 100),
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
                          onPressed: _isFormValid(context) ? _submitForm : null,
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
                width: MediaQuery.of(context).size.width *
                    0.4, // 40% da largura da tela
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

  bool _isFormValid(BuildContext context) {
    return _aceitaTermos && (_multioso || _ipveiculo);
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
  }

  void verificarTipoUtilizador(Utilizador user) async {
    if (user is Utente) {
      requerimento = RequerimentoRegister(
        hashed_id: user.hashedId,
        documentos: uploadedFilesUrls,
        observacoes: _observacoesController.text,
        type: _multioso ? 1 : (_ipveiculo ? 2 : 0),
      );
      var response = await insertRequerimento(requerimento);
      if (response.success == true) {
        SuccessAlert.show(context, 'Requrimento submetido com sucesso');
      } else {
        ErrorAlert.show(context, 'response.errorMessage.toString()');
      }
      setState(() {
        uploadedFiles.clear();
        uploadedFilesUrls.clear();
      });
    }
  }
}
