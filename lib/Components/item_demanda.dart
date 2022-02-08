import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/EditarInfo.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ItemDemanda extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    final Stream<QuerySnapshot> propostasFeitas =
    FirebaseFirestore.instance.collection('Demandas').where('userID', isEqualTo: userDao.userId()).snapshots();

    return StreamBuilder<QuerySnapshot> (
      stream: propostasFeitas,
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
          )
    {
      if (snapshot.hasError) {
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

      if (data.size == 0) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('SEM DEMANDAS CADASTRADAS'),

                      const SizedBox(height: 10),

                      const Text('Toque para poder cadastrar sua primeira propostas'),

                      const SizedBox(height: 10),

                      ElevatedButton(
                          onPressed: () {
                            debugPrint('Navegou para o formulário');
                          },
                          child: const Text('Cadastrar proposta')
                      )


                    ],
                  ),
                )
              ),
            ),
          ),
        );
      } else {

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
              final infoResutadosEsperados = data
                  .docs[index]['Resutados_Esperados'];
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
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ListTile(
                              leading: Icon(
                                  Icons.assignment_rounded, color: Colors.green[900]),
                              textColor: Colors.black,
                              title: Text(infoTitulo),
                              subtitle: Text(infoTempo,
                                  style: const TextStyle(color: Colors
                                      .black45)),
                              trailing: SizedBox(
                                width: 50,
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.green[900], size: 32),
                                      tooltip: 'Editar proposta',
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return EditarFormInfo(
                                                      infoTitulo,
                                                      infoTempo,
                                                      infoResumo,
                                                      infoObjetivo,
                                                      infoContrapartida,
                                                      infoResutadosEsperados,
                                                      updateDados);
                                                }));
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
    }
      },
    );
  }
}