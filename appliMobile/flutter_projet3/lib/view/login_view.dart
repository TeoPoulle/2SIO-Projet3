import 'package:flutter/material.dart';
import 'package:flutter_projet3/controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    _doLogin();
  }

  Future<void> _doLogin() async {
    setState(() {
      _error = null;
    });
    try {
      await AuthService.instance.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Se connecter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || v.isEmpty ? "Requis" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Mot de passe",
                    ),
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? "Requis" : null,
                  ),
                  const SizedBox(height: 12),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _submit();
                      }
                    },
                    child: const Text("Se connecter"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text("S'inscrire"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
