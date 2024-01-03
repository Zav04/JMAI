// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:JMAI/Class/Requerimento.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/Class/Utente.dart';

class RequerimentosTable extends StatefulWidget {
  final Utilizador user;

  const RequerimentosTable({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _RequerimentosTableState createState() => _RequerimentosTableState();
}

class _RequerimentosTableState extends State<RequerimentosTable> {
  List<Requerimento> requerimentos = [];
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
    fetchRequerimentostoTable(widget.user);
  }

  String getTypeDescription(int type) {
    switch (type) {
      case 1:
        return 'Mutioso';
      case 2:
        return 'Importação de Veículo Automóvel';
      default:
        return 'Tipo Desconhecido';
    }
  }

  String getStatusDescription(int status) {
    switch (status) {
      case 0:
        return 'Em espera de Aprovação';
      case 1:
        return 'Aprovado a espera de Pre-Avaliação';
      case 2:
        return 'Pré-Avaliação concluída';
      case 3:
        return 'Agendado';
      case 4:
        return 'Finalizado';
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
          Text(
            "Requerimentos",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: const [
                DataColumn(label: Text('Codigo')),
                DataColumn(label: Text('Tipo Requerimento')),
                DataColumn(label: Text('Data do Pedido')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Ações')), // Nova coluna para ações
              ],
              rows: requerimentos
                  .map((requerimento) => DataRow(
                        cells: [
                          DataCell(Text('REQ/' + requerimento.id.toString(),
                              textAlign: TextAlign.center)),
                          DataCell(Text(getTypeDescription(requerimento.type),
                              textAlign: TextAlign.center)),
                          DataCell(Text(requerimento.data.toString(),
                              textAlign: TextAlign.center)),
                          DataCell(Text(
                              getStatusDescription(requerimento.status),
                              textAlign: TextAlign.center)),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.visibility),
                              color: Colors.blue, // O ícone de olho
                              onPressed: () {
                                showUtenteDetailsOverlay(
                                    context, utente, requerimento);
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

  void fetchRequerimentostoTable(Utilizador user) async {
    try {
      var response = await fetchRequerimentos(user.hashedId);
      if (response.success) {
        var jsonData =
            response.data; // A resposta é um mapa JSON (um único objeto)
        Requerimento requerimento = Requerimento.fromJson(jsonData);

        setState(() {
          requerimentos = [requerimento]; // Colocando o objeto em uma lista
        });
      } else {
        ErrorAlert.show(context, response.errorMessage.toString());
      }
    } catch (e) {
      ErrorAlert.show(context, e.toString());
    }
  }

  void showUtenteDetailsOverlay(
      BuildContext context, Utente utente, Requerimento requerimento) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Detalhes do Requerimento',
              style: TextStyle(color: Colors.blue)),
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
                          color: Colors.lightBlue.shade50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Informações do Utente:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Nome Completo: ${utente.nomeCompleto}'),
                              Text('Sexo: ${utente.sexo}'),
                              Text('Morada: ${utente.morada}'),
                              Text('Número da Porta: ${utente.nr_porta}'),
                              Text('Andar: ${utente.nr_andar}'),
                              Text('Código Postal: ${utente.nr_codigo_postal}'),
                              Text(
                                  'Data de Nascimento: ${utente.dataNascimento}'),
                              Text('Distrito: ${utente.distrito}'),
                              Text('Concelho: ${utente.concelho}'),
                              Text('Freguesia: ${utente.freguesia}'),
                              Text('Naturalidade: ${utente.naturalidade}'),
                              Text(
                                  'Nacionalidade: ${utente.paisNacionalidade}'),
                              Text(
                                  'Tipo de Documento: ${utente.tipoDocumentoIdentificacao}'),
                              Text(
                                  'Número de Documento: ${utente.numeroDocumentoIdentificacao}'),
                              Text(
                                  'Número de Utente de Saúde: ${utente.numeroUtenteSaude}'),
                              Text(
                                  'Número de Identificação Fiscal: ${utente.numeroIdentificacaoFiscal}'),
                              Text(
                                  'Número de Segurança Social: ${utente.numeroSegurancaSocial}'),
                              Text(
                                  'Validade do Documento: ${utente.documentoValidade}'),
                              Text(
                                  'Número de Telemóvel: ${utente.numeroTelemovel}'),
                              Text(
                                  'Entidade Responsável: ${utente.nomeEntidadeResponsavel}'),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(width: 20, thickness: 1),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.lightGreen.shade50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Informações do Requerimento:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                              SizedBox(height: 8),
                              Text('Informações do Requerimento:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              // Suponha que as informações do requerimento sejam semelhantes a estas
                              Text(
                                  'Código do Requerimento: REQ/${requerimento.id}'),
                              Text(
                                  'Tipo do Requerimento: ${getTypeDescription(requerimento.type)}'),
                              Text(
                                  'Data do Pedido: ${requerimento.data.toString()}'),
                              Text(
                                  'Estado do Requerimento: ${getStatusDescription(requerimento.status)}'),
                              // ... Outros campos ...
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
            TextButton(
              child: Text('Fechar', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
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

  void verifyisUtente(Utilizador user) {
    if (user is Utente) {
      setState(() {
        utente = user;
      });
    }
  }
}
