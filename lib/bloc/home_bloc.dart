import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:watercontroliot/repository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<WaterRequesingEvent>(waterRequesingEvent);
  }

  FutureOr<void> waterRequesingEvent(
      WaterRequesingEvent event, Emitter<HomeState> emit) async {
    HomeRepository homeRepo = HomeRepository();
    try {
      emit(WaterRequestingState());
      await homeRepo.updateWaterState(event.wellWater, event.waterBoard);
      emit(WaterRequestingSucessState());
    } catch (e) {
      emit(WaterRequestingErrorState(error: e.toString()));
    }
  }
}
