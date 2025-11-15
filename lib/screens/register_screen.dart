import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Student Register')),
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
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: (v) => _username = v?.trim() ?? '',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter username' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Student Email'),
                    onSaved: (v) => _email = v?.trim() ?? '',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter email';
                      if (!v.contains('@')) return 'Enter valid email';
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => _password = v ?? '',
                    validator: (v) => (v == null || v.length < 6) ? '6+ chars' : null,
                  ),
                  const SizedBox(height: 12),
                  if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: _loading ? null : () async {
                      final form = _formKey.currentState!;
                      if (!form.validate()) return;
                      form.save();
                      setState(() { _loading = true; _error = null; });
                      final res = await auth.register(_username, _email, _password);
                      setState(() { _loading = false; });
                      if (res.success) {
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
                      } else {
                        setState(() {
                          _error = res.error?.message ?? 'Registration failed';
                        });
                      }
                    },
                    child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Register'),
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
