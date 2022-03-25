import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:projflutterfirebase/Components/Editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:open_file/open_file.dart';

class FormDemanda extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FormDemandaState();
  }
}

class FormDemandaState extends State<FormDemanda> {
  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();

  FilePickerResult result;
  PlatformFile name;

  String optionSelected;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  final styleTextFile = const TextStyle(fontSize: 12, fontWeight: FontWeight.w200);

  final styleText = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  String hintText = 'Selecionar disciplina';

  bool _valida = false;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Editor(_controladorTitulo, "Título da atividade", "Título da Proposta/Trabalho", 1, _valida, 150),

            Row(
              children: [
                Expanded(
                    child: Editor(_controladorTempoNecessario, "Informe o tempo necessário", "Número de meses/dias para ser realizada", 1, _valida, 150)),

                const SizedBox(width: 5),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('AREA_TEMATICA')
                      .snapshots(),
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

            Editor(_controladorResumo, "Tópicos sobre a atividade", "Explique melhor sobre a realização dessa atividade", 5, _valida, 500),

            Editor(_controladorObjetivo, "Informações extras", "Coloque informações extras sobre a sua atividade", 5, false, 500),

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

            const SizedBox(height: 10),

            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorTempoNecessario.text.isEmpty ? _valida = true : _valida = false;
                      _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorObjetivo.text.isEmpty ? _valida = true : _valida = false;
                      //optionSelected.isEmpty ? _valida = true : _valida = false;
                    });
                    if (!_valida) {
                      _criarDemanda(context);
                    }
                  },
                  child: const Text("CONFIRMAR")),
            ),
          ],
        ),
      ),
    );
  }

  void _criarDemanda(BuildContext context) async {
    final userDao = Provider.of<UserDao>(context, listen: false);

    //Adicionando um novo documento a nossa coleção -> Demandas
    DocumentReference propostasFeitas = await FirebaseFirestore.instance.collection('Demandas').add({
          'Titulo_proposta': _controladorTitulo.text,
          'Tempo_Necessario': _controladorTempoNecessario.text,
          'Resumo': _controladorResumo.text,
          'Objetivo': _controladorObjetivo.text,
          'Area_Tematica': selectedCurrency,
          'userID': userDao.userId(),
        })
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    debugPrint("ID da demanda: " + propostasFeitas.id);


    //Limpando os campos após a criação da proposta
    _controladorTitulo.text = '';
    _controladorTempoNecessario.text = '';
    _controladorResumo.text = '';
    _controladorObjetivo.text = '';

    debugPrint(result.files.first.name);

    //Faz o upload do arquivo selecionado para o Firebase storage
    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        _uploadFile(result.files.first.bytes, result.files.first.name,
            propostasFeitas.id);
      } else {
        _uploadFile(await File(result.files.first.path).readAsBytes(),
            result.files.first.name, propostasFeitas.id);
      }
    }

    //SnackBar
    const SnackBar snackBar =
        SnackBar(content: Text("Sua demanda foi criada com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///Função responsável por fazer o upload do arquivo para o storage
  Future<void> _uploadFile(
      Uint8List _data, String nameFile, String userId) async {
    CollectionReference _demandas = FirebaseFirestore.instance
        .collection('Demandas')
        .doc(userId)
        .collection('arquivos');

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref('arquivos/$nameFile');

    ///Mostrar a progressão do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

    ///Pega o download url do arquivo
    String url = await uploadTask.ref.getDownloadURL();

    OpenFile.open(url);

    if (uploadTask.state == firebase_storage.TaskState.success) {
      print('Arquivo enviado com sucesso!');
      print('URL do arquivo: $url');
      print(userId);
      _demandas.add({'file_url': url});
    } else {
      print(uploadTask.state);
    }
  }
}
