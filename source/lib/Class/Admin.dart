import 'package:JMAI/Class/Utilizador.dart';

class Admin extends Utilizador {
  final String nome;

  Admin({
    required String hashedId,
    required String email,
    required this.nome,
  }) : super(hashedId: hashedId, email: email, role: 'Admin');

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      hashedId: json['hashed_id'] ?? '',
      email: json['email'] ?? '',
      nome: 'Admin',
    );
  }
}
