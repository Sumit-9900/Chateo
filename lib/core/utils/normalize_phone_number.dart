String normalizePhoneNumber(String phone) {
  // Remove everything except digits
  final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
  // Keep only last 10 digits (valid Indian number)
  return digitsOnly.length >= 10
      ? digitsOnly.substring(digitsOnly.length - 10)
      : digitsOnly;
}
