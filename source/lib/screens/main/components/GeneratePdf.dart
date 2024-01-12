import 'dart:typed_data';
import 'package:JMAI/Class/DateTime.dart';
import 'package:JMAI/Class/Pre_Avalicao.dart';
import 'package:JMAI/Class/Requerimento.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> requerimentoPdf(Utente utente, Requerimento requerimento) async {
  final pdf = pw.Document();
  final imageBytes = await rootBundle.load('assets/images/Footer.png');
  final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

  //final fontData = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  //final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Image(
                image,
                width: 300,
                height: 150,
              )),
          pw.Divider(),
          pw.Text('Exmo/a Senhor/a,Diretor/a Executivo/a',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          _buildTitle('Identificação'),
          pw.Row(children: [
            _subTiltleTextField('Nome: '),
            _buildTextField(utente.nomeCompleto),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Utente do SNS nº: '),
            _buildTextField(utente.numeroUtenteSaude.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Bilhete de Idenetidade/CC nº: '),
            _buildTextField(utente.numeroDocumentoIdentificacao.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Válido até: '),
            _buildTextField(utente.documentoValidade.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Número de Contribuinte: '),
            _buildTextField(utente.numeroIdentificacaoFiscal.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Número Segurança Social: '),
            _buildTextField(utente.numeroSegurancaSocial.toString()),
          ]),
          _buildTitle('Naturalidade'),
          pw.Row(children: [
            _subTiltleTextField('Data de Nascimento: '),
            _buildTextField(utente.dataNascimento),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Freguesia de: '),
            _buildTextField(utente.freguesia),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Concelho: '),
            _buildTextField(utente.concelho),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Distrito: '),
            _buildTextField(utente.distrito),
          ]),
          pw.Row(children: [
            _subTiltleTextField('País: '),
            _buildTextField(utente.pais),
          ]),
          _buildTitle('Resisdência'),
          pw.Row(children: [
            _subTiltleTextField('Morada: '),
            _buildTextField(utente.morada),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Código Postal: '),
            _buildTextField(utente.nr_codigo_postal),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Freguesia de: '),
            _buildTextField(utente.freguesia),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Concelho: '),
            _buildTextField(utente.concelho),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Distrito: '),
            _buildTextField(utente.distrito),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Telefone nº: '),
            _buildTextField(utente.numeroTelemovel.toString()),
          ]),
          pw.SizedBox(height: 10),
          _buildTextField(
              'Venho solicitar a V. Ex.ª, que ao abrigo do nº 1 do art. 3º do Decreto Lei nº 291 / 2009 de 12 de outubro seja admitido a Junta Médica para Avaliação do grau de incapacidade para efeito de:'),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.type == 1),
              _buildTextField(
                  'Multiuso (Decreto-Lei nº 202/96, de 23 de outubro com a redação dada pelo Decreto-Lei nº 174/97 de 19 de julho)'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.type == 2),
              _buildTextField(
                  'Importação de veículo automóvel e outros (Lei nº 22-A/2007 de 29 de junho 2007).'),
            ],
          ),
          pw.SizedBox(height: 10),
          _buildTextField(
              'Comprometendo-se a ser portador de toda a informação clínica respeitante à(s) doença(s) e/ou deficiência(s) que justifica(m) este pedido.'),
          _buildTextField('Informa ainda que:'),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.nuncaSubmetido!),
              _buildTextField(
                  'Nunca foi submetido a Junta Médica de avaliação do grau de incapacidade.'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.submetido!),
              _buildTextField('Já foi submetido em (data) '),
              if (requerimento.submetido == true) ...[
                _buildTextField(
                    formatDateString(requerimento.data_submetido!.toString())),
              ] else
                _buildTextField("__/__/____"),
              _buildTextField(' pretendendo uma reavaliação.'),
            ],
          ),
          pw.SizedBox(height: 10),
          _buildCenteredSection([
            _subTiltleTextField('Pede deferimento'),
            _buildTextField(dataPorExtenso(requerimento.data)),
            _buildTextField(utente.nomeCompleto),
            _buildLowTextField('assinatura'),
          ]),
        ]);
      },
    ),
  );

  Uint8List pdfInBytes = await pdf.save();
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/Requerimento.pdf');
  await file.writeAsBytes(pdfInBytes);
  await Share.shareFiles(['${directory.path}/Requerimento.pdf'],
      text: 'Requerimento.pdf');
}

