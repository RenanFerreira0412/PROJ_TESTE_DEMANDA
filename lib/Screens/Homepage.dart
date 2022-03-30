import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:provider/provider.dart';


class HomePageUsers extends StatefulWidget{
  const HomePageUsers({Key key}) : super(key: key);


  @override
  State<HomePageUsers> createState() => _HomePageUsersState();
}

class _HomePageUsersState extends State<HomePageUsers> {

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Notes'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),

              child: const Text(
                'Mais Opções',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            ListTileOptions(
                Icons.assignment_rounded,
                'Formulário',
                    () {
                  Navigator.pushNamed(context, '/formActivity');
                },
                Colors.white),

            ListTileOptions(
                Icons.list_alt_rounded,
                'Minhas Atividades',
                    () {
                  Navigator.pushNamed(context, '/listActivity');
                },
                Colors.white),

            ListTileOptions(
                Icons.settings,
                'Configurações',
                    () {
                  Navigator.pushNamed(context, '/settings');
                },
                Colors.white),

            ListTileOptions(
                Icons.logout,
                'Sair',
                    () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sair'),
                              content: const Text('Tem certeza que deseja desconectar sua conta desse aparelho?'),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              actions: <Widget> [
                                TextButton(
                                  onPressed: (){
                                    debugPrint('O usuário saiu do app');
                                    Navigator.of(context).pop();
                                    userDao.logout();
                                  },
                                  child: const Text('SIM'),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('CANCELAR'),
                                ),
                              ],
                            );
                          }
                      );
                },
                Colors.redAccent),
          ],
        ),
      ),
    );
  }
}


class ListTileOptions extends StatelessWidget {

  final IconData icone;
  final String title;
  final Function onTap;
  final Color color;

  const ListTileOptions(this.icone, this.title, this.onTap, this.color);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
        leading: Icon(icone, color: color),
        title: Text(title),
        onTap: onTap
    );
  }

}