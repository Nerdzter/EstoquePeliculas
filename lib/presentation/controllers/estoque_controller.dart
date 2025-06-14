import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../data/models/filme_model.dart';

class EstoqueController extends GetxController {
  late Box<FilmeModel> box;
  var estoque = <FilmeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    box = Hive.box<FilmeModel>('estoqueBox');
    carregarEstoque();
  }

  void carregarEstoque() {
    estoque.value = box.values.cast<FilmeModel>().toList();
  }

  void adicionar(FilmeModel filme) {
    if (!box.containsKey(filme.id)) {
      box.put(filme.id, filme);
      carregarEstoque();
    }
  }

  void remover(String id) {
    box.delete(id);
    carregarEstoque();
  }

  void atualizar(FilmeModel filme) {
    box.put(filme.id, filme);
    carregarEstoque();
  }
}
