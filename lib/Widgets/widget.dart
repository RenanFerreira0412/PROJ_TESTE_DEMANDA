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


class Divisor extends StatelessWidget {
  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          _buildDivisor(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Ou",
              style: GoogleFonts.cabin(textStyle: styleText, color: Colors.white),
            ),
          ),
          _buildDivisor(),
        ],
      ),
    );
  }

  Expanded _buildDivisor() {
    return const Expanded(
        child: Divider(
          color: Colors.grey,
          height: 1.5,
        )
    );
  }
}




class IconesMedia extends StatelessWidget {
  final String imgMedia;
  final Function press;
  final String text;
  final double paddingRight;
  final double paddingLight;

  const IconesMedia(this.imgMedia, this.press, this.text, this.paddingRight, this.paddingLight);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(2),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Colors.grey
          ),
          borderRadius: BorderRadius.circular(30),
          shape: BoxShape.rectangle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgMedia,
              width: 30,
              height: 30,
            ),

            Padding(
              padding: EdgeInsets.only(right: paddingRight, left: paddingLight),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }

}


