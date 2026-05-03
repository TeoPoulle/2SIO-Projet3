import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Fonction d'inscription de l'utilisateur dans Firebase Authentication et création du profil dans Firestore
  // Le <UserCredential?> permet de typer les returns et le ? rend possible les renvois null
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String nom,
    required String prenom,
  }) async {
    try {
      // Création du compte dans Firebase Authentication (enlève le mot de passe du noSQL)
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Création du profil utilisateur dans Firestore avec les informations basiques
      final userDoc = _firestore.collection('compte').doc(cred.user!.uid);
      await userDoc.set({
        'id': cred.user!.uid,
        'nomUser': nom,
        'prenomUser': prenom,
        'emailUser': email,
        'role': 'Patient',
        'repas': [],
        'passage': [],
        'traitements': [],
      });

      return cred;
    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs classiques (email déjà utilisé, mot de passe faible, email invalide)
      if (e.code == 'email-already-in-use') {
        return Future.error("Cet email est déjà utilisé.");
      } else if (e.code == 'weak-password') {
        return Future.error("Mot de passe trop faible.");
      } else if (e.code == 'invalid-email') {
        return Future.error("Adresse email invalide.");
      }
      return Future.error("Erreur d'authentification : ${e.message}");
    } catch (e) {
      // Pour les erreurs moins fréquentes, on peut juste retourner un message générique
      return Future.error("Erreur inattendue : $e");
    }
  }

  // Fonction de connexion
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Vérifie si l’utilisateur a un profil dans Firestore
      final doc = await _firestore
          .collection('compte')
          .doc(userCredential.user!.uid)
          .get();
      if (!doc.exists) {
        await _auth.signOut();
        return Future.error("Profil utilisateur introuvable.");
      }
      return userCredential; //  Connexion réussie
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs fréquentes
      if (e.code == 'user-not-found') {
        return Future.error("Aucun utilisateur trouvé avec cet email.");
      } else if (e.code == 'wrong-password') {
        return Future.error("Mot de passe incorrect.");
      } else if (e.code == 'invalid-email') {
        return Future.error("Adresse email invalide.");
      }
      return Future.error("Erreur d'authentification : ${e.message}");
    } catch (e) {
      // Pour les erreurs moins fréquentes, on peut juste retourner un message générique
      return Future.error("Erreur inattendue : $e");
    }
  }

  // Récupère le profil Firestore du user courant (null si pas connecté)
  Future<DocumentSnapshot<Map<String, dynamic>>?>
  getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('compte').doc(user.uid).get();
    return doc;
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  // A voir l'utilité de cette fonction plus tard et enlever si pas utile
  //  Écouteur d’état de connexion
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
