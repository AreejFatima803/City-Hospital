import 'package:flutter/material.dart';
import '../api.dart';
import '../main.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(), _pass = TextEditingController();
  bool _signup = false, _loading = false, _hide = true;

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty || _pass.text.length < 6) {
      _msg('Enter an email and a password of 6+ characters');
      return;
    }
    setState(() => _loading = true);
    try {
      await Api.auth(_signup ? 'signup' : 'login', _email.text.trim(), _pass.text);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      _msg('$e');
    }
    if (mounted) setState(() => _loading = false);
  }

  void _msg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(children: [
                  const CircleAvatar(radius: 44, backgroundColor: kRed, child: Icon(Icons.local_hospital, size: 48, color: Colors.white)),
                  const SizedBox(height: 16),
                  const Text('City Hospital', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kRed)),
                  const SizedBox(height: 4),
                  Text(_signup ? 'Create your account' : 'Log in to continue', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 28),
                  TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _pass, obscureText: _hide,
                    decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(icon: Icon(_hide ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _hide = !_hide))),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_signup ? 'Sign up' : 'Log in'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _signup = !_signup),
                    child: Text(_signup ? 'Have an account? Log in' : 'New here? Sign up', style: const TextStyle(color: kRed)),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}
