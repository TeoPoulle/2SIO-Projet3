class MedocModel {
  final String nomMedoc;
  final String posologie;

  MedocModel({
    required this.nomMedoc,
    required this.posologie,
  });

  factory MedocModel.fromMap(Map<String, dynamic> map) {
    return MedocModel(
      nomMedoc: map['nomMedicament'] ?? '',
      posologie: map['posologie'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nomMedicament': nomMedoc,
      'posologie': posologie,
    };
  }
}