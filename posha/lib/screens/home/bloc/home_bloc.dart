import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posha/screens/home/bloc/home_event.dart';
import 'package:posha/screens/home/bloc/home_state.dart';

/// Home Screen BLoC
/// Manages the bottom navigation index state
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeTabState(0)) {
    on<HomeTabChanged>(_onTabChanged);
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(HomeTabState(event.index));
  }
}
