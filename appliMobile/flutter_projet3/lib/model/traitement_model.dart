import 'package:flutter_projet3/model/medoc_model.dart';

class TraitementModel {
  final int numTraitement;
  final DateTime dateDebut;
  final List<MedocModel> medicaments;

  TraitementModel({
    required this.numTraitement,
    required this.dateDebut,
    required this.medicaments,
  });

  factory TraitementModel.fromMap(Map<String, dynamic> map) {
    return TraitementModel(
      // Firestore peut stocker ce champ comme int ou comme chaîne selon la provenance de la donnée.
      numTraitement: int.tryParse(map['numTraitement'].toString()) ?? 0,
      dateDebut: DateTime.parse(
        (map['dateDebut'] ?? DateTime.now().toIso8601String()).toString(),
      ),
      medicaments: (map['medicaments'] as List<dynamic>? ?? [])
          .map((medoc) => MedocModel.fromMap(medoc as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numTraitement': numTraitement,
      // On reste proche du JSON de départ avec une date au format AAAA-MM-JJ.
      'dateDebut': dateDebut.toIso8601String().split('T').first,
      'medicaments': medicaments.map((medoc) => medoc.toMap()).toList(),
    };
  }
}


/* 
{
                    "numTraitement": 1,
                    "dateDebut": "2026-04-08",
                    "medicaments": [
                        {
                            "nomMedicament": "Smecta",
                            "posologie": "2 sachets par jour"
                        }
                    ]
                }
*/