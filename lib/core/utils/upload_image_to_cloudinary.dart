import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> uploadImageToCloudinary(File imageFile, String uniqueId) async {
  final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
  final apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;
  final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;

  final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  final publicId = '$uniqueId/user_image';

  // Create signature string with all parameters that will be sent
  // Parameters must be in alphabetical order as per Cloudinary requirements
  final Map<String, String> params = {
    'public_id': publicId,
    'timestamp': timestamp.toString(),
    'upload_preset': uploadPreset,
    'overwrite': 'true',
  };

  // Sort parameters alphabetically and create signature string
  final List<String> sortedKeys = params.keys.toList()..sort();
  final StringBuffer signatureBuffer = StringBuffer();

  for (final key in sortedKeys) {
    signatureBuffer.write('$key=${params[key]}&');
  }

  // Remove the trailing '&' and append the API secret
  String paramsToSign = signatureBuffer.toString();
  if (paramsToSign.endsWith('&')) {
    paramsToSign = paramsToSign.substring(0, paramsToSign.length - 1);
  }
  paramsToSign += apiSecret;

  final signature = sha1.convert(utf8.encode(paramsToSign)).toString();

  final url = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
  );

  final request = http.MultipartRequest('POST', url)
    ..fields['timestamp'] = timestamp.toString()
    ..fields['signature'] = signature
    ..fields['api_key'] = apiKey
    ..fields['upload_preset'] = uploadPreset
    ..fields['public_id'] = publicId
    ..fields['overwrite'] = 'true'
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  debugPrint('🔥 Request: ${request.fields}');

  final response = await request.send();

  debugPrint('🔥 Response: ${response.statusCode}');

  final responseData = await response.stream.toBytes();
  final responseString = String.fromCharCodes(responseData);

  debugPrint('🔥 Full response: $responseString');

  if (response.statusCode == 200) {
    final data = jsonDecode(responseString);
    debugPrint('✅ Uploaded: ${data['url']}');
    return data['url'];
  } else {
    debugPrint('❌ Upload failed with status: ${response.statusCode}');
    debugPrint('❌ Error response: $responseString');
    throw Exception('Upload failed with status: ${response.statusCode}');
  }
}
