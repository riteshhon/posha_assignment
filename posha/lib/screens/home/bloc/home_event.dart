import 'package:equatable/equatable.dart';

/// Home Screen Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Event to change the bottom navigation index
class HomeTabChanged extends HomeEvent {
  final int index;

  const HomeTabChanged(this.index);

  @override
  List<Object> get props => [index];
}
