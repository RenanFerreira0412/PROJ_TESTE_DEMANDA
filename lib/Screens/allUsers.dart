
import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Screens/form.dart';
import 'package:projflutterfirebase/Screens/lista.dart';
import 'package:projflutterfirebase/Screens/userOptions.dart';


class AllUsersHomePage extends StatefulWidget{

  @override
  State<AllUsersHomePage> createState() => _AllUsersHomePageState();
}

class _AllUsersHomePageState extends State<AllUsersHomePage> {

  int paginaAtual = 0;
  PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          FormDemanda(),
          ListaDemanda(),
          MoreOptions(),
        ],
        onPageChanged: setPaginaAtual,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
          unselectedIconTheme: const IconThemeData(color: Colors.white),
          unselectedItemColor:  Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.green[900], size: 30),
          selectedItemColor: Colors.green[900],

          type: BottomNavigationBarType.fixed,
          selectedFontSize: 15,

          items: const [
              BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Formulário'),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Minhas propostas'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'Mais'),
          ],
          onTap: (pagina) {
          pc.animateToPage(pagina, duration: const Duration(milliseconds: 400), curve: Curves.ease);
    },
        backgroundColor: const Color.fromRGBO(64, 64, 64, 0.4),

      ),
    );
  }
}

Widget BottomNavigationBarItemk(IconData icon, String label, Color color) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.green[900].withOpacity(0.3),
          Colors.green.withOpacity(0.015),
        ]
      )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
        ),

        Text(label, style: TextStyle(color: color))

      ],
    ),
  );
}