import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projflutterfirebase/Route/route_generator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
          providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
          child: MyApp(),
        )
          ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.light(scheme: FlexScheme.jungle).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.jungle).toTheme,
      themeMode: ThemeMode.dark,
      //Initially display FirstPage
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

