import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

void trocaPagina(BuildContext context, Widget pagina) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => pagina));
}

class _HomePageState extends State<HomePage> {
  final database = FirebaseFirestore.instance; 

  final List<Map<String, String>> veiculos = [
    {"nome": "Fusca", "placa": "ABC-1234", "modelo": "1975"},
    {"nome": "Civic", "placa": "XYZ-5678", "modelo": "2020"},
    {"nome": "Corolla", "placa": "LMN-9101", "modelo": "2018"},
  ];

  @override
  Widget build(BuildContext context) {
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
              accountName: Text("NomeDoUsuario"),
              accountEmail: Text("EmailDoUsuario"),
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
                trocaPagina(context, HomePage());
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car_filled_outlined),
              title: Text("Meus Veiculos"),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Adicionar Veiculos"),
            ),
            ListTile(
              leading: Icon(Icons.gas_meter),
              title: Text("Historico de abastecimentos"),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Perfil"),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text("Logout!"),
            ),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: veiculos.length, 
          itemBuilder: (context, index) {
            final veiculo = veiculos[index]; 
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                leading: Icon(Icons.directions_car,size: 40,color: Colors.deepPurple,),
                title: Text(veiculo["nome"]!,style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Placa: ${veiculo['placa']}\nModelo: ${veiculo['modelo']}"),
                onTap: (){} // funcao para abrir detalhes do veiculo,
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
