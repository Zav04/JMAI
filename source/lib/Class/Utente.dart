import 'package:JMAI/Class/Utilizador.dart';

class Utente extends Utilizador {
  final String nomeCompleto;
  final String sexo;
  final String morada;
  final String nr_porta;
  final String nr_andar;
  final String nr_codigo_postal;
  final String dataNascimento;
  final String distrito;
  final String concelho;
  final String freguesia;
  final String naturalidade;
  final String paisNacionalidade;
  final int tipoDocumentoIdentificacao;
  final String numeroDocumentoIdentificacao;
  final String numeroUtenteSaude;
  final String numeroIdentificacaoFiscal;
  final String numeroSegurancaSocial;
  final String documentoValidade;
  final String numeroTelemovel;
  final String nomeEntidadeResponsavel;

  Utente({
    required String hashedId,
    required String email,
    required this.nomeCompleto,
    required this.sexo,
    required this.morada,
    required this.nr_porta,
    required this.nr_andar,
    required this.nr_codigo_postal,
    required this.dataNascimento,
    required this.distrito,
    required this.concelho,
    required this.freguesia,
    required this.naturalidade,
    required this.paisNacionalidade,
    required this.tipoDocumentoIdentificacao,
    required this.numeroDocumentoIdentificacao,
    required this.numeroUtenteSaude,
    required this.numeroIdentificacaoFiscal,
    required this.numeroSegurancaSocial,
    required this.documentoValidade,
    required this.numeroTelemovel,
    required this.nomeEntidadeResponsavel,
  }) : super(hashedId: hashedId, email: email, role: 'Utente');

  factory Utente.fromJson(Map<String, dynamic> json) {
    return Utente(
      hashedId: json['hashed_id'] ?? '',
      email: json['email'] ?? '',
      nomeCompleto: json['nome_completo'] ?? '',
      sexo: json['sexo'] ?? '',
      morada: json['morada'] ?? '',
      nr_porta: json['nr_porta'] ?? '',
      nr_andar: json['nr_andar'] ?? '',
      nr_codigo_postal: json['codigo_postal'] ?? '',
      dataNascimento: json['data_nascimento'] ?? '',
      distrito: json['distrito'] ?? '',
      concelho: json['concelho'] ?? '',
      freguesia: json['freguesia'] ?? '',
      naturalidade: json['naturalidade'] ?? '',
      paisNacionalidade: json['pais_nacionalidade'] ?? '',
      tipoDocumentoIdentificacao: json['tipo_documento_identificacao'] is int
          ? json['tipo_documento_identificacao']
          : int.tryParse(json['tipo_documento_identificacao'].toString()) ?? 0,
      numeroDocumentoIdentificacao:
          json['numero_de_documento_de_identificacao'] ?? '',
      numeroUtenteSaude: json['numero_utente_saude'] ?? '',
      numeroIdentificacaoFiscal: json['numero_identificacao_fiscal'] ?? '',
      numeroSegurancaSocial: json['numero_seguranca_social'] ?? '',
      documentoValidade: json['documento_validade'] ?? '',
      numeroTelemovel: json['numero_telemovel'] ?? '',
      nomeEntidadeResponsavel: json['nome_entidade_responsavel'] ?? '',
    );
  }
}
