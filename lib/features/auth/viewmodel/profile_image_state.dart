part of 'profile_image_cubit.dart';

abstract class ProfileImageState extends Equatable {
  const ProfileImageState();

  @override
  List<Object?> get props => [];
}

class ProfileImageInitial extends ProfileImageState {}

class ProfileImageLoading extends ProfileImageState {}

class ProfileImageSelected extends ProfileImageState {
  final String imagePath;

  const ProfileImageSelected(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ProfileImageError extends ProfileImageState {
  final String error;

  const ProfileImageError(this.error);

  @override
  List<Object?> get props => [error];
}
