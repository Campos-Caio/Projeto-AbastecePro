import 'package:abastece_pro/screens/veichule_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final database = FirebaseFirestore.instance;

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Ajuste conforme sua rota de login
  }

    Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.data()?['name'] ?? "Nome não disponível";
    }
    return "Usuário não logado";
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final veichulesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('veichules')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AbastecePro'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.gas_meter_rounded))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFB39DDB),
              ),
              accountName: FutureBuilder<String>(
                future: getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Carregando...");
                  }
                  return Text(snapshot.data ?? "Nome não disponível");
                },
              ),
              accountEmail: Text(FirebaseAuth.instance.currentUser?.email ??
                  "Email nao disponivel!"),
              currentAccountPicture: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.of(context).pushNamed("/home");
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car_filled_outlined),
              title: Text("Meus Veiculos"),
              onTap: () {
                Navigator.of(context).pushNamed("/myVeichules");
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Adicionar Veiculos"),
              onTap: () {
                Navigator.of(context).pushNamed('/registerVeichule');
              },
            ),
            ListTile(
              leading: Icon(Icons.gas_meter),
              title: Text("Historico de abastecimentos"),
              onTap: () {
                Navigator.of(context).pushNamed('/supplyHistory');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Perfil"),
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text("Logout!"),
              onTap: () => _logout(context),
            ),
          ],
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.gas_meter_sharp),
      ),
    );
  }
}
