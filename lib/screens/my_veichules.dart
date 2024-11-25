import 'package:abastece_pro/screens/veichule_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyVeichules extends StatelessWidget {
  const MyVeichules({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Nenhum usuario logado!"),
      );
    }

    final veichulesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('veichules')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Veiculos!'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: veichulesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: const Text('Nenhum veiculo registrado!'),
            );
          }

          final veichules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: veichules.length,
            itemBuilder: (context, index) {
              final veichule = veichules[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Icon(
                    Icons.directions_car,
                    size: 40,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    veichule['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Placa: ${veichule['plate']}\nModelo: ${veichule['model']}\nAno: ${veichule['year']}"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            VeichuleDetails(veichule: veichule),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
