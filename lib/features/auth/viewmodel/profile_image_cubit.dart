import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_image_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  final ImagePicker _picker = ImagePicker();
  ProfileImageCubit() : super(ProfileImageInitial());

  Future<void> pickImage({
    required bool isCamera,
    double? maxWidth = 300,
    double? maxHeight = 300,
    int? imageQuality = 85,
  }) async {
    try {
      emit(ProfileImageLoading());

      final XFile? pickedFile = await _picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        emit(ProfileImageSelected(pickedFile.path));
      } else {
        emit(ProfileImageInitial());
      }
    } catch (e) {
      emit(ProfileImageError('Failed to pick image: $e'));
    }
  }

  Future<void> showImageSourceDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Select Image Source',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickImage(isCamera: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                pickImage(isCamera: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    emit(ProfileImageInitial());
  }
}
