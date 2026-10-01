import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_auth_state_stream.dart';
import '../../features/auth/domain/usecases/reset_password.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Onboarding
import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/check_onboarding_status.dart';
import '../../features/onboarding/domain/usecases/mark_onboarding_complete.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';

// Tasks
import '../../features/tasks/data/datasources/task_remote_data_source.dart';
import '../../features/tasks/data/repositories/task_repository_impl.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/domain/usecases/get_tasks_by_date.dart';
import '../../features/tasks/domain/usecases/get_tasks_for_month.dart';
import '../../features/tasks/domain/usecases/get_task_by_id.dart';
import '../../features/tasks/domain/usecases/create_task.dart';
import '../../features/tasks/domain/usecases/update_task.dart';
import '../../features/tasks/domain/usecases/delete_task.dart';
import '../../features/tasks/domain/usecases/toggle_task_completion.dart';
import '../../features/tasks/domain/usecases/change_task_status.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';

// Users
import '../../features/users/data/datasources/user_remote_data_source.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/domain/usecases/get_user_profile.dart';
import '../../features/users/domain/usecases/create_user_profile.dart';
import '../../features/users/domain/usecases/update_user_profile.dart';
import '../../features/users/domain/usecases/delete_user_profile.dart';
import '../../features/users/presentation/bloc/user_bloc.dart';

// Theme
import '../../features/theme/presentation/bloc/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core (e.g. Network info if any)

  // Features - Onboarding
  // Bloc
  sl.registerFactory(
    () => OnboardingBloc(
      checkOnboardingStatus: sl(),
      markOnboardingComplete: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckOnboardingStatus(sl()));
  sl.registerLazySingleton(() => MarkOnboardingComplete(sl()));

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sl()),
  );

  // Features - Auth
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);

  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      resetPassword: sl(),
      getAuthStateStream: sl(),
    ),
  );

  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl(), sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => GetAuthStateStream(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Features - Tasks
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firestore);

  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      getTasksByDate: sl(),
      getTasksForMonth: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      toggleTaskCompletion: sl(),
      changeTaskStatus: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => GetTasksByDate(sl()));
  sl.registerLazySingleton(() => GetTasksForMonth(sl()));
  sl.registerLazySingleton(() => GetTaskById(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => ToggleTaskCompletion(sl()));
  sl.registerLazySingleton(() => ChangeTaskStatus(sl()));

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl()),
  );

  // Features - Users
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => CreateUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => DeleteUserProfile(sl()));

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  // Users - Bloc
  sl.registerFactory(
    () => UserBloc(
      getUserProfile: sl(),
      createUserProfile: sl(),
      updateUserProfile: sl(),
      deleteUserProfile: sl(),
    ),
  );

  // Features - Theme
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(sl()),
  );
}
