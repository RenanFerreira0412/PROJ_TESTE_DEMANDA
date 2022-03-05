import 'package:cloud_firestore/cloud_firestore.dart';

class Demandas {
  String TituloProposta;
  String TempoNecessario;
  String Resumo;
  String Objetivo;
  String Contrapartida;
  String ResutadosEsperados;
  String AreaTematica;
  String userID;
  String docId;

  Demandas(
      this.TituloProposta,
      this.TempoNecessario,
      this.Resumo,
      this.Objetivo,
      this.Contrapartida,
      this.ResutadosEsperados,
      this.AreaTematica,
      this.userID,
      this.docId);

  @override
  String toString() {
    return "Demanda($TituloProposta, $TituloProposta, $Resumo, $Objetivo, $Contrapartida, $ResutadosEsperados)";
  }

  ///Método responsável por acessar as informações dos campos dos documentos cadastrados no Firebase
  Demandas.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    TituloProposta = data['Titulo_proposta'];
    TempoNecessario = data['Tempo_Necessario'];
    ResutadosEsperados = data['Resultados_Esperados'];
    Resumo = data['Resumo'];
    Objetivo = data['Objetivo'];
    Contrapartida = data['Contrapartida'];
    AreaTematica = data['Area_Tematica'];
    userID = data['userID'];
    docId = snapshot.id;
  }
}
