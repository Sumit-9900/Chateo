import 'package:chateo_app/features/auth/repository/auth_local_repository.dart';
import 'package:chateo_app/features/auth/repository/auth_remote_repository.dart';
import 'package:chateo_app/features/auth/viewmodel/phone_auth_cubit.dart';
import 'package:chateo_app/features/auth/viewmodel/profile_cubit.dart';
import 'package:chateo_app/features/auth/viewmodel/profile_image_cubit.dart';
import 'package:chateo_app/features/chats/repository/chats_remote_repository.dart';
import 'package:chateo_app/features/chats/viewmodel/cubit/chats_cubit.dart';
import 'package:chateo_app/features/contacts/repository/contacts_local_repository.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_cubit.dart';
import 'package:chateo_app/features/home/viewmodel/cubit/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chateo_app/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final client = http.Client();
  final firestore = FirebaseFirestore.instance;
  final sharedPreferences = await SharedPreferences.getInstance();

  // Repository
  getIt.registerFactory<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(client: client, firestore: firestore),
  );

  getIt.registerFactory<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(sharedPreferences),
  );

  getIt.registerFactory<ContactsLocalRepository>(
    () => ContactsLocalRepositoryImpl(firestore: firestore),
  );

  getIt.registerFactory<ChatsRemoteRepository>(
    () => ChatsRemoteRepositoryImpl(firestore: firestore),
  );

  // Cubit
  getIt.registerLazySingleton(() => PhoneAuthCubit(getIt()));
  getIt.registerLazySingleton(() => ProfileImageCubit());
  getIt.registerLazySingleton(
    () => ProfileCubit(remoteRepository: getIt(), localRepository: getIt()),
  );
  getIt.registerLazySingleton(() => HomeCubit());
  getIt.registerLazySingleton(() => ContactsCubit(repository: getIt()));
  getIt.registerFactory(() => ChatsCubit(chatsRemoteRepository: getIt()));
}
