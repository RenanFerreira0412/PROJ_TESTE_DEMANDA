import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/Login_page.dart';
import 'package:projflutterfirebase/Screens/Register_page.dart';
import 'package:projflutterfirebase/Screens/form.dart';
import 'package:projflutterfirebase/Screens/lista.dart';
import 'package:projflutterfirebase/Screens/userOptions.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
   // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ManegeAuthState());
      case '/authPages':
        return MaterialPageRoute(builder: (_) => const AuthenticationPages());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
      // Validation of correct data type
        return MaterialPageRoute(builder: (_) => const RegisterUser());
      case '/formActivity':
        return MaterialPageRoute(builder: (_) => FormDemanda());
      case '/listActivity':
        return MaterialPageRoute(builder: (_) => const ListaAtividade());
      case '/settings':
        return MaterialPageRoute(builder: (_) => MoreOptions());

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
