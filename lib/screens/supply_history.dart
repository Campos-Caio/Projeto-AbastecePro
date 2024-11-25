import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupplyHistory extends StatelessWidget {
  const SupplyHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Histórico de Abastecimentos")),
        body: const Center(child: Text("Erro: Usuário não autenticado!")),
      );
    }

    // Obtém todas as subcoleções 'fuel_records' para cada veículo
    final supplyStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('veichules') // Todos os veículos do usuário
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Abastecimentos")),
      body: StreamBuilder<QuerySnapshot>(
        stream: supplyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum abastecimento registrado."));
          }

          final vehicles = snapshot.data!.docs;

          return ListView(
            children: vehicles.map((vehicle) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('veichules')
                    .doc(vehicle.id)
                    .collection('fuel_records')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, fuelSnapshot) {
                  if (!fuelSnapshot.hasData || fuelSnapshot.data!.docs.isEmpty) {
                    return Container(); // Nenhum registro para este veículo
                  }

                  final supplies = fuelSnapshot.data!.docs;

                  return ExpansionTile(
                    title: Text(vehicle['name']),
                    subtitle: Text("Placa: ${vehicle['plate']}"),
                    children: supplies.map((supply) {
                      return ListTile(
                        title: Text("Data: ${supply['date']}"),
                        subtitle: Text(
                          "Litros: ${supply['liters']} L\n"
                          "Quilometragem: ${supply['mileage']} km",
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
