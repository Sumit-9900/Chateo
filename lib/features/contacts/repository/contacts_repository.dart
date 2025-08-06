import 'package:chateo_app/features/contacts/model/chat_contact_model.dart';
import 'package:chateo_app/features/contacts/model/contact_model.dart';
import 'package:chateo_app/features/contacts/model/invite_contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

abstract class ContactsRepository {
  /// Request contacts permission from the user
  Future<Either<String, bool>> requestContactsPermission();

  /// Check if contacts permission is granted
  Future<bool> hasContactsPermission();

  /// Fetch all contacts from the device
  Future<Either<String, ContactModel>> getContacts(
    String currentUserPhoneNumber,
  );
}

class ContactsRepositoryImpl implements ContactsRepository {
  final FirebaseFirestore firestore;
  ContactsRepositoryImpl({required this.firestore});

  @override
  Future<Either<String, bool>> requestContactsPermission() async {
    try {
      final hasPermission = await FlutterContacts.requestPermission();

      if (hasPermission) {
        return const Right(true);
      } else {
        return const Left('Contacts permission denied');
      }
    } catch (e) {
      return Left('Error requesting contacts permission: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasContactsPermission() async {
    return await FlutterContacts.requestPermission();
  }

  @override
  Future<Either<String, ContactModel>> getContacts(
    String currentUserPhoneNumber,
  ) async {
    try {
      // Check if we have permission first
      final hasPermission = await FlutterContacts.requestPermission();
      if (!hasPermission) {
        return const Left('Contacts permission not granted');
      }

      // Fetch contacts with properties
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        sorted: true,
      );

      final snapshot = await firestore.collection('users').get();
      final phoneNumbers = snapshot.docs
          .map((doc) => doc['phoneNumber'].toString())
          .toSet();

      List<ChatContactModel> matched = [];
      List<InviteContactModel> notRegistered = [];

      for (final contact in contacts) {
        if (contact.phones.isEmpty) continue;

        final phoneNumber = contact.phones.first.number;
        // print('phoneNumber: $phoneNumber');

        if (phoneNumber == currentUserPhoneNumber) {
          matched.add(
            ChatContactModel(
              name: 'You',
              phoneNumber: phoneNumber,
              isSelf: true,
            ),
          );
        } else if (phoneNumbers.contains(phoneNumber)) {
          matched.add(
            ChatContactModel(
              name: contact.displayName,
              phoneNumber: phoneNumber,
              isSelf: false,
            ),
          );
        } else {
          notRegistered.add(
            InviteContactModel(
              name: contact.displayName,
              phoneNumber: phoneNumber,
            ),
          );
        }
      }

      // print('contacts: $contacts');

      return Right(
        ContactModel(matched: matched, notRegistered: notRegistered),
      );
    } catch (e) {
      return Left('Error fetching contacts: ${e.toString()}');
    }
  }
}
