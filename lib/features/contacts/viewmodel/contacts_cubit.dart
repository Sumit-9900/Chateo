import 'package:chateo_app/features/contacts/model/contact_model.dart';
import 'package:chateo_app/features/contacts/repository/contacts_repository.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactsRepository _repository;

  List<ContactModel> allContacts = [];

  ContactsCubit({required ContactsRepository repository})
    : _repository = repository,
      super(ContactsInitial());

  Future<void> requestContactsPermission() async {
    emit(ContactsLoading());

    final result = await _repository.requestContactsPermission();

    result.fold(
      (error) =>
          emit(ContactsPermissionRequested(granted: false, message: error)),
      (granted) => emit(ContactsPermissionRequested(granted: granted)),
    );
  }

  Future<void> loadContacts() async {
    emit(ContactsLoading());

    // Check if we have permission first
    final hasPermission = await _repository.hasContactsPermission();
    if (!hasPermission) {
      emit(const ContactsError(message: 'Contacts permission not granted'));
      return;
    }

    final result = await _repository.getContacts();

    result.fold((error) => emit(ContactsError(message: error)), (contacts) {
      allContacts = contacts;
      emit(ContactsLoaded(contacts: contacts));
    });
  }

  void searchContacts(String query) async {
    if (query.isEmpty) {
      emit(ContactsLoaded(contacts: allContacts));
      return;
    }

    final filtered = allContacts.where((contact) {
      final name = contact.displayName.toLowerCase();
      final number = (contact.phoneNumber ?? '').toLowerCase();
      final q = query.toLowerCase();
      return name.contains(q) || number.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(const ContactsLoaded(contacts: []));
    } else {
      emit(ContactsLoaded(contacts: filtered));
    }
  }
}
