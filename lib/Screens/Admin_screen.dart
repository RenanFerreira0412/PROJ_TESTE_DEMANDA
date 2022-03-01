import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _filterController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  String nomeAreaTematica;

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
    resultsLoaded = getDemandasDataStreamSnapshots();
  }

  ///Mostra no console o que foi digitado pelo usuário
  _onSearchChanged() {
    searchResultsList();
  }


  searchResultsList() {
    var mostrarResultados = [];

    if(_filterController.text != "") {
      for(var dataSnapshot in _allResults){
        dataSnapshot = nomeAreaTematica.toLowerCase();
        debugPrint(dataSnapshot);

       // if(dataSnapshot.contains(_filterController.text.toLowerCase())) {
         // mostrarResultados.add(dataSnapshot);
        // debugPrint('Achou a demanda');
       // }
      }

    } else {
      mostrarResultados = List.from(_allResults);
    }

    setState(() {
      _resultsList = mostrarResultados;
    });
  }

  ///Lista que faz referência a coleção e seus documentos
  getDemandasDataStreamSnapshots() async {
    List<QueryDocumentSnapshot> documentList = (await FirebaseFirestore.instance
            .collection("Demandas")
            .get())
        .docs;

    setState(() {
      _allResults = documentList;
    });

    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Propostas registradas pelos usuários"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _filterController,
              decoration: const InputDecoration(
                hintText: 'Pesquisar pela área temática',
                helperText:
                    'Procure por demandas cadastradas através de sua área temática',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                fillColor: Color.fromRGBO(64, 64, 64, 0.4),
              ),
            ),
          ),

          ListView.builder(
                itemCount: _resultsList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (BuildContext context, int index) {

                  nomeAreaTematica = _resultsList[index]['Area_Tematica'];

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
                          title: Text(_resultsList[index]['Titulo_proposta']),
                          subtitle: Text(_resultsList[index]['Tempo_Necessario'],
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


          //AdminScreenItens(_filterController)
        ],
      ),
    );
  }
}

class AdminScreenItens extends StatefulWidget {
  final TextEditingController _filterController;

  const AdminScreenItens(this._filterController);

  @override
  State<AdminScreenItens> createState() => _AdminScreenItensState();
}

class _AdminScreenItensState extends State<AdminScreenItens> {
  @override
  Widget build(BuildContext context) {
    //Referência a coleção Demandas

    final Stream<QuerySnapshot> propostasCadastradas = FirebaseFirestore
        .instance
        .collection('Demandas')
        .where('Area_Tematica', isEqualTo: widget._filterController.text)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: propostasCadastradas,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Algo não deu certo !'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(color: Colors.green[900], size: 120),
            );
          }

          final data = snapshot.requireData;

          return AnimationLimiter(
            child: ListView.builder(
                itemCount: data.size,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  //Pegando as informações dos documentos do firebase da coleção Demandas
                  final infoTitulo = data.docs[index]['Titulo_proposta'];
                  final infoTempo = data.docs[index]['Tempo_Necessario'];
                  //final infoResumo = data.docs[index]['Resumo'];
                  //final infoObjetivo = data.docs[index]['Objetivo'];
                  //final infoContrapartida = data.docs[index]['Contrapartida'];
                  // final infoResutadosEsperados = data
                  //.docs[index]['Resutados_Esperados'];
                  // final updateDados = snapshot.data.docs[index];

                  return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 2500),
                          child: Container(
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
                                  title: Text(infoTitulo),
                                  subtitle: Text(infoTempo,
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
                                  ))),
                        ),
                      ));
                }),
          );
        });
  }
}
