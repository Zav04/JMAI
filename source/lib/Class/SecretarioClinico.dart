import 'package:JMAI/Class/Utilizador.dart';

class SecretarioClinico extends Utilizador {
  final String hashedId;
  final String email;
  final String nomeCompleto;
  final String sexo;
  final String dataNascimento;
  final String distrito;
  final String concelho;
  final String freguesia;
  final String paisNacionalidade;
  final String contacto;

  SecretarioClinico({
    required this.hashedId,
    required this.email,
    required this.nomeCompleto,
    required this.sexo,
    required this.dataNascimento,
    required this.distrito,
    required this.concelho,
    required this.freguesia,
    required this.paisNacionalidade,
    required this.contacto,
  }) : super(hashedId: hashedId, email: email, role: 'Secretario Clinico');

  factory SecretarioClinico.fromJson(Map<String, dynamic> json) {
    return SecretarioClinico(
      hashedId: json['hashed_id'],
      email: json['email'],
      nomeCompleto: json['nome_completo'],
      sexo: json['sexo'],
      dataNascimento: json['data_nascimento'],
      distrito: json['distrito'],
      concelho: json['concelho'],
      freguesia: json['freguesia'],
      paisNacionalidade: json['pais_nacionalidade'],
      contacto: json['contacto'],
    );
  }
}
