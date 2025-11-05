import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';

class TasksViewModel extends GetxController {
  final TaskRepository _repo;
  final FirebaseAuth _auth;

  TasksViewModel(this._repo, this._auth);

  final tasks = <TaskModel>[].obs;
  final loading = false.obs;
  final Rxn<EisenhowerQuadrant> filterQuadrant = Rxn<EisenhowerQuadrant>();

  String get uid => _auth.currentUser!.uid;

  @override
  Future<void> onInit() async {
    super.onInit();
    await load();
  }

  Future<void> load() async {
    loading.value = true;
    final res = await _repo.fetchAll(uid);
    res.fold(
      (_) => tasks.assignAll([]),
      (list) {
        // Ordena: 1) quadrante, 2) dueAt, 3) createdAt
        list.sort((a, b) {
          int qOrder(EisenhowerQuadrant q) {
            switch (q) {
              case EisenhowerQuadrant.urgentImportant:
                return 0;
              case EisenhowerQuadrant.notUrgentImportant:
                return 1;
              case EisenhowerQuadrant.urgentNotImportant:
                return 2;
              case EisenhowerQuadrant.notUrgentNotImportant:
                return 3;
            }
          }

          final cq = qOrder(a.quadrant).compareTo(qOrder(b.quadrant));
          if (cq != 0) return cq;

          if (a.dueAt != null && b.dueAt != null) {
            final cd = a.dueAt!.compareTo(b.dueAt!);
            if (cd != 0) return cd;
          } else if (a.dueAt != null) {
            return -1;
          } else if (b.dueAt != null) {
            return 1;
          }

          return b.createdAt.compareTo(a.createdAt);
        });
        tasks.assignAll(list);
      },
    );
    loading.value = false;
  }

  Future<void> addTask({
    required String title,
    required EisenhowerQuadrant quadrant,
    DateTime? dueAt,
  }) async {
    if (title.trim().isEmpty) return;
    final task = TaskModel.newLocal(
      title: title.trim(),
      quadrant: quadrant,
      dueAt: dueAt,
    );
    final res = await _repo.add(uid, task);
    res.fold((_) {}, (_) => load());
  }

  Future<void> toggle(String id, bool done) async {
    final res = await _repo.toggleDone(uid, id, done);
    res.fold((_) {}, (_) => load());
  }

  Future<void> remove(String id) async {
    final res = await _repo.remove(uid, id);
    res.fold((_) {}, (_) => load());
  }

  List<TaskModel> get visibleTasks {
    final fq = filterQuadrant.value;
    if (fq == null) return tasks;
    return tasks.where((t) => t.quadrant == fq).toList();
  }
}
