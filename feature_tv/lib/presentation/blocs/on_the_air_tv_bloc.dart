import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTVBloc extends Bloc<OnTheAirTVEvent, OnTheAirTVState> {
  final GetOnTheAirTVShows getOnTheAirTVShows;

  OnTheAirTVBloc({required this.getOnTheAirTVShows})
      : super(OnTheAirTVEmptyState()) {
    on<FetchNowOnTheAirTVShows>((event, emit) async {
      emit(OnTheAirTVLoadingState());
      final result = await getOnTheAirTVShows.execute();

      result.fold((failure) {
        emit(OnTheAirTVErrorState(message: failure.message));
      }, (data) {
        emit(OnTheAirTVHasDataState(result: data));
      });
    });
  }
}

// State
abstract class OnTheAirTVState extends Equatable {
  const OnTheAirTVState();

  @override
  List<Object> get props => [];
}

class OnTheAirTVEmptyState extends OnTheAirTVState {}

class OnTheAirTVLoadingState extends OnTheAirTVState {}

class OnTheAirTVErrorState extends OnTheAirTVState {
  final String message;

  const OnTheAirTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class OnTheAirTVHasDataState extends OnTheAirTVState {
  final List<TV> result;

  const OnTheAirTVHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class OnTheAirTVEvent extends Equatable {
  const OnTheAirTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowOnTheAirTVShows extends OnTheAirTVEvent {}
