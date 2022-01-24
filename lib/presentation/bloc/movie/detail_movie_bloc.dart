import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail getMovieDetail;

  DetailMovieBloc({
    required this.getMovieDetail,
  }) : super(DetailMovieEmptyState()) {
    on<FetchNowDetailMovie>((event, emit) async {
      final id = event.id;

      emit(DetailMovieLoadingState());
      final result = await getMovieDetail.execute(id);

      result.fold((failure) {
        emit(DetailMovieErrorState(message: failure.message));
      }, (dataDetail) {
        emit(DetailMovieHasDataState(result: dataDetail));
      });
    });
  }
}

// State
abstract class DetailMovieState extends Equatable {
  const DetailMovieState();

  @override
  List<Object> get props => [];
}

class DetailMovieEmptyState extends DetailMovieState {}

class DetailMovieLoadingState extends DetailMovieState {}

class DetailMovieErrorState extends DetailMovieState {
  final String message;

  DetailMovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class DetailMovieHasDataState extends DetailMovieState {
  final MovieDetail result;

  DetailMovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchNowDetailMovie extends DetailMovieEvent {
  final int id;

  FetchNowDetailMovie({required this.id});

  @override
  List<Object> get props => [id];
}
