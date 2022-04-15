import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:projflutterfirebase/Models/demanda.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:projflutterfirebase/Screens/Admin_screen.dart';
import 'package:projflutterfirebase/Screens/Homepage.dart';
import 'package:projflutterfirebase/Screens/Login_page.dart';
import 'package:provider/provider.dart';

class ActivityRef {

  final activityRef = FirebaseFirestore.instance.collection('ATIVIDADES').withConverter<SchoolActivity>(
    fromFirestore: (snapshot, _) => SchoolActivity.fromJson(snapshot.data()),
    toFirestore: (activity, _) => activity.toJson(),
  );

  String docId;

  Future<void> addActivity(
      String title,
      String tempo,
      String topics,
      String infoExtra,
      String subject,
      String userID) async {
    // Add an activity to firebase
    await activityRef.add(
        SchoolActivity(
            title,
            tempo,
            topics,
            infoExtra,
            subject,
            userID
        )
    )
        .then((value) => docId = value.id)
        .catchError((error) => "Ocorreu um erro ao registrar sua atividade: $error");

    //Mostra o id da atividade
    debugPrint(docId);

    uploadFile(docId, null, null);
  }

  Future<void> uploadFile([String docId, Uint8List _data, String nameFile]) async {
    CollectionReference _activity = FirebaseFirestore.instance.collection('ATIVIDADES').doc(docId).collection('arquivos');

    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('files/$nameFile');

    ///Mostrar a progressão do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

    ///Pega o download url do arquivo
    String url = await uploadTask.ref.getDownloadURL();

    if (uploadTask.state == firebase_storage.TaskState.success) {
      debugPrint('Arquivo enviado com sucesso!');
      debugPrint('URL do arquivo: $url');
      debugPrint(docId);
      _activity.add({'file_url': url});
    } else {
      if (kDebugMode) {
        print(uploadTask.state);
      }
    }
  }
}

class AuthService extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  User user;
  String errorMessage;
  String userType;

  final userRef = FirebaseFirestore.instance.collection('USUARIOS').withConverter<Users>(
    fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()),
    toFirestore: (user, _) => user.toJson(),
  );

  //helper methods to get user information
  //Get the user id
  String userId() {
    return auth.currentUser?.uid;
  }

  //Get the email from the current user
  String userEmail() {
    return auth.currentUser?.email;
  }

  //Verify if the current user is logged in or not
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String photoURL() {
    return auth.currentUser?.photoURL ?? 'assets/image/logo_user.png';
  }

  _getUser() async {
    user = auth.currentUser;
    notifyListeners();
  }

  ///create a new account on Firebase
  Future<void> registration(String userEmail, String name, String phone, String userPassword, BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword
      );
      notifyListeners();
      addUser(userEmail, name, phone);
      checkUser();
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'A senha fornecida é muito fraca.';
        debugPrint(errorMessage);
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Esse email já está sendo utilizado por outro usuário!';
        debugPrint(errorMessage);
      }

      //SnackBar
      SnackBar snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      debugPrint(e);
    }
  }

  ///sign-in to an existing account
  Future<void> signIn(String userEmail, String userPassword, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword
      );
      notifyListeners();
      checkUser();
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum usuário foi encontrado com o email fornecido.';
        debugPrint(errorMessage);
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta, tente novamente!';
        debugPrint(errorMessage);
      }

      //SnackBar
      SnackBar snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }

  ///add user to a collection in firebase
  Future<void> addUser(String email, String name, String phone) async {
    await userRef.doc(userId()).set(
      Users(
          userId(),
          email,
          'user',
          name,
          phone,
          '')
    );
  }

  ///verify the type of the current user
  Future<void> checkUser() async {
    // Pega o documento que possui em seu campo id o valor do id do usuário logado
    final docId = await userRef.where('id', isEqualTo: userId()).get().then((value) => value.docs);

    //Laço que retorna o tipo de usuário(admin ou user)
    for (var dataSnapshot in docId) {
      userType = dataSnapshot.data().tipo;
      debugPrint(dataSnapshot.id);
      debugPrint(dataSnapshot.data().email);
      debugPrint('Esse usuário é do tipo: + $userType' );
    }
  }




  ///Sing In with Google
  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
        _getUser();
        notifyListeners();
      } catch (e) {
        debugPrint(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
          _getUser();
          notifyListeners();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }

  ///Sing In with Facebook
  Future<UserCredential> signInWithFacebook() async {

    try {
      // Create a new provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      //await auth.signInWithRedirect(facebookProvider);
      await auth.signInWithPopup(facebookProvider);
      _getUser();
      notifyListeners();
    } on FirebaseAuthException catch(e) {
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint('erro de autentificação');

      }
    }

  }
}

class ManegeAuthState extends StatelessWidget {
  const ManegeAuthState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      if(authService.isLoggedIn()) {
        return const RoleBasedUI();
      } else {
        debugPrint('Não estou logado no app');
        return const AuthenticationPages();
      }
    },
    );
  }

}


class RoleBasedUI extends StatelessWidget{
  const RoleBasedUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<DocumentSnapshot>(
      stream: authService.userRef.doc(authService.userId()).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.primary, size: 120),
          );
        }

        else if (snapshot.hasData) {
          return checkRole(snapshot.data);
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return const Center(
        child: Text('no data set in the userId document in firestore'),
      );
    }
    if (snapshot.get('tipo') == 'admin') {
      return const SearchDocs();
    } else {
      return const HomePageUsers();
    }
  }
}


