part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeIndexChanged extends HomeState {
  const HomeIndexChanged(this.index);
  final int index;

  @override
  List<Object> get props => [index];
}
