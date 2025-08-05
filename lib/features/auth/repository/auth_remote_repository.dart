import 'dart:convert';
import 'dart:io';

import 'package:chateo_app/core/failure/app_failure.dart';
import 'package:chateo_app/core/utils/generate_user_id.dart';
import 'package:chateo_app/core/utils/upload_image_to_cloudinary.dart';
import 'package:chateo_app/features/auth/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthRemoteRepository {
  Future<Either<AppFailure, Map<String, dynamic>>> sendOtp(String phoneNumber);
  Future<Either<AppFailure, Map<String, dynamic>>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });
  Future<Either<AppFailure, void>> storeProfileData({
    required String phoneNumber,
    required String firstName,
    required String? lastName,
    required String? profileImage,
  });
}

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final http.Client client;
  final FirebaseFirestore firestore;
  AuthRemoteRepositoryImpl({required this.client, required this.firestore});

  final accountSid = dotenv.env['TWILIO_ACCOUNT_SID']!;
  final authToken = dotenv.env['TWILIO_AUTH_TOKEN']!;
  final serviceSid = dotenv.env['TWILIO_SERVICE_SID']!;

  @override
  Future<Either<AppFailure, Map<String, dynamic>>> sendOtp(
    String phoneNumber,
  ) async {
    final url =
        'https://verify.twilio.com/v2/Services/$serviceSid/Verifications';

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'To': phoneNumber, 'Channel': 'sms'},
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return right(data);
      } else {
        return left(AppFailure(message: 'Failed to send OTP'));
      }
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Map<String, dynamic>>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final url =
        'https://verify.twilio.com/v2/Services/$serviceSid/VerificationCheck';

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'To': phoneNumber, 'Code': otp},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'approved') {
          return right(data);
        } else {
          return left(AppFailure(message: 'Invalid OTP code'));
        }
      } else {
        return left(AppFailure(message: 'Failed to verify OTP'));
      }
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> storeProfileData({
    required String phoneNumber,
    required String firstName,
    required String? lastName,
    required String? profileImage,
  }) async {
    try {
      final userId = generateUserId(phoneNumber);
      String imageUrl = '';
      
      // Only attempt to upload if profileImage is not null and not empty
      if (profileImage != null && profileImage.isNotEmpty) {
        imageUrl = await uploadImageToCloudinary(File(profileImage), userId);
      }

      final profileData = ProfileModel(
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName ?? '',
        profileImage: imageUrl,
      );

      await firestore.collection('users').doc(userId).set(profileData.toJson());

      return right(null);
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }
}
