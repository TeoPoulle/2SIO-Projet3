class MedocModel {
  final String nomMedicament;
  final String posologie;

  MedocModel({required this.nomMedicament, required this.posologie});

  factory MedocModel.fromMap(Map<String, dynamic> map) {
    return MedocModel(
      // Les données Firestore peuvent venir avec le nom complet du champ ou une variante proche.
      nomMedicament: (map['nomMedicament'] ?? '').toString(),
      posologie: (map['posologie'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'nomMedicament': nomMedicament, 'posologie': posologie};
  }
}
