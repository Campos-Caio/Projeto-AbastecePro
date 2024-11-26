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

    final supplyStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('veichules')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Abastecimentos"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: supplyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState(context);
          }

          final vehicles = snapshot.data!.docs;

          // Verifica se algum veículo possui abastecimentos
          return FutureBuilder<bool>(
            future: _checkIfSuppliesExist(userId, vehicles),
            builder: (context, suppliesSnapshot) {
              if (suppliesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (suppliesSnapshot.data == false) {
                return _buildEmptyState(context);
              }

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
                      if (!fuelSnapshot.hasData ||
                          fuelSnapshot.data!.docs.isEmpty) {
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
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Você não tem nenhum abastecimento cadastrado! :(",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/myVeichules');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text(
              "Cadastre seu primeiro abastecimento!",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkIfSuppliesExist(
      String userId, List<QueryDocumentSnapshot> vehicles) async {
    for (var vehicle in vehicles) {
      final fuelRecords = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('veichules')
          .doc(vehicle.id)
          .collection('fuel_records')
          .get();

      if (fuelRecords.docs.isNotEmpty) {
        return true; // Existe pelo menos um abastecimento
      }
    }
    return false; // Nenhum abastecimento encontrado
  }
}
