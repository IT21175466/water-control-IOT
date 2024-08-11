import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:watercontroliot/repository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<AuthenticatingInitialEvent>(authenticatingInitialEvent);
  }

  FutureOr<void> authenticatingInitialEvent(
      AuthenticatingInitialEvent event, Emitter<HomeState> emit) async {
    HomeRepository homeRepository = HomeRepository();

    try {
      emit(AuthenticatingInitialState());
      await homeRepository.loginSplashUser(
        email: event.email,
        password: event.password,
      );
      emit(AuthenticatingSucessState());
    } on FirebaseAuthException catch (e) {
      emit(AuthenticatingErrorState(error: e.code));
    } catch (e) {
      emit(AuthenticatingErrorState(error: e.toString()));
    }
  }
}
