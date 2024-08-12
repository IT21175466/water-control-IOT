part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class AuthenticatingInitialEvent extends HomeEvent {
  final String email;
  final String password;
  AuthenticatingInitialEvent({required this.email, required this.password});
}

class WaterRequesingEvent extends HomeEvent {
  final int wellWater;
  final int waterBoard;
  WaterRequesingEvent({required this.wellWater, required this.waterBoard});
}
