import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:splashscreen/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onTap: _handleUserInteraction,
      // onPanDown: _handleUserInteraction,
      child: MaterialApp(
        title: 'MoneyApp',
        theme: ThemeData(
          primarySwatch: colours,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Center(
              // Page Title
              child: Text(
                "MoneyApp",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          backgroundColor: colours[50],
          body: MyHomePage(),
        ),
      ),
    );
  }
}

const MaterialColor colours = const MaterialColor(
  0xFFDE0607,
  const <int, Color>{
    50: const Color(0xFFF7F7F7), //
    100: const Color(0xFFF9E6F3), //
    200: const Color(0xFFC0028B), //
    300: const Color(0xFFB0B3B8), //
    400: const Color(0xFFE4E6EB), //
    500: const Color(0xFF3A3B3C), //
    600: const Color(0xFF242526), //
    700: const Color(0xFF18191A), //
    800: const Color(0xFFC0028B), //
    900: const Color(0xFFC0028B), //
  },
);

class MyHomePage extends StatefulWidget {
  MyHomePage({key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.325,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: colours[200],
              ),
              alignment: Alignment.center,
            ),
            Container(),
          ],
        ),
        Column(
          children: <Widget>[
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.125,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
