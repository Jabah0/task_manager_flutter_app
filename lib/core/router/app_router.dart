import 'package:go_router/go_router.dart';
import 'package:task_manager/features/task/presentation/pages/task_detail_screen.dart';
import 'package:task_manager/features/task/presentation/pages/task_list_screen.dart';
import '../../features/task/data/models/task_model.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: RouteNames.taskDetail,
      builder: (context, state) {
        final task = state.extra as TaskModel;
        return TaskDetailScreen(task: task);
      },
    ),
  ],
);
