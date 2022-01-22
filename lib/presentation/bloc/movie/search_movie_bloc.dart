import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies searchMovies;

  SearchMovieBloc({required this.searchMovies}) : super(SearchMovieEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchMovieLoading());
      final result = await searchMovies.execute(query);

      result.fold((failure) {
        emit(SearchMovieError(message: failure.message));
      }, (data) {
        emit(SearchMovieHasData(result: data));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}

// State
abstract class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

class SearchMovieEmpty extends SearchMovieState {}

class SearchMovieLoading extends SearchMovieState {}

class SearchMovieError extends SearchMovieState {
  final String message;

  SearchMovieError({required this.message});

  @override
  List<Object> get props => [message];
}

class SearchMovieHasData extends SearchMovieState {
  final List<Movie> result;
  SearchMovieHasData({required this.result});

  @override
  List<Object> get props => [result];
}


// Event
abstract class SearchMovieEvent extends Equatable{
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchMovieEvent{
  final String query;

  OnQueryChanged({required this.query});

  @override
  List<Object> get props => [query];
}