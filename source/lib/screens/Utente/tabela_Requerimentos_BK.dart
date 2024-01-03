// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:JMAI/Class/Requerimento.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';

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

  @override
  void initState() {
    super.initState();
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
    return DataTable(
      columns: const [
        DataColumn(label: Text('Codigo')),
        DataColumn(label: Text('Tipo Requerimento')),
        DataColumn(label: Text('Data do Pedido')),
        DataColumn(label: Text('Estado')),
      ],
      rows: requerimentos
          .map((requerimento) => DataRow(
                cells: [
                  DataCell(Text('REQ/' + requerimento.id.toString())),
                  DataCell(Text(getTypeDescription(requerimento.type))),
                  DataCell(Text(requerimento.data.toString())),
                  DataCell(Text(getStatusDescription(requerimento.status))),
                ],
              ))
          .toList(),
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
}
