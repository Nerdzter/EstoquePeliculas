import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/filme_model.dart';
import '../../controllers/estoque_controller.dart';

class EstoquePage extends StatelessWidget {
  final _controller = Get.put(EstoqueController());
  final TextEditingController searchController = TextEditingController();
  final RxString filtroMarca = ''.obs;
  final RxString filtroTipo = ''.obs;

  EstoquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/naytec_logo.png',
          height: 56, // AUMENTE AQUI
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoCadastro(context),
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAlertaPanel(),
          Expanded(
            child: Column(
              children: [
                _buildFiltroPanel(),
                const SizedBox(height: 16),
                Obx(() => _buildDataTable()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertaPanel() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 20),
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF330000),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Obx(() {
        final alertas = _controller.estoque.where((e) => e.quantidade <= 2).toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alertas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 8),
            if (alertas.isEmpty)
              const Text('Tudo certo!', style: TextStyle(color: Colors.green))
            else
              ...alertas.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('${e.marca} ${e.modelo} - ${e.tipo}: ${e.quantidade}', style: const TextStyle(color: Colors.white)),
                  )),
          ],
        );
      }),
    );
  }

  Widget _buildFiltroPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
              onChanged: (_) => _controller.carregarEstoque(),
            ),
          ),
          const SizedBox(width: 12),
          _buildDropdown('Marca', filtroMarca, ['', 'Samsung', 'Iphone', 'Redmi', 'Poco', 'Motorola', 'Lg']),
          const SizedBox(width: 12),
          _buildDropdown('Tipo', filtroTipo, ['', 'Vidro', 'Ceramica', 'Vidro Privacidade', 'Vidro fosco']),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              filtroMarca.value = '';
              filtroTipo.value = '';
              searchController.clear();
              _controller.carregarEstoque();
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, RxString value, List<String> items) {
    return Obx(() => DropdownButton<String>(
          value: value.value.isEmpty ? null : value.value,
          hint: Text(label),
          onChanged: (val) {
            value.value = val ?? '';
            _controller.carregarEstoque();
          },
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ));
  }

  Widget _buildDataTable() {
    final listaFiltrada = _controller.estoque.where((f) {
      final termo = searchController.text.toLowerCase();
      return f.modelo.toLowerCase().contains(termo) &&
          (filtroMarca.value.isEmpty || f.marca == filtroMarca.value) &&
          (filtroTipo.value.isEmpty || f.tipo == filtroTipo.value);
    }).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Marca')),
            DataColumn(label: Text('Modelo')),
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Qtd')),
            DataColumn(label: Text('Ações')),
          ],
          rows: listaFiltrada.map((filme) {
            return DataRow(cells: [
              DataCell(Text(filme.marca)),
              DataCell(Text(filme.modelo)),
              DataCell(Text(filme.tipo)),
              DataCell(Text(filme.quantidade.toString())),
              DataCell(Row(children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _mostrarDialogoCadastro(Get.context!, filme: filme),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _controller.remover(filme.id),
                ),
              ])),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _mostrarDialogoCadastro(BuildContext context, {FilmeModel? filme}) {
    final modeloCtrl = TextEditingController(text: filme?.modelo);
    final qtdCtrl = TextEditingController(text: filme?.quantidade.toString());
    String marcaSelecionada = filme?.marca ?? '';
    String tipoSelecionado = filme?.tipo ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Nova Película', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: marcaSelecionada.isEmpty ? null : marcaSelecionada,
              dropdownColor: Colors.black87,
              decoration: const InputDecoration(labelText: 'Marca', filled: true, fillColor: Colors.black45),
              style: const TextStyle(color: Colors.white),
              items: ['Samsung', 'Iphone', 'Redmi', 'Poco', 'Motorola', 'Lg']
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) => marcaSelecionada = val!,
            ),
            DropdownButtonFormField<String>(
              value: tipoSelecionado.isEmpty ? null : tipoSelecionado,
              dropdownColor: Colors.black87,
              decoration: const InputDecoration(labelText: 'Tipo', filled: true, fillColor: Colors.black45),
              style: const TextStyle(color: Colors.white),
              items: ['Vidro', 'Ceramica', 'Vidro Privacidade', 'Vidro fosco']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => tipoSelecionado = val!,
            ),
            TextField(
              controller: modeloCtrl,
              decoration: const InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: qtdCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Salvar", style: TextStyle(color: Colors.black)),
            onPressed: () {
              final novo = FilmeModel(
                id: filme?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                marca: marcaSelecionada,
                modelo: modeloCtrl.text,
                tipo: tipoSelecionado,
                quantidade: int.tryParse(qtdCtrl.text) ?? 0,
              );
              filme == null ? _controller.adicionar(novo) : _controller.atualizar(novo);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}