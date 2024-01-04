import 'package:JMAI/Class/Utilizador.dart';

class Medico extends Utilizador {
  final String hashedId;
  final String email;
  final String nomeCompleto;
  final String sexo;
  final String dataNascimento;
  final String distrito;
  final String concelho;
  final String freguesia;
  final String pais;
  final String paisNacionalidade;
  final String contacto;
  final String especialidade;
  final int numCedula;
  final int numOrdem;

  Medico({
    required this.hashedId,
    required this.email,
    required this.nomeCompleto,
    required this.sexo,
    required this.dataNascimento,
    required this.distrito,
    required this.concelho,
    required this.freguesia,
    required this.pais,
    required this.paisNacionalidade,
    required this.contacto,
    required this.especialidade,
    required this.numCedula,
    required this.numOrdem,
  }) : super(hashedId: hashedId, email: email, role: 'Medico');

  factory Medico.fromJson(Map<String, dynamic> json) {
    return Medico(
      hashedId: json['hashed_id'],
      email: json['email'],
      nomeCompleto: json['nome_medico'],
      sexo: json['sexo'],
      dataNascimento: json['data_nascimento'],
      distrito: json['distrito'],
      concelho: json['concelho'],
      freguesia: json['freguesia'],
      pais: json['pais'],
      paisNacionalidade: json['pais_nacionalidade'],
      contacto: json['contacto'],
      especialidade: json['especialidade'],
      numCedula: json['num_cedula'],
      numOrdem: json['num_ordem'],
    );
  }
}
