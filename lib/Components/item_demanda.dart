import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projflutterfirebase/Screens/EditarInfo.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';



class ItemDemanda extends StatelessWidget {
  final Stream<QuerySnapshot> propostasFeitas =
  FirebaseFirestore.instance.collection('Demandas').snapshots();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return StreamBuilder<QuerySnapshot> (
      stream: propostasFeitas,
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Algo não deu certo !'),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center (
            child: SpinKitFadingCircle(color: Colors.green, size: 120),
          );
        }

        final data = snapshot.requireData;


        return AnimationLimiter(
          child: ListView.builder(
              itemCount: data.size,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {

                //Pegando as informações dos documentos do firebase da coleção Demandas
                final infoTitulo = data.docs[index]['Titulo_proposta'];
                final infoTempo = data.docs[index]['Tempo_Necessario'];
                final infoResumo = data.docs[index]['Resumo'];
                final infoObjetivo = data.docs[index]['Objetivo'];
                final infoContrapartida = data.docs[index]['Contrapartida'];
                final infoResutadosEsperados = data.docs[index]['Resutados_Esperados'];
                final updateDados = snapshot.data.docs[index];

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
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                    leading: const Icon(Icons.add_circle_outline),
                                    title: Text(data.docs[index]['Titulo_proposta']),
                                    subtitle: Text(data.docs[index]['Tempo_Necessario']),
                                    trailing: SizedBox(
                                      width: 50,
                                      child: Row(
                                        children: <Widget>[
                                          IconButton (
                                            icon: const Icon(Icons.edit, color: Colors.green, size: 32),
                                            tooltip: 'Editar proposta',
                                            onPressed: () {

                                              final Future future =
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return EditarFormInfo(infoTitulo, infoTempo, infoResumo, infoObjetivo, infoContrapartida, infoResutadosEsperados, updateDados);
                                              }));

                                              future.then((demandaAtualizada) {
                                                debugPrint("$demandaAtualizada");
                                                debugPrint('A proposta foi alterada');
                                              });

                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                )),
                      ),
                    )
                );
              }),
        );
      },
    );
  }
}