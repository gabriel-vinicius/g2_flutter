import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/tasks_viewmodel.dart';

class TaskFormView extends StatefulWidget {
  const TaskFormView({super.key});
  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<TasksViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Título')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await vm.addTask(ctrl.text);
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
