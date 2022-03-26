import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projflutterfirebase/Screens/Admin_screen.dart';
import 'package:projflutterfirebase/Screens/Login_page.dart';
import 'package:projflutterfirebase/Screens/Homepage.dart';
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
      theme: FlexColorScheme.light(scheme: FlexScheme.jungle).toTheme,
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
                //Chama a função que verifica o usuário que logou e passa o id do mesmo
                userDao.checkUser(userDao.userId());

                //Mostra o tipo de usuário logado(admin ou user)
                debugPrint(userDao.userType);

                //Verifica o tipo de usuário logado(admin ou user)
                if(userDao.userType == 'admin'){
                  debugPrint('É um admin');
                  return AdminScreen();
                } else { // Caso contrário, retornará para a página dos usuários comuns
                  debugPrint('Não é um admin');
                  return const HomePageUsers();
                }
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

