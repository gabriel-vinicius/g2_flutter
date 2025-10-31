import 'package:get/get.dart';
import '../../../core/utils/either.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TasksViewModel extends GetxController {
  final TaskRepository _repo;
  final FirebaseAuth _auth;

  TasksViewModel(this._repo, this._auth);

  final tasks = <TaskModel>[].obs;
  final loading = false.obs;

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
      (list) => tasks.assignAll(list),
    );
    loading.value = false;
  }

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;
    final task = TaskModel.newLocal(title);
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
}
