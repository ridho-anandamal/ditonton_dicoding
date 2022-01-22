import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  bool isAddedToWatchlist = false;

  DetailMovieBloc(
      {required this.getMovieDetail,
      required this.getMovieRecommendations,
      required this.getWatchListStatus,
      required this.saveWatchlist,
      required this.removeWatchlist})
      : super(DetailMovieEmptyState()) {
    on<FetchNowDetailMovie>((event, emit) async {
      final id = event.id;

      emit(DetailMovieLoadingState());
      final resultDetail = await getMovieDetail.execute(id);
      final resultRecommendation = await getMovieRecommendations.execute(id);
      final resultIsAddedToWatchlist = await getWatchListStatus.execute(id);

      resultDetail.fold((failure) {
        emit(DetailMovieErrorState(message: failure.message));
      }, (dataDetail) {
        resultRecommendation.fold((failure) {
          emit(DetailMovieErrorState(message: failure.message));
        }, (dataRecommendation) {
          emit(DetailMovieHasDataState(
            resultDetail: dataDetail,
            resultRecommendation: dataRecommendation,
            isAddedToWatchlist: resultIsAddedToWatchlist,
          ));
        });
      });
    });

    on<ActionAddWatchlistMovie>((event, emit) async {
      final movie = event.movie;

      final result = await saveWatchlist.execute(movie);
      final resultIsAddedToWatchlist =
          await getWatchListStatus.execute(movie.id);

      result.fold((failure) {
        emit(WatchlistMessageState(
          message: failure.message,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      }, (successMessage) {
        emit(WatchlistMessageState(
          message: successMessage,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      });

      await loadWatchlistStatus(movie.id);
    });

    on<ActionRemoveFromWatchlistMovie>((event, emit) async {
      final movie = event.movie;

      final result = await removeWatchlist.execute(movie);
      final resultIsAddedToWatchlist =
          await getWatchListStatus.execute(movie.id);

      result.fold((failure) {
        emit(WatchlistMessageState(
          message: failure.message,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      }, (successMessage) {
        emit(WatchlistMessageState(
          message: successMessage,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      });

      await loadWatchlistStatus(movie.id);
    });
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    isAddedToWatchlist = result;
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
  final MovieDetail resultDetail;
  final List<Movie> resultRecommendation;
  final bool isAddedToWatchlist;

  DetailMovieHasDataState({
    required this.resultDetail,
    required this.resultRecommendation,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object> get props => [
        resultDetail,
        resultRecommendation,
        isAddedToWatchlist,
      ];
}

class WatchlistMessageState extends DetailMovieState {
  final String message;
  final bool isAddedToWatchlist;

  WatchlistMessageState({
    required this.message,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object> get props => [message];
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

class ActionAddWatchlistMovie extends DetailMovieEvent {
  final MovieDetail movie;

  ActionAddWatchlistMovie({required this.movie});

  @override
  List<Object> get props => [movie];
}

class ActionRemoveFromWatchlistMovie extends DetailMovieEvent {
  final MovieDetail movie;

  ActionRemoveFromWatchlistMovie({required this.movie});

  @override
  List<Object> get props => [movie];
}
