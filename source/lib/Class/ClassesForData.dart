class Utente {
  String? nomeCompleto;
  String? dataNascimento;
  String? numeroTelemovel;
  String? sexo;
  String? paisnaturalidade;
  String? paisNacionalidade;
  String? tipoDocumentoIdentificacao;
  String? documentoValidade;
  String? numeroIdentificacaoFiscal;
  String? numeroDocumentoIdentificacao;
  String? numeroSegurancaSocial;
  String? numeroUtenteSaude;
  String? morada;
  String? nrPorta;
  String? nrAndar;
  String? codigoPostal;
  String? distrito;
  String? concelho;
  String? freguesia;
  String? idEntidadeResponsavel;
  String? email;
  String? password;
  bool justvalidateInputs;
  Utente({
    required this.nomeCompleto,
    required this.dataNascimento,
    required this.numeroTelemovel,
    required this.sexo,
    required this.paisnaturalidade,
    required this.paisNacionalidade,
    required this.tipoDocumentoIdentificacao,
    required this.documentoValidade,
    required this.numeroIdentificacaoFiscal,
    required this.numeroDocumentoIdentificacao,
    required this.numeroSegurancaSocial,
    required this.numeroUtenteSaude,
    required this.morada,
    required this.nrPorta,
    required this.nrAndar,
    required this.codigoPostal,
    required this.distrito,
    required this.concelho,
    required this.freguesia,
    required this.idEntidadeResponsavel,
    required this.email,
    required this.password,
    required this.justvalidateInputs,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome_completo': nomeCompleto,
      'data_nascimento': dataNascimento,
      'numero_telemovel': numeroTelemovel,
      'sexo': sexo,
      'pais_naturalidade': paisnaturalidade,
      'pais_nacionalidade': paisNacionalidade,
      'tipo_documento_identificacao': tipoDocumentoIdentificacao,
      'documento_validade': documentoValidade,
      'numero_identificacao_fiscal': numeroIdentificacaoFiscal,
      'numero_documento_identificacao': numeroDocumentoIdentificacao,
      'numero_seguranca_social': numeroSegurancaSocial,
      'numero_utente_saude': numeroUtenteSaude,
      'morada': morada,
      'nr_porta': nrPorta,
      'nr_andar': nrAndar,
      'codigo_postal': codigoPostal,
      'distrito': distrito,
      'concelho': concelho,
      'freguesia': freguesia,
      'id_entidade_responsavel': idEntidadeResponsavel,
      'email': email,
      'password': password,
      'justvalidate_inputs': justvalidateInputs,
    };
  }
}
