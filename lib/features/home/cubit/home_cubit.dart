// lib/features/home/cubit/home_cubit.dart
import 'package:bloc/bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(selectedTabIndex: 0));

  // Updates the selected top tab index
  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}
