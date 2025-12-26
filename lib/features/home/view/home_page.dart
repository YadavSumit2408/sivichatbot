import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../users/view/users_page.dart';
import '../../chat/view/chat_history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final selectedTab = state.selectedTabIndex;

        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: NestedScrollView(
              headerSliverBuilder: (_, __) => [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  title: _TopTabSwitcher(selectedTab: selectedTab),
                ),
              ],
              body: IndexedStack(
                index: selectedTab,
                children: const [
                  UsersPage(key: PageStorageKey('users')),
                  ChatHistoryPage(key: PageStorageKey('history')),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}

class _TopTabSwitcher extends StatelessWidget {
  final int selectedTab;

  const _TopTabSwitcher({
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabButton(
            label: 'Users',
            isSelected: selectedTab == 0,
            onTap: () => context.read<HomeCubit>().changeTab(0),
          ),
          _TabButton(
            label: 'Chat History',
            isSelected: selectedTab == 1,
            onTap: () => context.read<HomeCubit>().changeTab(1),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.grey,
            fontSize: 14
          ),
        ),
      ),
    );
  }
}
