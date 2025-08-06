import 'dart:developer';

import 'package:chateo_app/core/widgets/loader.dart';
import 'package:chateo_app/core/widgets/search_field.dart';
import 'package:chateo_app/features/contacts/model/contact_model.dart';
import 'package:chateo_app/features/contacts/view/widgets/contact_item.dart';
import 'package:chateo_app/features/contacts/view/widgets/contacts_empty_widget.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_cubit.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Contacts')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ContactsState state) {
    if (state is ContactsInitial) {
      // Request permission when the page is first loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ContactsCubit>().requestContactsPermission();
      });
      return const ContactsEmptyWidget(message: 'Initializing contacts...');
    } else if (state is ContactsLoading) {
      return const Loader();
    } else if (state is ContactsPermissionRequested) {
      if (state.granted) {
        // If permission granted, load contacts
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ContactsCubit>().loadContacts();
        });
        return const Loader();
      } else {
        // If permission denied, show message with retry button
        return ContactsEmptyWidget(
          message: state.message ?? 'Permission to access contacts was denied',
          onActionPressed: () {
            context.read<ContactsCubit>().requestContactsPermission();
          },
          actionLabel: 'Grant Permission',
        );
      }
    } else if (state is ContactsLoaded) {
      return _buildContactsList(context, state.contact);
    } else if (state is ContactsError) {
      return ContactsEmptyWidget(
        message: 'Error: ${state.message}',
        onActionPressed: () {
          context.read<ContactsCubit>().loadContacts();
        },
        actionLabel: 'Retry',
      );
    }

    // Fallback
    return const ContactsEmptyWidget(message: 'Something went wrong');
  }

  Widget _buildContactsList(BuildContext context, ContactModel contact) {
    final matchedContacts = contact.matched;
    final notRegisteredContacts = contact.notRegistered;

    log('matchedContacts: $matchedContacts');
    log('notRegisteredContacts: $notRegisteredContacts');

    return GestureDetector(
      onTap: () => searchFocusNode.unfocus(),
      child: Column(
        children: [
          SearchField(
            controller: searchController,
            focusNode: searchFocusNode,
            onChanged: (value) {
              // Future search logic
              context.read<ContactsCubit>().searchContacts(value.trim());
            },
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              interactive: true,
              thickness: 12,
              radius: const Radius.circular(12),
              child: ListView(
                children: [
                  if (matchedContacts.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Text(
                        'Contacts on Chateo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ...matchedContacts.map((contact) {
                      return ContactItem(
                        matchedContact: contact,
                        isMatched: true,
                      );
                    }),
                  ],
                  if (notRegisteredContacts.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Text(
                        'Invite to Chateo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ...notRegisteredContacts.map((contact) {
                      return ContactItem(
                        inviteContact: contact,
                        isMatched: false,
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  Widget _buildContactsList(BuildContext context, ContactModel contact) {
    final matchedContacts = contact.matched;
    final notRegisteredContacts = contact.notRegistered;

    return GestureDetector(
      onTap: () => searchFocusNode.unfocus(),
      child: Column(
        children: [
          SearchField(
            controller: searchController,
            focusNode: searchFocusNode,
            onChanged: (value) {
              // Handle search
              // context.read<ContactsCubit>().searchContacts(value);
            },
          ),
          Expanded(
            child: matchedContacts.isEmpty
                ? const ContactsEmptyWidget(message: 'No contacts found!')
                : Column(
                    children: [
                      Text(
                        'Contacts on Chateo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Scrollbar(
                        thumbVisibility: true,
                        interactive: true,
                        thickness: 12,
                        radius: const Radius.circular(12),
                        child: ListView.builder(
                          itemCount: matchedContacts.length,
                          itemBuilder: (context, index) {
                            final contact = matchedContacts[index];
                            return ContactItem(
                              matchedContact: contact,
                              onTap: () {},
                              isMatched: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            'Invite to Chateo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Scrollbar(
            thumbVisibility: true,
            interactive: true,
            thickness: 12,
            radius: const Radius.circular(12),
            child: ListView.builder(
              itemCount: notRegisteredContacts.length,
              itemBuilder: (context, index) {
                final contact = notRegisteredContacts[index];
                return ContactItem(
                  inviteContact: contact,
                  onTap: () {},
                  isMatched: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  */
}
