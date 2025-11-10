import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_twitte_clone/features/auth/data/datasource/session_local.dart';
import 'package:flutter_twitte_clone/features/auth/data/repository/supabase_auth_repository.dart';
import 'package:flutter_twitte_clone/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/login_user_case.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/register_user_case.dart';
import 'package:flutter_twitte_clone/features/feed/data/repository/supabase_post_respository.dart';

import 'package:flutter_twitte_clone/features/feed/domain/repository/post_repository.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/create_post_use_case.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/fetch_post_use_case.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/like_post_use_case.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/unlike_post_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ✅ 基础依赖
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSourceImpl(secureStorage: sl()),
  );

  // ✅ Service
  sl.registerLazySingleton<UserSessionService>(
    () => UserSessionService(sessionLocalDataSource: sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<AuthRepository>(
    () => SupabaseAuthRepository(client: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => SupabasePostRespository(client: sl()),
  );

  // ✅ UseCases（一定要写泛型！）
  sl.registerFactory<RegisterUserCase>(
    () => RegisterUserCase(authRepository: sl()),
  );
  sl.registerFactory<LoginUserCase>(() => LoginUserCase(authRepository: sl()));
  sl.registerFactory<FetchPostUseCase>(
    () => FetchPostUseCase(postRepository: sl()),
  );
  sl.registerFactory<CreatePostUseCase>(
    () => CreatePostUseCase(postRepository: sl()),
  );

  sl.registerFactory<LikePostUseCase>(
    () => LikePostUseCase(postRepository: sl()),
  );

  sl.registerFactory<UnLikePostUseCase>(
    () => UnLikePostUseCase(postRepository: sl()),
  );
}
