import 'package:abastece_pro/widgets/custom_Input_Decoration.dart';
import 'package:abastece_pro/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VeichuleRegister extends StatefulWidget {
  const VeichuleRegister({super.key});

  @override
  State<VeichuleRegister> createState() => _VeichuleRegisterState();
}

class _VeichuleRegisterState extends State<VeichuleRegister> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();

  void _registerVeichule() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('veichules')
            .add({
          'name': _nameController.text,
          'model': _modelController.text,
          'year': _yearController.text,
          'plate': _plateController.text
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veiculo registrado com sucesso!")),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    customInputDecoration("Nome", Icons.car_rental_outlined),
                style: const TextStyle(color: Colors.black),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o nome do veículo' : null,
              ),
              
              const SizedBox(height: 20),
              TextFormField(
                controller: _modelController,
                decoration: customInputDecoration("Modelo", Icons.add),
                style: const TextStyle(color: Colors.black),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o modelo do veículo' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _yearController,
                decoration: customInputDecoration("Ano", Icons.date_range),
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Informe o ano do veículo' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _plateController,
                decoration: customInputDecoration("Placa", Icons.add),
                style: const TextStyle(color: Colors.black),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a placa do veículo' : null,
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: 'Registrar Veiculo', onPressed: _registerVeichule)
            ],
          ),
        ),
      ),
    );
  }
}
