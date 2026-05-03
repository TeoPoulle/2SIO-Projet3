import 'package:flutter/material.dart';
import 'package:flutter_projet3/controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S'inscrire")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(labelText: "Nom"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Requis" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _prenomController,
                      decoration: const InputDecoration(labelText: "Prénom"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Requis" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Requis" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                      ),
                      obscureText: true,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Requis" : null,
                    ),
                    const SizedBox(height: 12),
                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                    _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _submit();
                              }
                            },
                            child: const Text("S'inscrire"),
                          ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text("Déjà un compte ? Se connecter"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
