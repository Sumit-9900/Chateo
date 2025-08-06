// import 'package:flutter_contacts/flutter_contacts.dart';

// class ContactModel {
//   final String id;
//   final String displayName;
//   final String? phoneNumber;
//   final String? avatar;
//   final bool hasRegistered;

//   ContactModel({
//     required this.id,
//     required this.displayName,
//     this.phoneNumber,
//     this.avatar,
//     this.hasRegistered = false,
//   });

//   factory ContactModel.fromContact(Contact contact) {
//     String? phone;
//     if (contact.phones.isNotEmpty) {
//       phone = contact.phones.first.number;
//     }

//     return ContactModel(
//       id: contact.id,
//       displayName: contact.displayName,
//       phoneNumber: phone,
//       avatar: null, // We'll handle avatar conversion separately if needed
//     );
//   }

//   ContactModel copyWith({
//     String? id,
//     String? displayName,
//     String? phoneNumber,
//     String? avatar,
//     bool? hasRegistered,
//   }) {
//     return ContactModel(
//       id: id ?? this.id,
//       displayName: displayName ?? this.displayName,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       avatar: avatar ?? this.avatar,
//       hasRegistered: hasRegistered ?? this.hasRegistered,
//     );
//   }
// }

import 'package:chateo_app/features/contacts/model/chat_contact_model.dart';
import 'package:chateo_app/features/contacts/model/invite_contact_model.dart';

class ContactModel {
  final List<ChatContactModel> matched;
  final List<InviteContactModel> notRegistered;

  ContactModel({required this.matched, required this.notRegistered});
}
