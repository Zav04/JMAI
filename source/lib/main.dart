import 'package:JMAI/controllers/MenuAppController.dart';
import 'package:JMAI/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/sing_up/sing_up.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  setPathUrlStrategy();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuAppController()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(), // Bordas padrão para todos os estados
            enabledBorder: OutlineInputBorder(
              // Bordas específicas quando o TextField está habilitado, mas não focado
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              // Bordas específicas para quando o TextField está focado
              borderSide: BorderSide(color: Colors.blue),
            ),
            floatingLabelStyle: TextStyle(color: Colors.blue),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blue, // Cor do cursor
            selectionColor:
                Colors.blue.withOpacity(0.5), // Cor da seleção de texto
            selectionHandleColor:
                Colors.blue, // Cor do manipulador de seleção de texto
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/signup': (context) => Singup(),
          //TODO FORGET PASSWORD
        },
      ),
    );
  }
}
