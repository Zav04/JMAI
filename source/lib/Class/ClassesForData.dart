class UtenteRegister {
  String? numeroUtenteSaude;
  String? email;
  String? password;
  bool justvalidateInputs;
  UtenteRegister({
    required this.numeroUtenteSaude,
    this.email,
    this.password,
    required this.justvalidateInputs,
  });

  Map<String, dynamic> toJson() {
    return {
      'numero_utente_saude': numeroUtenteSaude,
      'email': email,
      'password': password,
      'justvalidate_inputs': justvalidateInputs,
    };
  }
}

class SecretarioClinicoRegister {
  String? nomeCompleto;
  String? dataNascimento;
  String? numeroTelemovel;
  String? sexo;
  String? paisNacionalidade;
  String? distrito;
  String? concelho;
  String? freguesia;
  String? email;
  String? password;
  bool justvalidateInputs;
  SecretarioClinicoRegister({
    required this.nomeCompleto,
    required this.dataNascimento,
    required this.numeroTelemovel,
    required this.sexo,
    required this.paisNacionalidade,
    required this.distrito,
    required this.concelho,
    required this.freguesia,
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
      'pais_nacionalidade': paisNacionalidade,
      'distrito': distrito,
      'concelho': concelho,
      'freguesia': freguesia,
      'email': email,
      'password': password,
      'justvalidate_input': justvalidateInputs,
    };
  }
}

class MedicoRegister {
  String? nomeCompleto;
  String? dataNascimento;
  String? numeroTelemovel;
  String? sexo;
  String? paisNacionalidade;
  String? distrito;
  String? concelho;
  String? freguesia;
  String? especialidade;
  String? numCedula;
  String? numOrdem;
  String? email;
  String? password;
  bool justvalidateInputs;

  MedicoRegister({
    required this.nomeCompleto,
    required this.dataNascimento,
    required this.numeroTelemovel,
    required this.sexo,
    required this.paisNacionalidade,
    required this.distrito,
    required this.concelho,
    required this.freguesia,
    required this.especialidade,
    required this.numCedula,
    required this.numOrdem,
    required this.email,
    required this.password,
    required this.justvalidateInputs,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome_completo': nomeCompleto,
      'data_nascimento': dataNascimento,
      'contacto': numeroTelemovel,
      'sexo': sexo,
      'pais_nacionalidade': paisNacionalidade,
      'distrito': distrito,
      'concelho': concelho,
      'freguesia': freguesia,
      'especialidade': especialidade,
      'num_cedula': numCedula,
      'num_ordem': numOrdem,
      'email': email,
      'password': password,
      'justvalidate_inputs': justvalidateInputs,
    };
  }
}

class RequerimentoRegister {
  String? hashed_id;
  List<String>? documentos;
  String? observacoes;
  int? type;
  final bool? submetido;
  final bool? nuncaSubmetido;
  final String? dataSubmetido;

  RequerimentoRegister({
    required this.hashed_id,
    required this.documentos,
    required this.observacoes,
    required this.type,
    this.submetido,
    this.nuncaSubmetido,
    this.dataSubmetido,
  });

  Map<String, dynamic> toJson() {
    return {
      'hashed_id': hashed_id,
      'documentos': documentos,
      'observacoes': observacoes,
      'type': type,
      'submetido': submetido,
      'nunca_submetido': nuncaSubmetido,
      'data_submissao': dataSubmetido,
    };
  }
}
