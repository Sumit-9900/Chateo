import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/auth_remote_repository.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final AuthRemoteRepository _authRemoteRepository;
  String? _phoneNumber;

  PhoneAuthCubit(this._authRemoteRepository) : super(PhoneAuthInitial());

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    emit(PhoneAuthLoading());
    try {
      _phoneNumber = phoneNumber;
      final result = await _authRemoteRepository.sendOtp(phoneNumber);

      result.fold(
        (failure) => emit(PhoneAuthFailure(failure.message)),
        (success) => emit(PhoneAuthCodeSent(phoneNumber)),
      );
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }

  Future<void> signInWithSmsCode(String smsCode) async {
    if (_phoneNumber == null) {
      emit(const PhoneAuthFailure('Phone number not found. Please try again'));
      return;
    }

    emit(PhoneAuthLoading());
    try {
      final result = await _authRemoteRepository.verifyOtp(
        phoneNumber: _phoneNumber!,
        otp: smsCode,
      );

      result.fold(
        (failure) => emit(PhoneAuthFailure(failure.message)),
        (success) => emit(PhoneAuthSuccess(_phoneNumber!)),
      );
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }

  Future<void> resendOtp() async {
    if (_phoneNumber == null) {
      emit(const PhoneAuthFailure('Phone number not found. Please try again'));
      return;
    }

    emit(PhoneAuthLoading());
    try {
      final result = await _authRemoteRepository.sendOtp(_phoneNumber!);

      result.fold(
        (failure) => emit(PhoneAuthFailure(failure.message)),
        (success) => emit(PhoneAuthResendSuccess(_phoneNumber!)),
      );
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }
}
