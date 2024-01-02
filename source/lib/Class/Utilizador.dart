import 'package:JMAI/Class/Medico.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:JMAI/Class/SecretarioClinico.dart';

abstract class Utilizador {
  final String hashedId;
  final String email;
  final String role;

  Utilizador({
    required this.hashedId,
    required this.email,
    required this.role,
  });

  factory Utilizador.fromJson(Map<String, dynamic> json) {
    switch (json['role']) {
      case 'Utente':
        return Utente.fromJson(json);
      case 'SecretarioClinico':
        return SecretarioClinico.fromJson(json);
      case 'Medico':
        return Medico.fromJson(json);
      default:
        throw Exception('Tipo de usuário desconhecido');
    }
  }
}
