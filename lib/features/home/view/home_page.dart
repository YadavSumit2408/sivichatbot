import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../../users/view/users_page.dart';
import '../../chat/view/chat_history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, int>(
      builder: (context, selectedTab) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F5F7),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: false,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  toolbarHeight: 70,
                  title: _AppBarSwitcher(
                    selectedIndex: selectedTab,
                    onTabChanged: (index) {
                      context.read<HomeCubit>().changeTab(index);
                    },
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
              ];
            },
            body: _buildBody(selectedTab),
          ),
        );
      },
    );
  }

  Widget _buildBody(int selectedTab) {
    switch (selectedTab) {
      case 0:
        return const UsersPage();
      case 1:
        return const ChatHistoryPage();
      default:
        return const UsersPage();
    }
  }
}

class _AppBarSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _AppBarSwitcher({
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SwitcherTab(
            label: 'Users',
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          const SizedBox(width: 4),
          _SwitcherTab(
            label: 'Chat History',
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _SwitcherTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SwitcherTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.green : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}