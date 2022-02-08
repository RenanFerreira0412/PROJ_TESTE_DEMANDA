import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projflutterfirebase/Screens/allUsers.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/login.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
          providers: [
        ChangeNotifierProvider(
          create: (context) => UserDao(),
          child: MyApp(),
        )
          ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.light(scheme: FlexScheme.red).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.jungle).toTheme,
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint("You have an error!");
            return const Text('Algo não deu certo!');
          } else if (snapshot.hasData) {
            return Consumer<UserDao>(builder: (context, userDao, child) {
              if (userDao.isLoggedIn()) {
                return AllUsersHomePage();
              } else {
                return const Login();
              }
            });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
