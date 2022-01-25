import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVBloc extends Bloc<TopRatedTVEvent, TopRatedTVState> {
  final GetTopRatedTVShows getTopRatedTVShows;

  TopRatedTVBloc({required this.getTopRatedTVShows})
      : super(TopRatedTVEmptyState()) {
    on<FetchNowTopRatedTVShows>((event, emit) async {
      emit(TopRatedTVLoadingState());
      final result = await getTopRatedTVShows.execute();

      result.fold((failure) {
        emit(TopRatedTVErrorState(message: failure.message));
      }, (data) {
        emit(TopRatedTVHasDataState(result: data));
      });
    });
  }
}

// State
abstract class TopRatedTVState extends Equatable {
  const TopRatedTVState();

  @override
  List<Object> get props => [];
}

class TopRatedTVEmptyState extends TopRatedTVState {}

class TopRatedTVLoadingState extends TopRatedTVState {}

class TopRatedTVErrorState extends TopRatedTVState {
  final String message;

  const TopRatedTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class TopRatedTVHasDataState extends TopRatedTVState {
  final List<TV> result;

  const TopRatedTVHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class TopRatedTVEvent extends Equatable {
  const TopRatedTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowTopRatedTVShows extends TopRatedTVEvent {}
