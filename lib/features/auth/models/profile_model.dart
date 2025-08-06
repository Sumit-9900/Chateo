class ProfileModel {
  final String phoneNumber;
  final String? profileImage;
  final String firstName;
  final String? lastName;

  ProfileModel({
    required this.phoneNumber,
    this.profileImage,
    required this.firstName,
    this.lastName,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  ProfileModel copyWith({
    String? phoneNumber,
    String? profileImage,
    String? firstName,
    String? lastName,
  }) {
    return ProfileModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  String toString() {
    return 'ProfileModel(phoneNumber: $phoneNumber, profileImage: $profileImage, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileModel &&
        other.phoneNumber == phoneNumber &&
        other.profileImage == profileImage &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode {
    return phoneNumber.hashCode ^
        profileImage.hashCode ^
        firstName.hashCode ^
        lastName.hashCode;
  }
}
