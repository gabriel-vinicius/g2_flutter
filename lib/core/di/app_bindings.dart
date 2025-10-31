import '../../features/tasks/viewmodel/tasks_viewmodel.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../data/services/firebase_service.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';



class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services externos (SDKs)
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance, permanent: true);

    // Service interno
    Get.put<FirebaseService>(
      FirebaseService(auth: Get.find(), store: Get.find()),
      permanent: true,
    );

    // Repositórios
    Get.put<TaskRepository>(TaskRepositoryImpl(Get.find()), permanent: true);

    // ViewModels
    Get.lazyPut<AuthViewModel>(() => AuthViewModel(Get.find()));
    Get.lazyPut<TasksViewModel>(() => TasksViewModel(Get.find(), Get.find()));
  }
}
