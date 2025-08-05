import 'package:chateo_app/features/chats/view/pages/chats_page.dart';
import 'package:chateo_app/features/contacts/view/pages/contacts_page.dart';
import 'package:chateo_app/features/home/viewmodel/cubit/home_cubit.dart';
import 'package:chateo_app/features/user/view/pages/user_page.dart';
import 'package:chateo_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [ChatsPage(), ContactsPage(), UserPage()];

    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: BlocSelector<HomeCubit, HomeState, int>(
        selector: (state) {
          if (state is HomeIndexChanged) {
            return state.index;
          }
          return 0;
        },
        builder: (context, selectedIndex) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                context.read<HomeCubit>().changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  label: 'Contacts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
            ),
            body: pages[selectedIndex],
          );
        },
      ),
    );
  }
}
