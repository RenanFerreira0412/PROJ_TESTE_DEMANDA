import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Models/demanda.dart';
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
      body: const HomePageContent(),
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


class HomePageContent extends StatelessWidget {
  const HomePageContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final userDao = Provider.of<AuthService>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu_rounded)),

              const SizedBox(width: 10),

              const Expanded(child: SearchBar()),
            ],
          ),


        ],
      ),
    );
  }
}


class SearchBar extends StatefulWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  static final List<AllSubjects> _allResults = [
    AllSubjects('física', 1),
    AllSubjects('biologia', 2),
    AllSubjects('história', 3),
    AllSubjects('matemática', 4),
    AllSubjects('inglês', 5),
    AllSubjects('educação física', 6),
    AllSubjects('banco de dados', 7),
    AllSubjects('português', 8),
    AllSubjects('geografia', 9),
    AllSubjects('progamação', 10),
    AllSubjects('química', 11),
    AllSubjects('sistemas operacionais', 12),
  ];

  static String _displayStringForOption(AllSubjects option) => option.name;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<AllSubjects>(
      displayStringForOption: _displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<AllSubjects>.empty();
        }
        return _allResults.where((AllSubjects option) {
          return option
              .toString()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (AllSubjects selection) {
        debugPrint('You just selected ${_displayStringForOption(selection)}');
      },
    );

  }
}