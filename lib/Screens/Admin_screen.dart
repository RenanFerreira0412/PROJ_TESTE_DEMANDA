import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Models/demanda.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _filterController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  ///Chama a função que verifica qualquer mudança no que foi digitado no TextFild
  @override
  void initState() {
    super.initState();
    _filterController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _filterController.removeListener(_onSearchChanged);
    _filterController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = pegaDadosDemandaStreamSnapshots();
  }

  ///Detecta o que foi digitado pelo usuário
  _onSearchChanged() {
    searchResultsList();
  }

  ///Função responsável por filtrar as demandas cadastradas pela área temática de cada demanda
  searchResultsList() {
    //Esse vetor ira armazenar todos os resultados encontrados durante a pesquisa
    var mostrarResultados = [];

    //Caso o usuário tenha digitado alguma coisa no TextField
    if(_filterController.text != "") {
      for(var dataSnapshot in _allResults){
        //Pega as áreas temáticas de todos os documentos registrados no Firebase
        Map<String, dynamic> data = dataSnapshot.data() as Map<String, dynamic>;
        var areaTematica = SchoolActivity.fromJson(data).subject.toLowerCase();
        debugPrint(areaTematica);
        //Caso o usuário tenha pesquisado por uma área existente, será apresentado todas as demandas registradas com essa área temática
       if(areaTematica.contains(_filterController.text.toLowerCase())) {
         //Adiciona as demandas encontradas ao vetor mostrarResultados
         mostrarResultados.add(dataSnapshot);
        }
      }
      //Caso contrário, será apresentado o vetor que contém todas as demandas cadastradas no banco do Firebase
    } else {
      mostrarResultados = List.from(_allResults);
    }

    setState(() {
      _resultsList = mostrarResultados;
    });
  }

  ///Função que pega os documentos da coleção Demandas e passa para uma lista
  pegaDadosDemandaStreamSnapshots() async {
    List<QueryDocumentSnapshot> listaDeDocumentos = (await FirebaseFirestore.instance
            .collection("ATIVIDADES")
            .get())
        .docs;

    setState(() {
      _allResults = listaDeDocumentos;
    });

    //Chama a função que traz os resultados da pesquisa feita
    searchResultsList();
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Propostas registradas pelos usuários"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () {
                userDao.logout();
              },
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  hintText: 'Pesquise por uma área temática',
                  helperText:
                      'Procure por demandas cadastradas através de sua área temática',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  fillColor: const Color.fromRGBO(64, 64, 64, 0.4),
                ),
              ),
            ),

            ListView.builder(
                  itemCount: _resultsList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {

                    return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 70.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: ListTile(
                            leading: Icon(Icons.assignment_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                            textColor: Colors.black,
                            title: Text(_resultsList[index]['title']),
                            subtitle: Text(_resultsList[index]['tempo'],
                                style: const TextStyle(
                                    color: Colors.black45)),
                            trailing: SizedBox(
                              width: 50,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 32),
                                    tooltip: 'Editar proposta',
                                    onPressed: () {
                                      debugPrint('consultou a demanda');
                                    },
                                  ),
                                ],
                              ),
                            )));
                  }),
          ],
        ),
      ),
    );
  }
}





class SearchDocs extends StatefulWidget {
  const SearchDocs({Key key}) : super(key: key);

  @override
  _SearchDocsState createState() => _SearchDocsState();
}

class _SearchDocsState extends State<SearchDocs> {
  final  _filterController = TextEditingController();
  List _allResults = [];

  @override
  void initState() {
    super.initState();
    _filterController.addListener(_pesquisaProposta);
  }

  @override
  void dispose() {
    _filterController.removeListener(_pesquisaProposta);
    _filterController.dispose();
    super.dispose();
  }

  _pesquisaProposta() {
    searchResultsList();
  }

  searchResultsList() {
    if(_filterController.text.isNotEmpty) {
      //Filtra as atividades de acordo com a disciplina digitada
      for(var dataSnapshot in _allResults) {
        Map<String, dynamic> data = dataSnapshot.data() as Map<String, dynamic>;
        var subjects = SchoolActivity.fromJson(data).subject.toLowerCase();
        debugPrint(subjects);
      }
    } else {
      debugPrint('hello');
    }
  }

  catchData() async {
    List<QueryDocumentSnapshot<SchoolActivity>> activity = await ActivityRef().activityRef
        .get()
        .then((snapshot) => snapshot.docs);

    setState(() {
      _allResults = activity;
    });

    searchResultsList();
  }


  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demandas'),
        actions: [
          IconButton(
              onPressed: () {
                userDao.logout();
              },
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  hintText: 'Pesquise por uma área temática',
                  helperText:
                  'Procure por demandas cadastradas através de sua área temática',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),


            StreamBuilder<QuerySnapshot>(
              stream: ActivityRef().activityRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                if (snapshot.requireData.size == 0) {
                  return const Center(child: Text("Sem dados cadastrados no banco"));
                }

                final data = snapshot.requireData;

                return CreateList(dataSnapshot: data);
              },
            )

          ],
        ),
      ),
    );
  }
}

class CreateList extends StatelessWidget{
  final QuerySnapshot dataSnapshot;

  const CreateList({Key key, this.dataSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: dataSnapshot.size,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {

        final infoTitle = dataSnapshot.docs[index]['title'];
        final infoTempo = dataSnapshot.docs[index]['tempo'];
        //final infoTopics = dataSnapshot.docs[index]['topics'];
        //final infoExtra = dataSnapshot.docs[index]['infoExtra'];
        //final infoSubject = dataSnapshot.docs[index]['subject'];
        //final updateDados = dataSnapshot.docs[index];

        return Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(64, 64, 64, 0.4),
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey)),
          ),
          child: ListTile(
            leading: Icon(Icons.assignment_rounded, color: Theme.of(context).colorScheme.primary),
            textColor: Colors.white,
            title: Text(infoTitle),
            subtitle: Text(infoTempo, style: const TextStyle(color: Colors.grey)),
            onTap: () {
              //Navega para a tela de edição
            },
          ),
        );
      },
    );
  }

}

