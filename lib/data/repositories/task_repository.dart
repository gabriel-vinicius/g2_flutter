import '../../core/utils/either.dart';
import '../../core/utils/failures.dart';
import '../models/task_model.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskModel>>> fetchAll(String uid);
  Future<Either<Failure, String>> add(String uid, TaskModel task);
  Future<Either<Failure, void>> toggleDone(String uid, String taskId, bool done);
  Future<Either<Failure, void>> remove(String uid, String taskId);
}
