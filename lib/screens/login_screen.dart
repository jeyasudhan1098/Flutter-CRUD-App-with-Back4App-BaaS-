import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email or Username'),
                    onSaved: (v) => _username = v?.trim() ?? '',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter email or username' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => _password = v ?? '',
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 12),
                  if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: _loading ? null : () async {
                      final form = _formKey.currentState!;
                      if (!form.validate()) return;
                      form.save();
                      setState(() { _loading = true; _error = null; });
                      final res = await auth.login(_username, _password);
                      setState(() { _loading = false; });
                      if (res.success) {
                        if (!mounted) return;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                      } else {
                        setState(() {
                          _error = res.error?.message ?? 'Login failed';
                        });
                      }
                    },
                    child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Register (student)'),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
