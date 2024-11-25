import 'package:abastece_pro/widgets/custom_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      _nameController = TextEditingController(text: userDoc['name']);
      _emailController = TextEditingController(text: userDoc['email']);
      _phoneController = TextEditingController(text: userDoc['phone']);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    });

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: customInputDecoration('Nome', Icons.person),
                      style: TextStyle(color: Colors.black),
                      validator: (value) =>
                          value!.isEmpty ? "Campo obrigatório" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: customInputDecoration('Email', Icons.email),
                      style: TextStyle(color: Colors.black),
                      validator: (value) =>
                          value!.isEmpty ? "Campo obrigatório" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: customInputDecoration('Telefone', Icons.phone_android),
                      style: TextStyle(color: Colors.black),
                      validator: (value) =>
                          value!.isEmpty ? "Campo obrigatório" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text("Salvar Alterações"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
