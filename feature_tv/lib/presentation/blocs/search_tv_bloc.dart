import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/search_tv_shows.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchTVBloc extends Bloc<SearchTVEvent, SearchTVState> {
  final SearchTVShows searchTVShows;

  SearchTVBloc({required this.searchTVShows}) : super(SearchTVEmptyState()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchTVLoadingState());
      final result = await searchTVShows.execute(query);

      result.fold((failure) {
        emit(SearchTVErrorState(message: failure.message));
      }, (data) {
        emit(SearchTVHasDataState(result: data));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) =>
      (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

// State
abstract class SearchTVState extends Equatable {
  const SearchTVState();

  @override
  List<Object> get props => [];
}

class SearchTVEmptyState extends SearchTVState {}

class SearchTVLoadingState extends SearchTVState {}

class SearchTVErrorState extends SearchTVState {
  final String message;

  const SearchTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class SearchTVHasDataState extends SearchTVState {
  final List<TV> result;

  const SearchTVHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class SearchTVEvent extends Equatable {
  const SearchTVEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchTVEvent {
  final String query;

  const OnQueryChanged({required this.query});

  @override
  List<Object> get props => [query];
}
