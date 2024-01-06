import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/Class/DateTime.dart';

class Utente extends Utilizador {
  final String nomeCompleto;
  final String sexo;
  final String morada;
  final String nr_porta;
  final String? nr_andar;
  final String nr_codigo_postal;
  final String dataNascimento;
  final String distrito;
  final String concelho;
  final String freguesia;
  final String pais;
  final int tipoDocumentoIdentificacao;
  final int numeroDocumentoIdentificacao;
  final int numeroUtenteSaude;
  final int numeroIdentificacaoFiscal;
  final int numeroSegurancaSocial;
  final String documentoValidade;
  final int numeroTelemovel;
  final String nomeEntidadeResponsavel;

  Utente({
    required String hashedId,
    required String email,
    required this.nomeCompleto,
    required this.sexo,
    required this.morada,
    required this.nr_porta,
    this.nr_andar,
    required this.nr_codigo_postal,
    required this.dataNascimento,
    required this.distrito,
    required this.concelho,
    required this.freguesia,
    required this.pais,
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
      nr_andar: json['nr_andar'] as String?, // Permite que seja null
      nr_codigo_postal: json['codigo_postal'] ?? '',
      dataNascimento: json['data_nascimento'] != null
          ? formatDateString(json['data_nascimento'])
          : '',
      distrito: json['distrito'] ?? '',
      concelho: json['concelho'] ?? '',
      freguesia: json['freguesia'] ?? '',
      pais: json['pais'] ?? '',
      tipoDocumentoIdentificacao: json['tipo_documento_identificacao'] ?? 0,
      numeroDocumentoIdentificacao:
          json['numero_de_documento_de_identificação'] ?? 0,
      numeroUtenteSaude: json['numero_utente_saude'] ?? 0,
      numeroIdentificacaoFiscal: json['numero_de_identificacao_fiscal'] ?? 0,
      numeroSegurancaSocial: json['numero_de_segurança_social'] ?? 0,
      documentoValidade: json['documento_validade'] != null
          ? formatDateString(json['documento_validade'])
          : '',
      numeroTelemovel: json['numero_de_telemovel'] ?? 0,
      nomeEntidadeResponsavel: json['nome_entidade_responsavel'] ?? '',
    );
  }
}
