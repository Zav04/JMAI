import 'package:JMAI/controllers/MenuAppController.dart';
import 'package:JMAI/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:JMAI/screens/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:JMAI/screens/main/components/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: dotenv.env['FIRE_APIKEY'].toString(),
  authDomain: dotenv.env['FIRE_AUTHDOMAIN'].toString(),
  databaseURL: dotenv.env['FIRE_DATABASE_URL'].toString(),
  projectId: dotenv.env['FIRE_PROJECTID'].toString(),
  storageBucket: dotenv.env['FIRE_STORAGEBUCKET'].toString(),
  messagingSenderId: dotenv.env['FIRE_MESSAGINGSENDERID'].toString(),
  appId: dotenv.env['FIRE_APPID'].toString(),
);

void main() async {
  setPathUrlStrategy();
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
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
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('pt', 'PT'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: bgColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.white),
            canvasColor: secondaryColor,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.blue,
              selectionColor: Colors.blue.withOpacity(0.4),
              selectionHandleColor: Colors.blue,
            ),
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              floatingLabelStyle: TextStyle(color: Colors.blue),
            )),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/MainScreen': (context) => MainScreen(),
        },
      ),
    );
  }
}
