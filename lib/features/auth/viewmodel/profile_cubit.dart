import 'package:chateo_app/features/auth/repository/auth_local_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_remote_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRemoteRepository _remoteRepository;
  final AuthLocalRepository _localRepository;

  ProfileCubit({
    required AuthRemoteRepository remoteRepository,
    required AuthLocalRepository localRepository,
  }) : _remoteRepository = remoteRepository,
       _localRepository = localRepository,
       super(ProfileInitial());

  Future<void> saveProfile({
    required String phoneNumber,
    required String firstName,
    String? lastName,
    String? imagePath,
  }) async {
    try {
      emit(ProfileLoading());

      final result = await _remoteRepository.storeProfileData(
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        profileImage: imagePath,
      );

      result.fold((failure) => emit(ProfileFailure(failure.message)), (
        _,
      ) async {
        try {
          await _localRepository.setAuthenticatedStatus();
          emit(const ProfileSuccess());
        } catch (e) {
          emit(ProfileFailure('Failed to save auth status: ${e.toString()}'));
        }
      });
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
