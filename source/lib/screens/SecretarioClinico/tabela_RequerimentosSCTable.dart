// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:JMAI/Class/Requerimento_DadosUtente.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/screens/main/components/Descriptions.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Centraliza o texto na Stack
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Requerimentos",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // Posiciona o ícone de refresh no canto direito
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    // Sua lógica de recarregamento da tabela
                    widget.updateTable();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: const [
                DataColumn(label: Text('CODIGO')),
                DataColumn(label: Text('NOME DO UTENTE')),
                DataColumn(label: Text('NÚMERO DE SAÚDE')),
                DataColumn(label: Text('TIPO REQUERIMENTO')),
                DataColumn(label: Text('DATA DO PEDIDO')),
                DataColumn(label: Text('AÇÕES')),
              ],
              rows: sortRequerimentos()
                  .map((requerimento) => DataRow(
                        cells: [
                          DataCell(Text(
                            'REQ/' + requerimento.idRequerimento.toString(),
                          )),
                          DataCell(Text(
                            requerimento.nomeCompleto,
                          )),
                          DataCell(Text(
                            requerimento.numeroUtenteSaude.toString(),
                          )),
                          DataCell(Blend(getTypeDescription(
                                  requerimento.typeRequerimento))
                              .widget),
                          DataCell(Text(
                            requerimento.dataSubmissao.toString(),
                          )),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.file_present_outlined),
                              color: Colors.blue,
                              onPressed: () {
                                showDetailsOverlay(context, requerimento);
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

  void showDetailsOverlay(
      BuildContext context, Requerimento_DadosUtente requerimento) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Blend tipoRequerimentoBlend = Blend(
          getTypeDescription(requerimento.typeRequerimento),
        );
        Blend estadoRequerimentoBlend = Blend(
          getStatusDescription(requerimento.statusRequerimento),
        );
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
                                  'IDENTIFICAÇÃO DO UTENTE',
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
                                  buildRichText('Nome Completo: ',
                                      requerimento.nomeCompleto),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Sexo: ', requerimento.sexoUtente),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Tipo de Documento: ',
                                      getDocumentsDescription(requerimento
                                          .tipoDocumentoIdentificacao)),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número de Documento: ',
                                      requerimento.numeroDocumentoIdentificacao
                                          .toString()),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número de Utente de Saúde: ',
                                      requerimento.numeroUtenteSaude
                                          .toString()),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número de Identificação Fiscal: ',
                                      requerimento.numeroIdentificacaoFiscal
                                          .toString()),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número Segurança Social: ',
                                      requerimento.numeroSegurancaSocial
                                          .toString()),
                                  SizedBox(height: 2),
                                  buildRichText('Validade Documento: ',
                                      requerimento.documentoValidade),
                                  if (requerimento.emailUtente != null &&
                                      requerimento.emailUtente!.isNotEmpty) ...[
                                    SizedBox(height: 2),
                                    buildRichText(
                                        'Andar: ', requerimento.emailUtente!),
                                  ],
                                  SizedBox(height: 2),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  Center(
                                    child: Text('NATURALIDADE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                        textAlign: TextAlign.center),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  buildRichText('Data de Nascimento: ',
                                      requerimento.dataNascimentoUtente),
                                  SizedBox(height: 2),
                                  buildRichText('Distrito: ',
                                      requerimento.distritoUtente),
                                  SizedBox(height: 2),
                                  buildRichText('Concelho: ',
                                      requerimento.concelhoUtente),
                                  SizedBox(height: 2),
                                  buildRichText('Freguesia: ',
                                      requerimento.freguesiaUtente),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Naturalidade: ', requerimento.pais),
                                  SizedBox(height: 2),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  Center(
                                    child: Text(
                                      'RESIDÊNCIA',
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
                                  buildRichText(
                                      'Morada: ', requerimento.morada),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número Porta: ', requerimento.nrPorta),
                                  if (requerimento.nrAndar != null &&
                                      requerimento.nrAndar!.isNotEmpty) ...[
                                    SizedBox(height: 2),
                                    buildRichText(
                                        'Andar: ', requerimento.nrAndar!),
                                  ],
                                  SizedBox(height: 2),
                                  buildRichText('Código Postal: ',
                                      requerimento.codigoPostal),
                                  SizedBox(height: 2),
                                  buildRichText('Freguesia: ',
                                      requerimento.freguesiaUtente),
                                  SizedBox(height: 2),
                                  buildRichText('Concelho: ',
                                      requerimento.concelhoUtente),
                                  SizedBox(height: 2),
                                  buildRichText('Número Telemovel: ',
                                      requerimento.numeroTelemovel.toString()),
                                  SizedBox(height: 2),
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
                                  buildRichText('Entidade Responsável: ',
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
                                  'Código do Requerimento: ',
                                  'REQ/' +
                                      requerimento.idRequerimento.toString()),
                              SizedBox(height: 2),
                              buildRichText('Data do Pedido: ',
                                  requerimento.dataSubmissao.toString()),
                              if (requerimento.nuncaSubmetido == true) ...[
                                SizedBox(height: 2),
                                buildRichText('Pedido: ',
                                    'Nunca foi submetido a junta médica'),
                                SizedBox(height: 5),
                              ],
                              if (requerimento.submetido == true) ...[
                                SizedBox(height: 2),
                                buildRichText(
                                    'Pedido: ',
                                    'Ja foi submetido a junta médica em ' +
                                        requerimento.data_submetido.toString() +
                                        ' e requer reavaliação'),
                                SizedBox(height: 5),
                              ],
                              Row(
                                children: [
                                  Text('Tipo do Requerimento: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey)),
                                  tipoRequerimentoBlend.widget,
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Estado do Requerimento: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  estadoRequerimentoBlend.widget,
                                ],
                              ),
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
                              if (requerimento.documentos!.length == 0) ...[
                                Text(
                                  'Não existem documentos associados ao requerimento',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              if (requerimento.documentos!.length > 0) ...[
                                ...buildDocumentWidgets(
                                    requerimento.documentos!),
                              ],
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
                  SizedBox(
                    width: 220, // Largura do botão
                    height: 50, // Altura do botão
                    child: TextButton(
                      onPressed: () async {
                        await _submitValidarRequerimento(requerimento.hashedId);
                        sendEmailRequerimentoAceite(requerimento.emailUtente!);
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
                      child: Text('VALIDAR REQUERIMENTO'),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 220, // Largura do botão
                    height: 50, // Altura do botão
                    child: TextButton(
                      onPressed: () async {
                        await _submitRecusarRequerimento(requerimento.hashedId);
                        sendEmailRequerimentoRecusado(
                            requerimento.emailUtente!);
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
                      child: Text('CANCELAR REQUERIMENTO'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
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
          TextSpan(
              text: label,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Future<void> openDocument(String url) async {
    if (await canLaunch(url)) {
      await launch(url, webOnlyWindowName: '_blank');
    } else {
      ErrorAlert.show(context, 'Não foi possível abrir o documento');
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
}
