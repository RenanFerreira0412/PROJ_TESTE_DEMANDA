import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class AppBarLogo extends StatelessWidget {
  final TextStyle styleTextTitle;

  const AppBarLogo(this.styleTextTitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Column(
      children: [
        Image.asset(
          'assets/image/logo.png',
          width: 240,
        ),
        const SizedBox(height: 20),
        Text(
          'Escola de Extensão do IFSul',
          style: GoogleFonts.cabin(textStyle: styleTextTitle),
        ),
      ],
    );
  }

}

class AppBarLogoUser extends StatelessWidget {
  final TextStyle styleTextTitle;
  final String userPhoto;
  final String emailUser;

  const AppBarLogoUser(this.styleTextTitle, this.userPhoto, this.emailUser);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Row(
      children: [

        DottedBorder(
          color: Colors.white,
        borderType: BorderType.Rect,
        strokeWidth: 1,
        dashPattern: const [5, 4],
        strokeCap: StrokeCap.round,
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(2),
          child: Image.asset(
            userPhoto,
            width: 70,
          ),
        ),
        ),


        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            emailUser,
            style: GoogleFonts.cabin(textStyle: styleTextTitle),
          ),
        ),
      ],
    );
  }

}



class Buttons extends StatelessWidget {

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  final Function press;
  final String text;
  final Color color;
  final Color letterColor;
  final Color colorIcon;
  final Color borderColor;
  final double width;
  final IconData icon;

  Buttons(this.press, this.text, this.color, this.letterColor, this.borderColor, this.width, this.icon, this.colorIcon);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: ElevatedButton.icon(
        onPressed: press,
        icon: Icon(
          icon,
          color: colorIcon,
        ),
        label: Text(text, style: GoogleFonts.roboto(textStyle: styleText, color: letterColor)),
        style: ElevatedButton.styleFrom(
          primary: color,
            side: BorderSide(
            color: borderColor,
              width: width,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
            )
        ),
      ),
    );
  }

}

class ButtonsMedia extends StatelessWidget {

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  final Function press;
  final String text;
  final Color color;
  final Color letterColor;
  final String imgMedia;


  const ButtonsMedia(this.press, this.text, this.color, this.letterColor, this.imgMedia);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: ElevatedButton(
        onPressed: press,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgMedia,
              width: 30,
              height: 30,
            ),

            Text(text, style: GoogleFonts.roboto(textStyle: styleText, color: letterColor)),
          ],
        ),
        style: ElevatedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
            )
        ),
      ),
    );
  }

}


