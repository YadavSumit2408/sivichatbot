// lib/features/home/cubit/home_state.dart
class HomeState {
  final int selectedTabIndex;

  const HomeState({required this.selectedTabIndex});

  HomeState copyWith({int? selectedTabIndex}) {
    return HomeState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}
