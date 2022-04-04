
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:provider/provider.dart';


class HomePageUsers extends StatefulWidget{
  const HomePageUsers({Key key}) : super(key: key);

  @override
  State<HomePageUsers> createState() => _HomePageUsersState();
}

class _HomePageUsersState extends State<HomePageUsers> {

  static String _displayStringForOption(DocumentSnapshot option) => option['nome'];

  String valueSelected;

  @override
  void initState() {
    super.initState();
    filteringData();
  }

  filteringData() {
    if(valueSelected == null) {
      final Stream<QuerySnapshot> _activityStream = FirebaseFirestore.instance.collection('ATIVIDADES').snapshots();
      return AllActivitiesData(stream: _activityStream);
    } else {
      final Stream<QuerySnapshot> _filterActivityStream = FirebaseFirestore.instance.collection('ATIVIDADES').where('subject', isEqualTo: valueSelected).snapshots();
      return AllActivitiesData(stream: _filterActivityStream);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('AREA_TEMATICA').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Text('Carregando ...');
            } else {
              return Autocomplete<DocumentSnapshot>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<DocumentSnapshot>.empty();
                  }
                  return snapshot.data.docs.where((DocumentSnapshot option) {
                    return option.get('nome').toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                fieldViewBuilder: fieldViewBuilder,
                onSelected: (DocumentSnapshot selection) {
                  debugPrint('You just selected ${_displayStringForOption(selection)}');

                  setState(() {
                    valueSelected = _displayStringForOption(selection);
                  });

                  debugPrint(valueSelected);

                },
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            filteringData()
          ],
        ),
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
                icone: Icons.assignment_rounded,
                title: 'Formulário',
                onTap: () {
                  Navigator.pushNamed(context, '/formActivity');
                },
                color: Colors.white),

            ListTileOptions(
                icone: Icons.list_alt_rounded,
                title: 'Minhas Atividades',
                onTap: () {
                  Navigator.pushNamed(context, '/listActivity');
                },
                color: Colors.white),

            ListTileOptions(
                icone: Icons.settings,
                title: 'Configurações',
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
                color: Colors.white),

            ListTileOptions(
                icone: Icons.logout,
                title: 'Sair',
                onTap: () {
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
                color: Colors.redAccent),
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

  const ListTileOptions({Key key, this.icone, this.title, this.onTap, this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icone, color: color),
        title: Text(title),
        onTap: onTap
    );

}

Widget fieldViewBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted) {
  return TextField(
    controller: textEditingController,
    focusNode: focusNode,
    decoration: const InputDecoration(
        label: Text('Pesquise pelas disciplinas cadastradas'),
        border: OutlineInputBorder(),
    ),
  );
}

class AllActivitiesData extends StatelessWidget {

  final Stream<QuerySnapshot> stream;

  const AllActivitiesData({Key key, this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Algo deu errado!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Carregando dados..."));
          }

          final data = snapshot.requireData;

          return ListView.builder(
              itemCount: data.size,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                //Pegando as informações dos documentos do firebase da coleção Activities

                final infoTitle = data.docs[index]['title'];
                final infoTempo = data.docs[index]['tempo'];

                return ListTile(
                    leading: const Icon(FontAwesome.file),
                    title: Text(infoTitle),
                    subtitle: Text(infoTempo, style: const TextStyle(color: Colors.black45)),
                    );
              }
          );
        }
    );
  }

}