import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Data/User_dao.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {

  UserDao userDao;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    userDao = Provider.of<UserDao>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Meu Perfil'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              child: CircleAvatar(
                backgroundColor: Colors.grey[700],
                child: Image.asset(
                  userDao.photoURL(),
                  width: 300,
                ),
              )
          ),

          Text(userDao.email())
        ],
      ),
    );
  }

}