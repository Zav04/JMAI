import 'dart:typed_data';
import 'package:JMAI/Class/Requerimento.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

//TODO MELHORAR ISTO PARA O FORMULARIO QUE TENHO COMO PADRÃO
Future<void> generatePdfForm(Utente utente, Requerimento requerimento) async {
  final pdf = pw.Document();

  final fontData = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttf,
        italic: ttf,
        boldItalic: ttf,
      ),
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.Header(
              level: 0,
              child: pw.Text('Exmo/a Senhor/a\nDiretor/a Executivo/a',
                  textAlign: pw.TextAlign.center)),
          pw.Paragraph(text: 'Identificação'),
          pw.Checkbox(name: 'teste', value: true),
          pw.Table.fromTextArray(context: context, data: const [
            ['Nome', ''],
            ['Utente do SNS nº', ''],
            [
              'Bilhete de Identidade / CC nº',
              'Emitido pelo D.S.I.C. de',
              'em',
              'Válido até'
            ],
            ['Nº Cont.', ''],
          ]),
          pw.Paragraph(text: 'Naturalidade'),
          pw.Table.fromTextArray(context: context, data: const [
            ['Data de nascimento:', '', 'Freguesia de', '', 'Concelho', ''],
          ]),
          pw.Paragraph(text: 'Residência'),
          pw.Table.fromTextArray(context: context, data: const [
            ['Rua', ''],
            ['Código Postal', '', 'Freguesia de', '', 'Concelho', ''],
            ['Telefone nº', ''],
          ]),
          pw.Paragraph(
              text:
                  'Venho solicitar a V. Ex.ª, que ao abrigo do nº 1 do art. 3º do Decreto – Lei nº 291 / 2009 de 12 de outubro seja admitido a Junta Médica para Avaliação do grau de incapacidade para efeito de:'),
          pw.Bullet(
              text:
                  'Multiuso (Decreto-Lei nº 202/96, de 23 de outubro com a redação dada pelo Decreto-Lei nº 174/97 de 19 de julho)'),
          pw.Bullet(
              text:
                  'Importação de veículo automóvel e outros (Lei nº 22-A/2007 de 29 de junho 2007).'),
          pw.Paragraph(
              text:
                  'Comprometendo-se a ser portador de toda a informação clínica respeitante à(s) doença(s) e/ou deficiência(s) que justifica(m) este pedido.'),
          pw.Paragraph(text: 'Informa ainda que:'),
          pw.Bullet(
              text:
                  'Nunca foi submetido a Junta Médica de avaliação do grau de incapacidade.'),
          pw.Bullet(
              text:
                  'Já foi submetido em (data) _______/_______/_________, pretendendo uma reavaliação.'),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                  'Pede deferimento\n\n____________ de __________________ de 202__',
                  textAlign: pw.TextAlign.left),
              pw.Text('(assinatura)', textAlign: pw.TextAlign.right)
            ],
          ),
        ]);
      },
    ),
  );

  // Salva o documento PDF
  Uint8List pdfInBytes = await pdf.save();

  // Preparando para o download
  final blob = html.Blob([pdfInBytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "example.pdf")
    ..click();
  html.Url.revokeObjectUrl(url);
}
