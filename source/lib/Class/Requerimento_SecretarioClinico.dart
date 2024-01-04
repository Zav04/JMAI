import 'DateTime.dart';

class RequerimentoSC {
  final int idRequerimento;
  final String hashedId;
  final String dataSubmissao;
  final List<String> documentos;
  final int statusRequerimento;
  final String observacoesRequerimento;
  final int typeRequerimento;
  final String utenteHashedId;
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
  final String naturalidade;
  final String paisNacionalidadeUtente;
  final int tipoDocumentoIdentificacao;
  final String numeroDocumentoIdentificacao;
  final String numeroUtenteSaude;
  final String numeroIdentificacaoFiscal;
  final String numeroSegurancaSocial;
  final String numeroTelemovel;
  final bool obito;
  final String documentoValidade;
  final String nomeEntidadeResponsavel;
  final String emailUtente;

  RequerimentoSC({
    required this.idRequerimento,
    required this.hashedId,
    required this.dataSubmissao,
    required this.documentos,
    required this.statusRequerimento,
    required this.observacoesRequerimento,
    required this.typeRequerimento,
    required this.utenteHashedId,
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
    required this.naturalidade,
    required this.paisNacionalidadeUtente,
    required this.tipoDocumentoIdentificacao,
    required this.numeroDocumentoIdentificacao,
    required this.numeroUtenteSaude,
    required this.numeroIdentificacaoFiscal,
    required this.numeroSegurancaSocial,
    required this.numeroTelemovel,
    required this.obito,
    required this.documentoValidade,
    required this.nomeEntidadeResponsavel,
    required this.emailUtente,
  });

  factory RequerimentoSC.fromJson(Map<String, dynamic> json) {
    return RequerimentoSC(
      idRequerimento: json['id_requerimento'],
      hashedId: json['hashed_id'],
      dataSubmissao: formatDateString(json['data_submissao']),
      documentos: List<String>.from(json['documentos']),
      statusRequerimento: json['status_requerimento'],
      observacoesRequerimento: json['observacoes_requerimento'],
      typeRequerimento: json['type_requerimento'],
      utenteHashedId: json['utente_hashed_id'],
      nomeCompleto: json['nome_completo'],
      sexoUtente: json['sexo_utente'],
      morada: json['morada'],
      dataNascimentoUtente: formatDateString(json['data_nascimento_utente']),
      nrPorta: json['nr_porta'],
      nrAndar: json['nr_andar'] as String?,
      codigoPostal: json['codigo_postal'],
      distritoUtente: json['distrito_utente'],
      concelhoUtente: json['concelho_utente'],
      freguesiaUtente: json['freguesia_utente'],
      naturalidade: json['naturalidade'],
      paisNacionalidadeUtente: json['pais_nacionalidade_utente'],
      tipoDocumentoIdentificacao: json['tipo_documento_identificacao'],
      numeroDocumentoIdentificacao: json['numero_documento_identificacao'],
      numeroUtenteSaude: json['numero_utente_saude'],
      numeroIdentificacaoFiscal: json['numero_identificacao_fiscal'],
      numeroSegurancaSocial: json['numero_seguranca_social'],
      numeroTelemovel: json['numero_telemovel'],
      obito: json['obito'],
      documentoValidade: formatDateString(json['documento_validade']),
      nomeEntidadeResponsavel: json['nome_entidade_responsavel'],
      emailUtente: json['email_utente'],
    );
  }
}
