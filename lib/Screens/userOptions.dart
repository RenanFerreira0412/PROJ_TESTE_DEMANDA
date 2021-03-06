import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/My_Profile.dart';
import 'package:provider/provider.dart';


class MoreOptions extends StatelessWidget {

  final styleTextTitle = const TextStyle(fontSize: 23, fontWeight: FontWeight.bold);

  AuthService userDao;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userDao = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Image.asset(
          'assets/image/logo.png',
          width: 240,
        ),
        centerTitle: true,
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 4.0,
            ),
            preferredSize: const Size.fromHeight(4.0)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
          'Mais Serviços',
          style: GoogleFonts.quicksand(textStyle: styleTextTitle),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Options(Icons.person_pin_rounded, 'Meu Perfil', 'Visualize seus dados cadastrados', () {
                    debugPrint('Meus dados');
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return MyProfile();
                    }));
                  },
                      Theme.of(context).colorScheme.primary
                  ),

                  const SizedBox(height: 10),

                  Options(Icons.feedback_outlined , 'Retornos', 'Visualize atualizações sobre a sua demanda', () {
                    debugPrint("Página retorno");
                  },
                      Theme.of(context).colorScheme.primary
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

class Options extends StatelessWidget {

  final IconData icone;
  final String title;
  final String subtitle;
  final Function onTap;
  final Color color;

  const Options(this.icone, this.title, this.subtitle, this.onTap, this.color);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: Icon(icone, size: 50, color: color),
      title: Text(title, style: GoogleFonts.quicksand(textStyle: const TextStyle(fontWeight: FontWeight.bold))),
      subtitle: Text(subtitle, style: GoogleFonts.quicksand(textStyle: const TextStyle(fontWeight: FontWeight.bold))),
      onTap: onTap
    );
  }

}