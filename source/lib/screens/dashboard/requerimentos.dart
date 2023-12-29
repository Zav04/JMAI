import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:flutter/material.dart';
import 'requerimento_form.dart';
import '../main/components/constants.dart';
import 'components/header.dart';
import '../../screens/dashboard/components/tabela.dart';

class Requerimentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
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
                      Tabela(),
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
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: RequerimentoForm(),
              );
            },
          ),
        );
      },
    );
  }
}
