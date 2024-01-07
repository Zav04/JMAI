import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:flutter/material.dart';
import 'requerimento_form.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'tabela_Requerimentos.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/Class/Requerimento.dart';

class Requerimentos extends StatefulWidget {
  final Utilizador user;
  const Requerimentos({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _RequerimentosState createState() => _RequerimentosState();
}

class _RequerimentosState extends State<Requerimentos> {
  List<Requerimento> requerimentos = [];

  @override
  void initState() {
    super.initState();
    fetchRequerimentostoTable(widget.user);
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
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          onPrimary: buttonTextColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          var response = await verificarRequerimentoExistente(
                              widget.user.hashedId);
                          if (response.success) {
                            response.data
                                ? ErrorAlert.show(
                                    context, "Já tem um requerimento em curso")
                                : showRequerimentoFormDialog(context);
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text('Iniciar Requerimento'),
                      ),
                      SizedBox(height: defaultPadding),
                      RequerimentosTable(
                        user: widget.user,
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

  Future<void> showRequerimentoFormDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: RequerimentoForm(
                  utilizador: widget.user, onRequerimentoAdded: updateTable),
            ),
          ),
        );
      },
    );
  }

  void updateTable() async {
    setState(() {
      fetchRequerimentostoTable(widget.user);
    });
  }

  void fetchRequerimentostoTable(Utilizador user) async {
    try {
      var response = await fetchRequerimentos(user.hashedId);
      if (response.success) {
        var jsonData = response.data;
        List<Requerimento> listaRequerimentos = (jsonData as List)
            .map((item) => Requerimento.fromJson(item))
            .toList();

        setState(() {
          requerimentos = listaRequerimentos;
        });
      } else {
        ErrorAlert.show(context, response.errorMessage.toString());
      }
    } catch (e) {
      ErrorAlert.show(context, e.toString());
    }
  }
}
