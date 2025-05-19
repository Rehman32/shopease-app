import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final void Function(String email, String password) onSubmit;

  const AuthForm({super.key, required this.isLogin, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _trySubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_email.trim(), _password.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const ValueKey('email'),
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value!,
            validator: (value) =>
            value!.contains('@') ? null : 'Enter valid email',
          ),
          TextFormField(
            key: const ValueKey('password'),
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) => _password = value!,
            validator: (value) => value!.length >= 6
                ? null
                : 'Password must be 6+ characters',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _trySubmit,
            child: Text(widget.isLogin ? 'Login' : 'Signup'),
          )
        ],
      ),
    );
  }
}
