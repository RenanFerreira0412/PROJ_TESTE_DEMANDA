import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projflutterfirebase/Screens/lista.dart';
import 'package:conditional_questions/conditional_questions.dart';

class EditarFormInfo extends StatefulWidget {

  final String titulo;
  final String tempo;
  final String resumo;
  final String objetivo;
  final String contrapartida;
  final String resutadosEsperados;
  final QueryDocumentSnapshot updateDados;

  const EditarFormInfo(this.titulo, this.tempo, this.resumo, this.objetivo, this.contrapartida, this.resutadosEsperados, this.updateDados);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditarFormInfoState();
  }

}

class EditarFormInfoState extends State<EditarFormInfo> {

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();
  final TextEditingController _controladorContrapartida = TextEditingController();
  final TextEditingController _controladorResutadosEsperados = TextEditingController();

  bool _valida = false;

  @override
  Widget build(BuildContext context) {

    //Retornando os valores para os campos de texto
    _controladorTitulo.text = widget.titulo;
    _controladorTempoNecessario.text = widget.tempo;
    _controladorResumo.text = widget.resumo;
    _controladorObjetivo.text = widget.objetivo;
    _controladorContrapartida.text = widget.contrapartida;
    _controladorResutadosEsperados.text = widget.resutadosEsperados;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Atualizar propostas"),
        elevation: 0,
        actions: [
          SizedBox(
            width: 80,
            child: IconButton (
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 32),
              tooltip: 'Remover proposta',
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Deletar proposta'),
                      content: const Text('Você deseja deletar esta proposta?'),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      actions: <Widget> [
                        TextButton(
                          onPressed: (){
                            //Deleting the data from the firebase
                            debugPrint('Foi deletado a proposta');
                            widget.updateDados.reference.delete();

                            //Going back to the main page
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ListaDemanda();
                            }));

                            //SnackBar
                            const SnackBar snackBar = SnackBar(content: Text("A proposta foi deletada com sucesso! "));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: const Text('Sim'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            debugPrint('Não foi deletado a proposta');
                          },
                          child: const Text('Não'),
                        ),
                      ],
                    );
                  }
                );
              },
            ),
          )
        ],
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 4.0,
            ),
            preferredSize: const Size.fromHeight(4.0)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Editor(_controladorTitulo, "Título da proposta", "Título da Proposta", 1, _valida, 150),

            Editor(_controladorTempoNecessario, "Informe o tempo necessário", "Número de meses para ser realizada", 1, _valida, 150),

            Editor(_controladorResumo, "Faça uma breve descrição da sua proposta",
                "Explique da melhor forma que conseguir sobre o que se trata a proposta", 5, _valida, 600),

            Editor(_controladorObjetivo, "Descreva os objetivos que você espera serem atendidos",
                "Coloque em forma de tópicos os objetivos da proposta", 5, _valida, 600),

            Editor(_controladorContrapartida, "Quais recursos a equipe dispõe para a execução da proposta?",
                "Descreva quais recursos estão disponíveis para a execução da proposta, financeiros, humanos, estrutura, etc", 5, _valida, 600),

            Editor(_controladorResutadosEsperados, "Quais os resultados esperados?  ",
                "Descreva os resultados esperados", 5, false, 600),




            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    setState((){
                      _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorTempoNecessario.text.isEmpty ? _valida = true : _valida = false;
                      _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorObjetivo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorContrapartida.text.isEmpty ? _valida = true : _valida = false;
                    });
                    if(!_valida){
                      _criarDemanda(context);
                    }
                  },
                  child: const Text("SALVAR MUDANÇAS")
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _criarDemanda(BuildContext context) {

    //Atualiza as propostas já cadastradas pelo usuário
    widget.updateDados
        .reference
        .update({
      'Titulo_proposta': _controladorTitulo.text,
      'Tempo_Necessario': _controladorTempoNecessario.text,
      'Resumo': _controladorResumo.text,
      'Objetivo': _controladorObjetivo.text,
      'Contrapartida': _controladorContrapartida.text,
      'Resutados_Esperados': _controladorResutadosEsperados.text
    }).then((value) => debugPrint("Sua proposta foi atualizada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    //Retorna para a página com as demandas listadas
    Navigator.pop(context);

    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("A demanda foi editada com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}



