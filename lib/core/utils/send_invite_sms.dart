import 'package:url_launcher/url_launcher.dart';

void sendInviteSms({
  required String phoneNumber,
  required String message,
}) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: {'body': message},
  );

  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    throw 'Could not launch $smsUri';
  }
}
