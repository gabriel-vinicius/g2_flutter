import 'package:get/get.dart';
import '../../features/auth/view/auth_view.dart';
import '../../features/tasks/view/tasks_view.dart';
import '../di/app_bindings.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.tasks,
      page: () => const TasksView(),
      binding: AppBindings(),
    ),
  ];
}
