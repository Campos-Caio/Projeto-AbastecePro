import 'package:abastece_pro/screens/fuel_register.dart';
import 'package:abastece_pro/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VeichuleDetails extends StatelessWidget {
  final QueryDocumentSnapshot veichule;

  VeichuleDetails({Key? key, required this.veichule}) : super(key: key);

  Stream<double> _calculateAverageConsumption(
      String userId, String veichuleId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('veichules')
        .doc(veichuleId)
        .collection('fuel_records')
        .orderBy('mileage')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.length < 2) return 0.0;

      double totalLiters = 0;
      double average = 0;
      int previousMileage = snapshot.docs.first['mileage'];

      for (int i = 1; i < snapshot.docs.length; i++) {
        final record = snapshot.docs[i];
        final currentMileage = record['mileage'];
        final liters = snapshot.docs[i - 1]['liters'];

        average += (currentMileage - previousMileage) / liters;
        previousMileage = currentMileage;
      }

      return average / (snapshot.docs.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid; 

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<double>(
          stream: _calculateAverageConsumption(userId!, veichule.id),
          builder: (context, snapshot) {
            final averageConsumption = snapshot.data ?? 0.0;

            return Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      veichule['name'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Placa: ${veichule['plate']}\n"
                      "Modelo: ${veichule['model']}\n"
                      "Ano: ${veichule['year']}\n"
                      "Média de Consumo: ${averageConsumption.toStringAsFixed(2)} km/L",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Adicionar Abastecimento",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            FuelRegister(veichuleId: veichule.id),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
