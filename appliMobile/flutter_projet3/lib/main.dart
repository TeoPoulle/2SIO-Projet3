import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_projet3/firebase_options.dart';
import 'package:flutter_projet3/view/parameter_view.dart';
import 'package:flutter_projet3/view/login_view.dart';
import 'package:flutter_projet3/view/signup_view.dart';
// Import des widgets customs
import 'package:flutter_projet3/view/customWidget/app_bar.dart';
import 'package:flutter_projet3/view/customWidget/bottom_nav_bar.dart';
import 'package:flutter_projet3/view/traitement_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool get _isDark => _themeMode == ThemeMode.dark;

  void _setDarkMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Maird'Alor",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      routes: {
        '/': (context) => AuthGate(
              isDark: _isDark,
              onThemeChanged: _setDarkMode,
            ),
        '/parameter': (context) =>
            ParameterApp(isDark: _isDark, onThemeChanged: _setDarkMode),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        // '/passage': (context) => const PassagePage(),
        // '/repas': (context) => const RepasPage(),
        '/traitement': (context) => TraitementApp(isDark: _isDark, onThemeChanged: _setDarkMode),
      },
      initialRoute: '/',
    );
  }
}

class AuthGate extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const AuthGate({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return MainApp(isDark: isDark);
        }
        return const LoginPage();
      },
    );
  }
}

class MainApp extends StatelessWidget {
  final bool isDark;

  const MainApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Accueil", isDark: isDark),
      bottomNavigationBar: buildBottomNavBar(context),
      // Contenu de la page principale
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Row(children: [])],
        ),
      ),
    );
  }
}
