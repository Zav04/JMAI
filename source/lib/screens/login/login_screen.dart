import 'package:flutter/material.dart';
import '../main/components/password_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:JMAI/screens/main/main_screen.dart';
import 'package:JMAI/controllers/API_Connection.dart';
import 'package:JMAI/overlay/SuccessAlert.dart';
import 'package:JMAI/overlay/ErrorAlert.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:JMAI/Class/Medico.dart';
import 'package:JMAI/Class/SecretarioClinico.dart';
import 'package:JMAI/Class/Admin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? hashedId;
  String? role;
  String? uid;
  Utilizador? utilizador;

  @override
  void initState() {
    _emailController.text = '';
    _passwordController.text = '';
    hashedId = '';
    role = '';
    uid = '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/logo-no-background.svg',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: screenHeight * 0.05),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 650,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText:
                                'Insira um e-mail válido como abc@gmail.com',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 650,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: PasswordField(controller: _passwordController),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool response = await submitlogin();
                      if (response)
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => MainScreen(
                                    uid: uid,
                                    user: utilizador,
                                  )),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      onPrimary: buttonTextColor,
                      primary: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    _showForgotPasswordDialog(context);
                  },
                  child: const Text(
                    'Esqueceu-se da sua Palavra passe',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 90),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: const Text(
                    'Novo Utilizador? Criar conta',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          surfaceTintColor: bgColor,
          backgroundColor: bgColor,
          iconColor: bgColor,
          shadowColor: bgColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Esqueceu-se da sua Palavra passe?'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 600,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: 80,
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Insira o seu Email de Registro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Enviar Pedido',
                style: TextStyle(color: buttonTextColor),
              ),
              style: TextButton.styleFrom(
                primary: buttonColor,
                backgroundColor: buttonColor,
              ),
              onPressed: () async {
                var response = await submitResetPassword();
                if (response) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> submitResetPassword() async {
    var response = await verifyEmailExist(_emailController.text);
    if (response.success && response.data == false) {
      ErrorAlert.show(context, 'Este email não está registado no sistema');
      return false;
    } else if (response.success && response.data == true) {
      response = await resetPassword(_emailController.text);
      if (response.success) {
        SuccessAlert.show(
            context, 'Email para recuperação da password enviado');
        return true;
      } else {
        ErrorAlert.show(context, 'Ocorreu um erro ao enviar o pedido');
        return false;
      }
    } else {
      ErrorAlert.show(context, 'Ocorreu um erro ao enviar o pedido');
      return false;
    }
  }

  Future<bool> submitlogin() async {
    var response = await login(_emailController.text, _passwordController.text);
    if (response.success == true) {
      uid = response.data['idToken'];
      var getUser = await getUserRole(_emailController.text);
      hashedId = getUser.data['hashed_id'];
      role = getUser.data['cargo_name'];
      switch (role) {
        case 'Utente':
          var response = await getUtenteInfo(hashedId!);
          if (response.success == false) {
            ErrorAlert.show(context, response.errorMessage.toString());
            return false;
          }
          utilizador = Utente.fromJson(response.data);
          break;
        case 'SecretarioClinico':
          var response = await getMedicoInfo(hashedId!);
          if (response.success == false) {
            ErrorAlert.show(context, response.errorMessage.toString());
            return false;
          }
          utilizador = SecretarioClinico.fromJson(response.data);
          break;
        case 'Medico':
          var response = await getSecretarioClinicoInfo(hashedId!);
          if (response.success == false) {
            ErrorAlert.show(context, response.errorMessage.toString());
            return false;
          }
          utilizador = Medico.fromJson(response.data);
          break;
        case 'Admin':
          utilizador = Admin.fromJson(response.data);
          break;
        default:
      }
      return true;
    } else
      ErrorAlert.show(context, response.errorMessage.toString());
    return false;
  }
}
