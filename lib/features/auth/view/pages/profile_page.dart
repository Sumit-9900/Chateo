import 'dart:io';
import 'package:chateo_app/core/router/route_constants.dart';
import 'package:chateo_app/core/utils/show_snackbar.dart';
import 'package:chateo_app/core/widgets/input_field.dart';
import 'package:chateo_app/features/auth/viewmodel/profile_cubit.dart';
import 'package:chateo_app/features/auth/viewmodel/profile_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chateo_app/core/theme/app_colors.dart';
import 'package:chateo_app/core/widgets/loader.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  final String phoneNumber;
  const ProfilePage({super.key, required this.phoneNumber});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          showSnackBar(
            context,
            message: 'Profile updated successfully!',
            color: Colors.green,
          );
          context.goNamed(RouteConstants.home);
          // print('phone number 3: ${widget.phoneNumber}');
        } else if (state is ProfileFailure) {
          showSnackBar(
            context,
            message: '${state.message}!',
            color: Colors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Profile')),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Profile Image Stack
                        Stack(
                          children: [
                            BlocBuilder<ProfileImageCubit, ProfileImageState>(
                              builder: (context, state) {
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      AppColors.textFieldBackgroundColor,
                                  backgroundImage: state is ProfileImageSelected
                                      ? FileImage(File(state.imagePath))
                                      : null,
                                  child: state is! ProfileImageSelected
                                      ? const Icon(
                                          Icons.person_outline,
                                          size: 40,
                                          color: AppColors.textPrimary,
                                        )
                                      : null,
                                );
                              },
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<ProfileImageCubit>()
                                      .showImageSourceDialog(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.textPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        InputField(
                          hintText: 'First Name (Required)',
                          controller: firstNameController,
                          focusNode: firstNameFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'First Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        InputField(
                          hintText: 'Last Name (Optional)',
                          controller: lastNameController,
                          focusNode: lastNameFocusNode,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Save Button
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                    return BlocBuilder<ProfileImageCubit, ProfileImageState>(
                      builder: (context, imageState) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: profileState is ProfileLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<ProfileCubit>().saveProfile(
                                        phoneNumber: widget.phoneNumber,
                                        firstName: firstNameController.text
                                            .trim(),
                                        lastName:
                                            lastNameController.text.isEmpty
                                            ? ''
                                            : lastNameController.text.trim(),
                                        imagePath:
                                            imageState is ProfileImageSelected
                                            ? imageState.imagePath
                                            : null,
                                      );
                                    }
                                  },
                            child: profileState is ProfileLoading
                                ? const Loader()
                                : const Text('Save'),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