Future<void> preAvalicaoPdf(
    Utente utente, Requerimento requerimento, PreAvalicao preAvalicao) async {
  final pdf = pw.Document();

  final imageBytes = await rootBundle.load('assets/images/Footer.png');
  final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

  //final fontData = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  //final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Image(
                image,
                width: 300,
                height: 150,
              )),
          pw.Divider(),
          pw.Text('Exmo/a Senhor/a,Diretor/a Executivo/a',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          _buildTitle('Identificação'),
          pw.Row(children: [
            _subTiltleTextField('Nome: '),
            _buildTextField(utente.nomeCompleto),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Utente do SNS nº: '),
            _buildTextField(utente.numeroUtenteSaude.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Bilhete de Idenetidade/CC nº: '),
            _buildTextField(utente.numeroDocumentoIdentificacao.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Válido até: '),
            _buildTextField(utente.documentoValidade.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Número de Contribuinte: '),
            _buildTextField(utente.numeroIdentificacaoFiscal.toString()),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Número Segurança Social: '),
            _buildTextField(utente.numeroSegurancaSocial.toString()),
          ]),
          _buildTitle('Naturalidade'),
          pw.Row(children: [
            _subTiltleTextField('Data de Nascimento: '),
            _buildTextField(utente.dataNascimento),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Freguesia de: '),
            _buildTextField(utente.freguesia),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Concelho: '),
            _buildTextField(utente.concelho),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Distrito: '),
            _buildTextField(utente.distrito),
          ]),
          pw.Row(children: [
            _subTiltleTextField('País: '),
            _buildTextField(utente.pais),
          ]),
          _buildTitle('Resisdência'),
          pw.Row(children: [
            _subTiltleTextField('Morada: '),
            _buildTextField(utente.morada),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Código Postal: '),
            _buildTextField(utente.nr_codigo_postal),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Freguesia de: '),
            _buildTextField(utente.freguesia),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Concelho: '),
            _buildTextField(utente.concelho),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Distrito: '),
            _buildTextField(utente.distrito),
          ]),
          pw.Row(children: [
            _subTiltleTextField('Telefone nº: '),
            _buildTextField(utente.numeroTelemovel.toString()),
          ]),
          pw.SizedBox(height: 10),
          _buildTextField(
              'Venho solicitar a V. Ex.ª, que ao abrigo do nº 1 do art. 3º do Decreto Lei nº 291 / 2009 de 12 de outubro seja admitido a Junta Médica para Avaliação do grau de incapacidade para efeito de:'),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.type == 1),
              _buildTextField(
                  'Multiuso (Decreto-Lei nº 202/96, de 23 de outubro com a redação dada pelo Decreto-Lei nº 174/97 de 19 de julho)'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.type == 2),
              _buildTextField(
                  'Importação de veículo automóvel e outros (Lei nº 22-A/2007 de 29 de junho 2007).'),
            ],
          ),
          pw.SizedBox(height: 10),
          _buildTextField(
              'Comprometendo-se a ser portador de toda a informação clínica respeitante à(s) doença(s) e/ou deficiência(s) que justifica(m) este pedido.'),
          _buildTextField('Informa ainda que:'),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.nuncaSubmetido!),
              _buildTextField(
                  'Nunca foi submetido a Junta Médica de avaliação do grau de incapacidade.'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildCheckBox(requerimento.submetido!),
              _buildTextField('Já foi submetido em (data) '),
              if (requerimento.submetido == true) ...[
                _buildTextField(
                    formatDateString(requerimento.data_submetido!.toString())),
              ] else
                _buildTextField("__/__/____"),
              _buildTextField(' pretendendo uma reavaliação.'),
            ],
          ),
          pw.SizedBox(height: 10),
          _buildCenteredSection([
            _subTiltleTextField('Pede deferimento'),
            _buildTextField(dataPorExtenso(requerimento.data)),
            _buildTextField(utente.nomeCompleto),
            _buildLowTextField('assinatura'),
          ]),
        ]);
      },
    ),
  );

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Image(
                    image,
                    width: 300,
                    height: 150,
                  )),
              pw.Divider(),
              pw.Text('Relatorio Médico Pré-Avaliação',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 14)),
              pw.SizedBox(height: 15),
              _buildParagraph('Eu, ' +
                  preAvalicao.nome_medico +
                  ' médico especialista em ' +
                  preAvalicao.especialidade +
                  ', após cuidadosa análise e avaliação dos documentos e dados clínicos fornecidos, venho por meio deste relatar minhas conclusões acerca do estado de saúde do paciente ' +
                  utente.nomeCompleto +
                  '.'),
              _buildParagraph('Na data de ' +
                  formatTimestampString(preAvalicao.data_pre_avaliacao) +
                  ', realizei uma avaliação abrangente que incluiu a revisão dos exames, histórico médico e demais informações pertinentes ao caso. Com base nesta análise meticulosa e considerando as diretrizes clínicas e padrões médicos vigentes, concluo que o paciente apresenta uma condição que resulta em uma estimativa de incapacidade funcional de aproximadamente ' +
                  preAvalicao.pre_avaliacao +
                  '%.'),
              _buildParagraph(
                  'Este grau de incapacidade é determinado levando em conta os impactos da condição médica nas atividades diárias do paciente, sua capacidade de trabalho e qualidade de vida. Saliento que esta avaliação reflete o estado atual do paciente e pode estar sujeita a alterações com o decorrer do tempo, necessitando, portanto, de reavaliações periódicas.'),
              _buildParagraph(
                  'Recomendo que as devidas providências e suportes sejam oferecidos ao paciente, visando a melhoria de sua condição e bem-estar geral. Estou à disposição para quaisquer esclarecimentos adicionais que se façam necessários.'),
              pw.SizedBox(height: 200),
              _buildCenteredSection([
                _subTiltleTextField('Atenciosamente,'),
                _buildTextField('Dr/ra.' + preAvalicao.nome_medico),
                _buildTextField(dataPorExtenso(
                    formatTimestampString(preAvalicao.data_pre_avaliacao))),
              ]),
            ]);
      },
    ),
  );

  Uint8List pdfInBytes = await pdf.save();

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/Requerimento.pdf');
  await file.writeAsBytes(pdfInBytes);
  await Share.shareFiles(['${directory.path}/PreAvalicao.pdf'],
      text: 'PreAvaliacao.pdf');
}

