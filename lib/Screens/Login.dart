import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/Admin_screen.dart';
import 'package:projflutterfirebase/Screens/Homepage.dart';
import 'package:provider/provider.dart';

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
          SignUpPage(pageController: pc),
          RegisterUser(pageController: pc)
        ],
        onPageChanged: setInitialPage,
      ),
    );
  }
}


class SignUpPage extends StatefulWidget {

  final PageController pageController;

  const SignUpPage({Key key, this.pageController}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _valida = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
              child: const Text('Novo usuário? Cadastre-se'),
            ),

            EditorAuth(_emailController, 'Email', 'Informe seu email', const Icon(Icons.email), _valida, 30, false),

            EditorAuth(_passwordController, 'Senha', 'Informe sua senha', const Icon(Icons.password), _valida, 10, true),

            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _emailController.text.isEmpty ? _valida = true : _valida = false;
                    _passwordController.text.isEmpty ? _valida = true : _valida = false;
                  });

                  if(!_valida) {
                    authService.signIn(_emailController.text, _passwordController.text);
                  }
                },
                child: const Text('Entrar')
            )
          ],
        ),
      ),
    );
  }
}

class RegisterUser extends StatefulWidget {
  final PageController pageController;

  const RegisterUser({Key key, this.pageController}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _valida = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
              child: const Text('já possui uma conta? Entrar'),
            ),

            EditorAuth(_nameController, 'Nome', 'Informe o seu nome', const Icon(Icons.person), _valida, 20, false),

            EditorAuth(_phoneController, 'Telefone', 'Informe o seu telefone', const Icon(Icons.phone), _valida, 20, true),

            EditorAuth(_emailController, 'Email', 'Informe seu email', const Icon(Icons.email), _valida, 30, false),

            EditorAuth(_passwordController, 'Senha', 'Informe sua senha', const Icon(Icons.password), _valida, 10, true),

            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _nameController.text.isEmpty ? _valida = true : _valida = false;
                    _phoneController.text.isEmpty ? _valida = true : _valida = false;
                    _emailController.text.isEmpty ? _valida = true : _valida = false;
                    _passwordController.text.isEmpty ? _valida = true : _valida = false;
                  });

                  if(!_valida) {
                    authService.registration(
                        _emailController.text,
                        _nameController.text,
                        _phoneController.text,
                        _passwordController.text);
                  }
                },
                child: const Text('Criar conta')
            )
          ],
        ),
      ),
    );
  }
}
