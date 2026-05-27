import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projet3/model/medoc_model.dart';
import 'package:flutter_projet3/model/traitement_model.dart';
// Import des widgets customs
import 'package:flutter_projet3/view/customWidget/app_bar.dart';
import 'package:flutter_projet3/view/customWidget/bottom_nav_bar.dart';

class TraitementApp extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const TraitementApp({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<TraitementApp> createState() => _TraitementAppState();
}

class _TraitementAppState extends State<TraitementApp> {
  // Récupération des instances de firestore et firebase_auth pour les opérations sur firebase
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Création des controllers pour les champs du formulaire de traitement
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nomMedicamentController =
      TextEditingController();
  final TextEditingController _posologieController = TextEditingController();
  DateTime _selectionDate = DateTime.now();

  @override
  // La méthode dispose() permet de d'effacer le contenu des controllers quand la page de traitement se ferme
  // Cela évite que les données précédentes restent affichées si l'utilisateur ouvre à nouveau le formulaire
  // C'est une bonne pratique pour éviter les fuites de mémoire et optimiser les performances de l'application
  void dispose() {
    _dateController.dispose();
    _nomMedicamentController.dispose();
    _posologieController.dispose();
    super.dispose();
  }

  // Méthode de formatage des dates au format AAAA-MM-JJ (format attendu par Firestore)
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  // Méthode pour réinitialiser les champs du formulaire lorsque l'utilisateur ouvre le formulaire
  // ou après enregistrement
  void _resetForm() {
    _dateController.clear();
    _nomMedicamentController.clear();
    _posologieController.clear();
    _selectionDate = DateTime.now();
  }

  //
  int _incrementerTraitement(List<TraitementModel> traitements) {
    if (traitements.isEmpty) return 1;
    return traitements
            .map((traitement) => traitement.numTraitement)
            .reduce((current, next) => current > next ? current : next) +
        1;
  }

  // Méthode qui permet de sélectionner une date grâce à un petit calendrier
  Future<void> _selectionnerDate(BuildContext context) async {
    final selection = await showDatePicker(
      context: context,
      initialDate: _selectionDate, // La date par défaut = date actuelle
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR'), // Affiche le calendrier en français
    );
    if (selection != null) {
      setState(() {
        // Met à jour la date sélectionnée et affiche la date choisie dans le champ du formulaire
        _selectionDate = selection;
        _dateController.text = _formatDate(selection);
      });
    }
  }

  // Méthode pour afficher un message pop-up à l'utilisateur
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Méthode pour enregistrer un nouveau traitement dans Firestore
  Future<void> _enregistrerTraitement(
    BuildContext dialogContext,
    List<TraitementModel> traitementsPatient,
  ) async {
    final user = auth.currentUser;
    if (user == null) return;

    final dateDebut =
        _selectionDate; // Utilise la date sélectionnée via le calendrier
    final nomMedicament = _nomMedicamentController.text.trim();
    final posologie = _posologieController.text.trim();

    if (nomMedicament.isEmpty || posologie.isEmpty) {
      _showSnackBar('Renseigne le nom et la posologie du médicament.');
      return; // Vérifie que les champs des médicaments ne sont pas vides
      // Si les champs sont vides = affichage d'un message pop-up
    }

    // Création du traitement à partir des champs du formulaire
    final traitement = TraitementModel(
      numTraitement: _incrementerTraitement(traitementsPatient),
      dateDebut: dateDebut,
      medicaments: [
        MedocModel(nomMedicament: nomMedicament, posologie: posologie),
      ],
    );

    try {
      // Ajout du traitement dans Firestore
      await db.collection('compte').doc(user.uid).set({
        'traitements': FieldValue.arrayUnion([traitement.toMap()]),
        // arrayUnion fonctionne comme méthode list.add() de python
      }, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.of(dialogContext).pop();
      setState(_resetForm);
      _showSnackBar('Traitement ajouté avec succès.');
    } on FirebaseException catch (e) {
      _showSnackBar(
        'Impossible d\'enregistrer le traitement : ${e.message ?? e.code}',
      );
    } catch (e) {
      _showSnackBar('Erreur inattendue : $e');
    }
  }

  void _afficherFormulaire(List<TraitementModel> traitementsPatient) {
    _resetForm();
    _selectionDate = DateTime.now();
    _dateController.text = _formatDate(_selectionDate);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ajouter un traitement'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectionnerDate(dialogContext),
                  decoration: const InputDecoration(
                    labelText: 'Date de début',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nomMedicamentController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du médicament',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _posologieController,
                  decoration: const InputDecoration(labelText: 'Posologie'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () =>
                  _enregistrerTraitement(dialogContext, traitementsPatient),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: db.collection('compte').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: buildAppBar(
              context,
              title: 'Mes Traitements',
              isDark: widget.isDark,
            ),
            bottomNavigationBar: buildBottomNavBar(context),
            body: const Center(
              child: Text('Erreur lors du chargement des traitements.'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: buildAppBar(
              context,
              title: 'Mes Traitements',
              isDark: widget.isDark,
            ),
            bottomNavigationBar: buildBottomNavBar(context),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final traitements = _afficherTraitements(snapshot.data);

        return Scaffold(
          appBar: buildAppBar(
            context,
            title: 'Mes Traitements',
            isDark: widget.isDark,
          ),
          bottomNavigationBar: buildBottomNavBar(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _afficherFormulaire(traitements),
            child: const Icon(Icons.add),
          ),
          body: traitements.isEmpty
              ? const Center(
                  child: Text('Aucun traitement enregistré pour le moment.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: traitements.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final traitement = traitements[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Traitement',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Date de début : ${_formatDate(traitement.dateDebut)}',
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Médicaments :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            ...traitement.medicaments.map(
                              (medoc) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '- ${medoc.nomMedicament} : ${medoc.posologie}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  List<TraitementModel> _afficherTraitements(
    DocumentSnapshot<Map<String, dynamic>>? snapshot,
  ) {
    final data = snapshot?.data();
    final listTraitements = data?['traitements'] as List<dynamic>? ?? [];

    final traitements = listTraitements
        .whereType<Map<String, dynamic>>()
        .map(TraitementModel.fromMap)
        .toList();

    traitements.sort((a, b) => a.numTraitement.compareTo(b.numTraitement));
    return traitements;
  }
}
