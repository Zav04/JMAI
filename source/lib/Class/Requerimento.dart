import 'DateTime.dart';

class Requerimento {
  final int id;
  final String hashedId;
  final String data;
  final List<String> documentos;
  final String observacoes;
  final int type;
  final int status;

  Requerimento({
    required this.id,
    required this.hashedId,
    required this.data,
    required this.documentos,
    required this.observacoes,
    required this.type,
    required this.status,
  });

  factory Requerimento.fromJson(Map<String, dynamic> json) {
    return Requerimento(
      id: json['id_requerimento_junta_medica'],
      data: formatDateString(json['data_submissao']),
      hashedId: json['hashed_id'],
      documentos: json['documentos'] != null
          ? List<String>.from(json['documentos'])
          : [],
      observacoes: json['observacoes'],
      type: json['type'],
      status: json['status'],
    );
  }
}
