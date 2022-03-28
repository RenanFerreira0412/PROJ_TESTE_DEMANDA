import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Screens/Login_page.dart';
import 'package:projflutterfirebase/Screens/Register_page.dart';
import 'package:projflutterfirebase/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
   // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ManegeStateAuth());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
      // Validation of correct data type
        return MaterialPageRoute(builder: (_) => const RegisterUser());

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
