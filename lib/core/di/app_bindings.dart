import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/services/firebase_service.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/tasks/viewmodel/tasks_viewmodel.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Firebase SDKs - Singletons
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance, permanent: true);

    // Service interno
    Get.put<FirebaseService>(
      FirebaseService(
        auth: Get.find<FirebaseAuth>(),
        store: Get.find<FirebaseFirestore>(),
      ),
      permanent: true,
    );

    // Repositórios
    Get.put<TaskRepository>(
      TaskRepositoryImpl(Get.find<FirebaseService>()),
      permanent: true,
    );

    // ViewModels (lazy loading)
    Get.lazyPut<AuthViewModel>(
      () => AuthViewModel(Get.find<FirebaseService>()),
    );
    Get.lazyPut<TasksViewModel>(
      () => TasksViewModel(
        Get.find<TaskRepository>(),
        Get.find<FirebaseAuth>(),
      ),
    );
  }
}
