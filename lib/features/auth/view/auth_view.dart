import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../../../core/routes/app_routes.dart';

class AuthView extends GetView<AuthViewModel> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthViewModel>(
      builder: (vm) {
        if (vm.user.value != null) {
          Future.microtask(() => Get.offAllNamed(Routes.tasks));
          return const SizedBox.shrink();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Projeto G2 - Login'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Matriz de Eisenhower',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gerencie suas tarefas por prioridade',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: vm.signInAnon,
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar Anonimamente'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
