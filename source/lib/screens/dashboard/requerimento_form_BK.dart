import 'package:flutter/material.dart';
import 'dart:io';
import '../main/components/constants.dart';
import 'package:file_picker/file_picker.dart';
import '../main/components/responsive.dart';

class RequerimentoForm extends StatefulWidget {
  const RequerimentoForm({Key? key}) : super(key: key);

  @override
  _RequerimentoFormState createState() => _RequerimentoFormState();
}

class _RequerimentoFormState extends State<RequerimentoForm> {
  bool _aceitaTermos = false;
  bool _multioso = false;
  bool _ipveiculo = false;

  List<File> uploadedFiles = [];

  @override
  void initState() {
    _aceitaTermos = false;
    _multioso = false;
    _ipveiculo = false;
    super.initState();
  }

  @override
  void dispose() {
    _aceitaTermos = false;
    _multioso = false;
    _ipveiculo = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktopDevice = Responsive.isDesktop(context);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenSize
                .width, // Define a largura com base na largura da tela
            height: screenSize.height *
                0.9, // Define a altura com base na altura da tela
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
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Text(
                      'Formulario de Junta Médica',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    CheckboxListTile(
                      title: Text(
                          'Mulitioso (Decreto Lei nº 202/96, de 23 de Outubro com a redação dada pelo Decreto Lei nº 147/978 de 19 de julho))'),
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
                          'Importação de veículo automóvel e outros (Lei nº 22-A/2007, de 29 de Junho)'),
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
                    isDesktopDevice
                        ? SizedBox(height: 145)
                        : SizedBox(height: 20),
                    TextButton.icon(
                      icon: Icon(Icons.upload_file),
                      label: Text('Carregar ficheiro'),
                      onPressed: _pickFile,
                    ),
                    buildFileList(),
                    // Botão para submeter o formulário
                    const SizedBox(height: 385),
                    CheckboxListTile(
                      title: Text(
                          'Aceito os termos de funcionamento e garanto que os dados de utente estão corretos.'),
                      value: _aceitaTermos,
                      onChanged: (bool? valor) {
                        setState(() {
                          _aceitaTermos = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              primary: cancelButtonColor,
                              onPrimary: buttonTextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Cancelar'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: (_aceitaTermos &&
                                    (_multioso || _ipveiculo))
                                ? () {
                                    // TODO: Lógica para submeter o formulário
                                  }
                                : null, // Desabilita o botão se as condições não forem atendidas
                            style: ElevatedButton.styleFrom(
                              primary: buttonColor,
                              onPrimary: buttonTextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Submeter Requerimento'),
                          ),
                        )
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        uploadedFiles.addAll(files);
      });
    } else {
      // O usuário cancelou a seleção de ficheiros
    }
  }

  Widget buildFileList() {
    if (uploadedFiles.isEmpty) {
      return Text("Nenhum arquivo carregado.");
    }
    return ListView.builder(
      shrinkWrap:
          true, // Use isso para garantir que o ListView ocupe apenas o espaço necessário
      itemCount: uploadedFiles.length,
      itemBuilder: (context, index) {
        File file = uploadedFiles[index];
        String fileName = file.path.split('/').last;
        // Use um widget adequado para representar o arquivo
        return Card(
          child: ListTile(
            title: Text(fileName),
            leading: Icon(Icons.insert_drive_file),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Implemente a lógica para remover o arquivo da lista
                setState(() {
                  uploadedFiles.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
