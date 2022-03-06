import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Components/item_demanda.dart';

class ListaDemanda extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Propostas criadas"),
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 2,
            ),
            preferredSize: const Size.fromHeight(4.0)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: ItemDemanda(),
    );
  }
}

