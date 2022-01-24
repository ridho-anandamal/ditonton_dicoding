import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendationMovieBloc extends Bloc<RecommendationMovieEvent, RecommendationMovieState>{
  final GetMovieRecommendations getMovieRecommendations;

  RecommendationMovieBloc({required this.getMovieRecommendations}): super(RecommendationMovieEmptyState()) {
    on<FetchNowRecommendationMovie> ((event, emit) async {
      final id = event.id;
      emit(RecommendationMovieLoadingState());

      final result = await getMovieRecommendations.execute(id);

      result.fold((failure) {
        emit(RecommendationMovieErrorState(message: failure.message));
      }, (dataDetail) {
        emit(RecommendationMovieHasDataState(result: dataDetail));
      });
    });
  }
}

abstract class RecommendationMovieState extends Equatable {
  const RecommendationMovieState();

  @override
  List<Object> get props => [];
}

class RecommendationMovieEmptyState extends RecommendationMovieState {}

class RecommendationMovieLoadingState extends RecommendationMovieState {}

class RecommendationMovieErrorState extends RecommendationMovieState {
  final String message;

  RecommendationMovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class RecommendationMovieHasDataState extends RecommendationMovieState {
  final List<Movie> result;

  RecommendationMovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class RecommendationMovieEvent extends Equatable {
  const RecommendationMovieEvent();

  @override
  List<Object> get props => [];
}


class FetchNowRecommendationMovie extends RecommendationMovieEvent {
  final int id;

  FetchNowRecommendationMovie({required this.id});

  @override
  List<Object> get props => [id];
}