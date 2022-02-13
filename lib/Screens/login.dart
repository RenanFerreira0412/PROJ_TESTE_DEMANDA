import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:projflutterfirebase/Widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key key}) : super(key: key);

  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  final styleTextLogo = const TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
  final styleTextTitle = const TextStyle(fontSize: 20);
  final optionsText = const TextStyle(fontSize: 20);

  bool onlyEmail = true;
  Widget element;
  String title = 'Mais opções';

  @override
  void initState() {
    super.initState();
    setWidgetAction(true);
  }

  setWidgetAction(bool acao){
    setState(() {
      onlyEmail = acao;
      if(onlyEmail) {
        element = Text(title, style: GoogleFonts.cabin(textStyle: optionsText));
      } else {
        element = SocialMediaButtons();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                //Navegar para a tela de Login
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text('Login', style: GoogleFonts.cabin(textStyle: styleTextTitle))
                ),
              ),
            ),

            Text('Logo' ,style: GoogleFonts.cabin(textStyle: styleTextLogo)),

            Container(
              color: const Color.fromRGBO(64, 64, 64, 0.4),
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Buttons(
                          () {},
                      'Entrar com email',
                      Colors.white,
                      Colors.black,
                      Colors.white,
                    4,
                    Icons.email,
                      Theme.of(context).colorScheme.primary
                  ),

                  const SizedBox(height: 20),

                  Buttons(
                          () {},
                      'Administrador',
                      const Color.fromRGBO(64, 64, 64, 0.4),
                      Colors.white,
                      const Color.fromRGBO(125, 155, 118, 0.6),
                    4,
                    Icons.person,
                      Theme.of(context).colorScheme.primary
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: (){
                      setWidgetAction(!onlyEmail);
                      },
                    child: element,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

Widget SocialMediaButtons() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Buttons(() {}, 'Google', Colors.white, Colors.black, Colors.white, 1, Icons.assessment_rounded, Colors.orange),

      const SizedBox(height: 20),

      Buttons(() {}, 'facebook', const Color.fromRGBO(26, 71, 137, 0.5), Colors.white, const Color.fromRGBO(26, 71, 137, 0.5), 1, Icons.facebook, Colors.white),
    ],
  );
}


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _valida = false;

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  final styleTextTitle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  bool isLogin = true;

  String title;
  String textActionButton;
  String firstTextNavigation;
  String secondTextNavigation;

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
        textActionButton = 'CONECTE-SE';
        firstTextNavigation = 'Não possui nenhuma conta?';
        secondTextNavigation = 'Cadastre-se';
      } else {
        title = 'CADASTRO';
        textActionButton = 'CADASTRAR';
        firstTextNavigation = 'Já possui uma conta?';
        secondTextNavigation = 'Conecte-se';
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
          toolbarHeight: 150,
          title: AppBarLogo(styleTextTitle),
          centerTitle: true,
          backgroundColor: Colors.green[900],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(45),
                child: Text(
                title,
                style: GoogleFonts.cabin(textStyle: styleTextTitle),
                ),
              ),

              //We are calling the EditorLogin to give our password and email
              EditorLogin(_emailController, 'Email', 'Email', const Icon(Icons.email_outlined), _valida, 25, false),

              const SizedBox(height: 10),

              EditorLogin(_passwordController, 'Senha','Senha', const Icon(Icons.lock_outline), _valida, 10, true),

              const SizedBox(height: 10),

              
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _emailController.text.isEmpty ? _valida = true : _valida = false;
                    _passwordController.text.isEmpty ? _valida = true : _valida = false;
                  });

                  if(!_valida){
                    if(isLogin){
                      userDao.login(_emailController.text, _passwordController.text);

                    } else {
                      userDao.signup(_emailController.text, _passwordController.text);
                    }

                  }
                },
                  child: Text(textActionButton, style: GoogleFonts.roboto(textStyle: styleText)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    ),
                  ),
              ),
              ),

              CadastrarConta(styleText, firstTextNavigation, secondTextNavigation, () => setFormAction(!isLogin)),

              ContaAdministrador(styleText),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                  child: Divisor()
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconesMedia(
                        'assets/image/logo_google.png',
                            () {
                          debugPrint('Você logou com o google');

                          userDao.signInWithGoogle();
                        },
                        'Cadastre-se com o Google',
                      18,
                      5
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconesMedia(
                          'assets/image/logo_facebook.png',
                              () {
                            debugPrint('Você logou com o facebook');

                            userDao.signInWithFacebook();
                          },
                          'Cadastre-se com o Facebook',
                        0,
                        5
                      ),
                    )
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
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(30),
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                firstTextNavigation,
                style: GoogleFonts.cabin(textStyle: styleText, color: Colors.grey[700])),

            GestureDetector(
              onTap: setFormAction,
              child: Text(
                  secondTextNavigation,
                  style: GoogleFonts.cabin(textStyle: styleText, color: Colors.white)),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              'Entrar como',
              style: GoogleFonts.cabin(textStyle: styleText, color: Colors.grey[700])),

          GestureDetector(
            onTap: () {
              debugPrint('Página de login do administrador');
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOptions(),
              ));
            },

            child: Text(
                ' administrador',
                style: GoogleFonts.cabin(textStyle: styleText, color: Colors.white)),
          )

        ]);
  }

}
