import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/themes/app_theme.dart';
import 'presentation/pages/estoque/estoque_page.dart';
import 'data/models/filme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(FilmeModelAdapter());

  if (!Hive.isBoxOpen('estoqueBox')) {
    await Hive.openBox<FilmeModel>('estoqueBox');
  } else {
    Hive.box<FilmeModel>('estoqueBox');
  }

  runApp(const EstoqueApp());
}

class EstoqueApp extends StatelessWidget {
  const EstoqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Estoque de Películas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => EstoquePage()),
      ],
    );
  }
}
