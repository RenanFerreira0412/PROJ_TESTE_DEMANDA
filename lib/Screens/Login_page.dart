import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:projflutterfirebase/Screens/Register_page.dart';
import 'package:provider/provider.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';

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
          backgroundColor: const Color.fromRGBO(64, 64, 64, 0.4),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Login',
                style: GoogleFonts.cabin(textStyle: styleTextTitle),
                ),
              ),

              CadastrarConta(
                  styleText,
                  'Novo Usuário?',
                  ' Registrar uma conta',
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(),
                    ));
                  }
              ),

              //We are calling the EditorLogin to give our password and email
              EditorAuth(_emailController, 'Email', 'Email', const Icon(Icons.email_outlined), _valida, 25, false),

              const SizedBox(height: 10),

              EditorAuth(_passwordController, 'Senha','Senha', const Icon(Icons.lock_outline), _valida, 10, true),

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
                    userDao.login(_emailController.text, _passwordController.text);
                  }
                },
                  child: Text('Entrar', style: GoogleFonts.roboto(textStyle: styleText)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
              ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text('Esqueceu sua senha?', style: GoogleFonts.roboto(textStyle: styleText)),
                  ),
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
  final String firstText;
  final String secondTextNavigation;
  final Function setFormAction;

  const CadastrarConta(this.styleText, this.firstText, this.secondTextNavigation, this.setFormAction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                firstText,
                style: GoogleFonts.cabin(textStyle: styleText)),

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


