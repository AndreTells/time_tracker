import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/src/ui/home_page.dart';

//color scheme from : https://colorhunt.co/palette/261c2c3e2c415c527f6e85b2
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme(
              primary: Color.fromARGB(255, 110, 133, 178),
              primaryVariant: Color.fromARGB(200, 110, 133, 178),
              secondary: Color.fromARGB(255, 92, 82, 127),
              secondaryVariant: Color.fromARGB(200, 92, 82, 127),
              surface: Color.fromARGB(255, 62, 44, 65),
              background: Color.fromARGB(255, 38, 28, 44),
              error: Color.fromARGB(255, 170, 67, 68),
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Colors.white,
              onBackground: Colors.white,
              onError: Colors.white,
              brightness: Brightness.dark),
          textTheme: const TextTheme(
            headline1: TextStyle(
              height: 0.75,
              fontSize: 250.0,
              fontWeight: FontWeight.w100,
              letterSpacing: -3,
            ),
            headline2: TextStyle(
              fontSize: 70.0,
              fontWeight: FontWeight.w100,
              letterSpacing: -3,
            ),
            headline3: TextStyle(
              fontSize: 55.0,
              fontWeight: FontWeight.w100,
              letterSpacing: -3,
            ),
            headline4: TextStyle(
              fontSize: 43.0,
              fontWeight: FontWeight.w100,
              letterSpacing: -3,
            ),
            headline5: TextStyle(fontSize: 22),
            headline6: TextStyle(fontSize: 18),
          ),
        ),
        home: const HomePage());
  }
}
