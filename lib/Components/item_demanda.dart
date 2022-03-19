import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projflutterfirebase/Models/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/EditarInfo.dart';
import 'package:projflutterfirebase/Screens/Homepage.dart';
import 'package:provider/provider.dart';

class ItemDemanda extends StatefulWidget {
  @override
  State<ItemDemanda> createState() => _ItemDemandaState();
}

class _ItemDemandaState extends State<ItemDemanda> {
  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    final Stream<QuerySnapshot> propostasFeitas = FirebaseFirestore.instance
        .collection('Demandas')
        .where('userID', isEqualTo: userDao.userId())
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.primary, size: 120),
          );
        }

        final data = snapshot.requireData;

        if (data.size == 0) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  color: const Color.fromRGBO(125, 155, 118, 0.6),
                  dashPattern: const [10, 5],
                  child: ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('SEM DEMANDAS CADASTRADAS',
                                style: GoogleFonts.cabin(textStyle: style)),
                            const SizedBox(height: 10),
                            const Text(
                                'Toque para poder cadastrar sua primeira propostas'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('Navegou para o formulário');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AllUsersHomePage(),
                                      ));
                                },
                                child: const Text('Cadastrar proposta'))
                          ],
                        ),
                      )

                  ),
                ),
              ],

              ),
          );
        } else {
          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                //Pegando as informações dos documentos do firebase da coleção Demandas
                final infoTitulo = data.docs[index]['Titulo_proposta'];
                final infoTempo = data.docs[index]['Tempo_Necessario'];
                final infoResumo = data.docs[index]['Resumo'];
                final infoObjetivo = data.docs[index]['Objetivo'];
                final infoContrapartida = data.docs[index]['Contrapartida'];
                final infoResutadosEsperados =
                    data.docs[index]['Resutados_Esperados'];
                final updateDados = snapshot.data.docs[index];

                return Dismissible(
                    key: ValueKey(data),
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerStart,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 64, 64, 0.4),
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey)),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.assignment_rounded,
                            color: Theme.of(context).colorScheme.primary),
                        textColor: Colors.white,
                        title: Text(infoTitulo),
                        subtitle: Text(infoTempo,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                    confirmDismiss: (direction) => alertDialog(
                        direction,
                        infoTitulo,
                        infoTempo,
                        infoResumo,
                        infoObjetivo,
                        infoContrapartida,
                        infoResutadosEsperados,
                        updateDados));
              });
        }
      },
    );
  }

  ///Método que será chamado quando o usuário deslizar para um dos lados do card
  Future<bool> alertDialog(DismissDirection direction, String titulo, tempo,
      resumo, objetivo, contrapartida, resutadosEsperados, updateDados) async {
    String action;

    if (direction == DismissDirection.startToEnd) {
      // Ação para deletar uma proposta
      action = "Deletar proposta";
      debugPrint(action);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(action),
              content: const Text('Você deseja deletar esta proposta?'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              actions: <Widget> [
                TextButton(
                  onPressed: (){
                    //Deletando o documento do banco de dados
                    debugPrint('Foi deletado a proposta');
                    updateDados.reference.delete();

                    //Navegando de volta para a página da lista de propostas
                    Navigator.of(context).pop(true);

                    //SnackBar
                    const SnackBar snackBar = SnackBar(content: Text("A proposta foi deletada com sucesso! "));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Sim'),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    debugPrint('Não foi deletado a proposta');
                  },
                  child: const Text('Não'),
                ),
              ],
            );
          }
      );

    } else {
      // Ação para editar uma proposta
      action = "editar proposta";
      debugPrint(action);

      //Navegar para a tela de edição de demandas
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EditarFormInfo(titulo, tempo, resumo, objetivo, contrapartida,
            resutadosEsperados, updateDados);
      }));
    }
  }
}
