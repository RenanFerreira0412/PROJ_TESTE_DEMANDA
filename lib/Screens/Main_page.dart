import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projflutterfirebase/Screens/Login_page.dart';
import 'package:projflutterfirebase/Screens/Register_page.dart';
import 'package:projflutterfirebase/Screens/Adm_page.dart';
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

  void facebookAuth;
  Future googleAuth;

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
        element = SocialMediaButtons(googleAuth, facebookAuth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final userDao = Provider.of<UserDao>(context, listen: false);

    googleAuth = userDao.signInWithGoogle();
    facebookAuth = userDao.signInWithFacebook();

    return GestureDetector(
      onTap: () {
        if(!onlyEmail) {
          //Esconde o Widget com os botões de média social
          setWidgetAction(!onlyEmail);
        }
      },
      child: Scaffold(
        body: Stack(
            children: [

              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //Navegar para a tela de Login
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Login(),
                          ));
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text('Login', style: GoogleFonts.cabin(textStyle: styleTextTitle))
                          ),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: AppBarLogo(styleTextTitle)
                      ),
                    ],
                  )
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: const Color.fromRGBO(64, 64, 64, 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  height: 430,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Buttons(
                              () {
                            //Navegar para a tela de cadastro
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(),
                            ));
                          },
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
                              () {
                            //Navegar para a tela do Adiministrador
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdmPage(),
                            ));
                          },
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
                ),
              ),

            ]
        ),
      ),
    );
  }

  Widget SocialMediaButtons(Future googleAuth, void facebookAuth) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonsMedia(
                () {
                  debugPrint('google login');
                  googleAuth;
            },
            'Google',
            Colors.white,
            Colors.black,
            'assets/image/logo_google.png'
        ),

        const SizedBox(height: 20),

        ButtonsMedia(
                () {
                  debugPrint('fecebook login');
                  facebookAuth;
            },
            'facebook',
            const Color.fromRGBO(24, 119, 242, 0.5),
            Colors.white,
            'assets/image/logo_facebook.png'
        ),
      ],
    );
  }

}

