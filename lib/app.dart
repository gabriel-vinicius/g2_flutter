import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

class ProjetoG2App extends StatelessWidget {
  const ProjetoG2App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto G2 - Matriz de Eisenhower',
      initialRoute: Routes.auth,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
    );
  }
}
