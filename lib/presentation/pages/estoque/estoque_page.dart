import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/filme_model.dart';
import '../../controllers/estoque_controller.dart';

class EstoquePage extends StatelessWidget {
  final controller = Get.put(EstoqueController());

  final TextEditingController searchController = TextEditingController();
  final RxString filtroMarca = ''.obs;
  final RxString filtroTipo = ''.obs;

  EstoquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estoque')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoCadastro(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Painel lateral de alerta com altura fixa
            Obx(() {
              final alertas = controller.estoque.where((f) => f.quantidade < 5).toList();
              return Container(
                width: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade900.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Alertas',
                        style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...alertas.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("${f.marca} ${f.modelo} - ${f.tipo}: ${f.quantidade}",
                        style: const TextStyle(color: Colors.white)),
                    )),
                    if (alertas.isEmpty)
                      const Text('Tudo certo!', style: TextStyle(color: Colors.greenAccent))
                  ],
                ),
              );
            }),
            const SizedBox(width: 20),

            // Conteúdo principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Buscar',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onChanged: (_) => controller.update(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        hint: const Text('Marca'),
                        value: filtroMarca.value.isEmpty ? null : filtroMarca.value,
                        items: ['Samsung', 'Iphone', 'Redmi', 'Poco', 'Motorola', 'Lg']
                            .map((marca) => DropdownMenuItem(value: marca, child: Text(marca)))
                            .toList(),
                        onChanged: (val) => filtroMarca.value = val ?? '',
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        hint: const Text('Tipo'),
                        value: filtroTipo.value.isEmpty ? null : filtroTipo.value,
                        items: ['Vidro', 'Ceramica', 'Vidro Privacidade', 'Vidro fosco']
                            .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                            .toList(),
                        onChanged: (val) => filtroTipo.value = val ?? '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    final filmes = controller.estoque.where((f) {
                      final busca = searchController.text.toLowerCase();
                      final matchesBusca = f.marca.toLowerCase().contains(busca) ||
                          f.modelo.toLowerCase().contains(busca) ||
                          f.tipo.toLowerCase().contains(busca);
                      final matchesMarca = filtroMarca.value.isEmpty || f.marca == filtroMarca.value;
                      final matchesTipo = filtroTipo.value.isEmpty || f.tipo == filtroTipo.value;
                      return matchesBusca && matchesMarca && matchesTipo;
                    }).toList();

                    if (filmes.isEmpty) return const Center(child: Text("Sem películas"));

                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Marca')),
                            DataColumn(label: Text('Modelo')),
                            DataColumn(label: Text('Tipo')),
                            DataColumn(label: Text('Qtd')),
                            DataColumn(label: Text('Ações')),
                          ],
                          rows: filmes.map((filme) => DataRow(cells: [
                            DataCell(Text(filme.marca)),
                            DataCell(Text(filme.modelo)),
                            DataCell(Text(filme.tipo)),
                            DataCell(Text(filme.quantidade.toString())),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _mostrarDialogoCadastro(context, filme: filme),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => controller.remover(filme.id),
                                ),
                              ],
                            )),
                          ])).toList(),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoCadastro(BuildContext context, {FilmeModel? filme}) {
    final modeloCtrl = TextEditingController(text: filme?.modelo);
    final qtdCtrl = TextEditingController(text: filme?.quantidade.toString());
    final RxString selectedMarca = (filme?.marca ?? '').obs;
    final RxString selectedTipo = (filme?.tipo ?? '').obs;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          filme == null ? 'Nova Película' : 'Editar Película',
          style: const TextStyle(
            color: Colors.tealAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Obx(() => SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMarca.value.isEmpty ? null : selectedMarca.value,
                decoration: const InputDecoration(labelText: 'Marca'),
                items: ['Samsung', 'Iphone', 'Redmi', 'Poco', 'Motorola', 'Lg']
                    .map((marca) => DropdownMenuItem(value: marca, child: Text(marca)))
                    .toList(),
                onChanged: (val) => selectedMarca.value = val ?? '',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: modeloCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedTipo.value.isEmpty ? null : selectedTipo.value,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: ['Vidro', 'Ceramica', 'Vidro Privacidade', 'Vidro fosco']
                    .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (val) => selectedTipo.value = val ?? '',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtdCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),
            ],
          ),
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            onPressed: () {
              final novo = FilmeModel(
                id: filme?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                marca: selectedMarca.value,
                modelo: modeloCtrl.text,
                tipo: selectedTipo.value,
                quantidade: int.tryParse(qtdCtrl.text) ?? 0,
              );
              filme == null ? controller.adicionar(novo) : controller.atualizar(novo);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
} 
