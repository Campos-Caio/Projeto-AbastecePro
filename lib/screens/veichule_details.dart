import 'package:abastece_pro/screens/fuel_register.dart';
import 'package:abastece_pro/widgets/custom_button.dart';
import 'package:abastece_pro/widgets/custom_input_decoration.dart';
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

  void _deleteVeichule(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Veículo excluído.'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () async {
            // Restaura o veículo caso o usuário desfaça a exclusão
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('veichules')
                .doc(veichule.id)
                .set(veichule.data() as Map<String, dynamic>);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exclusão desfeita.')),
            );
          },
        ),
      ),
    );

    // Exclui o veículo após 3 segundos se o usuário não desfizer a exclusão
    Future.delayed(const Duration(seconds: 3), () async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('veichules')
          .doc(veichule.id)
          .delete();
    });

    Navigator.pop(context);
  }

  void _showEditDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: veichule['name']);
    final _plateController = TextEditingController(text: veichule['plate']);
    final _modelController = TextEditingController(text: veichule['model']);
    final _yearController = TextEditingController(text: veichule['year']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Veículo'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: customInputDecoration('Nome', Icons.person),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _plateController,
                  decoration: customInputDecoration('Placa', Icons.add),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe a placa' : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _modelController,
                  decoration: customInputDecoration('Modelo', Icons.add),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o modelo' : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _yearController,
                  decoration:
                      customInputDecoration('Placa', Icons.calendar_month),
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Informe o ano' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final userId = FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('veichules')
                      .doc(veichule.id)
                      .update({
                    'name': _nameController.text,
                    'plate': _plateController.text,
                    'model': _modelController.text,
                    'year': _yearController.text,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veículo atualizado com sucesso!'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Veículo'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              icon: const Icon(Icons.home))
        ],
      ),
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
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditDialog(context);
                        } else if (value == 'delete') {
                          _deleteVeichule(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Excluir'),
                        ),
                      ],
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
