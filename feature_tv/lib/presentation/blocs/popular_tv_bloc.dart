import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_popular_tv_shows.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVBloc extends Bloc<PopularTVEvent, PopularTVState> {
  final GetPopularTVShows getPopularTVShows;

  PopularTVBloc({required this.getPopularTVShows})
      : super(PopularTVEmptyState()) {
    on<FetchNowPopularTVShows>((event, emit) async {
      emit(PopularTVLoadingState());
      final result = await getPopularTVShows.execute();

      result.fold((failure) {
        emit(PopularTVErrorState(message: failure.message));
      }, (data) {
        emit(PopularTVHasDataState(result: data));
      });
    });
  }
}

// State
abstract class PopularTVState extends Equatable {
  const PopularTVState();

  @override
  List<Object> get props => [];
}

class PopularTVEmptyState extends PopularTVState {}

class PopularTVLoadingState extends PopularTVState {}

class PopularTVErrorState extends PopularTVState {
  final String message;

  const PopularTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class PopularTVHasDataState extends PopularTVState {
  final List<TV> result;

  const PopularTVHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class PopularTVEvent extends Equatable {
  const PopularTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPopularTVShows extends PopularTVEvent {}
