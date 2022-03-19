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

class Profile {
  final String uid;
  final String email;
  final String market;
  final String roleView;
  final String firstName;
  final String lastName;
  final String photoUrl;

  Profile({
    this.uid,
    this.email,
    this.market,
    this.roleView,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Profile(
      uid: doc.id,
      email: data['email'] ?? '',
      market: data['market'] ?? '',
      roleView: data['roleView'] ?? 'member',
      firstName: data['firstName'] ?? 'Valued',
      lastName: data['lastName'] ?? 'Guest',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}


class Users {

  Users(
      this.userId,
      this.email,
      this.tipo,
      this.userName,
      this.userPhone,
      this.userPhoto,
      );

  Users.fromJson(Map<String, Object> json)
      : this(
    json['id'] as String,
    json['email'] as String,
    json['tipo'] as String,
    json['name'] as String,
    json['telefone'] as String,
    json['url_photo'] as String,
  );

  final String userId;
  final String email;
  final String tipo;
  final String userName;
  final String userPhone;
  final String userPhoto;


  Map<String, Object> toJson() {
    return {
      'id': userId,
      'email': email,
      'tipo': tipo,
      'name': userName,
      'telefone': userPhone,
      'url_photo': userPhoto,
    };
  }
}
