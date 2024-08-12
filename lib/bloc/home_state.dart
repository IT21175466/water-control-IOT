part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class AuthenticatingInitialState extends HomeState {}

class AuthenticatingSucessState extends HomeState {}

class AuthenticatingErrorState extends HomeState {
  final String error;
  AuthenticatingErrorState({required this.error});
}

class WaterRequestingState extends HomeState {}

class WaterRequestingSucessState extends HomeState {}

class WaterRequestingErrorState extends HomeState {
  final String error;
  WaterRequestingErrorState({required this.error});
}
