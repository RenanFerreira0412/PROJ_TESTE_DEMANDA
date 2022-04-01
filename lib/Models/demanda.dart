class SchoolActivity {

  SchoolActivity(
      this.title,
      this.tempo,
      this.topics,
      this.infoExtra,
      this.subject,
      this.userID,
      );

  SchoolActivity.fromJson(Map<String, Object> json)
      : this(
    json['title'] as String,
    json['tempo'] as String,
    json['topics'] as String,
    json['infoExtra'] as String,
    json['subject'] as String,
    json['userId'] as String,
  );

  final String title;
  final String tempo;
  final String topics;
  final String infoExtra;
  final String subject;
  final String userID;

  Map<String, Object> toJson() {
    return {
      'title': title,
      'tempo': tempo,
      'topics': topics,
      'infoExtra': infoExtra,
      'subject': subject,
      'userId': userID,
    };
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



class Subject {

  Subject(
      this.name,
      );

  Subject.fromJson(Map<String, Object> json)
      : this(
    json['nome'] as String,
  );

  final String name;

  Map<String, Object> toJson() {
    return {
      'nome': name,
    };
  }
}
