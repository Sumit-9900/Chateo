import 'package:chateo_app/features/contacts/model/contact_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

abstract class ContactsRepository {
  /// Request contacts permission from the user
  Future<Either<String, bool>> requestContactsPermission();

  /// Check if contacts permission is granted
  Future<bool> hasContactsPermission();

  /// Fetch all contacts from the device
  Future<Either<String, List<ContactModel>>> getContacts();
}

class ContactsRepositoryImpl implements ContactsRepository {
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
  Future<Either<String, List<ContactModel>>> getContacts() async {
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

      // print('contacts: $contacts');

      // Convert to our model
      final contactModels = contacts
          .where(
            (contact) =>
                contact.displayName.isNotEmpty && contact.phones.isNotEmpty,
          )
          .map((contact) => ContactModel.fromContact(contact))
          .toList();

      return Right(contactModels);
    } catch (e) {
      return Left('Error fetching contacts: ${e.toString()}');
    }
  }
}
