import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:projflutterfirebase/Models/demanda.dart';

class UserDao extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  User usuario;
  String errorMessage;
  UserCredential user;
  String userType;



// TODO: Add helper methods - Métodos de ajuda
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String userId() {
    return auth.currentUser?.uid;
  }

  String userEmail() {
    return auth.currentUser?.email;
  }
  // ImgUsuario.src = user.photoURL ? user.photoURL : 'IMGs/usuarioIMG.png'

  String photoURL() {
    return auth.currentUser?.photoURL ?? 'assets/image/logo_user.png';
  }

  _getUser() {
    usuario = auth.currentUser;
    notifyListeners();
  }

  // Método responsável por adicionar um novo usuário na coleção USUARIOS
  void addUser(String email, String password, String userName, String userNumber) async {
    //Adicionando um novo usuario a nossa coleção -> Usuários
    DocumentReference _novoUsuario = await FirebaseFirestore.instance.collection('USUARIOS').add({
      'id': userId(),
      'nome': userName,
      'email': userEmail(),
      'telefone': userNumber,
      'tipo': 'user',
      'url_photo': '',
    })
    .catchError((error) => debugPrint("Ocorreu um erro ao registrar o usuário: $error"));

    checkRole(_novoUsuario.id);
  }

  checkRole(String docUserId) {
    debugPrint(docUserId);
  }

// TODO: Add signup - Cadastrar no App
  void signup(String email, String password, String name, String userNumber) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      addUser(email, password, name, userNumber);
      notifyListeners();
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //throw AuthException('Sua senha é muito fraca');
        errorMessage = 'Sua senha é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        //throw AuthException('Este email já está cadastrado');
        errorMessage = 'Este email já está cadastrado';
      }
      
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.BOTTOM);
    } catch (e) {
      debugPrint(e);
    }
  }


// TODO: Add login - Entrar no App
  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _getUser();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        //throw AuthException('Senha incorreta. Tente novamente');
        errorMessage = 'Senha incorreta. Tente novamente';
      } else if (e.code == 'user-not-found') {
        //throw AuthException('Email não encontrado. Cadastre-se');
        errorMessage = 'Email não encontrado. Cadastre-se';
      }

      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.SNACKBAR);
    } catch (e) {
      debugPrint(e);
    }
  }


// TODO: Add logout -  Sair do App
  void logout() async {
    await auth.signOut();
    notifyListeners();
    _getUser();
  }

  // TODO: verifica o tipo do usuário logado
  Future<void> checkUser(String userID) async {
    final usersRef = FirebaseFirestore.instance.collection('USUARIOS').withConverter<Users>(
      fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()),
      toFirestore: (movie, _) => movie.toJson(),
    );

    // Pega o documento que possui em seu campo id o valor do id do usuário logado
    final userId = await usersRef.where('id', isEqualTo: userID).get().then((value) => value.docs);

    //Laço que retorna o tipo de usuário(admin ou user)
    for (var element in userId) {
      userType = element.data().tipo;
    }
  }

// TODO: Sing In with Google
  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        usuario = userCredential.user;
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

          usuario = userCredential.user;
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

    return usuario;
  }

  // TODO: Sing In with Facebook
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






