import 'package:flutter/material.dart';
import 'package:JMAI/Class/Requerimento.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';
import 'package:JMAI/screens/main/components/Etiquetas.dart';
import 'package:intl/intl.dart';
import 'package:JMAI/screens/main/components/GeneratePdf.dart';

class RequerimentosTable extends StatefulWidget {
  final Utilizador user;
  final List<Requerimento> requerimentos;
  const RequerimentosTable({
    Key? key,
    required this.user,
    required this.requerimentos,
  }) : super(key: key);

  @override
  _RequerimentosTableState createState() => _RequerimentosTableState();
}

class _RequerimentosTableState extends State<RequerimentosTable> {
  Utente utente = Utente(
    hashedId: '',
    email: '',
    nomeCompleto: '',
    sexo: '',
    morada: '',
    nr_porta: '',
    nr_andar: '',
    nr_codigo_postal: '',
    dataNascimento: '',
    distrito: '',
    concelho: '',
    freguesia: '',
    naturalidade: '',
    paisNacionalidade: '',
    tipoDocumentoIdentificacao: 0,
    numeroDocumentoIdentificacao: '',
    numeroUtenteSaude: '',
    numeroIdentificacaoFiscal: '',
    numeroSegurancaSocial: '',
    documentoValidade: '',
    numeroTelemovel: '',
    nomeEntidadeResponsavel: '',
  );

  @override
  void initState() {
    super.initState();
    verifyisUtente(widget.user);
  }

  List<Requerimento> sortRequerimentos() {
    List<Requerimento> requerimentos = widget.requerimentos;
    requerimentos.sort((Requerimento a, Requerimento b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a.data);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b.data);
      return dateB.compareTo(dateA);
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
      case 5:
        return Tuple2('Cancelado', Colors.red);
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
            "REQUERIMENTOS",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Divider(
            color: Colors.white,
            thickness: 2,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: const [
                DataColumn(
                    label: Text(
                  'CODIGO',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'TIPO REQUERIMENTO',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'DATA DO PEDIDO',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'ESTADO',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'AÇÕES',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
              ],
              rows: sortRequerimentos()
                  .map((requerimento) => DataRow(
                        cells: [
                          DataCell(Text(
                            'REQ/' + requerimento.id.toString(),
                          )),
                          DataCell(Blend(getTypeDescription(requerimento.type))
                              .widget),
                          DataCell(Text(
                            requerimento.data.toString(),
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataCell(
                              Blend(getStatusDescription(requerimento.status))
                                  .widget),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility),
                                  color: Colors.blue,
                                  onPressed: () {
                                    showUtenteDetailsOverlay(
                                        context, utente, requerimento);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.download),
                                  color: Colors.redAccent,
                                  onPressed: () async {
                                    await generatePdfForm(utente, requerimento);
                                  },
                                ),
                              ],
                            ),
                          )
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
      BuildContext context, Utente utente, Requerimento requerimento) {
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
                                  buildRichText(
                                      'NOME COMPLETO: ', utente.nomeCompleto),
                                  SizedBox(height: 2),
                                  buildRichText('DATA DE NASCIMENTO: ',
                                      utente.dataNascimento),
                                  SizedBox(height: 2),
                                  buildRichText('SEXO: ', utente.sexo),
                                  SizedBox(height: 2),
                                  buildRichText('EMAIL: ', utente.email),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DE TELEMÓVEL: ',
                                      utente.numeroTelemovel),
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
                                  buildRichText('MORADA: ', utente.morada),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'NÚMERO DA PORTA: ', utente.nr_porta),
                                  SizedBox(height: 2),
                                  buildRichText('ANDAR: ', utente.nr_andar),
                                  SizedBox(height: 2),
                                  buildRichText('CÓDIGO POSTAL: ',
                                      utente.nr_codigo_postal),
                                  SizedBox(height: 2),
                                  buildRichText('DISTRITO: ', utente.distrito),
                                  SizedBox(height: 2),
                                  buildRichText('CONCELHO: ', utente.concelho),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'FREGUESIA: ', utente.freguesia),
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
                                  buildRichText(
                                      'NATURALIDADE: ', utente.naturalidade),
                                  SizedBox(height: 2),
                                  buildRichText('NACIONALIDADE: ',
                                      utente.paisNacionalidade),
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
                                      getDocumentsDescription(
                                          utente.tipoDocumentoIdentificacao)),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DE DOCUMENTO: ',
                                      utente.numeroDocumentoIdentificacao),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DE UTENTE DE SAÚDE: ',
                                      utente.numeroUtenteSaude),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'NÚMERO DE IDENTIFICAÇÃO FISCAL: ',
                                      utente.numeroIdentificacaoFiscal),
                                  SizedBox(height: 2),
                                  buildRichText('NÚMERO DE SEGURANÇA SOCIAL: ',
                                      utente.numeroSegurancaSocial),
                                  SizedBox(height: 2),
                                  buildRichText('VALIDADE DO DOCUMENTO: ',
                                      utente.documentoValidade),
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
                                      utente.nomeEntidadeResponsavel),
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
                              buildRichText('CÓDIGO DO REQUERIMENTO: ',
                                  'REQ/' + requerimento.id.toString()),
                              SizedBox(height: 2),
                              buildRichText('DATA DO PEDIDO: ',
                                  requerimento.data.toString()),
                              SizedBox(height: 2),
                              buildRichText('TIPO DO REQUERIMENTO: ',
                                  getTypeDescription(requerimento.type).item1),
                              SizedBox(height: 2),
                              buildRichText(
                                  'ESTADO DO REQUERIMENTO: ',
                                  getStatusDescription(requerimento.status)
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
                              ...buildDocumentWidgets(requerimento.documentos),
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

  void verifyisUtente(Utilizador user) {
    if (user is Utente) {
      setState(() {
        utente = user;
      });
    }
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
}
