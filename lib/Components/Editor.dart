import 'package:dotted_border/dotted_border.dart';
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
        padding: const EdgeInsets.only(top: 15, bottom: 15),
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
            fillColor: const Color.fromRGBO(64, 64, 64, 0.4)
          ),
        )
    );
  }
}

class EditorAuth extends StatelessWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final Icon icon;
  final bool valida;
  final int qtdCaracteres;
  final bool verdadeOuFalso;

  EditorAuth(this.controlador, this.rotulo, this.dica, this.icon, this.valida, this.qtdCaracteres, this.verdadeOuFalso);

  @override
  Widget build(BuildContext context) {
    return TextField(
          obscureText: verdadeOuFalso,
          controller: controlador,
          style: const TextStyle(
            fontSize: 18.0,
          ),
          decoration: InputDecoration(
              labelText: rotulo,
              hintText: dica,
              prefixIcon: icon,
              errorText: valida ? 'Campo obrigatório!' : null,
              border: const OutlineInputBorder(),
              fillColor: const Color.fromRGBO(64, 64, 64, 0.4)
          ),
        );
  }
}


class CampoSelecaoArquivos extends StatelessWidget{

  final IconData uploadIcone;
  final String subText;
  final String mainText;
  final Function setUploadAction;
  final TextStyle styleText;
  final TextStyle styleTextFile;
  final String fileName;

  const CampoSelecaoArquivos(this.uploadIcone, this.subText, this.mainText, this.setUploadAction, this.styleText, this.fileName, this.styleTextFile);

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
          color: const Color.fromRGBO(64, 64, 64, 0.4),
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
                        style: GoogleFonts.cabin(textStyle: styleText, color: Theme.of(context).colorScheme.primary)),
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8),
                  child: Text(fileName, style: GoogleFonts.cabin(textStyle: styleTextFile))
              )
            ],
          ),
        ),
      ),

    );
  }
  
}
