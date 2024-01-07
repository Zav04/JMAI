import 'DateTime.dart';

class Requerimento_DadosUtente {
  final int idRequerimento;
  final String hashedId;
  final String dataSubmissao;
  final List<String>? documentos;
  final int statusRequerimento;
  final int typeRequerimento;
  final bool? submetido;
  final bool? nuncaSubmetido;
  final String? data_submetido;
  final String nomeCompleto;
  final String sexoUtente;
  final String morada;
  final String dataNascimentoUtente;
  final String nrPorta;
  final String? nrAndar;
  final String codigoPostal;
  final String distritoUtente;
  final String concelhoUtente;
  final String freguesiaUtente;
  final String pais;
  final int tipoDocumentoIdentificacao;
  final int numeroDocumentoIdentificacao;
  final int numeroUtenteSaude;
  final int numeroIdentificacaoFiscal;
  final int numeroSegurancaSocial;
  final int numeroTelemovel;
  final bool obito;
  final String documentoValidade;
  final String nomeEntidadeResponsavel;
  String? emailUtente;

  Requerimento_DadosUtente({
    required this.idRequerimento,
    required this.hashedId,
    required this.dataSubmissao,
    this.documentos,
    required this.statusRequerimento,
    this.submetido,
    this.nuncaSubmetido,
    this.data_submetido,
    required this.typeRequerimento,
    required this.nomeCompleto,
    required this.sexoUtente,
    required this.morada,
    required this.dataNascimentoUtente,
    required this.nrPorta,
    this.nrAndar,
    required this.codigoPostal,
    required this.distritoUtente,
    required this.concelhoUtente,
    required this.freguesiaUtente,
    required this.pais,
    required this.tipoDocumentoIdentificacao,
    required this.numeroDocumentoIdentificacao,
    required this.numeroUtenteSaude,
    required this.numeroIdentificacaoFiscal,
    required this.numeroSegurancaSocial,
    required this.numeroTelemovel,
    required this.obito,
    required this.documentoValidade,
    required this.nomeEntidadeResponsavel,
    this.emailUtente,
  });

  factory Requerimento_DadosUtente.fromJson(Map<String, dynamic> json) {
    return Requerimento_DadosUtente(
      idRequerimento: json['id_requerimento'] as int,
      hashedId: json['hashed_id'] as String,
      dataSubmissao: formatDateString(json['data_submissao']),
      documentos: json['documentos'] != null
          ? List<String>.from(json['documentos'])
          : [],
      statusRequerimento: json['status_requerimento'] as int,
      typeRequerimento: json['type_requerimento'] as int,
      submetido: json['submetido'] as bool?,
      nuncaSubmetido: json['nunca_submetido'] as bool?,
      data_submetido: json['data_submetido'] != null
          ? formatDateString(json['data_submetido'])
          : "",
      nomeCompleto: json['nome_completo'] as String,
      sexoUtente: json['sexo'] as String,
      morada: json['morada'] as String,
      dataNascimentoUtente: formatDateString(json['data_nascimento']),
      nrPorta: json['nr_porta'] as String,
      nrAndar: json['nr_andar'] as String?,
      codigoPostal: json['codigo_postal'] as String,
      distritoUtente: json['distrito'] as String,
      concelhoUtente: json['concelho'] as String,
      freguesiaUtente: json['freguesia'] as String,
      pais: json['pais'] as String,
      tipoDocumentoIdentificacao: json['tipo_documento_identificacao'] as int,
      numeroDocumentoIdentificacao:
          json['numero_de_documento_de_identificação'] as int,
      numeroUtenteSaude: json['numero_utente_saude'] as int,
      numeroIdentificacaoFiscal: json['numero_de_identificacao_fiscal'] as int,
      numeroSegurancaSocial: json['numero_de_segurança_social'] as int,
      numeroTelemovel: json['numero_de_telemovel'] as int,
      obito: json['obito'] as bool,
      documentoValidade: json['documento_validade'] != null
          ? formatDateString(json['documento_validade'])
          : '',
      emailUtente: json['email_utente'] != null ? json['email_utente'] : '',
      nomeEntidadeResponsavel: json['nome_entidade_responsavel'] as String,
    );
  }
}
