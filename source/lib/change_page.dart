import 'package:flutter/material.dart';
import 'package:JMAI/screens/main/main_screen.dart';

abstract class Action {
  void execute(BuildContext context);
}

class ChangeToHome implements Action {
  @override
  void execute(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
      (Route<dynamic> route) => false,
    );
  }
}

// class ChangeToMainMenu implements Action {
//   User user;
//   ChangeToMainMenu({required this.user});
//   @override
//   void execute(BuildContext context) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => MainMenu(user: user)),
//       (Route<dynamic> route) =>
//           false, // Esta condição sempre retorna false, removendo todas as rotas anteriores
//     );
//   }
// }

// class ChangeToMainMenuInspector implements Action {
//   User user;
//   ChangeToMainMenuInspector({required this.user});
//   @override
//   void execute(BuildContext context) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => MainMenuInspection(user: user)),
//       (Route<dynamic> route) =>
//           false, // Esta condição sempre retorna false, removendo todas as rotas anteriores
//     );
//   }
// }