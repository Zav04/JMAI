import 'package:JMAI/screens/main/components/constants.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';

class RequerimentoForm extends StatefulWidget {
  const RequerimentoForm({Key? key}) : super(key: key);

  @override
  _RequerimentoFormState createState() => _RequerimentoFormState();
}

class _RequerimentoFormState extends State<RequerimentoForm> {
  List<File> uploadedFiles = [];
  List<String> webUploadedFileNames = [];
  List<Uint8List> webUploadedFiles = [];

  bool _aceitaTermos = false;
  bool _ipveiculo = false;
  bool _multioso = false;

  @override
  void initState() {
    _aceitaTermos = false;
    _multioso = false;
    _ipveiculo = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: bgColor,
            width: double.infinity,
            child: Card(
              color: bgColor, // Use a cor desejada
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                      'Formulário de Junta Médica',
                      style: Theme.of(context).textTheme.headline6,
                    ),
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
                      icon: Icon(Icons.upload_file),
                      label: Text('Carregar ficheiro'),
                      onPressed: _pickFile,
                    ),
                    buildFileList(),
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
        final file = files[0];
        final reader = html.FileReader();
        reader.onLoad.listen((e) {
          final result = reader.result;
          if (result is Uint8List) {
            setState(() {
              webUploadedFiles.add(result);
              webUploadedFileNames.add(file.name);
            });
          } else {
            // Tratar erro de leitura do ficheiro
          }
        });
        reader.readAsArrayBuffer(file);
      } else {
        // Nenhum ficheiro selecionado
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
        children: webUploadedFileNames.asMap().entries.map((entry) {
          final index = entry.key;
          final fileName = entry.value;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
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
                        webUploadedFiles.removeAt(index);
                        webUploadedFileNames.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isFormValid() {
    return _aceitaTermos && (_multioso || _ipveiculo);
  }

  void _submitForm() {
    // Lógica para submeter o formulário
    // Você pode implementar a lógica de envio do formulário aqui
  }
}
