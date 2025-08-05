import 'dart:async';
import 'package:chateo_app/core/router/route_constants.dart';
import 'package:chateo_app/core/utils/show_snackbar.dart';
import 'package:chateo_app/core/widgets/loader.dart';
import 'package:chateo_app/features/auth/viewmodel/phone_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final pinController = TextEditingController();
  bool canResend = false;
  int resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    setState(() {
      canResend = false;
      resendTimer = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (resendTimer > 0) {
            resendTimer--;
          } else {
            canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void handleResendOtp() {
    if (canResend) {
      context.read<PhoneAuthCubit>().resendOtp();
      startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: AppTheme.lightTheme.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<PhoneAuthCubit, PhoneAuthState>(
        listener: (context, state) {
          if (state is PhoneAuthSuccess) {
            showSnackBar(
              context,
              message: 'Successfully verified!',
              color: Colors.green,
            );
            context.pushNamed(RouteConstants.profile, extra: widget.phoneNumber);
          } else if (state is PhoneAuthFailure) {
            showSnackBar(context, message: state.error, color: Colors.red);
            pinController.clear();
          } else if (state is PhoneAuthResendSuccess) {
            showSnackBar(
              context,
              message: 'OTP resent successfully!',
              color: Colors.green,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Code',
                style: AppTheme.lightTheme.textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'We have sent you an SMS with the code\nto ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Pinput(
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: defaultPinTheme,
                        controller: pinController,
                        enabled: state is! PhoneAuthLoading,
                        onCompleted: (pin) {
                          context.read<PhoneAuthCubit>().signInWithSmsCode(pin);
                        },
                      ),
                      if (state is PhoneAuthLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Loader(),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: canResend ? handleResendOtp : null,
                style: TextButton.styleFrom(
                  foregroundColor: canResend
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.5),
                ),
                child: Text(
                  canResend ? 'Resend Code' : 'Resend Code in ${resendTimer}s',
                  style: AppTheme.lightTheme.textTheme.labelLarge!.copyWith(
                    color: canResend
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
