import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:flutter/material.dart';
import 'requerimento_form.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'tabela_Requerimentos.dart';

class Requerimentos extends StatelessWidget {
  final Utilizador user;
  const Requerimentos({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(user: user),
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
                        onPressed: () => _showRequerimentoFormDialog(context),
                        icon: Icon(Icons.add),
                        label: Text('Iniciar Requerimento'),
                      ),
                      SizedBox(height: defaultPadding),
                      RequerimentosTable(user: user),
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

  Future<void> _showRequerimentoFormDialog(BuildContext context) async {
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
                utilizador: user,
              ),
            ),
          ),
        );
      },
    );
  }
}
