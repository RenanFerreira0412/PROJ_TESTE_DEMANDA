import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/Login_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameController = TextEditingController();

  final _phoneController = TextEditingController();

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
                  'Registrar',
                  style: GoogleFonts.cabin(textStyle: styleTextTitle),
                ),
              ),

              EntrarConta(
                  styleText,
                  'Já possui uma conta?',
                  ' Entrar',
                      () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login(),
                    ));
                  }
              ),

              EditorAuth(_nameController, 'Seu nome', 'Informe seu nome completo', const Icon(Icons.person), _valida, 20, false),

              const SizedBox(height: 10),

              EditorAuth(_phoneController, 'Seu telefone', 'Informe seu número de contato ', const Icon(Icons.phone), _valida, 20, false),

              const SizedBox(height: 10),

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
                      _nameController.text.isEmpty ? _valida = true : _valida = false;
                      _phoneController.text.isEmpty ? _valida = true : _valida = false;
                      _emailController.text.isEmpty ? _valida = true : _valida = false;
                      _passwordController.text.isEmpty ? _valida = true : _valida = false;
                    });

                    if(!_valida){
                      userDao.signup(_emailController.text, _passwordController.text);
                    }
                  },
                  child: Text('Cadastrar', style: GoogleFonts.roboto(textStyle: styleText)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }



}

class EntrarConta extends StatelessWidget{

  final TextStyle styleText;
  final String firstText;
  final String secondTextNavigation;
  final Function setFormAction;

  const EntrarConta(this.styleText, this.firstText, this.secondTextNavigation, this.setFormAction);

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