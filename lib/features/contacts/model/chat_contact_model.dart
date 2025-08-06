class ChatContactModel {
  final String name;
  final String phoneNumber;
  final bool? isSelf;
  ChatContactModel({
    required this.name,
    required this.phoneNumber,
    this.isSelf = false,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      isSelf: json['isSelf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phoneNumber': phoneNumber, 'isSelf': isSelf};
  }

  @override
  String toString() {
    return 'ChatContactModel{name: $name, phoneNumber: $phoneNumber, isSelf: $isSelf}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatContactModel &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.isSelf == isSelf;
  }

  @override
  int get hashCode {
    return Object.hash(name, phoneNumber, isSelf);
  }
}
