import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final int lines;
  final bool valida;
  final int qtdCaracteres;

  Editor(this.controlador, this.rotulo, this.dica, this.lines, this.valida, this.qtdCaracteres);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          maxLength: qtdCaracteres,
          controller: controlador,
          style: const TextStyle(
            fontSize: 18.0,
          ),
          maxLines: lines,
          decoration: InputDecoration(
            labelText: rotulo,
            hintText: dica,
            helperText: dica,
            errorText: valida ? 'Campo obrigatório!' : null,
            border: const OutlineInputBorder(),
          ),
        )
    );
  }
}

class EditorDropdownButton extends StatefulWidget{
  final TextStyle style;
  String optionSelected;

  EditorDropdownButton(this.style, this.optionSelected);

  @override
  State<EditorDropdownButton> createState() => _EditorDropdownButtonState();
}

class _EditorDropdownButtonState extends State<EditorDropdownButton> {

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
              style: GoogleFonts.cabin(textStyle: widget.style),
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField(

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              helperText: 'Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
              hintText: 'Selecione a área temática',
              //errorText: widget.valida ? 'Campo obrigatório!' : null,
            ),
            items: buttonOptions.map((options) {
              return DropdownMenuItem(
                value: options,
                child: Text(options),
              );
            }).toList(),
            onChanged: (value) => setState(() => widget.optionSelected = value),
          ),
        ],
      ),
    );
  }
}

class EditorLogin extends StatelessWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final Icon icon;
  final bool valida;
  final int qtdCaracteres;
  final bool verdadeOuFalso;

  EditorLogin(this.controlador, this.rotulo, this.dica, this.icon, this.valida, this.qtdCaracteres, this.verdadeOuFalso);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // Size size = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(29),
        ),
        child: TextField(
          obscureText: verdadeOuFalso,
          //maxLength: qtdCaracteres,
          controller: controlador,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black
          ),
          decoration: InputDecoration(
            //labelText: rotulo,
            hintText: dica,
            prefixIcon: icon,
            fillColor: Colors.grey[200],
            //helperText: dica,
            errorText: valida ? 'Campo obrigatório!' : null,
            border: InputBorder.none,
          ),
        )
    );
  }
}

class CampoSelecaoArquivos extends StatelessWidget{

  final IconData uploadIcone;
  final String subText;
  final String mainText;
  final Function setUploadAction;
  final TextStyle styleText;

  const CampoSelecaoArquivos(this.uploadIcone, this.subText, this.mainText, this.setUploadAction, this.styleText);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      color: const Color.fromRGBO(125, 155, 118, 0.6),
      dashPattern: const [10, 5],
      child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          height: 150,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(uploadIcone, size: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      subText,
                      style: GoogleFonts.cabin(textStyle: styleText)),

                  GestureDetector(
                    onTap: setUploadAction,
                    child: Text(
                        mainText,
                        style: GoogleFonts.cabin(textStyle: styleText, color: Colors.green[900])),
                  )
                ],
              )
            ],
          ),
        ),
      ),

    );
  }
  
}
