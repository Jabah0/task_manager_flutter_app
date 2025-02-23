import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/features/task/data/datasources/task_local_data_source.dart';
import 'package:task_manager/features/task/domain/usecases/add_sub_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
import 'features/task/data/repositories/task_repository_impl.dart';
import 'features/task/domain/repositories/task_repository.dart';
import 'features/task/domain/usecases/add_task.dart';
import 'features/task/domain/usecases/get_tasks.dart';
import 'features/task/domain/usecases/change_task_status.dart';
import 'features/task/domain/usecases/change_task_priority.dart';
import 'features/task/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// Core Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  sl.registerLazySingleton(() => Hive.box(name: 'tasks'));

  /// Data Layer
  sl.registerLazySingleton<TaskLocalDataSource>(
      () => TaskLocalDataSourceImpl(tasksBox: sl()));

  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(localDataSource: sl()));

  /// Domain Layer (Use Cases)
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => AddSubTask(sl()));
  sl.registerLazySingleton(() => ChangeTaskStatus(sl()));
  sl.registerLazySingleton(() => ChangeTaskPriority(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  /// Presentation Layer (BLoC)
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      addTask: sl(),
      addSubTask: sl(),
      changeTaskStatus: sl(),
      changeTaskPriority: sl(),
      deleteTask: sl(),
    ),
  );
}
