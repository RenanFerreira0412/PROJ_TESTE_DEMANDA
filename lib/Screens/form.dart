import 'dart:io';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FormDemanda extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FormDemandaState();
  }
}

class FormDemandaState extends State<FormDemanda> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tempoController = TextEditingController();
  final TextEditingController _topicsController = TextEditingController();
  final TextEditingController _infoExtraController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FilePickerResult result;
  PlatformFile name;

  String optionSelected;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  final styleTextFile = const TextStyle(fontSize: 12, fontWeight: FontWeight.w200);

  final styleText = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  String hintText = 'Selecionar disciplina';

  String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    final fileName = name != null ? basename(name.name) : 'Sem arquivos selecionados ...';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Atividades'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 4.0,
            ),
            preferredSize: const Size.fromHeight(4.0)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Form(
              key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EditorTextFormField(
                      controller: _titleController,
                      maxLength: 150,
                      lines: 1,
                      labelText: "Título da atividade",
                      dica: "Título da Proposta/Trabalho",
                      validaField: true,
                    ),

                    Row(
                      children: [
                        Expanded(
                            child: EditorTextFormField(
                              controller: _tempoController,
                              maxLength: 150,
                              lines: 1,
                              labelText: "Informe o tempo necessário",
                              dica: "Número de meses/dias para ser realizada",
                              validaField: true,
                            )),

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

                    EditorTextFormField(
                      controller: _topicsController,
                      maxLength: 500,
                      lines: 5,
                      labelText: "Tópicos sobre a atividade",
                      dica: "Explique melhor sobre a realização dessa atividade",
                      validaField: true,
                    ),

                    EditorTextFormField(
                      controller: _infoExtraController,
                      maxLength: 500,
                      lines: 5,
                      labelText: "Informações extras",
                      dica: "Coloque informações extras sobre a sua atividade",
                      validaField: false,
                    ),

                    const SizedBox(height: 10),

                    CampoSelecaoArquivos(
                        Icons.cloud_upload_rounded,
                        'Faça o upload de arquivos ',
                        'AQUI',
                            () async {
                          result = await FilePicker.platform.pickFiles(allowMultiple: false);

                          if (result != null) {
                            final file = result.files.first;

                            //Pega o nome do arquivo selecionado
                            setState(() => name = PlatformFile(name: file.name, size: file.size));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                'Arquivo não selecionado e/ou Falha ao selecionar arquivo',
                              ),
                            ));
                          }
                        },
                        styleText,
                        fileName,
                        styleTextFile),
                  ],
                )
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _criarAtividade(context);

            //SnackBar
            const SnackBar snackBar = SnackBar(content: Text("Sua demanda foi criada com sucesso! "));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
    );
  }

  void _criarAtividade(BuildContext context) async {
    final userDao = Provider.of<AuthService>(context, listen: false);

    //Chama o método da class ActivityRef() que realizará a adição de atividades no Firebase
    ActivityRef().addActivity(
        _titleController.text,
        _tempoController.text,
        _topicsController.text,
        _infoExtraController.text,
        selectedCurrency,
        userDao.userId());

    //Limpa os campos após a criação da atividade
    _titleController.text = '';
    _tempoController.text = '';
    _topicsController.text = '';
    _infoExtraController.text = '';

    //Mostra o nome o arquivo selecionado pelo usuário
    debugPrint(result.files.first.name);

    //Faz o upload do arquivo selecionado para o Firebase storage
    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        ActivityRef().uploadFile(null, result.files.first.bytes, result.files.first.name);
      } else {
        ActivityRef().uploadFile(null, await File(result.files.first.path).readAsBytes(), result.files.first.name);
      }
    } else {
      return;
    }
  }
}
