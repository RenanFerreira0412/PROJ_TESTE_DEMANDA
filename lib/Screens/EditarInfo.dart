import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_questions/conditional_questions.dart';

class EditarFormulario extends StatefulWidget {

  final String title;
  final String tempo;
  final String topics;
  final String infoExtra;
  final String subject;
  final QueryDocumentSnapshot updateDados;

  const EditarFormulario(this.title, this.tempo, this.topics, this.infoExtra, this.subject, this.updateDados);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditarFormularioState();
  }

}

class EditarFormularioState extends State<EditarFormulario> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tempoController = TextEditingController();
  final TextEditingController _topicsController = TextEditingController();
  final TextEditingController _infoExtraController = TextEditingController();
  String selectedCurrency;


  String hintText = 'Selecionar disciplina';

  bool _valida = false;

  @override
  Widget build(BuildContext context) {

    //Retornando os valores para os campos de texto
    _titleController.text = widget.title;
    _tempoController.text = widget.tempo;
    _topicsController.text = widget.topics;
    _infoExtraController.text = widget.infoExtra;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Atualizar Atividade"),
        elevation: 0,
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 2.0,
            ),
            preferredSize: const Size.fromHeight(4.0)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Editor(_titleController, "Título da atividade", "Título da Proposta/Trabalho", 1, _valida, 150),

            Row(
              children: [
                Expanded(
                    child: Editor(_tempoController, "Informe o tempo necessário", "Número de meses/dias para ser realizada", 1, _valida, 150)),

                const SizedBox(width: 5),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('AREA_TEMATICA').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Carregando ...');
                    } else {

                      return Expanded(
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            helperText:
                            'Selecione a disciplina desse trabalho',
                            hintText: hintText,
                          ),
                          items: snapshot.data.docs.map((DocumentSnapshot document) {
                            return DropdownMenuItem<String>(
                              child: Text(document['nome']),
                              value: document['nome'],
                            );
                          }).toList(),
                          onChanged: (currencyValue) {
                            setState(() {
                              selectedCurrency = currencyValue;
                            });

                            debugPrint(currencyValue);
                          },
                          value: selectedCurrency,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            Editor(_topicsController, "Tópicos sobre a atividade", "Explique melhor sobre a realização dessa atividade", 5, _valida, 500),

            Editor(_infoExtraController, "Informações extras", "Coloque informações extras sobre a sua atividade", 5, false, 500),

            const SizedBox(height: 10),


            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    setState((){
                      _titleController.text.isEmpty ? _valida = true : _valida = false;
                      _tempoController.text.isEmpty ? _valida = true : _valida = false;
                      _topicsController.text.isEmpty ? _valida = true : _valida = false;
                      _infoExtraController.text.isEmpty ? _valida = true : _valida = false;
                    });
                    if(!_valida){
                      _updateActivity(context);
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

  void _updateActivity(BuildContext context) {
    //Atualiza as atividade já cadastradas pelo usuário
    widget.updateDados
        .reference
        .update({
      'title': _titleController.text,
      'tempo': _tempoController.text,
      'topics': _topicsController.text,
      'infoExtra': _infoExtraController.text,
      'subject': selectedCurrency,
    }).then((value) => debugPrint("Sua atividade foi atualizada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua atividade: $error"));

    //Retorna para a página com as atividade listadas
    Navigator.pop(context);

    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("Atividade editada com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}



