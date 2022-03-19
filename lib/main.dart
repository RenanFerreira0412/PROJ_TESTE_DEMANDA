import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projflutterfirebase/Models/demanda.dart';
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
                return VerificaUser(userId: userDao.userId());
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

class VerificaUser extends StatefulWidget {

  final String userId;

  const VerificaUser({Key key, this.userId}) : super(key: key);

  @override
  State<VerificaUser> createState() => _VerificaUserState();
}

class _VerificaUserState extends State<VerificaUser> {
  @override
  Widget build(BuildContext context) {

    final usersRef = FirebaseFirestore.instance.collection('movies')
        .withConverter<Users>(
      fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()),
      toFirestore: (user, _) => user.toJson(),
    );

    ///Função que pega os documentos da coleção USUARIOS e passa para uma lista
    _pegaDadosUsersStreamSnapshots() async {
      List<QueryDocumentSnapshot<Users>> users = await usersRef
          .where('userID', isEqualTo: widget.userId)
          .get()
          .then((snapshot) => snapshot.docs);

      return users;
    }


    return StreamBuilder<QuerySnapshot<Users>>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return checkRole(snapshot.data, widget.userId);
        });
  }
}

Widget checkRole(QuerySnapshot snapshot, String userId) {

  if (snapshot.docs.isEmpty) {
    return const Center(
      child: Text('no data set in the userId document in firestore '),
    );
  }

  for (var doc in snapshot.docs) {
    if (doc['tipo'] == 'admin') {
      return AdminScreen();
    } else {
      return AllUsersHomePage();
    }
  }
}

