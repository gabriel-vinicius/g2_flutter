import '../../core/utils/either.dart';
import '../../core/utils/failures.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseService service;

  TaskRepositoryImpl(this.service);

  @override
  Future<Either<Failure, List<TaskModel>>> fetchAll(String uid) async {
    try {
      final snap = await service
          .tasksCollection(uid)
          .orderBy('createdAt', descending: true)
          .get();
      final list = snap.docs.map(TaskModel.fromDoc).toList();
      return Right(list);
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, String>> add(String uid, TaskModel task) async {
    try {
      final ref = await service.tasksCollection(uid).add(task.toMap());
      return Right(ref.id);
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleDone(
      String uid, String taskId, bool done) async {
    try {
      await service.tasksCollection(uid).doc(taskId).update({'done': done});
      return const Right(null);
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> remove(String uid, String taskId) async {
    try {
      await service.tasksCollection(uid).doc(taskId).delete();
      return const Right(null);
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
