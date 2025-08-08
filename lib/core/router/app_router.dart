import 'package:chateo_app/features/auth/repository/auth_local_repository.dart';
import 'package:chateo_app/features/auth/view/pages/otp_page.dart';
import 'package:chateo_app/features/auth/view/pages/phone_page.dart';
import 'package:chateo_app/features/auth/view/pages/profile_page.dart';
import 'package:chateo_app/features/chats/view/pages/chat_page.dart';
import 'package:chateo_app/features/contacts/model/chat_contact_model.dart';
import 'package:chateo_app/features/home/view/pages/home_page.dart';
import 'package:chateo_app/features/onboarding/view/pages/onboarding_page.dart';
import 'package:chateo_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_constants.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.onboardingPath,
  routes: [
    GoRoute(
      name: RouteConstants.onboarding,
      path: RouteConstants.onboardingPath,
      builder: (context, state) => const OnboardingPage(),
    ),
    // Add more routes as needed
    GoRoute(
      name: RouteConstants.phoneAuth,
      path: RouteConstants.phoneAuthPath,
      builder: (context, state) => const PhonePage(),
    ),
    GoRoute(
      name: RouteConstants.otp,
      path: RouteConstants.otpPath,
      builder: (context, state) {
        final phoneNumber = state.extra as String;
        return OtpPage(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      name: RouteConstants.profile,
      path: RouteConstants.profilePath,
      builder: (context, state) {
        final phoneNumber = state.extra as String;
        return ProfilePage(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      name: RouteConstants.home,
      path: RouteConstants.homePath,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: RouteConstants.chat,
      path: RouteConstants.chatPath,
      builder: (context, state) {
        final chatContact = state.extra as ChatContactModel;
        return ChatPage(chatContact: chatContact);
      },
    ),
  ],
  redirect: (context, state) {
    if (state.matchedLocation == RouteConstants.onboardingPath) {
      if (getIt<AuthLocalRepository>().getAuthenticatedStatus()) {
        return RouteConstants.homePath;
      }
    }
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Error: ${state.error}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  ),
);
