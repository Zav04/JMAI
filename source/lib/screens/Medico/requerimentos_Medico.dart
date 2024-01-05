import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:flutter/material.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'tabela_Requerimentos_Medico_Table.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/Class/Requerimento_SecretarioClinico.dart';

class RequerimentosMedico extends StatefulWidget {
  final Utilizador user;
  const RequerimentosMedico({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _RequerimentosSCState createState() => _RequerimentosSCState();
}

class _RequerimentosSCState extends State<RequerimentosMedico> {
  List<RequerimentoSC> requerimentos = [];

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
                      RequerimentosSCTable(
                        requerimentos: requerimentos,
                        updateTable: updateTable,
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
    try {
      var response = await getRequerimentosUtenteStatusZero();
      if (response.success) {
        var jsonData = response.data;
        if (jsonData is List) {
          List<RequerimentoSC> listaRequerimentos = jsonData.map((item) {
            var itemData = item['get_requerimentos_utente_status_zero'];
            return RequerimentoSC.fromJson(itemData as Map<String, dynamic>);
          }).toList();

          setState(() {
            requerimentos = listaRequerimentos;
          });
        } else {
          print('Dados recebidos não estão no formato de lista');
        }
      } else {
        ErrorAlert.show(context, response.errorMessage.toString());
      }
    } catch (e) {
      ErrorAlert.show(context, 'Erro ao processar os dados');
    }
  }
}
