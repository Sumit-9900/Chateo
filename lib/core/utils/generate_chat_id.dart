String generateChatId(String userA, String userB) {
  final sorted = [userA, userB]..sort();
  return '${sorted[0]}_${sorted[1]}';
}
