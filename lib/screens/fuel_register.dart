import 'package:abastece_pro/widgets/custom_Input_Decoration.dart';
import 'package:abastece_pro/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FuelRegister extends StatelessWidget {
  final String veichuleId;

  FuelRegister({Key? key, required this.veichuleId}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _literController = TextEditingController();
  final _miliageController = TextEditingController();
  final _dateController = TextEditingController();

  void _saveFuelRecord(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid; 

    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('veichules')
          .doc(veichuleId)
          .collection('fuel_records')
          .add({
        "liters": double.parse(_literController.text),
        "mileage": int.parse(_miliageController.text),
        "date": _dateController.text,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Abastecimento registrado!")));

    Navigator.of(context).pushNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Abastcimento!"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _literController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration(
                    "Litros Abastecidos", Icons.gas_meter),
                style: TextStyle(color: Colors.black),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a quilometragem' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _miliageController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration(
                    "Quilometragem atual", Icons.gas_meter),
                style: TextStyle(color: Colors.black),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a quilometragem' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _dateController,
                decoration: customInputDecoration("Data", Icons.calendar_today),
                style: TextStyle(color: Colors.black),
                validator: (value) => value!.isEmpty ? 'Informe a data' : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateController.text =
                        "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  text: "Salvar Abastecimento!",
                  onPressed: () => _saveFuelRecord(context))
            ],
          ),
        ),
      ),
    );
  }
}
