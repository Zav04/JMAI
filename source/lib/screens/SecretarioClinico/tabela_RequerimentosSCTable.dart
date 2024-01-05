// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:JMAI/Class/Requerimento_DadosUtente.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';
import 'package:JMAI/screens/main/components/Etiquetas.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:intl/intl.dart';

class RequerimentosSCTable extends StatefulWidget {
  final List<Requerimento_DadosUtente> requerimentos;
  VoidCallback updateTable;

  RequerimentosSCTable({
    Key? key,
    required this.requerimentos,
    required this.updateTable,
  }) : super(key: key);

  @override
  _RequerimentosTableSCState createState() => _RequerimentosTableSCState();
}

class _RequerimentosTableSCState extends State<RequerimentosSCTable> {
  @override
  void initState() {
    super.initState();
  }

  List<Requerimento_DadosUtente> sortRequerimentos() {
    List<Requerimento_DadosUtente> requerimentos = widget.requerimentos;
    requerimentos
        .sort((Requerimento_DadosUtente a, Requerimento_DadosUtente b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a.dataSubmissao);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b.dataSubmissao);
      return dateA.compareTo(dateB);
    });
    return requerimentos;
  }

  Tuple2<String, Color> getTypeDescription(int status) {
    switch (status) {
      case 1:
        return Tuple2('Multiuso', Colors.lime);
      case 2:
        return Tuple2('Importação de Veículo Automóvel', Colors.purple);
      default:
        return Tuple2('Status Desconhecido', Colors.grey);
    }
  }

  Tuple2<String, Color> getStatusDescription(int status) {
    switch (status) {
      case 0:
        return Tuple2('Em espera de Aprovação', Colors.grey);
      case 1:
        return Tuple2('Aprovado a espera de Pre-Avaliação', Colors.orange);
      case 2:
        return Tuple2('Pré-Avaliação Concluída', Colors.yellow);
      case 3:
        return Tuple2('Agendado', Colors.blue);
      case 4:
        return Tuple2('Finalizado', Colors.green);
      default:
        return Tuple2('Status Desconhecido', Colors.grey);
    }
  }

  String getDocumentsDescription(int typeDocument) {
    switch (typeDocument) {
      case 1:
        return 'CC';
      case 2:
        return 'Bilhete de Identidade';
      case 3:
        return 'Cedula Militar';
      default:
        return 'Status Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Text(
            "Requerimentos",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: const [
                DataColumn(label: Text('CODIGO')),
                DataColumn(label: Text('TIPO REQUERIMENTO')),
                DataColumn(label: Text('DATA DO PEDIDO')),
                DataColumn(label: Text('ESTADO')),
                DataColumn(label: Text('AÇÕES')),
              ],
              rows: sortRequerimentos()
                  .map((requerimento) => DataRow(
                        cells: [
                          DataCell(Text(
                            'REQ/' + requerimento.idRequerimento.toString(),
                          )),
                          DataCell(Blend(getTypeDescription(
                                  requerimento.typeRequerimento))
                              .widget),
                          DataCell(Text(
                            requerimento.dataSubmissao.toString(),
                          )),
                          DataCell(Blend(getStatusDescription(
                                  requerimento.statusRequerimento))
                              .widget),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.visibility),
                              color: Colors.blue,
                              onPressed: () {
                                showUtenteDetailsOverlay(context, requerimento);
                              },
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void showUtenteDetailsOverlay(
      BuildContext context, Requerimento_DadosUtente requerimento) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'DETALHES DO REQUERIMENTO',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: secondaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              Center(
                                child: Text(
                                  'Informações do Utente',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildRichText('NOME COMPLETO: ',
                                      requerimento.nomeCompleto),
                                  SizedBox(height: 2),
                                  buildRichText('DATA DE NASCIMENTO: ',
                                      requerimento.dataNascimentoUtente),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'SEXO: ', requerimento.sexoUtente),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'EMAIL: ', requerimento.emailUtente),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DE TELEMÓVEL: ',
                                      requerimento.numeroTelemovel),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  Center(
                                    child: Text('INFORMAÇÕES DE LOCALIZAÇÃO',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                        textAlign: TextAlign.center),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  buildRichText(
                                      'MORADA: ', requerimento.morada),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DA PORTA: ',
                                      requerimento.nrPorta),
                                  SizedBox(height: 2),
                                  buildRichText('ANDAR: ',
                                      requerimento.nrAndar.toString()),
                                  SizedBox(height: 2),
                                  buildRichText('CÓDIGO POSTAL: ',
                                      requerimento.codigoPostal),
                                  SizedBox(height: 2),
                                  buildRichText('DISTRITO: ',
                                      requerimento.distritoUtente),
                                  SizedBox(height: 2),
                                  buildRichText('CONCELHO: ',
                                      requerimento.concelhoUtente),
                                  SizedBox(height: 2),
                                  buildRichText('FREGUESIA: ',
                                      requerimento.freguesiaUtente),
                                  SizedBox(height: 2),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  Center(
                                    child: Text(
                                        'INFORMAÇÕES DE NACIONALIDADE E NATURALIDADE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: secondaryColor),
                                        textAlign: TextAlign.center),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  buildRichText('NATURALIDADE: ',
                                      requerimento.naturalidade),
                                  SizedBox(height: 2),
                                  buildRichText('NACIONALIDADE: ',
                                      requerimento.paisNacionalidadeUtente),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  Center(
                                    child: Text('INFORMAÇÕES DE IDENTIFICAÇÃO',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                        textAlign: TextAlign.center),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  buildRichText(
                                      'TIPO DE DOCUMENTO: ',
                                      getDocumentsDescription(requerimento
                                          .tipoDocumentoIdentificacao)),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'NÚMERO DE DOCUMENTO: ',
                                      requerimento
                                          .numeroDocumentoIdentificacao),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DE UTENTE DE SAÚDE: ',
                                      requerimento.numeroUtenteSaude),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'NÚMERO DE IDENTIFICAÇÃO FISCAL: ',
                                      requerimento.numeroIdentificacaoFiscal),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DE SEGURANÇA SOCIAL: ',
                                      requerimento.numeroSegurancaSocial),
                                  SizedBox(height: 2),
                                  buildRichText('VALIDADE DO DOCUMENTO: ',
                                      requerimento.documentoValidade),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  Center(
                                    child: Text('CENTRO DE SAÚDE REGISTADO',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                        textAlign: TextAlign.center),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  buildRichText('ENTIDADE RESPONSÁVEL: ',
                                      requerimento.nomeEntidadeResponsavel),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(width: 20, thickness: 1),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: secondaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              Center(
                                child: Text(
                                  'INFORMAÇÕES DO REQUERIMENTO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              buildRichText(
                                  'CÓDIGO DO REQUERIMENTO: ',
                                  'REQ/' +
                                      requerimento.idRequerimento.toString()),
                              SizedBox(height: 2),
                              buildRichText('DATA DO PEDIDO: ',
                                  requerimento.dataSubmissao.toString()),
                              SizedBox(height: 2),
                              buildRichText(
                                  'TIPO DO REQUERIMENTO: ',
                                  getTypeDescription(
                                          requerimento.typeRequerimento)
                                      .item1),
                              SizedBox(height: 2),
                              buildRichText(
                                  'ESTADO DO REQUERIMENTO: ',
                                  getStatusDescription(
                                          requerimento.statusRequerimento)
                                      .item1),
                              SizedBox(height: 2),
                              Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              Center(
                                child: Text(
                                  'DOCUMENTOS ASSOCIADOS AO REQUERIMENTO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              ...buildDocumentWidgets(requerimento.documentos!),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _submitValidarRequerimento(requerimento.hashedId);
                      widget.updateTable();
                      Navigator.of(dialogContext).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Validar Requerimento'),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      await _submitRecusarRequerimento(requerimento.hashedId);
                      widget.updateTable();
                      Navigator.of(dialogContext).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Cancelar Requerimento'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildTextRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: title, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }

  Widget buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(text: label, style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Future<void> openDocument(String url) async {
    if (await canLaunch(url)) {
      await launch(url, webOnlyWindowName: '_blank');
    } else {
      print('Não foi possível abrir o documento');
    }
  }

  String extractFileName(String url) {
    var uri = Uri.parse(url);
    String fileName = uri.pathSegments.last;

    const String pathPrefix = 'docs/';
    if (fileName.startsWith(pathPrefix)) {
      fileName = fileName.substring(pathPrefix.length);
    }

    return fileName;
  }

  String getFileExtension(String fileName) {
    return fileName.split('.').last;
  }

  List<Widget> buildDocumentWidgets(List<String> documentos) {
    return documentos.map((documento) {
      String fileName = extractFileName(documento);
      String fileExtension = getFileExtension(fileName);

      String assetName;
      switch (fileExtension.toLowerCase()) {
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

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(assetName, width: 24, height: 24),
              SizedBox(width: 5),
              Expanded(
                child: Text(fileName, overflow: TextOverflow.ellipsis),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                  child: Text('Download'),
                  onPressed: () => openDocument(documento),
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                    onPrimary: buttonTextColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),
            ],
          ),
          Divider(),
        ],
      );
    }).toList();
  }

  Future<void> _submitValidarRequerimento(String hashed_id) async {
    var response = await validarRequerimento(hashed_id);
    if (response.success == true) {
      SuccessAlert.show(context, 'Requrimento Aceite com sucesso');
    } else {
      ErrorAlert.show(context, response.errorMessage.toString());
    }
  }

  Future<void> _submitRecusarRequerimento(String hashed_id) async {
    var response = await recusarRequerimento(hashed_id);
    if (response.success == true) {
      SuccessAlert.show(context, 'Requrimento Recusado com sucesso');
    } else {
      ErrorAlert.show(context, response.errorMessage.toString());
    }
  }
}
