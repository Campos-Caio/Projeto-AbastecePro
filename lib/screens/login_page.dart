import 'package:abastece_pro/screens/register_page.dart';
import 'package:abastece_pro/widgets/custom_Input_Decoration.dart';
import 'package:abastece_pro/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error ao fazer login:  ${error.toString()} ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: customInputDecoration("Email", Icons.email),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: customInputDecoration("Password", Icons.password),
              obscureText: true,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(text: 'Entrar', onPressed: _loginUser),
            const SizedBox(
              height: 16.0,
            ),
            CustomButton(
                text: 'Criar conta',
                onPressed: () {
                  Navigator.of(context).pushNamed("/register");
                })
          ],
        ),
      ),
    );
  }
}
