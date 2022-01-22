import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies})
      : super(WatchlistMovieEmptyState()) {
    on<FetchNowWatchlistMovie>((event, emit) async {
      emit(WatchlistMovieLoadingState());
      final result = await getWatchlistMovies.execute();

      result.fold((failure) {
        emit(WatchlistMovieErrorState(message: failure.message));
      }, (data) {
        emit(WatchlistMovieHasDataState(result: data));
      });
    });
  }
}

// State
abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieEmptyState extends WatchlistMovieState {}

class WatchlistMovieLoadingState extends WatchlistMovieState {}

class WatchlistMovieErrorState extends WatchlistMovieState {
  final String message;

  WatchlistMovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class WatchlistMovieHasDataState extends WatchlistMovieState {
  final List<Movie> result;

  WatchlistMovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchNowWatchlistMovie extends WatchlistMovieEvent {}
