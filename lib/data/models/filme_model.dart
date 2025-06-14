import 'package:hive/hive.dart';

part 'filme_model.g.dart'; 

@HiveType(typeId: 0)
class FilmeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String marca;

  @HiveField(2)
  final String modelo;

  @HiveField(3)
  final String tipo;

  @HiveField(4)
  final int quantidade;

  FilmeModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.tipo,
    required this.quantidade,
  });
}
