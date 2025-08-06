import 'package:chateo_app/features/contacts/model/contact_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsPermissionRequested extends ContactsState {
  final bool granted;
  final String? message;

  const ContactsPermissionRequested({required this.granted, this.message});

  @override
  List<Object?> get props => [granted, message];
}

class ContactsLoaded extends ContactsState {
  final ContactModel contact;

  const ContactsLoaded({required this.contact});

  @override
  List<Object?> get props => [contact];
}

class ContactsError extends ContactsState {
  final String message;

  const ContactsError({required this.message});

  @override
  List<Object?> get props => [message];
}