import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:projflutterfirebase/Widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/Adm_page.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _userNumberController = TextEditingController();

  bool _valida = false;

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  final styleTextTitle = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  bool isLogin = true;

  String title;
  String welcomeText;
  String textActionButton;
  String firstTextNavigation;
  String secondTextNavigation;
  Widget camposCadastro;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao){
    setState(() {
      isLogin = acao;
      if(isLogin) {
        title = 'LOGIN';
        textActionButton = 'ENTRAR';
        firstTextNavigation = 'Novo Usuário?';
        secondTextNavigation = 'Registrar uma conta';
        welcomeText = null;
        camposCadastro = const Text('');
      } else {
        title = 'CADASTRO';
        textActionButton = 'CADASTRAR';
        firstTextNavigation = 'Já possui uma conta?';
        secondTextNavigation = 'Entrar';
        welcomeText = 'Bem Vindo ao Extensiona-IF! Por favor, crie uma conta para poder prosseguir';
        camposCadastro = camposExtras(_nameController, _userNumberController, _valida);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: const Color.fromRGBO(64, 64, 64, 0.4),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: GoogleFonts.cabin(textStyle: styleTextTitle),
                  ),
                ),
              ),


              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: !isLogin ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 0),
                    child: Text(!isLogin ? welcomeText : '')
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                  child: CadastrarConta(styleText, firstTextNavigation, secondTextNavigation, () => setFormAction(!isLogin))
              ),

              EditorAuth(_emailController, 'Email', 'Email', const Icon(Icons.email_outlined), _valida, 25, false),

              const SizedBox(height: 10),

              EditorAuth(_passwordController, 'Senha','Senha', const Icon(Icons.lock_outline), _valida, 10, true),

              camposCadastro,

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text('Esqueceu sua senha?', style: GoogleFonts.roboto(textStyle: styleText)),
                  ),
                ),
              ),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(isLogin){
                        _emailController.text.isEmpty ? _valida = true : _valida = false;
                        _passwordController.text.isEmpty ? _valida = true : _valida = false;
                      } else {
                        _emailController.text.isEmpty ? _valida = true : _valida = false;
                        _passwordController.text.isEmpty ? _valida = true : _valida = false;
                        _nameController.text.isEmpty ? _valida = true : _valida = false;
                        _userNumberController.text.isEmpty ? _valida = true : _valida = false;
                      }
                    });

                    if(!_valida){
                      if(isLogin){
                        userDao.login(_emailController.text, _passwordController.text);

                      } else {
                        userDao.signup(_emailController.text, _passwordController.text, _nameController.text, _userNumberController.text);
                      }

                    }
                  },
                  child: Text(textActionButton, style: GoogleFonts.roboto(textStyle: styleText)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdmPage(),
                      ));
                    },
                    child: Text('Entrar como administrador', style: GoogleFonts.roboto(textStyle: styleText)),
                  ),
                ),
              ),


              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Divisor()
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () {
                          userDao.signInWithGoogle();
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: SignInButton(
                        Buttons.FacebookNew,
                        text: "Sign up with facebook",
                        onPressed: () {
                          userDao.signInWithFacebook();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }



}

class CadastrarConta extends StatelessWidget{

  final TextStyle styleText;
  final String firstTextNavigation;
  final String secondTextNavigation;
  final Function setFormAction;

  const CadastrarConta(this.styleText, this.firstTextNavigation, this.secondTextNavigation, this.setFormAction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child:  Row(
          children: <Widget>[
            Text(
                firstTextNavigation,
                style: GoogleFonts.cabin(textStyle: styleText, color: Colors.white)),

            GestureDetector(
              onTap: setFormAction,
              child: Text(
                  secondTextNavigation,
                  style: GoogleFonts.cabin(textStyle: styleText, color: Theme.of(context).colorScheme.primary)),
            )

          ]),
    );

  }

}


class ContaAdministrador extends StatelessWidget {
  final TextStyle styleText;

  const ContaAdministrador(this.styleText);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Text(
              'Entrar como',
              style: GoogleFonts.cabin(textStyle: styleText, color: Colors.grey[700])),

          GestureDetector(
            onTap: () {
              debugPrint('Página de login do administrador');
            },

            child: Text(
                ' administrador',
                style: GoogleFonts.cabin(textStyle: styleText, color: Colors.white)),
          )

        ]);
  }

}

Widget camposExtras(TextEditingController _nameController, TextEditingController _userNumberController, bool _valida) {
  return Column(
    children: [
      const SizedBox(height: 10),

      EditorAuth(_nameController, 'Nome','Informe o seu nome completo', const Icon(Icons.lock_outline), _valida, 10, false),

      const SizedBox(height: 10),

      EditorAuth(_userNumberController, 'Telefone','Informe um número de contato', const Icon(Icons.lock_outline), _valida, 10, false),
    ],
  );
}