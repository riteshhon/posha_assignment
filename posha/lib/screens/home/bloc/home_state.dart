import 'package:equatable/equatable.dart';

/// Home Screen States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

/// Initial state with default index 0
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// State containing the current bottom navigation index
class HomeTabState extends HomeState {
  final int currentIndex;

  const HomeTabState(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}
