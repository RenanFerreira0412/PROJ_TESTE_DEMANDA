import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/Register_page.dart';
import 'package:provider/provider.dart';

class AuthenticationPages extends StatefulWidget {
  const AuthenticationPages({Key key}) : super(key: key);

  @override
  State<AuthenticationPages> createState() => _AuthenticationPagesState();
}

class _AuthenticationPagesState extends State<AuthenticationPages> {

  int initialPage = 0;
  PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: initialPage);
  }

  setInitialPage(page) {
    setState(() {
      initialPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        pageSnapping: false,
        controller: pc,
        children: [
          LoginPage(pageController: pc),
          RegisterUser(pageController: pc)
        ],
        onPageChanged: setInitialPage,
      ),
    );
  }
}


class LoginPage extends StatefulWidget {

  final PageController pageController;

  const LoginPage({Key key, this.pageController}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _valida = false;
  String validaMassage = 'Campo Obrigatório!';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Text('Bem Vindo ao student.notes'),

            registerOrLogin(
                'Novo Usuário?',
                'Registre-se',
                    () {
                      widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                    },
                context),

            EditorAuth(_emailController, 'Email', 'Informe seu email', const Icon(Ionicons.md_mail), _valida, 30, false, validaMassage),

            EditorAuth(_passwordController, 'Senha', 'Informe sua senha', const Icon(Ionicons.md_key), _valida, 10, true, validaMassage),

            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _emailController.text.isEmpty ? _valida = true : _valida = false;
                      _passwordController.text.isEmpty ? _valida = true : _valida = false;
                    });

                    if(!_valida) {
                      authService.signIn(_emailController.text, _passwordController.text, context);
                    }
                  },
                  child: const Text('Entrar')
              ),
            )
          ],
        ),
      ),
    );
  }
}