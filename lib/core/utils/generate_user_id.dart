String generateUserId(String phoneNumber) {
  return phoneNumber.replaceAll('+', '');
}
