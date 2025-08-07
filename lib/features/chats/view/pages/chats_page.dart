import 'package:chateo_app/core/widgets/search_field.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
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
    return GestureDetector(
      onTap: () => searchFocusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Chats')),
        body: Column(
          children: [
            SearchField(
              controller: searchController,
              focusNode: searchFocusNode,
              onChanged: (value) {},
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                interactive: true,
                thickness: 12,
                radius: const Radius.circular(12),
                child: ListView(children: []),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
