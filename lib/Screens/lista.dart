import 'package:flutter/material.dart';
import 'package:projflutterfirebase/Components/item_demanda.dart';

class ListaDemanda extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Propostas criadas"),
        centerTitle: true,

      ),

      body: ItemDemanda(),
    );
    throw UnimplementedError();
  }
}

