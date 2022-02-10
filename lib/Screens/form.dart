import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class FormDemandaState extends State<FormDemanda>{

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();
  final TextEditingController _controladorContrapartida = TextEditingController();
  final TextEditingController _controladorResutadosEsperados = TextEditingController();

  PlatformFile name;
  File file;

  final List<String> buttonOptions = [
    'Comunicação',
    'Cultura',
    'Direitos Humanos e Justiça',
    'Educação',
    'Meio Ambiente',
    'Saúde',
    'Tecnologia e Produção',
    ' Trabalho'
  ];

  String optionSelected;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  final styleTextFile = const TextStyle(fontSize: 12, fontWeight: FontWeight.w200);

  final styleText = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  String hintText = 'Selecione a área temática';

  bool _valida = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Formulário de Cadastro'),
        centerTitle: true,
        backgroundColor: Colors.green[900],
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 4.0,
            ),
            preferredSize: const Size.fromHeight(4.0)),
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

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
              alignment: Alignment.centerLeft,
                    child: Text('Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
                        style: GoogleFonts.cabin(textStyle: style),
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      helperText: 'Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
                      hintText: hintText,
                    ),
                    items: buttonOptions.map((options) {
                      return DropdownMenuItem(
                        value: options,
                        child: Text(options),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => optionSelected = value),
                  ),

                  const SizedBox(height: 30),

                  CampoSelecaoArquivos(
                      Icons.cloud_upload_rounded,
                      'Faça o upload de arquivos ',
                      'AQUI',
                          () {
                        selectedFile(name, file);
                          },
                      styleText,
                      FILE(),
                      styleTextFile
                  )


                ],
              ),
            ),

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
                      //optionSelected.isEmpty ? _valida = true : _valida = false;
                    });
                    if(!_valida){
                      _criarDemanda(context);
                    }

                  },
                  child: const Text("CONFIRMAR")
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _criarDemanda(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    CollectionReference propostasFeitas = FirebaseFirestore.instance.collection('Demandas');

    //Adicionando um novo documento a nossa coleção -> Demandas
    propostasFeitas.add({
      'Titulo_proposta': _controladorTitulo.text,
      'Tempo_Necessario': _controladorTempoNecessario.text,
      'Resumo': _controladorResumo.text,
      'Objetivo': _controladorObjetivo.text,
      'Contrapartida': _controladorContrapartida.text,
      'Resutados_Esperados': _controladorResutadosEsperados.text,
      'Area_Tematica': optionSelected,
      'userID': userDao.userId(),
    })
        .then((value) => debugPrint("Sua proposta foi registrada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    //Limpando os campos após a criação da proposta
      _controladorTitulo.text = '';
      _controladorTempoNecessario.text = '';
      _controladorResumo.text = '';
      _controladorObjetivo.text = '';
      _controladorContrapartida.text = '';
      _controladorResutadosEsperados.text = '';

    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("Sua demanda foi criada com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future selectedFile(PlatformFile fileNameWeb, File fileNameNotWeb) async {
    debugPrint('selecionei um arquivo');

    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: false);

    //Caso o usuário tenha selecionado um arquivo
    if (result != null) {
      if(kIsWeb) { // Caso o usuário esteja acessando pela web
        PlatformFile file = result.files.first;

        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);

        //Pegando o nome do arquivo
        final fileName = file.name;

        setState(() => name = PlatformFile(name: fileName, size: file.size));
      } else {
        final path = result.files.single.path;

        setState(() => file = File(path));
        debugPrint('O arquivo selecionado é : $path');
      }

    } else { //Caso o usuário tenha cancelado a seleção de um arquivo
      Fluttertoast.showToast(msg: 'Nenhum arquivo foi selecionado, tente novamente!', gravity: ToastGravity.SNACKBAR);
    }


  }

  FILE()  {
    if(kIsWeb){
      //Pega o nome do arquivo selecionado
      return name != null ? basename(name.name) : 'Sem arquivos selecionados ...';
    } else {
      //Pega o nome do arquivo selecionado
      return file != null  ? basename(file.path)  : 'Sem arquivos selecionados ...';
    }
  }

}

