import 'package:flutter/material.dart';
import '../main/components/password_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main/components/constants.dart';
import '../main/main_screen.dart';
import '../sing_up/sing_up.dart';
import '../../controllers/API_Connection.dart';
import '../../overlay/ErrorAlert.dart';
import '../../overlay/WarningAlert.dart';
import '../../overlay/SuccessAlert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    onPressed: () {
                      // TODO Implementar login
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()),
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
                    checkConnection();
                    // TODOImplementar esqueceu a senha
                    SuccessAlert.show(context, 'Ocorreu um erro:');
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
}
