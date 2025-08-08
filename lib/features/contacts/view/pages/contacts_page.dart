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
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContactsState state) {
    if (state is ContactsLoaded) {
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
}
