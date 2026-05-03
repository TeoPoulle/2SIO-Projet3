import 'package:flutter_projet3/model/traitement_model.dart';

class UserModel {
  final String uid;
  final String emailUser;
  final String nomUser;
  final String prenomUser;
  final String role; // 'Patient', 'Médecin'
  final List<dynamic> repas; // Liste des repas (pour les patients)
  final List<dynamic> passage; // Liste des passages (pour les patients)
  final List<TraitementModel> traitements; // Liste des traitements (pour les patients)

  UserModel({
    required this.uid,
    required this.emailUser,
    required this.nomUser,
    required this.prenomUser,
    required this.role,
    required this.repas,
    required this.passage,
    required this.traitements,
  });

  factory UserModel.fromFirebaseUser(UserModel user, {Map<String, dynamic>? additionalData}) {
    return UserModel(
      uid: user.uid,
      emailUser: user.emailUser,
      nomUser: user.nomUser,
      prenomUser: user.prenomUser,
      role: user.role, 
      repas: user.repas,
      passage: user.passage,
      traitements: user.traitements,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'emailUser': emailUser,
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'role': role,
      'repas': repas,
      'passage': passage,
      'traitements': traitements,
    };
  }
}