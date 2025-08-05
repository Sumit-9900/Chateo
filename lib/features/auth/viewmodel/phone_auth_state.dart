part of 'phone_auth_cubit.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthCodeSent extends PhoneAuthState {
  final String phoneNumber;
  const PhoneAuthCodeSent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneAuthResendSuccess extends PhoneAuthState {
  final String phoneNumber;
  const PhoneAuthResendSuccess(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneAuthSuccess extends PhoneAuthState {
  final String phoneNumber;
  const PhoneAuthSuccess(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneAuthFailure extends PhoneAuthState {
  final String error;
  const PhoneAuthFailure(this.error);

  @override
  List<Object> get props => [error];
}
