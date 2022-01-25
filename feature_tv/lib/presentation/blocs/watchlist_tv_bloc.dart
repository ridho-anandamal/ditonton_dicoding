import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVBloc extends Bloc<WatchlistTVEvent, WatchlistTVState> {
  final GetWatchlistTVShows getWatchlistTVShows;

  WatchlistTVBloc({required this.getWatchlistTVShows}) : super(WatchlistTVEmptyState()){
    on<FetchNowWatchlistTVShows>((event, emit) async {
      emit(WatchlistTVLoadingState());
      final result = await getWatchlistTVShows.execute();

      result.fold((failure) {
        emit(WatchlistTVErrorState(message: failure.message));
      }, (data) {
        emit(WatchlistTVHasDataState(result: data));
      });
    });
  }
}

// State
abstract class WatchlistTVState extends Equatable {
  const WatchlistTVState();

  @override
  List<Object> get props => [];
}

class WatchlistTVEmptyState extends WatchlistTVState {}

class WatchlistTVLoadingState extends WatchlistTVState {}

class WatchlistTVErrorState extends WatchlistTVState {
  final String message;

  const WatchlistTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class WatchlistTVHasDataState extends WatchlistTVState {
  final List<TV> result;

  const WatchlistTVHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class WatchlistTVEvent extends Equatable {
  const WatchlistTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowWatchlistTVShows extends WatchlistTVEvent {}
