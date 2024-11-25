import 'package:abastece_pro/screens/fuel_register.dart';
import 'package:abastece_pro/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VeichuleDetails extends StatelessWidget {
  final QueryDocumentSnapshot veichule;

  VeichuleDetails({Key? key, required this.veichule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  veichule['name'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Placa: ${veichule['plate']}\n"
                  "Modelo: ${veichule['model']}\n"
                  "Ano: ${veichule['year']}",
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Adicionar Abastecimento",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FuelRegister(veichuleId: veichule.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
