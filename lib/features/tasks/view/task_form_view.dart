import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/tasks_viewmodel.dart';
import '../../../data/models/task_model.dart';

class TaskFormView extends StatefulWidget {
  const TaskFormView({super.key});

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final titleCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  EisenhowerQuadrant _quadrant = EisenhowerQuadrant.urgentImportant;

  @override
  void dispose() {
    titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _date ?? now,
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (t != null) setState(() => _time = t);
  }

  DateTime? _composeDueAt() {
    if (_date == null) return null;
    final h = _time?.hour ?? 9;
    final m = _time?.minute ?? 0;
    return DateTime(_date!.year, _date!.month, _date!.day, h, m);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<TasksViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tarefa'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Título da Tarefa',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
          const SizedBox(height: 24),
          const Text(
            'Matriz de Eisenhower',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<EisenhowerQuadrant>(
            initialValue: _quadrant,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.dashboard),
            ),
            items: const [
              DropdownMenuItem(
                value: EisenhowerQuadrant.urgentImportant,
                child: Text('🔴 Urgente e Importante (Fazer)'),
              ),
              DropdownMenuItem(
                value: EisenhowerQuadrant.notUrgentImportant,
                child: Text('🔵 Não Urgente e Importante (Agendar)'),
              ),
              DropdownMenuItem(
                value: EisenhowerQuadrant.urgentNotImportant,
                child: Text('🟠 Urgente e Não Importante (Delegar)'),
              ),
              DropdownMenuItem(
                value: EisenhowerQuadrant.notUrgentNotImportant,
                child: Text('⚪ Não Urgente e Não Importante (Eliminar)'),
              ),
            ],
            onChanged: (v) => setState(() => _quadrant = v ?? _quadrant),
          ),
          const SizedBox(height: 24),
          const Text(
            'Prazo (opcional)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _date == null
                        ? 'Escolher data'
                        : '${_date!.day.toString().padLeft(2, '0')}/${_date!.month.toString().padLeft(2, '0')}/${_date!.year}',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    _time == null
                        ? 'Escolher hora'
                        : '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () async {
              final nav = Navigator.of(context);
              await vm.addTask(
                title: titleCtrl.text,
                quadrant: _quadrant,
                dueAt: _composeDueAt(),
              );
              if (!mounted) return;
              nav.pop();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Tarefa'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
