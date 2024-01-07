import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:flutter/material.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'tabela_Requerimentos_Medico_Table.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/Class/Requerimento_DadosUtente.dart';

class RequerimentosMedico extends StatefulWidget {
  final Utilizador user;
  const RequerimentosMedico({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _RequerimentosMedicoState createState() => _RequerimentosMedicoState();
}

class _RequerimentosMedicoState extends State<RequerimentosMedico> {
  List<Requerimento_DadosUtente> requerimentos = [];

  @override
  void initState() {
    super.initState();
    fetchRequerimentostoTable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(user: widget.user),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      RequerimentosMedicoTable(
                        requerimentos: requerimentos,
                        updateTable: updateTable,
                        user: widget.user,
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateTable() async {
    setState(() async {
      await fetchRequerimentostoTable();
    });
  }

  Future<void> fetchRequerimentostoTable() async {
    var dados;
    var itemData;
    try {
      var response = await getRequerimentosUtenteStatusone();
      if (response.success && response.data != null) {
        var jsonData = response.data;
        for (var item in jsonData) {
          var itemData = item['get_requerimentos_utente_status_one'];
          if (itemData['numero_utente_one'] == null &&
              itemData['numero_utente_saude_by_SNS'] != null) {
            response =
                await getDadosNSS(itemData['numero_utente_saude_by_SNS']);
          } else {
            response = await getDadosNSS(itemData['numero_utente_saude']);
          }
          if (response.success) {
            dados = response.data;
            dados[0].forEach((chave, valor) {
              item['get_requerimentos_utente_status_one'][chave] = valor;
            });
          } else {
            ErrorAlert.show(context, response.errorMessage.toString());
          }
        }
        if (jsonData is List) {
          List<Requerimento_DadosUtente> listaRequerimentos =
              jsonData.map((item) {
            itemData = item['get_requerimentos_utente_status_one'];
            return Requerimento_DadosUtente.fromJson(
                itemData as Map<String, dynamic>);
          }).toList();

          setState(() {
            requerimentos = listaRequerimentos;
          });
        }
      }
    } catch (e) {
      ErrorAlert.show(context, e.toString());
    }
  }
}
