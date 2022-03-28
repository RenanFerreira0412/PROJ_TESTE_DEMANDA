import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projflutterfirebase/Route/route_generator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/Admin_screen.dart';
import 'package:projflutterfirebase/Screens/Homepage.dart';
import 'package:projflutterfirebase/Screens/Login_page.dart';
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

  ThemeMode themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.bahamaBlue;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: usedScheme,
        // Use very subtly themed app bar elevation in light mode.
        appBarElevation: 0.5,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: usedScheme,
        // Use stronger themed app bar elevation in dark mode.
        appBarElevation: 2,
      ),
      themeMode: themeMode,
      //Initially display FirstPage
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class ManegeStateAuth extends StatelessWidget {
  const ManegeStateAuth({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      if (authService.isLoggedIn()) {
        if(authService.userType == 'admin') {
          return const AdminScreen();
        } else {
          return const HomePageUsers();
        }
      } else {
        return const AuthenticationPages();
      }
    },
    );
  }

}