pw.Widget _buildTitle(String title) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(top: 8.0),
    child: pw.Container(
      width: 300,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          width: 1.0,
        ),
      ),
      child: pw.Padding(
        padding: pw.EdgeInsets.all(8.0),
        child: pw.Text(
          title,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

pw.Widget _buildJustifiedRow(List<pw.Widget> widgets) {
  return pw.Row(
    children: widgets.map((widget) {
      return pw.Expanded(child: widget);
    }).toList(),
  );
}

pw.Widget _buildParagraph(String text) {
  return pw.Container(
    padding: pw.EdgeInsets.all(2.0),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontSize: 10),
      textAlign: pw.TextAlign.justify,
    ),
  );
}

pw.Widget _buildTextField(String label) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
    child: pw.Text(
      label,
      style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
    ),
  );
}

pw.Widget _buildLowTextField(String label) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
    child: pw.Text(
      label,
      style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 5),
    ),
  );
}

pw.Widget _subTiltleTextField(String label) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(4.0),
    child: pw.Text(
      label,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
    ),
  );
}

pw.Widget _buildCheckBox(bool isChecked) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(left: 10.0),
    child: pw.Container(
      width: 10,
      height: 10,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: isChecked
          ? pw.Center(
              child: pw.Text('X',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 8)),
            )
          : pw.Container(),
    ),
  );
}

pw.Widget _buildCenteredSection(List<pw.Widget> widgets) {
  return pw.Align(
    alignment: pw.Alignment.center,
    child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: widgets
            .map((widget) => pw.Align(
                  alignment: pw.Alignment.center,
                  child: widget,
                ))
            .toList()),
  );
}
