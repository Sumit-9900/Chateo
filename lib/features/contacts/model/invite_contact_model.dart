class InviteContactModel {
  final String name;
  final String phoneNumber;
  InviteContactModel({required this.name, required this.phoneNumber});

  factory InviteContactModel.fromJson(Map<String, dynamic> json) {
    return InviteContactModel(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'phoneNumber': phoneNumber};
  }

  @override
  String toString() {
    return 'InviteContactModel{name: $name, phoneNumber: $phoneNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InviteContactModel &&
        other.name == name &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return Object.hash(name, phoneNumber);
  }
}
