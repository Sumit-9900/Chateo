import 'package:chateo_app/core/router/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../models/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<OnboardingModel> _pages = [
    OnboardingModel(
      title: 'Connect easily with your family and friends over countries',
      image: 'assets/images/walkthrough_illustration.svg',
    ),
    // You can add more pages if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: () {
            context.pushNamed(RouteConstants.phoneAuth);
          },
          child: const Text('Get Started'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Center(
                            child: SvgPicture.asset(
                              _pages[0].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Title
                    Text(
                      _pages[0].title,
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
