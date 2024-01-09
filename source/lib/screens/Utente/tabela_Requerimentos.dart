import 'package:JMAI/Class/Pre_Avalicao.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:flutter/material.dart';
import 'package:JMAI/Class/Requerimento.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/screens/main/components/Etiquetas.dart';
import 'package:intl/intl.dart';
import 'package:JMAI/screens/main/components/GeneratePdf.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/Class/DateTime.dart';
import 'package:JMAI/screens/main/components/Descriptions.dart';

class RequerimentosTable extends StatefulWidget {
  final Utilizador user;
  final List<Requerimento> requerimentos;
  final VoidCallback updateTable;
  const RequerimentosTable({
    Key? key,
    required this.user,
    required this.requerimentos,
    required this.updateTable,
  }) : super(key: key);

  @override
  _RequerimentosTableState createState() => _RequerimentosTableState();
}

class _RequerimentosTableState extends State<RequerimentosTable> {
  DateTime? selectedDateTime;
  String dataJuntaMedica = '';

  PreAvalicao preAvalicao = PreAvalicao(
    hashed_id_pre_avaliacao: '',
    pre_avaliacao: '',
    data_pre_avaliacao: '',
    nome_medico: '',
    especialidade: '',
  );

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
    pais: '',
    tipoDocumentoIdentificacao: 0,
    numeroDocumentoIdentificacao: 0,
    numeroUtenteSaude: 0,
    numeroIdentificacaoFiscal: 0,
    numeroSegurancaSocial: 0,
    documentoValidade: '',
    numeroTelemovel: 0,
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
                                  onPressed: () async {
                                    if (requerimento.status >= 2 &&
                                        requerimento.status <= 6) {
                                      await preAvalicaoData(
                                          requerimento.hashedId);
                                      if (requerimento.status == 3 ||
                                          requerimento.status == 4) {
                                        await getAgendamento(
                                            requerimento.hashedId);
                                      }
                                      showDetailsOverlay(
                                          context, utente, requerimento);
                                    } else {
                                      showDetailsOverlay(
                                          context, utente, requerimento);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.download),
                                  color: Colors.redAccent,
                                  onPressed: () async {
                                    if (requerimento.status == 0 ||
                                        requerimento.status == 1 ||
                                        requerimento.status == 7) {
                                      await requerimentoPdf(
                                          utente, requerimento);
                                    }

                                    if (requerimento.status == 2 ||
                                        requerimento.status == 5 ||
                                        requerimento.status == 6) {
                                      if (requerimento.status >= 2 &&
                                          requerimento.status <= 6) {
                                        await preAvalicaoData(
                                            requerimento.hashedId);
                                      }

                                      await preAvalicaoPdf(
                                          utente, requerimento, preAvalicao);
                                    }
                                    if (requerimento.status == 3) {
                                      if (requerimento.status >= 2 &&
                                          requerimento.status <= 6) {
                                        await preAvalicaoData(
                                            requerimento.hashedId);
                                        if (requerimento.status == 3 ||
                                            requerimento.status == 4) {
                                          await getAgendamento(
                                              requerimento.hashedId);
                                        }
                                      }

                                      await preAvalicaoPdf(
                                          utente, requerimento, preAvalicao);
                                    }
                                  },
                                ),
                                if (requerimento.status == 2) ...[
                                  IconButton(
                                    icon: Icon(
                                        Icons.check_circle_outline_outlined),
                                    color: Colors.green,
                                    onPressed: () async {
                                      var response = await acceptJuntaMedica(
                                          requerimento.hashedId);
                                      if (response) {
                                        widget.updateTable();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close_outlined),
                                    color: Colors.red,
                                    onPressed: () async {
                                      var response = await declineJuntaMedica(
                                          requerimento.hashedId);
                                      if (response) {
                                        widget.updateTable();
                                      }
                                    },
                                  ),
                                ],
                                if (requerimento.status == 6) ...[
                                  IconButton(
                                      icon: Icon(Icons.calendar_month_outlined),
                                      color: Colors.green,
                                      onPressed: () async {
                                        await showCalendarAndTimeDialog(
                                            context);
                                        agendarJuntaMedica(requerimento);
                                      }),
                                ],
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

  void showDetailsOverlay(
      BuildContext context, Utente utente, Requerimento requerimento) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Blend tipoRequerimentoBlend = Blend(
          getTypeDescription(requerimento.type),
        );
        Blend estadoRequerimentoBlend = Blend(
          getStatusDescription(requerimento.status),
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
                                  buildRichText(
                                      'Nome Completo: ', utente.nomeCompleto),
                                  SizedBox(height: 2),
                                  buildRichText('Sexo: ', utente.sexo),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Tipo de Documento: ',
                                      getDocumentsDescription(
                                          utente.tipoDocumentoIdentificacao)),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número de Documento: ',
                                      utente.numeroDocumentoIdentificacao
                                          .toString()),
                                  SizedBox(height: 2),
                                  buildRichText('Número de Utente de Saúde: ',
                                      utente.numeroUtenteSaude.toString()),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número de Identificação Fiscal: ',
                                      utente.numeroIdentificacaoFiscal
                                          .toString()),
                                  SizedBox(height: 2),
                                  buildRichText('Número Segurança Social: ',
                                      utente.numeroSegurancaSocial.toString()),
                                  SizedBox(height: 2),
                                  buildRichText('Validade Documento: ',
                                      utente.documentoValidade),
                                  SizedBox(height: 2),
                                  buildRichText('Email: ', utente.email),
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
                                      utente.dataNascimento),
                                  SizedBox(height: 2),
                                  buildRichText('Distrito: ', utente.distrito),
                                  SizedBox(height: 2),
                                  buildRichText('Concelho: ', utente.concelho),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Freguesia: ', utente.freguesia),
                                  SizedBox(height: 2),
                                  buildRichText('Naturalidade: ', utente.pais),
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
                                  buildRichText('Morada: ', utente.morada),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Número Porta: ', utente.nr_porta),
                                  if (utente.nr_andar != null &&
                                      utente.nr_andar!.isNotEmpty) ...[
                                    SizedBox(height: 2),
                                    buildRichText('Andar: ', utente.nr_andar!),
                                  ],
                                  SizedBox(height: 2),
                                  buildRichText('Código Postal: ',
                                      utente.nr_codigo_postal),
                                  SizedBox(height: 2),
                                  buildRichText(
                                      'Freguesia: ', utente.freguesia),
                                  SizedBox(height: 2),
                                  buildRichText('Concelho: ', utente.concelho),
                                  SizedBox(height: 2),
                                  buildRichText('Número Telemovel: ',
                                      utente.numeroTelemovel.toString()),
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
                              buildRichText('Código do Requerimento: ',
                                  'REQ/' + requerimento.id.toString()),
                              SizedBox(height: 2),
                              buildRichText('Data do Pedido: ',
                                  requerimento.data.toString()),
                              SizedBox(height: 5),
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
                              SizedBox(height: 5),
                              buildRichText(
                                  'Ja foi submetido a um Junta Medica?: ',
                                  requerimento.submetido == true
                                      ? 'Sim'
                                      : 'Não'),
                              if (requerimento.submetido == true) ...[
                                buildRichText(
                                    'Data que foi submetido: ',
                                    formatDateString(
                                        requerimento.data_submetido!)),
                              ],
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
                              if (requerimento.documentos.length == 0) ...[
                                Text(
                                  'Não existem documentos associados ao requerimento',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              if (requerimento.documentos.length > 0) ...[
                                ...buildDocumentWidgets(
                                    requerimento.documentos),
                              ],
                              if (requerimento.status >= 2) ...[
                                Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                                Center(
                                  child: Text(
                                    'INFORMAÇÕES DA PRÉ-AVALIAÇÃO',
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
                                SizedBox(height: 2),
                                buildRichText(
                                    'Data da Pré Avaliação: ',
                                    formatTimestampString(
                                        preAvalicao.data_pre_avaliacao)),
                                SizedBox(height: 2),
                                buildRichText('Médico Responsável: ',
                                    preAvalicao.nome_medico),
                                SizedBox(height: 2),
                                buildRichText('Especialidade do Médico: ',
                                    preAvalicao.especialidade),
                                buildRichText('Resultado da Pré Avaliação: ',
                                    preAvalicao.pre_avaliacao.toString()),
                                if (preAvalicao.observacoes != '') ...[
                                  SizedBox(height: 2),
                                  buildRichText('Observações: ',
                                      preAvalicao.observacoes.toString()),
                                  SizedBox(height: 2),
                                ],
                                Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                                if (requerimento.status == 3 ||
                                    requerimento.status == 4) ...[
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  Center(
                                    child: Text(
                                      'INFORMAÇÕES DO AGENDAMENTO DA JUNTA MÉDICA',
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
                                  SizedBox(height: 2),
                                  buildRichText('Data da Junta Médica: ',
                                      formatTimestampString(dataJuntaMedica)),
                                  Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                ],
                              ]
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

  Future<void> preAvalicaoData(String hashedId) async {
    var response = await getDadosPreAvalicao(hashedId);
    if (response.success) {
      setState(() {
        preAvalicao = PreAvalicao(
          hashed_id_pre_avaliacao: response.data[0]['hashed_id_pre_avaliacao'],
          pre_avaliacao: response.data[0]['pre_avaliacao'],
          observacoes: response.data[0]['observacoes'],
          data_pre_avaliacao: response.data[0]['data_pre_avaliacao'],
          nome_medico: response.data[0]['nome_medico'],
          especialidade: response.data[0]['especialidade'],
        );
      });
    } else {
      ErrorAlert.show(
          context, 'Não foi possível obter os dados da pré-avaliação');
    }
  }

  Future<void> getAgendamento(String hashedId) async {
    var response = await getAgendamentoJuntaMedica(hashedId);
    if (response.success) {
      setState(() {
        dataJuntaMedica = response.data;
      });
    } else {
      ErrorAlert.show(
          context, 'Não foi possível obter os dados da pré-avaliação');
    }
  }

  Future<bool> acceptJuntaMedica(String hashed_id) async {
    var response = await acceptJuntaMedicaRequerimento(hashed_id);
    if (response.success) {
      return true;
    } else {
      ErrorAlert.show(
          context, 'Não foi possível atualizar o estado do requerimento');
      return false;
    }
  }

  Future<bool> declineJuntaMedica(String hashed_id) async {
    var response = await declineJuntaMedicaRequerimento(hashed_id);
    if (response.success) {
      return true;
    } else {
      ErrorAlert.show(
          context, 'Não foi possível atualizar o estado do requerimento');
      return false;
    }
  }

  Future<void> agendarJuntaMedica(Requerimento requerimento) async {
    String strData = selectedDateTime!.toString();
    var response =
        await agendarJuntaMedicaRequerimento(strData, requerimento.hashedId);
    if (response.success) {
      widget.updateTable();
      sendEmailAgendado(utente.email, formatTimestampString(strData));
      SuccessAlert.show(context, 'Junta médica agendada com sucesso');
    } else {
      widget.updateTable();
      ErrorAlert.show(context, response.errorMessage.toString());
    }
  }

  Future<TimeOfDay?> showCustomTimePicker(BuildContext context) async {
    TimeOfDay? selectedTime;
    int? selectedHourIndex;
    final List<int> availableHours = List.generate(13, (index) => 8 + index);

    // Mostra um diálogo com a lista de horários permitidos
    return await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Selecione um horário',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: Container(
                height: 500,
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableHours.length,
                        itemBuilder: (BuildContext context, int index) {
                          int hour = availableHours[index];
                          bool isSelected = selectedHourIndex == index;
                          return ListTile(
                            title: Text('${hour}:00'),
                            tileColor: isSelected ? Colors.blue : null,
                            onTap: () {
                              setState(() {
                                selectedHourIndex = index;
                                selectedTime = TimeOfDay(hour: hour, minute: 0);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    TextButton(
                      onPressed: selectedTime != null
                          ? () {
                              Navigator.pop(context, selectedTime);
                            }
                          : null,
                      style: TextButton.styleFrom(
                        backgroundColor:
                            selectedTime != null ? Colors.blue : Colors.grey,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Agendar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showCalendarAndTimeDialog(BuildContext context) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    // Mostra o DatePicker
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'PT'),
    );

    if (selectedDate != null) {
      // Chama a função personalizada para escolher a hora
      selectedTime = await showCustomTimePicker(context);

      if (selectedTime != null) {
        // Combina a data e a hora em um objeto DateTime
        final combinedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
        );

        await showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmação de Agendamento'),
              content: Text(
                'Deseja Agendar uma Junta Médica em: ${DateFormat('dd/MM/yyyy HH:mm').format(combinedDateTime)}',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    selectedDateTime = combinedDateTime;
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Agendar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
