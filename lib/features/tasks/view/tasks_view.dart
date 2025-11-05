import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/tasks_viewmodel.dart';
import '../../../data/models/task_model.dart';
import 'task_form_view.dart';

class TasksView extends GetView<TasksViewModel> {
  const TasksView({super.key});

  String _qLabel(EisenhowerQuadrant q) {
    switch (q) {
      case EisenhowerQuadrant.urgentImportant:
        return 'Fazer';
      case EisenhowerQuadrant.notUrgentImportant:
        return 'Agendar';
      case EisenhowerQuadrant.urgentNotImportant:
        return 'Delegar';
      case EisenhowerQuadrant.notUrgentNotImportant:
        return 'Eliminar';
    }
  }

  Color _qColor(EisenhowerQuadrant q) {
    switch (q) {
      case EisenhowerQuadrant.urgentImportant:
        return Colors.red.shade100;
      case EisenhowerQuadrant.notUrgentImportant:
        return Colors.blue.shade100;
      case EisenhowerQuadrant.urgentNotImportant:
        return Colors.orange.shade100;
      case EisenhowerQuadrant.notUrgentNotImportant:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final items = controller.visibleTasks;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Tarefas'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            PopupMenuButton<String>(
              onSelected: (v) {
                switch (v) {
                  case 'all':
                    controller.filterQuadrant.value = null;
                    break;
                  case 'ui':
                    controller.filterQuadrant.value =
                        EisenhowerQuadrant.urgentImportant;
                    break;
                  case 'nui':
                    controller.filterQuadrant.value =
                        EisenhowerQuadrant.notUrgentImportant;
                    break;
                  case 'uni':
                    controller.filterQuadrant.value =
                        EisenhowerQuadrant.urgentNotImportant;
                    break;
                  case 'nuni':
                    controller.filterQuadrant.value =
                        EisenhowerQuadrant.notUrgentNotImportant;
                    break;
                }
              },
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'all', child: Text('📋 Todos')),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'ui',
                  child: Text('🔴 Fazer (Urgente/Importante)'),
                ),
                PopupMenuItem(
                  value: 'nui',
                  child: Text('🔵 Agendar (Não Urgente/Importante)'),
                ),
                PopupMenuItem(
                  value: 'uni',
                  child: Text('🟠 Delegar (Urgente/Não Importante)'),
                ),
                PopupMenuItem(
                  value: 'nuni',
                  child: Text('⚪ Eliminar (Não Urgente/Não Importante)'),
                ),
              ],
              icon: const Icon(Icons.filter_list),
            ),
          ],
        ),
        body: items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sem tarefas',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Clique no + para adicionar',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final t = items[i];
                  final dueStr = (t.dueAt == null)
                      ? 'Sem prazo'
                      : '${t.dueAt!.day.toString().padLeft(2, '0')}/${t.dueAt!.month.toString().padLeft(2, '0')}/${t.dueAt!.year} '
                          '${t.dueAt!.hour.toString().padLeft(2, '0')}:${t.dueAt!.minute.toString().padLeft(2, '0')}';

                  final createdStr =
                      '${t.createdAt.day.toString().padLeft(2, '0')}/${t.createdAt.month.toString().padLeft(2, '0')}/${t.createdAt.year} '
                      '${t.createdAt.hour.toString().padLeft(2, '0')}:${t.createdAt.minute.toString().padLeft(2, '0')}';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: _qColor(t.quadrant),
                    child: ListTile(
                      title: Text(
                        t.title,
                        style: TextStyle(
                          decoration:
                              t.done ? TextDecoration.lineThrough : null,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('📅 Prazo: $dueStr'),
                          Text('🕐 Criada: $createdStr'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(
                                label: Text(_qLabel(t.quadrant)),
                                labelStyle: const TextStyle(fontSize: 12),
                                visualDensity: VisualDensity.compact,
                              ),
                              if (t.done)
                                const Chip(
                                  label: Text('✓ Concluída'),
                                  labelStyle: TextStyle(fontSize: 12),
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                        ],
                      ),
                      leading: Checkbox(
                        value: t.done,
                        onChanged: (v) => controller.toggle(t.id, v ?? false),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red.shade700,
                        onPressed: () => controller.remove(t.id),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(() => const TaskFormView()),
          icon: const Icon(Icons.add),
          label: const Text('Nova Tarefa'),
        ),
      );
    });
  }
}
