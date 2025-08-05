import 'package:chateo_app/core/router/route_constants.dart';
import 'package:chateo_app/core/utils/show_snackbar.dart';
import 'package:chateo_app/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chateo_app/features/auth/viewmodel/phone_auth_cubit.dart';
import 'package:chateo_app/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();
  String? countryCode;

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneAuthCodeSent) {
          showSnackBar(
            context,
            message: 'Code sent to phone. Please check your SMS!',
            color: Colors.green,
          );
          context.pushNamed(
            RouteConstants.otp,
            extra: '$countryCode-${phoneController.text.trim()}',
          );
        } else if (state is PhoneAuthFailure) {
          showSnackBar(context, message: '${state.error}!', color: Colors.red);
        }
      },
      child: GestureDetector(
        onTap: () => phoneFocusNode.unfocus(),
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Your Phone Number',
                  style: AppTheme.lightTheme.textTheme.displayLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  'Please confirm your country code and enter your phone number',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: width / 1.17,
                  child: IntlPhoneField(
                    controller: phoneController,
                    focusNode: phoneFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      counterText: '',
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      countryCode = phone.countryCode;
                    },
                  ),
                ),
                const Spacer(),
                BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          phoneController.text.trim().isEmpty ||
                              state is PhoneAuthLoading
                          ? null
                          : () {
                              context.read<PhoneAuthCubit>().verifyPhoneNumber(
                                '$countryCode${phoneController.text.trim()}',
                              );
                            },
                      child: state is PhoneAuthLoading
                          ? const Loader()
                          : Text(
                              'Continue',
                              style: AppTheme.lightTheme.textTheme.labelLarge,
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
