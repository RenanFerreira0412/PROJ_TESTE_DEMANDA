import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Models/Data/User_dao.dart';
import 'package:projflutterfirebase/Screens/userOptions.dart';
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
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[700],
                    child: Image.asset(
                      userDao.photoURL(),
                    ),
                  )
              ),
            ],
          ),

          Options(Icons.email, 'Email', userDao.userEmail(), () {debugPrint('user email');}, Theme.of(context).colorScheme.primary)

        ]
      ),
    );
  }

}