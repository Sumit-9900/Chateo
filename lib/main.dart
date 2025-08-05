import 'package:chateo_app/features/auth/viewmodel/phone_auth_cubit.dart';
import 'package:chateo_app/features/auth/viewmodel/profile_cubit.dart';
import 'package:chateo_app/features/auth/viewmodel/profile_image_cubit.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_cubit.dart';
import 'package:chateo_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ .env file loaded successfully");
  } catch (e) {
    debugPrint("❌ Error loading .env file: $e");
    debugPrint("⚠️ Using hardcoded API secrets instead");
    // Continue without .env as we have ApiSecrets class as fallback
  }

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PhoneAuthCubit>(create: (_) => getIt<PhoneAuthCubit>()),
        BlocProvider<ProfileImageCubit>(
          create: (_) => getIt<ProfileImageCubit>(),
        ),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<ContactsCubit>(create: (_) => getIt<ContactsCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chateo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
